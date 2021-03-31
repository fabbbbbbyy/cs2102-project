/* 3. (Gerren) 
Function: add_customer
Input: name, home address, contact number, email address, credit card number, expiry date, CVV code
Status: Implemented with testing
*/
CREATE OR REPLACE PROCEDURE add_customer(name TEXT, home_address TEXT, email_address TEXT, contact_no TEXT, credit_card_no TEXT,
          expiry_date DATE, CVV_code INTEGER)
AS $$
BEGIN
    INSERT INTO Credit_Cards(number, expiry_date, cvv)
    	VALUES (credit_card_no, expiry_date, CVV_code);
    INSERT INTO Customers(address, name, email, phone, number)
    	VALUES (home_address, name, email_address, contact_no, credit_card_no);
    UPDATE Credit_Cards SET from_date = CURRENT_DATE WHERE number = credit_card_no;
END;
$$ LANGUAGE plpgsql;

/* 7. (Gerren) 
Function: get_available_instructors
Input: course_identifier, start_date, end_date
Status: Implemented with testing
Approach:
- Get the list of instructors eligible to teach the course specified
- For each instructor:
- 	For each date in range [start date, end_date]:
-			1. Update global instructor info and date
-			2. Get the total number of teaching hours for the month
-			3. Clear array of available hours
- 		For each available hour:
-				1. Verify if instructor is free on that date and hour.
-					1.1. If instructor is free, add hour to array
-					1.2. Otherwise, move on to next hour
-			4. Add record to result table, of instructor info, teaching hours, 
			date and array of available hours
*/
CREATE OR REPLACE FUNCTION get_available_instructors(course_identifier INTEGER, start_date DATE, end_date DATE)
RETURNS TABLE(instructor_id INTEGER, instructor_name TEXT, total_teaching_hours INTEGER, day DATE, available_hours INTEGER[]) AS $$
DECLARE
	curs CURSOR FOR (SELECT eid, name 
                   FROM Instructors NATURAL JOIN Courses 
                   WHERE course_id = course_identifier
                   ORDER BY eid);
  r RECORD;
  current_instructor_area TEXT;
  range_of_hours INTEGER[] := '{9, 10, 11, 14, 15, 16, 17}';
  is_instructor_busy BOOLEAN;
BEGIN
	OPEN curs;
  
  LOOP
  	FETCH curs INTO r;
    EXIT WHEN NOT FOUND;
		instructor_id := r.eid;
    current_instructor_area := r.name;
    instructor_name := (SELECT name FROM Employees WHERE eid = r.eid);
    day := start_date;

    LOOP
      EXIT WHEN day > end_date;
			total_teaching_hours := (
        SELECT COALESCE(SUM(extract(hour from end_time) - extract(hour from start_time)), 0)
        FROM Conducts NATURAL JOIN Instructors NATURAL JOIN Course_Offering_Sessions
        WHERE date_part('month', session_date) = date_part('month', day) AND Conducts.eid = instructor_id AND Conducts.name = current_instructor_area 
      );
      available_hours := '{}';
      
      FOR i IN 1 .. array_upper(range_of_hours, 1)
      LOOP
      	SELECT COUNT(course_id) > 0 INTO is_instructor_busy
        FROM Conducts NATURAL JOIN Instructors NATURAL JOIN Course_Offering_Sessions
        WHERE session_date = day AND Conducts.eid = instructor_id AND Conducts.name = current_instructor_area 
        AND range_of_hours[i] >= extract(hour from start_time) AND range_of_hours[i] < extract(hour from end_time);
        IF is_instructor_busy = FALSE THEN 
        	available_hours := array_append(available_hours, range_of_hours[i]);
        END IF;    
      END LOOP;
      
      RETURN NEXT;
      day := day + 1;
    END LOOP;
    
  END LOOP;
  
  CLOSE curs;
	
END;
$$ LANGUAGE plpgsql;

