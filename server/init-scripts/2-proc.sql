/* SQL or PL/pgSQL routines for function implementations */

/* Function (1) add_employee */

/* Function (2) remove_employee */

/* Function (3) add_customer (Gerren) */
CREATE OR REPLACE PROCEDURE add_customer(name TEXT, home_address TEXT, phone_no INTEGER, email_address TEXT, credit_card_no TEXT,
          expiry_date DATE, CVV_code text)
AS $$
BEGIN
    INSERT INTO Customers(address, name, email, phone_num, credit_card_num)
    	VALUES (home_address, name, email_address, phone_no, credit_card_no);
    INSERT INTO Credit_Cards(credit_card_num, expiry_date, from_date, cvv)
    	VALUES (credit_card_no, expiry_date, CURRENT_DATE, CVV_code);
END;
$$ LANGUAGE plpgsql;

/* Function (4) update_credit_card */

/* Function (5) add_course */

/* Function (6) find_instructors */

/* Function (7) get_available_instructors (Gerren) */
CREATE OR REPLACE FUNCTION get_available_instructors(course_identifier INTEGER, start_date DATE, end_date DATE)
RETURNS TABLE(instructor_identifier INTEGER, instructor_name TEXT, total_teaching_hours INTEGER, day DATE, available_hours INTEGER[]) AS $$
DECLARE
	curs CURSOR FOR (SELECT Instructors.instructor_id, Instructors.course_area_name 
                   FROM Instructors NATURAL JOIN Courses 
                   WHERE course_id = course_identifier
                   ORDER BY instructor_id);
  r RECORD;
  current_instructor_area TEXT;
  range_of_hours INTEGER[] := '{9, 10, 11, 14, 15, 16, 17}';
  is_instructor_busy BOOLEAN;
BEGIN
	OPEN curs;
  
  LOOP
  	FETCH curs INTO r;
    EXIT WHEN NOT FOUND;
		instructor_identifier := r.instructor_id;
    current_instructor_area := r.course_area_name;
    instructor_name := (SELECT employee_name FROM Employees WHERE eid = r.instructor_id);
    day := start_date;

    LOOP
      EXIT WHEN day > end_date;
			total_teaching_hours := (
        SELECT COALESCE(SUM(end_time_hour - start_time_hour), 0)
        FROM Conducts NATURAL JOIN Instructors NATURAL JOIN Course_Offering_Sessions
        WHERE date_part('month', session_date) = date_part('month', day) AND Conducts.instructor_id = instructor_identifier AND Conducts.course_area_name = current_instructor_area 
      );
      available_hours := '{}';
      
      FOR i IN 1 .. array_upper(range_of_hours, 1)
      LOOP
      	SELECT COUNT(course_id) > 0 INTO is_instructor_busy
        FROM Conducts NATURAL JOIN Instructors NATURAL JOIN Course_Offering_Sessions
        WHERE session_date = day AND Conducts.instructor_id = instructor_identifier AND Conducts.course_area_name = current_instructor_area 
        AND range_of_hours[i] >= start_time_hour AND range_of_hours[i] < end_time_hour;
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

/* Function (8) find_rooms */

/* Function (9) get_available_rooms */

/* Function (10) add_course_offering */

/* Function (11) add_course_package (Gerren) */
CREATE OR REPLACE PROCEDURE add_course_package(package_name TEXT, num_free_course_sessions INTEGER, price NUMERIC, start_date DATE, end_date DATE)
AS $$
BEGIN
		INSERT INTO Course_Packages(course_package_name, num_free_registrations, price, sale_start_date, sale_end_date)
    	VALUES (package_name, num_free_course_sessions, price, start_date, end_date);
END;
$$ LANGUAGE plpgsql;

/* Function (12) get_available_course_packages */

/* Function (13) buy_course_package */

/* Function (14) get_my_course_package */

/* Function (15) get_available_course_offerings (Gerren) */
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
	SELECT C.title, C.course_area_name, CO.start_date, CO.end_date, CO.registration_deadline, CO.fees,
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

/* Function (16) get_available_course_sessions */

/* Function (17) register_session */

/* Function (18) get_my_registrations */