/* 11. (Gerren) 
Function: add_course_package
Input: package name, number of free course sessions, start date, end date, price of package
Status: Implemented with testing
*/
CREATE OR REPLACE PROCEDURE add_course_package(package_name TEXT, no_free_course_sessions INTEGER, price NUMERIC, start_date DATE, end_date DATE)
AS $$
BEGIN
		INSERT INTO Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date)
    	VALUES (package_name, no_free_course_sessions, price, start_date, end_date);
END;
$$ LANGUAGE plpgsql;

/* 15. (Gerren) 
Function: get_available_course_offerings
Input: None
Status: Implemented with testing
Approach:
- For each course offering, customer can register for at most 1 session
- Seating capacity of a course session is equal to the seating capacity of the room it is conducted in
- Seating capacity of course offering is equal to the sum of seating capcities of its sessions
- Course offering is available if num of registrations <= seating capacity
- Num of remaining seats = Sum of all course session's seating capacity - number of registrations for course sessions
Note:
- Need to change schemma of Rooms, from seating_capacity -> room_seating_capacity
*/
CREATE OR REPLACE FUNCTION get_available_course_offerings()
RETURNS TABLE(course_title TEXT, course_area TEXT, start_date DATE, end_date DATE, reg_deadline DATE, course_fees NUMERIC, remaining_seats INTEGER) AS $$
	WITH Course_Offerings_Sessions_Conducts_Rooms AS (	
  	SELECT Rooms.seating_capacity AS room_seating_capacity, *
    FROM Conducts NATURAL JOIN Course_Offering_Sessions NATURAL JOIN Course_Offerings
			INNER JOIN Rooms ON Rooms.rid = Conducts.rid
  	),
   	Course_Offerings_Sessions_Registers AS (
  	SELECT *
    FROM Course_Offering_Sessions NATURAL JOIN Course_Offerings NATURAL LEFT JOIN Registers
	)
	SELECT C.title, C.name, CO.start_date, CO.end_date, CO.registration_deadline, CO.fees,
  	(SELECT SUM(room_seating_capacity) 
     FROM Course_Offerings_Sessions_Conducts_Rooms
     WHERE Course_Offerings_Sessions_Conducts_Rooms.course_id = CO.course_id
     GROUP BY Course_Offerings_Sessions_Conducts_Rooms.course_id) - 
    (SELECT COUNT(cust_id) 
     FROM Course_Offerings_Sessions_Registers
     WHERE Course_Offerings_Sessions_Registers.course_id = CO.course_id
     GROUP BY Course_Offerings_Sessions_Registers.course_id)
  FROM Courses AS C INNER JOIN Course_Offerings AS CO ON C.course_id = CO.course_id
  ORDER BY CO.registration_deadline, C.title;
$$ LANGUAGE sql;

/* 19. (Gerren) 
Function: update_course_session
Input: cust_id, course_offering_id(???), session_number
Status: Implemented with testing
Approach:
- Change a customer's registered course session to another session
- Additional check to ensure there is available seat in the new session
- Schema does not have course_offering_id to identify a course offering
*/
CREATE OR REPLACE PROCEDURE update_course_session(cust_id INTEGER, course_offering_id INTEGER, session_no INTEGER)
AS $$
DECLARE
	remaining_seats INTEGER;
  session_launch_date DATE;
  session_course_id INTEGER;
  input_cust_id INTEGER := cust_id;
BEGIN
	WITH Sessions_Registers AS (
  	SELECT COUNT(*) AS num_registrations
		FROM Registers NATURAL JOIN Course_Offering_Sessions
    WHERE Course_Offering_Sessions.sid = session_no
  ),
   Sessions_Conducts_Rooms AS (
  	SELECT SUM(Rooms.seating_capacity) AS session_capacity
    FROM Conducts NATURAL JOIN Course_Offering_Sessions NATURAL JOIN Rooms
    WHERE Course_Offering_Sessions.sid = session_no
  )
  SELECT (
  	(SELECT session_capacity FROM Sessions_Conducts_Rooms) - (SELECT num_registrations FROM Sessions_Registers)
  ) INTO remaining_seats;
  IF remaining_seats > 0 THEN
  	SELECT launch_date, course_id INTO session_launch_date, session_course_id
    FROM Course_Offering_Sessions
    WHERE sid = session_no;
    UPDATE Registers
    SET sid = session_no, launch_date = session_launch_date, course_id = session_course_id
    WHERE Registers.cust_id = input_cust_id;
  ELSE
  	RAISE EXCEPTION 'Session requested is fully booked.';
  END IF;
END;
$$ LANGUAGE plpgsql;

/* 23. (Gerren) 
Function: remove_session
Input: course_offering_id(???), session_no
Status: Implemented with testing
Approach:
- Course session must not have started
- If there is at least one registration for the session, request must not be performed
- Resultant seating capacity of the course offering IS ALLOWED to fall below the target number
Note: 
- now() function has to be altered, to account for timezone
*/
CREATE OR REPLACE PROCEDURE remove_session(course_offering_id INTEGER, session_no INTEGER)
AS $$
DECLARE
	session_start_time TIMESTAMP;
  num_registrations INTEGER;
  isPresent BOOLEAN;
BEGIN
	SELECT COUNT(*) = 1 INTO isPresent
  FROM Course_Offering_Sessions
  WHERE sid = session_no;
  
	SELECT start_time INTO session_start_time
  FROM Course_Offering_Sessions
  WHERE sid = session_no;
  
  SELECT COUNT(*) INTO num_registrations
  FROM Registers
  WHERE sid = session_no;
  
  IF isPresent = FALSE THEN
  	RAISE EXCEPTION 'Invalid Session number.';
  END IF;
	
  IF now() < session_start_time THEN
  	IF num_registrations = 0 THEN
    	DELETE FROM Course_Offering_Sessions
      WHERE sid = session_no;
    ELSE
    	RAISE EXCEPTION 'Session has customers registered.';
    END IF;	
  ELSE
  	RAISE EXCEPTION 'Session has already commenced.';
	END IF;
END;
$$ LANGUAGE plpgsql;

/* 29. (Gerren) 
Function: top_packages
Input: N
Status: Implemented with testing
Approach:
- Top N packages for this year
- Sorted by descending order of number of packages sold, followed by price of package
- There can be more than N packages among the result set, and can be less than N as well if there are fewer than N
number of packages launched this year.
*/
CREATE OR REPLACE FUNCTION top_packages(N INTEGER)
RETURNS TABLE(package_id INTEGER, num_free_course_sessions INTEGER, package_price NUMERIC, start_date DATE, end_date DATE, num_packages_sold INTEGER) AS $$
DECLARE
	package_start_date DATE;
BEGIN
  RETURN QUERY
	WITH Top_N_Sold_Count AS (
  	SELECT DISTINCT COUNT(cust_id) AS Top_N
  	FROM Course_Packages AS CP NATURAL LEFT JOIN Buys AS B
    WHERE date_part('year', sale_start_date) = date_part('year', CURRENT_DATE)
  	GROUP BY CP.package_id
		ORDER BY COUNT(cust_id) DESC
    LIMIT N
  ),
   Top_N_Package_ID AS (
    SELECT CP.package_id, COUNT(cust_id) AS Sales_Count
  	FROM Course_Packages AS CP NATURAL LEFT JOIN Buys AS B
    WHERE date_part('year', sale_start_date) = date_part('year', CURRENT_DATE)
    GROUP BY CP.package_id
    HAVING COUNT(cust_id) IN (SELECT Top_N FROM Top_N_Sold_Count)
  )
  SELECT CP.package_id, CP.num_free_registrations, CP.price, CP.sale_start_date, CP.sale_end_date, TNPI.Sales_Count::INTEGER
  FROM Top_N_Package_ID AS TNPI NATURAL JOIN Course_Packages AS CP
  ORDER BY TNPI.Sales_Count DESC, CP.price DESC;
END;
$$ LANGUAGE plpgsql;