/* Function (19) update_course_session (Gerren) */
CREATE OR REPLACE PROCEDURE update_course_session(cust_identifer INTEGER, course_identifier INTEGER, course_launch_date DATE, session_num INTEGER)
AS $$
DECLARE
  is_session_present BOOLEAN;
	current_session_count INTEGER;
	remaining_seats INTEGER;
  input_cust_id INTEGER := cust_identifer;
BEGIN
  SELECT COUNT(*) = 1 INTO is_session_present
  FROM Course_Offering_Sessions
  WHERE course_id = course_identifier AND launch_date = course_launch_date AND sid = session_num;
  IF is_session_present = FALSE THEN
  	RAISE EXCEPTION 'Session is not present in Course Offering specified.';
  END IF;
    
	SELECT COUNT(cust_id) INTO current_session_count
  FROM Registers NATURAL JOIN Course_Offering_Sessions NATURAL JOIN Course_Offerings
  WHERE cust_id = cust_identifer AND course_id = course_identifier AND launch_date = course_launch_date;
  IF current_session_count <> 1 THEN
  	RAISE EXCEPTION 'Customer has not signed up for specified Course Offering.';
  END IF;
  
	WITH Sessions_Registers AS (
  	SELECT COUNT(*) AS num_registrations
		FROM Registers NATURAL JOIN Course_Offering_Sessions
    WHERE course_id = course_identifier AND launch_date = course_launch_date AND sid = session_num
  ),
   Sessions_Conducts_Rooms AS (
  	SELECT COALESCE(SUM(Rooms.seating_capacity), 0) AS session_capacity
    FROM Conducts NATURAL JOIN Course_Offering_Sessions NATURAL JOIN Rooms
    WHERE course_id = course_identifier AND launch_date = course_launch_date AND sid = session_num
  )
  SELECT (
  	(SELECT session_capacity FROM Sessions_Conducts_Rooms) - (SELECT num_registrations FROM Sessions_Registers)
  ) INTO remaining_seats;
  IF remaining_seats > 0 THEN
    UPDATE Registers
    SET sid = session_num
    WHERE Registers.cust_id = input_cust_id;
  ELSE
  	RAISE EXCEPTION 'Session requested is fully booked.';
  END IF;
END;
$$ LANGUAGE plpgsql;

/* Function (20) cancel_registration */

/* Function (21) update_instructor */

/* Function (22) update_room */

/* Function (23) remove_session (Gerren) */
CREATE OR REPLACE PROCEDURE remove_session(course_identifier INTEGER, course_launch_date DATE, session_num INTEGER)
AS $$
DECLARE
	session_start_time INTEGER;
  session_start_date DATE;
  num_registrations INTEGER;
  isPresent BOOLEAN;
BEGIN
	SELECT COUNT(*) = 1 INTO isPresent
  FROM Course_Offering_Sessions NATURAL JOIN Course_Offerings
  WHERE sid = session_num AND course_id = course_identifier AND launch_date = course_launch_date;
  
  IF isPresent = FALSE THEN
  	RAISE EXCEPTION 'Invalid Session.';
  END IF;
  
	SELECT start_time_hour, session_date INTO session_start_time, session_start_date
  FROM Course_Offering_Sessions
  WHERE sid = session_num AND course_id = course_identifier AND launch_date = course_launch_date;
  
  SELECT COUNT(*) INTO num_registrations
  FROM Registers
  WHERE sid = session_num AND course_id = course_identifier AND launch_date = course_launch_date;
	
  IF CURRENT_DATE > session_start_date THEN
  	RAISE EXCEPTION 'Session has already commenced.';
  END IF;
  
  IF CURRENT_DATE = session_start_date AND extract(hour from now()) >= session_start_time THEN
  	RAISE EXCEPTION 'Session has already commenced.';
  END IF;
  
  IF num_registrations = 0 THEN
    DELETE FROM Course_Offering_Sessions
    WHERE sid = session_num AND course_id = course_identifier AND launch_date = course_launch_date;
  ELSE
    RAISE EXCEPTION 'Session has customers registered.';
  END IF;	
END;
$$ LANGUAGE plpgsql;

/* Function (24) add_session */

/* Function (25) pay_salary */

/* Function (26) promote_courses */

/* Function (27) top_packages (Gerren) */
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

/* Function (28) popular_courses */

/* Function (29) view_summary_report */

/* Function (30) view_manager_report */
