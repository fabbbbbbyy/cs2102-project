/* SQL or PL/pgSQL routines for function implementations */

-- Helper Functions
CREATE OR REPLACE FUNCTION add_employee_helper(address text, contact_number text, email text, 
join_date date, name text) 
RETURNS integer AS $$
DECLARE
eid integer;
BEGIN
    INSERT INTO Employees (address, depart_date, email, join_date, employee_name, phone_num)
    VALUES (address, null, email, join_date, name, contact_number)
    RETURNING Employees.eid into eid;
    return eid;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE add_parttime_employee_helper(eid integer, hourly_rate numeric) 
AS $$
BEGIN
    INSERT INTO Part_Time_Employees
        VALUES (eid, hourly_rate);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE add_fulltime_employee_helper(eid integer, monthly_salary numeric) 
AS $$
BEGIN
    INSERT INTO Full_Time_Employees
        VALUES (eid, monthly_salary);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE add_administrator_helper(eid integer) 
AS $$
BEGIN
    INSERT INTO Administrators
        VALUES (eid);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE add_instructor_helper(eid integer, course_area_name text) 
AS $$
BEGIN
    INSERT INTO Instructors
        VALUES (eid, course_area_name);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE add_parttime_instructor_helper(eid integer, course_area_name text) 
AS $$
BEGIN
    INSERT INTO Part_Time_Instructors
        VALUES (eid, course_area_name);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE add_fulltime_instructor_helper(eid integer, course_area_name text) 
AS $$
BEGIN
    INSERT INTO Full_Time_Instructors
        VALUES (eid, course_area_name);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE add_manager_helper(eid integer) 
AS $$
BEGIN
    INSERT INTO Managers
        VALUES (eid);
END;    
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE add_course_area_helper(eid integer, name text) 
AS $$
BEGIN
    INSERT INTO Course_Areas
        VALUES (eid, name);
END;
$$ LANGUAGE plpgsql;

/* Function (1) add_employee */
CREATE OR REPLACE PROCEDURE add_employee(name text, home_address text, contact_number text, 
email_address text, salary_type text, salary_rate numeric, join_date date, employee_category text,
course_areas text[]) 
AS $$
DECLARE
eid integer;
course_area text;
BEGIN
    IF (employee_category = 'Manager') THEN
        SELECT add_employee_helper(home_address, contact_number, email_address, join_date, name) into eid;
        CALL add_fulltime_employee_helper(eid, salary_rate);
        CALL add_manager_helper(eid);
        FOREACH course_area IN ARRAY course_areas
        LOOP 
            CALL add_course_area_helper(eid, course_area);
        END LOOP;
    ELSIF (employee_category = 'Instructor') THEN
        SELECT add_employee_helper(home_address, contact_number, email_address, join_date, name) into eid;
        IF salary_type = 'Monthly' THEN
            CALL add_fulltime_employee_helper(eid, salary_rate);
            FOREACH course_area IN ARRAY course_areas
            LOOP 
                CALL add_instructor_helper(eid, course_area);
                CALL add_fulltime_instructor_helper(eid, course_area);
            END LOOP;
        ELSIF salary_type = 'Hourly' THEN
            CALL add_parttime_employee_helper(eid, salary_rate);
            FOREACH course_area IN ARRAY course_areas
            LOOP 
                CALL add_instructor_helper(eid, course_area);
                CALL add_parttime_instructor_helper(eid, course_area);
            END LOOP;
        END IF;
    ELSIF (employee_category = 'Administrator') THEN
        IF (course_areas != null AND cardinality(course_areas) > 0) THEN
            RAISE EXCEPTION 'Course areas must be empty for an administrator.';
        ELSE
            SELECT add_employee_helper(home_address, contact_number, email_address, join_date, name) into eid;
            CALL add_fulltime_employee_helper(eid, salary_rate);
            CALL add_administrator_helper(eid);
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;

/* Function (2) remove_employee (Siddarth)*/
CREATE OR REPLACE PROCEDURE remove_employee(employee_id integer, date_of_departure date)
AS $$
BEGIN
	Update Employees
  SET depart_date = date_of_departure
  WHERE employee_id = eid;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_if_invalid_remove_employee()
RETURNS TRIGGER AS $$
DECLARE
  num_of_registration_after_depart_date integer;
  num_of_courses_session_after_depart_date integer;
  num_of_course_area_emp_managing integer;
BEGIN
  SELECT count(distinct (course_id, launch_date)) INTO num_of_registration_after_depart_date
  FROM Employees NATURAL JOIN Administrators NATURAL JOIN Course_Offerings
  WHERE eid = NEW.eid and registration_deadline > NEW.depart_date;
  
  SELECT count(distinct c1.course_id) INTO num_of_courses_session_after_depart_date
  FROM Conducts c1 NATURAL JOIN Course_Offering_Sessions c2
  WHERE c1.instructor_id = NEW.eid
  and c1.course_id = c2.course_id
  and c2.session_date > NEW.depart_date;
  
  SELECT count(course_id) INTO num_of_course_area_emp_managing
  FROM Managers m NATURAL LEFT OUTER JOIN Course_Areas c NATURAL LEFT OUTER JOIN (Courses NATURAL JOIN Course_Offerings)
  WHERE m.eid = NEW.eid
  and ((end_date IS NOT NULL and end_date > NEW.depart_date) or end_date IS NULL);
  
  IF num_of_registration_after_depart_date > 0 THEN
  	RAISE EXCEPTION 'Employee is an administrator who is handling some course offering where its registration deadline is after employee departure date. Hence employee cannot be removed.';
  END IF;
  
  IF num_of_courses_session_after_depart_date > 0 THEN
  	RAISE EXCEPTION 'Employee is an instructor who is teaching some course session that starts after employee departure date. Hence employee cannot be removed';
  END IF;
  
  IF num_of_course_area_emp_managing > 0 THEN
  	RAISE EXCEPTION 'Employee is a manager who is managing some area. Hence employee cannot be removed.';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_remove_employee_constraints
BEFORE INSERT OR UPDATE ON Employees
FOR EACH ROW EXECUTE FUNCTION check_if_invalid_remove_employee();

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

/* Function (4) update_credit_card (Kevin) */
CREATE OR REPLACE PROCEDURE update_credit_card(customer_id INTEGER, credit_card_no TEXT, expiration_date DATE, CVV_code TEXT)
AS $$
DECLARE
  previous_credit_card_num TEXT;
BEGIN
  SELECT credit_card_num INTO previous_credit_card_num
  FROM Customers C
  WHERE C.cust_id = customer_id;

  IF previous_credit_card_num IS NULL THEN
  	RAISE EXCEPTION 'Invalid customer ID.';
  END IF;

  DELETE FROM Credit_Cards WHERE credit_card_num = previous_credit_card_num;
  INSERT INTO Credit_Cards(credit_card_num, expiry_date, from_date, cvv) VALUES(credit_card_no, expiration_date, CURRENT_DATE, CVV_code);

  UPDATE Customers
  SET credit_card_num = credit_card_no
  WHERE cust_id = customer_id;
END;
$$ LANGUAGE plpgsql;

/* Function (5) add_course */
CREATE OR REPLACE PROCEDURE add_course(course_description text, course_title text, duration integer,
course_area text) 
AS $$
BEGIN
    INSERT INTO Courses (description, title, duration, course_area_name)
        VALUES (course_description, course_title, duration, course_area);
END;
$$ LANGUAGE plpgsql;

/* Function (6) find_instructors (Siddarth) */
CREATE OR REPLACE FUNCTION find_instructors(course_identifier integer, new_session_date date, new_session_start_hour integer)
RETURNS TABLE(eid integer, name text) AS $$
DECLARE
  session_duration integer;
  query_course_area_name text;
BEGIN
  SELECT duration INTO session_duration
  FROM Courses
  WHERE course_id = course_identifier;

  SELECT course_area_name INTO query_course_area_name
  FROM Courses
  WHERE course_id = course_identifier;

  return query
  SELECT distinct instructor_id, employee_name
  FROM Instructors i, Employees e
  WHERE i.instructor_id = e.eid
  and
  i.course_area_name = query_course_area_name
  and new_session_date > e.join_date

  EXCEPT

  SELECT distinct instructor_id, employee_name 
  FROM Instructors i, Employees e
  WHERE i.instructor_id = e.eid
  and
  course_area_name = query_course_area_name
  and
  EXISTS (
    SELECT 1
    FROM Course_Offering_Sessions c1,Conducts c2
    WHERE i.instructor_id = c2.instructor_id 
    			and c2.course_id = c1.course_id
    			and c1.session_date = new_session_date 
          and (int8range(new_session_start_hour, new_session_start_hour + session_duration) && int8range(c1.start_time_hour, c1.end_time_hour))
  );

END;
$$ LANGUAGE plpgsql;

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

/* Function (8) find_rooms (Kevin) */
CREATE OR REPLACE FUNCTION find_rooms(date_to_check DATE, session_start_hour INTEGER, session_duration INTEGER)
RETURNS TABLE(room_id INTEGER) AS $$
DECLARE
  is_weekend BOOLEAN := EXTRACT(isodow from date_to_check) in (6, 7);
  session_end_hour INTEGER := session_start_hour + session_duration;
BEGIN
  IF is_weekend = TRUE THEN
  	RAISE EXCEPTION 'Session cannot fall on a weekend.';
  END IF;
  
  IF session_duration <= 0 OR session_duration > 4 THEN
  	RAISE EXCEPTION 'Session duration must be between 1-4 hours long.';
  END IF;

  IF ((session_start_hour >= 9 AND session_end_hour <= 12) OR (session_start_hour >= 14 AND session_end_hour <= 18)) = FALSE THEN
  	RAISE EXCEPTION 'Session must fall between 9am to 12pm or 2pm to 6pm';
  END IF;

	WITH Joined AS (
    SELECT *
    FROM Conducts NATURAL JOIN Course_Offering_Sessions)
  SELECT rid
  FROM Rooms
  EXCEPT
  SELECT rid
  FROM Joined
  WHERE (
	Joined.session_date = date_to_check AND (
		(session_start_hour <= Joined.start_time_hour AND session_end_hour > Joined.start_time_hour) OR
		(session_start_hour < Joined.end_time_hour AND session_end_hour >= Joined.end_time_hour) OR
		(session_start_hour <= Joined.start_time_hour AND session_end_hour >= Joined.end_time_hour) OR
		(session_start_hour >= Joined.start_time_hour AND session_end_hour <= Joined.end_time_hour)));
END;
$$ LANGUAGE plpgsql;

/* Function (9) get_available_rooms */

/* Function (10) add_course_offering (Siddarth) */

/* Function (11) add_course_package (Gerren) */
CREATE OR REPLACE PROCEDURE add_course_package(package_name TEXT, num_free_course_sessions INTEGER, price NUMERIC, start_date DATE, end_date DATE)
AS $$
BEGIN
		INSERT INTO Course_Packages(course_package_name, num_free_registrations, price, sale_start_date, sale_end_date)
    	VALUES (package_name, num_free_course_sessions, price, start_date, end_date);
END;
$$ LANGUAGE plpgsql;

/* Function (12) get_available_course_packages (Kevin) */
CREATE OR REPLACE FUNCTION get_available_course_packages()
RETURNS TABLE(name TEXT, num_free_registrations INTEGER, sale_end_date DATE, price NUMERIC) AS $$
BEGIN
  SELECT CP.course_package_name, CP.num_free_registrations, CP.sale_end_date, CP.price
  FROM Course_Packages CP
  WHERE CP.sale_start_date <= CURRENT_DATE AND CP.sale_end_date >= CURRENT_DATE;
END;
$$ LANGUAGE plpgsql;

/* Function (13) buy_course_package */
CREATE OR REPLACE PROCEDURE buy_course_package(customer_id integer, course_package_id integer) 
AS $$
DECLARE
    num_remaining_registrations integer; 
BEGIN
    SELECT num_free_registrations
    FROM Course_Packages
    WHERE package_id = course_package_id
    INTO num_remaining_registrations;

    IF num_remaining_registrations IS NULL THEN
        RAISE EXCEPTION 'This course package does not exist!';
    END IF;

    INSERT INTO Buys
        VALUES (customer_id, course_package_id, current_date, num_remaining_registrations);
END;
$$ LANGUAGE plpgsql;

/* Function (14) get_my_course_package (Siddarth) */
CREATE OR REPLACE FUNCTION get_my_course_package(customer_id INTEGER)
RETURNS JSON AS $$
DECLARE
  result json;
BEGIN
  result := (With 
    Active_And_Partially_Actice_Course_Packages AS
    (
      SELECT distinct package_id, course_package_name AS package_name, purchase_date, price AS price_of_package, num_remaining_redemptions AS number_of_free_sessions_not_redeeemed
      FROM Course_Packages NATURAL JOIN Buys NATURAL LEFT OUTER JOIN Redeems NATURAL LEFT OUTER JOIN Course_Offering_Sessions
      WHERE cust_id = customer_id
      and 
      (num_remaining_redemptions > 0 or (num_remaining_redemptions = 0 and session_date::DATE - CURRENT_DATE::DATE >= 7))
    ),
    Sorted_Redeemed_Info AS 
    (
      SELECT *
      FROM Course_Packages NATURAL JOIN Buys NATURAL JOIN Redeems NATURAL JOIN Course_Offering_Sessions NATURAL JOIN Course_Offerings NATURAL JOIN Courses
      WHERE cust_id = customer_id
      ORDER BY package_id, session_date, start_time_hour
    ),
    Redeemed_Sessions AS
    (
      SELECT package_id, ARRAY_AGG(title || ', ' || session_date || ', ' || start_time_hour) redeemed_session_info
      FROM Sorted_Redeemed_Info
      GROUP BY package_id
    )
      SELECT 
      json_agg(
        json_build_object(
        'package_name', package_name,
        'purchase_date', purchase_date,
        'price_of_package', price_of_package,
        'number_of_free_sessions_not_redeemed_yet', number_of_free_sessions_not_redeeemed,
        'redeemed_session_info', coalesce(redeemed_session_info, null)
        )
      )
    FROM Active_And_Partially_Actice_Course_Packages NATURAL LEFT OUTER JOIN Redeemed_Sessions);

    return result;
END;
$$ LANGUAGE plpgsql;


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
  	(SELECT CAST(SUM(room_seating_capacity) AS INTEGER)
     FROM Course_Offerings_Sessions_Conducts_Rooms
     WHERE Course_Offerings_Sessions_Conducts_Rooms.course_id = CO.course_id
     GROUP BY Course_Offerings_Sessions_Conducts_Rooms.course_id) - 
    (SELECT CAST(COUNT(cust_id) AS INTEGER)
     FROM Course_Offerings_Sessions_Registers
     WHERE Course_Offerings_Sessions_Registers.course_id = CO.course_id
     GROUP BY Course_Offerings_Sessions_Registers.course_id)
  FROM Courses AS C INNER JOIN Course_Offerings AS CO ON C.course_id = CO.course_id
  ORDER BY CO.registration_deadline, C.title;
$$ LANGUAGE sql;

/* Function (16) get_available_course_sessions (Kevin) */
CREATE OR REPLACE FUNCTION get_available_course_sessions(courseId INTEGER, launchDate DATE)
RETURNS TABLE(session_date DATE, start_time INTEGER, name TEXT, number_remaining_seats INTEGER) AS $$
DECLARE
  deadline DATE;
BEGIN
  SELECT registration_deadline FROM Course_Offerings WHERE (course_id = courseId AND launch_date = launchDate) INTO deadline;
  
  IF deadline < CURRENT_DATE THEN
    RAISE EXCEPTION 'Registration deadline for the course is over.';
  END IF;
  
  WITH C AS (
    SELECT *
    FROM Course_Offering_Sessions NATURAL JOIN Conducts NATURAL JOIN Instructors NATURAL JOIN Rooms),
  Result AS (
	SELECT C.session_date, C.start_time_hour, (SELECT employee_name FROM Employees WHERE eid = C.instructor_id),
	  C.seating_capacity - (SELECT CAST(COUNT(*) AS INT) FROM Registers WHERE Registers.sid = C.sid) AS number_remaining_seats
    FROM C
    WHERE C.course_id = courseId AND C.launch_date = launchDate
    GROUP BY C.sid, C.session_date, C.start_time_hour, C.instructor_id, C.seating_capacity)
  SELECT *
  FROM Result
  WHERE Result.number_remaining_seats > 0
  ORDER BY session_date, start_time ASC;
END;
$$ LANGUAGE plpgsql;

/* Function (17) register_session */
CREATE OR REPLACE PROCEDURE register_session(customer_id integer, _course_id integer, _launch_date date,
session_id integer, payment_method text) 
AS $$
DECLARE
    current_date date;
    _purchase_date date;
    _package_id integer;
    num_records_with_same_cust_id integer;
    num_records_with_same_cust_id_in_buys integer;
    num_records_with_same_course_offering_session_id integer;
BEGIN
    IF (payment_method = 'Credit Card') THEN
        SELECT COUNT(*) into num_records_with_same_cust_id 
        FROM Customers
        WHERE cust_id = customer_id;
        
        SELECT COUNT(*) into num_records_with_same_course_offering_session_id
        FROM Course_Offering_Sessions COS
        WHERE COS.sid = session_id
        AND COS.launch_date = _launch_date
        AND COS.course_id = _course_id;

        IF num_records_with_same_cust_id <= 0 THEN
            RAISE EXCEPTION 'This customer does not exist!';
        END IF;

        IF num_records_with_same_course_offering_session_id <= 0 THEN
            RAISE EXCEPTION 'There is no such course session.';
        END IF;

        SELECT CURRENT_DATE into current_date;
        INSERT INTO Registers
            VALUES (customer_id, current_date, session_id, _launch_date, _course_id);
    ELSIF (payment_method = 'Redemption') THEN
        SELECT COUNT(*) into num_records_with_same_cust_id 
        FROM Customers
        WHERE cust_id = customer_id;

        SELECT COUNT(*) into num_records_with_same_course_offering_session_id
        FROM Course_Offering_Sessions COS
        WHERE COS.sid = session_id
        AND COS.launch_date = _launch_date
        AND COS.course_id = _course_id;

        SELECT COUNT(*) into num_records_with_same_cust_id_in_buys
        FROM Buys 
        WHERE cust_id = customer_id;

        IF num_records_with_same_cust_id_in_buys <= 0 THEN
            RAISE EXCEPTION 'This customer does not own any course packages!';
        END IF;

        IF num_records_with_same_cust_id <= 0 THEN
            RAISE EXCEPTION 'This customer does not exist!';
        END IF;

        IF num_records_with_same_course_offering_session_id <= 0 THEN
            RAISE EXCEPTION 'There is no such course session.';
        END IF;

        SELECT CURRENT_DATE into current_date;
        SELECT B.package_id, B.purchase_date
        FROM Buys B
        WHERE B.cust_id = customer_id
        INTO _package_id, _purchase_date;

        INSERT INTO Redeems
            VALUES (current_date, session_id, _launch_date, _course_id, customer_id, _package_id,  
            _purchase_date);
    END IF;
END;
$$ LANGUAGE plpgsql;


/* Function (18) get_my_registrations (Siddarth) */
CREATE OR REPLACE FUNCTION get_my_registrations(customer_id integer)
RETURNS TABLE(course_name text, course_fees numeric, session_date date, session_start_hour integer, session_duration integer, instructor_name text) AS $$
DECLARE
	current_date date;
BEGIN
	SELECT CURRENT_DATE INTO current_date;
  
  return query
  /*{course_id, sid, launch_date, session_date, fees, start_time}*/
  SELECT title as course_name, fees as course_fees, C1.session_date, start_time_hour as session_start_hour, duration as session_duration, employee_name as instructor_name
  FROM (Registers R NATURAL JOIN Course_Offering_Sessions C1 NATURAL JOIN Course_Offerings C2 NATURAL JOIN Conducts NATURAL JOIN Courses) INNER JOIN Employees on instructor_id = eid
  WHERE cust_id = customer_id
  and registration_deadline > CURRENT_DATE

  UNION 

  SELECT title as course_name, fees as course_fees, C1.session_date, start_time_hour as session_start_hour, duration as session_duration, employee_name as instructor_name
  FROM (Redeems R NATURAL JOIN Course_Offering_Sessions C1 NATURAL JOIN Course_Offerings C2 NATURAL JOIN Conducts NATURAL JOIN Courses) INNER JOIN Employees on instructor_id = eid
  WHERE cust_id = customer_id
  and registration_deadline > CURRENT_DATE
  ORDER BY session_date asc, session_start_hour asc;

END;
$$ LANGUAGE plpgsql;

/* Function (19) update_course_session (Gerren) */
CREATE OR REPLACE PROCEDURE update_course_session(cust_identifer INTEGER, course_identifier INTEGER, course_launch_date DATE, session_num INTEGER)
AS $$
DECLARE
  is_session_present BOOLEAN;
	current_session_count INTEGER;
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
  
  UPDATE Registers
  SET sid = session_num
  WHERE cust_id = input_cust_id AND course_id = course_identifier AND launch_date = course_launch_date;
END;
$$ LANGUAGE plpgsql;

/* Function (20) cancel_registration */
CREATE OR REPLACE PROCEDURE cancel_registration(customer_id INTEGER, courseId INTEGER, launchDate DATE, sessionNumber INTEGER)
AS $$
DECLARE
  is_valid_course_offering_identifier BOOLEAN;
  is_valid_registration_identifier BOOLEAN;
  did_redeem BOOLEAN;
  package_credit INTEGER;
  refund_amt NUMERIC;
BEGIN
  SELECT COUNT(*) = 1 INTO is_valid_course_offering_identifier
  FROM Course_Offerings
  WHERE course_id = course_id AND launch_date = launch_date AND sid = session_number;
  
  IF is_valid_course_offering_identifier = FALSE THEN
  	RAISE EXCEPTION 'Invalid course offering identifier.';
  END IF;

  SELECT COUNT(*) = 1 INTO is_valid_registration_identifier
  FROM Registers
  WHERE cust_id = customer_id AND course_id = course_id AND launch_date = launch_date AND sid = session_number;
  
  IF is_valid_registration_identifier = FALSE THEN
  	RAISE EXCEPTION 'Invalid registration details.';
  END IF;
  
  SELECT COUNT(*) > 0 INTO did_redeem
  FROM Redeems
  WHERE cust_id = customer_id AND course_id = courseId AND launch_date = launchDate AND session_number = sessionNumber;
  
  IF did_redeem = TRUE THEN
  	package_credit := 1;
  	refund_amt := NULL;
  ELSE
  	SELECT fees * 0.9 INTO refund_amt
	FROM Course_Offering_Sessions NATURAL JOIN Course_Offerings NATURAL JOIN Courses
	WHERE course_id = courseId AND launch_date = launchDate AND session_number = sessionNumber;
	
	package_credit := NULL;
  END IF;

  INSERT INTO Cancels(cancel_date, cust_id, launch_date, package_credit, refund_amt, sid, course_id) VALUES(CURRENT_DATE, launch_date, package_credit, refund_amt, session_number, course_id);
END;
$$ LANGUAGE plpgsql;

/* Function (21) update_instructor */
CREATE OR REPLACE PROCEDURE update_instructor(_course_id integer, _launch_date date, session_id integer,
new_instructor_id integer) 
AS $$
DECLARE
    _current_date date;
    num_sessions_which_already_started integer;
    num_conflicting_sessions integer;
    num_same_course_session_records integer;
BEGIN
    SELECT CURRENT_DATE into _current_date;

    SELECT COUNT(*) into num_sessions_which_already_started
    FROM Conducts NATURAL JOIN Course_Offering_Sessions
    WHERE course_id = _course_id
    AND launch_date = _launch_date
    AND sid = session_id
    AND _current_date >= session_date;

    SELECT COUNT(*) INTO num_same_course_session_records
    FROM Course_Offering_Sessions
    WHERE sid = session_id
    AND course_id = _course_id
    AND launch_date = _launch_date;

    IF (num_same_course_session_records <= 0) THEN
        RAISE EXCEPTION 'No such course session exists!';
    END IF;

    IF (num_sessions_which_already_started <= 0) THEN
        SELECT COUNT(*) into num_conflicting_sessions
        FROM Conducts Natural Join Course_Offering_Sessions CCOS
        WHERE instructor_id = new_instructor_id
        AND start_time_hour >= ANY (
            SELECT start_time_hour
            FROM Conducts NATURAL JOIN Course_Offering_Sessions
            WHERE course_id = _course_id
            AND launch_date = _launch_date
            AND sid = session_id
        )
        AND start_time_hour <= ANY (
            SELECT end_time_hour
            FROM Conducts NATURAL JOIN Course_Offering_Sessions
            WHERE course_id = _course_id
            AND launch_date = _launch_date
            AND sid = session_id
        );

        IF (num_conflicting_sessions <= 0) THEN
            UPDATE Conducts
            SET instructor_id = new_instructor_id
            WHERE course_id = _course_id
            AND launch_date = _launch_date
            AND sid = session_id;
        ELSE 
            RAISE EXCEPTION 'This instructor is already teaching sessions during this timeframe.';
        END IF;
    ELSE 
        RAISE EXCEPTION 'The session has already started.';
    END IF;
END;
$$ LANGUAGE plpgsql;

/* Function (22) update_room (Siddarth) */
CREATE OR REPLACE PROCEDURE update_room(existing_course_id INTEGER, existing_launch_date DATE, existing_session_id INTEGER, new_room_id INTEGER)
AS $$
DECLARE
  existing_session_seating_capacity INTEGER;
  new_room_seating_capacity INTEGER;
  current_date DATE;
  course_duration INTEGER;
  course_offering_session_date DATE;
  course_offering_session_start_hour INTEGER;
  num_of_conflicting_sessions INTEGER;
BEGIN
  SELECT seating_capacity INTO existing_session_seating_capacity
  FROM Conducts C1 NATURAL JOIN Course_Offering_Sessions C2 NATURAL JOIN Rooms R1
  WHERE C2.course_id = existing_course_id
  and C2.launch_date = existing_launch_date
  and C2.sid = existing_session_id;

  /* Find seating capacity of new room */
  SELECT seating_capacity INTO new_room_seating_capacity
  FROM Rooms
  WHERE rid = existing_session_id;

  IF new_room_seating_capacity < existing_session_seating_capacity THEN
  	RAISE EXCEPTION 'New room cannot accomodate to the number of people in course offering session.';
  END IF;

  /* Find course duration */
  SELECT duration INTO course_duration
  FROM Conducts NATURAL JOIN Course_Offering_Sessions NATURAL JOIN Course_Offerings NATURAL JOIN Courses
  WHERE course_id = existing_course_id
  and sid = existing_session_id
  and launch_date = existing_launch_date;

  /* Find start hour of course_offering_session */
  SELECT start_time_hour, session_date  INTO course_offering_session_start_hour, course_offering_session_date
  FROM Conducts NATURAL JOIN Course_Offering_Sessions
  WHERE course_id = existing_course_id
  and sid = existing_session_id
  and launch_date = existing_launch_date;

  /* Find number of conflicting course_offering_sessions in the new rid */
  SELECT count(distinct sid) INTO num_of_conflicting_sessions
  FROM Conducts NATURAL JOIN Course_Offering_Sessions
  WHERE rid = existing_session_id
  and session_date = course_offering_session_date
  and (int8range(course_offering_session_start_hour, course_offering_session_start_hour + course_duration)
  && int8range(start_time_hour, end_time_hour));

  IF num_of_conflicting_sessions > 0 THEN
    RAISE EXCEPTION 'There is a session using the room on the same date and duration of the course. Hence new room cannot be assigned.';
  END IF;

	UPDATE Conducts
  SET rid = new_room_id
  WHERE course_id = existing_course_id and existing_launch_date = launch_date and sid = existing_session_id;
END;
$$ LANGUAGE plpgsql;

/* Function (23) remove_session (Gerren) */
CREATE OR REPLACE PROCEDURE remove_session(course_identifier INTEGER, course_launch_date DATE, session_num INTEGER)
AS $$
DECLARE
  isPresent BOOLEAN;
BEGIN
	SELECT COUNT(*) = 1 INTO isPresent
  FROM Course_Offering_Sessions NATURAL JOIN Course_Offerings
  WHERE sid = session_num AND course_id = course_identifier AND launch_date = course_launch_date;
  
  IF isPresent = FALSE THEN
  	RAISE EXCEPTION 'Invalid Session.';
  END IF;
  
  DELETE FROM Course_Offering_Sessions
  WHERE sid = session_num AND course_id = course_identifier AND launch_date = course_launch_date;

END;
$$ LANGUAGE plpgsql;

/* Function (24) add_session */
CREATE OR REPLACE PROCEDURE add_session(courseId INTEGER, launchDate DATE, session_number INTEGER, session_date DATE, session_start_hour INTEGER, instructorId INTEGER, room_id INTEGER)
AS $$
DECLARE
  is_valid_course_offering_identifier BOOLEAN;
  is_valid_instructor BOOLEAN;
  is_valid_room BOOLEAN;
  registration_deadline DATE;
  duration INTEGER;
  course_area_name TEXT;
  session_seating_capacity INTEGER;
  updated_course_offering_seating_capacity INTEGER;
BEGIN
  SELECT COUNT(*) > 0 INTO is_valid_course_offering_identifier
  FROM Course_Offerings CO
  WHERE CO.course_id = course_id AND CO.launch_date = launch_date;
  
  IF is_valid_course_offering_identifier = FALSE THEN
  	RAISE EXCEPTION 'Invalid course offering identifier (course_id, launch_date).';
  END IF;
  
  SELECT COUNT(*) > 0 INTO is_valid_instructor
  FROM Instructors
  WHERE instructor_id = instructorId;
  
  IF is_valid_instructor = FALSE THEN
  	RAISE EXCEPTION 'Invalid instructor identifier.';
  END IF;
  
  SELECT COUNT(*) > 0 INTO is_valid_room
  FROM Rooms
  WHERE rid = room_id;
  
  IF is_valid_room = FALSE THEN
  	RAISE EXCEPTION 'Invalid room identifier.';
  END IF;
  
  SELECT CO.registration_deadline INTO registration_deadline
  FROM Course_Offerings CO
  WHERE CO.course_id = courseId AND CO.launch_date = launchDate;
  
  IF CURRENT_DATE > registration_deadline THEN
  	RAISE EXCEPTION 'Registration deadline has passed.';
  END IF;
  
  SELECT C.duration INTO duration
  FROM Courses C
  WHERE C.course_id = course_id;
  
  SELECT I.course_area_name INTO course_area_name
  FROM Instructors I
  WHERE I.instructor_id = instructor_id;

  SELECT seating_capacity INTO session_seating_capacity
  FROM Rooms R
  WHERE R.rid = room_id;

  SELECT seating_capacity INTO updated_course_offering_seating_capacity
  FROM Course_Offerings CO
  WHERE CO.course_id = courseId AND CO.launch_date = launchDate;

  updated_course_offering_seating_capacity := updated_course_offering_seating_capacity + session_seating_capacity;
  
  INSERT INTO Course_Offering_Sessions(sid, session_date, start_time_hour, end_time_hour, launch_date, course_id) VALUES(session_number, session_date, session_start_hour, session_start_hour + duration, launchDate, courseId);
  INSERT INTO Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) VALUES(room_id, instructorId, session_number, course_area_name, launchDate, courseId);
  UPDATE Course_Offerings SET seating_capacity = updated_course_offering_seating_capacity WHERE course_id = courseId AND launch_date = launchDate;
END;
$$ LANGUAGE plpgsql;

/* Function (25) pay_salary */
CREATE OR REPLACE FUNCTION pay_salary() 
RETURNS TABLE (eid integer, _name text, status text, number_of_work_days_for_month integer, 
number_of_work_hours_for_month integer, _hourly_rate integer, _monthly_salary integer, 
salary_amount_paid integer) 
AS $$
DECLARE
cursF CURSOR FOR (SELECT * FROM Full_Time_Employees Natural Join Employees);
rF RECORD;
cursP CURSOR FOR (
    WITH Differences_In_Time AS (
        SELECT Employees.eid as eid, employee_name, (end_time_hour - start_time_hour) as difference, hourly_rate
        FROM (Part_Time_Employees Natural Join Employees) 
            Inner Join 
            (Part_Time_Instructors Natural Join Instructors) 
            ON Employees.eid = Instructors.instructor_id
            Natural Join 
            (Conducts Natural Join Course_Offering_Sessions)   
        WHERE EXTRACT(MONTH FROM join_date) = EXTRACT(MONTH FROM current_date)
    )
    SELECT DIT.eid, sum(difference) as total_hours_worked
    FROM Differences_In_Time DIT
    GROUP BY DIT.eid
);
rP RECORD;
current_date date;
first_work_day integer;
last_work_day integer;
num_days_of_current_month integer;
BEGIN
    SELECT CURRENT_DATE into current_date;

    OPEN cursF;
    LOOP
        FETCH cursF INTO rF;
        EXIT WHEN NOT FOUND;

        IF (EXTRACT(MONTH FROM rF.join_date) = EXTRACT(MONTH FROM current_date)) THEN
            SELECT EXTRACT(DAY FROM rF.join_date) into first_work_day;
        ELSE
            first_work_day := 1;
        END IF;
        IF (EXTRACT(MONTH FROM rF.depart_date) < EXTRACT(MONTH FROM current_date)) THEN
            CONTINUE;
        ELSIF (EXTRACT(MONTH FROM rF.depart_date) = EXTRACT(MONTH FROM current_date)) THEN
            SELECT EXTRACT(DAY FROM rF.depart_date) into last_work_day;
        ELSE
            SELECT EXTRACT(DAY FROM(date_trunc('month', current_date::date) + interval '1 month' - interval '1 day')::date)
INTO last_work_day; /* This gets last day of current month. */
        END IF;

        eid := rF.eid;
        _name := rF.employee_name;
        status := 'Full Time';
        number_of_work_days_for_month := last_work_day - first_work_day + 1;
        number_of_work_hours_for_month := null;
        _hourly_rate := null;
        _monthly_salary := rF.monthly_salary;
        SELECT  
        DATE_PART('days', 
            DATE_TRUNC('month', NOW()) 
            + '1 MONTH'::INTERVAL 
            - '1 DAY'::INTERVAL
        ) into num_days_of_current_month;
        salary_amount_paid := _monthly_salary * (num_days_of_current_month/number_of_work_days_for_month);

        INSERT INTO Employee_Pay_Slips
            VALUES (salary_amount_paid, eid, number_of_work_days_for_month, null, current_date);
        RETURN NEXT;
    END LOOP;
    CLOSE cursF;

    OPEN cursP;
    LOOP
        FETCH cursP INTO rP;
        EXIT WHEN NOT FOUND;

        IF (EXTRACT(MONTH FROM rP.depart_date) < EXTRACT(MONTH FROM current_date)) THEN
            CONTINUE;
        END IF;

        WITH Differences_In_Time AS (
            SELECT Employees.eid, employee_name, (end_time_hour - start_time_hour) as difference, hourly_rate
            FROM (Part_Time_Employees Natural Join Employees) 
                Inner Join 
                (Part_Time_Instructors Natural Join Instructors) 
                ON Employees.eid = Instructors.instructor_id
                Natural Join 
                (Conducts Natural Join Course_Offering_Sessions)   
            WHERE EXTRACT(MONTH FROM join_date) = EXTRACT(MONTH FROM current_date)
        )
        SELECT employee_name, hourly_rate
        FROM Differences_In_Time 
        WHERE eid = rP.eid
        INTO _name, _hourly_rate;

        eid := rP.eid;
        status := 'Part Time';
        number_of_work_days_for_month := null;
        number_of_work_hours_for_month := rP.total_hours_worked;
        _monthly_salary := null;
        salary_amount_paid := _hourly_rate * number_of_work_hours_for_month;

        INSERT INTO Employee_Pay_Slips
            VALUES (salary_amount_paid, eid, null, number_of_work_hours_for_month, current_date);
        RETURN NEXT;
    END LOOP;
    CLOSE cursP;

END;
$$ LANGUAGE plpgsql;

/* Function (26) promote_courses (Siddarth) */
CREATE OR REPLACE FUNCTION promote_courses()
RETURNS TABLE(customer_id integer, customer_name text, course_area_name text, course_id integer, course_title text, launch_date date, registration_deadline date, fees numeric) AS $$
BEGIN
  return query
  WITH 
    Inactive_Customers as 
    (
      SELECT cust_id
      FROM Registers NATURAL JOIN Customers
      GROUP BY cust_id
      HAVING EXTRACT(year from AGE(current_date, max(register_date))) * 12 + EXTRACT(month from AGE(current_date, max(register_date))) + 1 > 6
    ),
  Recent_Course_Areas_Registered AS
  (
  	SELECT distinct *
    FROM (
      SELECT *,
      rank() OVER (PARTITION BY cust_id ORDER BY register_date desc)
      FROM Inactive_Customers NATURAL JOIN Registers NATURAL JOIN Course_Offering_Sessions NATURAL JOIN Course_Offerings NATURAL JOIN Courses
    ) ranked_course_areas
    WHERE rank <= 3
  ),
  Customers_With_No_Registrations AS
  (
    SELECT cust_id, name
    FROM Customers

    EXCEPT

    SELECT cust_id, name
    FROM Registers NATURAL JOIN Customers
  )
  SELECT C1.cust_id as customer_id, C1.name as customer_name, C2.course_area_name, C2.course_id, C2.title as course_title, C2.launch_date, C2.registration_deadline, C2.fees
  FROM Customers_With_No_Registrations C1, (Course_Offerings NATURAL JOIN Courses) C2
  WHERE C2.registration_deadline > current_timestamp

  UNION

  SELECT R1.cust_id as customer_id, R1.name as customer_name, C2.course_area_name, C2.course_id, C2.title as course_title, C2.launch_date, C2.registration_deadline, C2.fees
  FROM (Recent_Course_Areas_Registered NATURAL JOIN Customers) R1, (Course_Offerings NATURAL JOIN Courses) C2
  WHERE C2.registration_deadline > current_timestamp
  and EXISTS (
    SELECT 1
    FROM Recent_Course_Areas_Registered R2
    WHERE R1.cust_id = R2.cust_id
    and C2.course_area_name = R2.course_area_name
  );

END;
$$ LANGUAGE plpgsql;

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

/* Function (28) popular_courses (Kevin) */
CREATE OR REPLACE FUNCTION popular_courses()
RETURNS TABLE (course_id INTEGER, course_title TEXT, course_area_name TEXT, num_offerings INTEGER, latest_offering_num_registrations INTEGER) AS $$
BEGIN
  WITH Filtered_Courses AS (
    SELECT C.course_id AS course_id, C.title AS title,
    C.course_area_name AS course_area_name, CAST(COUNT(*) AS INTEGER) AS num_offerings
    FROM Courses C NATURAL JOIN Course_Offerings CO
    WHERE EXTRACT(YEAR FROM CO.start_date) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY C.course_id, C.title, C.course_area_name
    HAVING COUNT(*) >= 2),
  Offering_Registrations AS (
    SELECT F.course_id AS course_id, C.launch_date AS launch_date, C.start_date AS start_date,
	COALESCE(
		(SELECT CAST(COUNT(*) AS INTEGER)
	    FROM Registers R
	 	WHERE R.course_id = F.course_id AND launch_date = C.launch_date
	 	GROUP BY F.course_id, C.launch_date), 0) AS num_registrations
    FROM Filtered_Courses F NATURAL JOIN Course_Offerings C NATURAL JOIN Course_Offering_Sessions S
    GROUP BY F.course_id, C.launch_date, C.start_date),
  Latest_Offering_Registrations AS (
  	SELECT OR1.course_id AS course_id, OR1.launch_date AS launch_date, OR1.start_date AS start_date, OR1.num_registrations AS latest_num_registrations
    FROM Offering_Registrations OR1
    WHERE (OR1.course_id, OR1.launch_date, OR1.start_date) IN (
      SELECT OR2.course_id, OR2.launch_date, OR2.start_date
      FROM Offering_Registrations OR2
	  WHERE OR1.course_id = OR2.course_id
      ORDER BY OR2.start_date DESC
      LIMIT 1)),
  Intermediate_Combined AS (
	SELECT F.course_id AS course_id, F.title AS title, F.course_area_name AS course_area_name, F.num_offerings AS num_offerings,
    L.latest_num_registrations AS latest_num_registrations
	FROM Filtered_Courses F NATURAL JOIN Latest_Offering_Registrations L),
  Combined1 AS (
    SELECT IC.course_id AS course_id, IC.title AS title, IC.course_area_name AS course_area_name, IC.num_offerings AS num_offerings,
    O.num_registrations AS num_registrations, IC.latest_num_registrations AS latest_num_registrations, O.start_date AS start_date
    FROM Intermediate_Combined IC NATURAL JOIN Offering_Registrations O),
  Combined2 AS (
    SELECT C.course_id AS course_id, C.title AS title, C.course_area_name AS course_area_name, C.num_offerings AS num_offerings,
    C.num_registrations AS num_registrations2, C.latest_num_registrations AS latest_num_registrations, C.start_date AS start_date2
    FROM Combined1 C)
  SELECT DISTINCT C.course_id AS course_id, C.title AS title, C.course_area_name AS course_area_name,
    CAST(C.num_offerings AS INTEGER) AS num_offerings, CAST(C.latest_num_registrations AS INTEGER) AS latest_num_registrations
  FROM (Combined1 NATURAL JOIN Combined2) C
  WHERE C.course_id NOT IN (
    SELECT C3.course_id
    FROM Combined1 C3 INNER JOIN Combined2 C4 ON (C3.course_id = C4.course_id AND C3.title = C4.title AND C3.course_area_name = C4.course_area_name AND C3.num_offerings = C4.num_offerings AND C3.latest_num_registrations = C4.latest_num_registrations)
    WHERE C3.start_date < C4.start_date2 AND C3.num_registrations >= C4.num_registrations2)
  ORDER BY latest_num_registrations DESC, course_id ASC;
END;
$$ LANGUAGE plpgsql;

/* Function (29) view_summary_report */
CREATE OR REPLACE FUNCTION view_summary_report(number_of_months integer) 
RETURNS TABLE (month integer, year integer, total_salary_for_month integer, 
course_package_sales_for_month integer,
registration_fees_paid_via_credit_card_for_month integer, 
refunded_registration_fees_for_month integer,
course_registrations_via_course_package_redemptions_for_month integer) 
AS $$
DECLARE
current_date date;
current_month integer;
current_year integer;
BEGIN
    SELECT CURRENT_DATE into current_date;
    SELECT EXTRACT(MONTH FROM current_date) into current_month;
    SELECT EXTRACT(YEAR FROM current_date) into current_year;
    FOR i IN 1..number_of_months LOOP
        month := current_month;
        year := current_year;

        SELECT sum(amount)
        FROM Employee_Pay_Slips
        WHERE EXTRACT(MONTH FROM payment_date) = month AND EXTRACT(YEAR FROM payment_date) = year
        INTO total_salary_for_month;

        IF total_salary_for_month IS NULL THEN
            total_salary_for_month := 0;
        END IF;
        
        SELECT COUNT(*)
        FROM Buys
        WHERE EXTRACT(MONTH FROM purchase_date) = month AND EXTRACT(YEAR FROM purchase_date) = year
        INTO course_package_sales_for_month;
        
        SELECT COUNT(*)
        FROM Registers
        WHERE EXTRACT(MONTH FROM register_date) = month AND EXTRACT(YEAR FROM register_date) = year
        INTO registration_fees_paid_via_credit_card_for_month;

        SELECT sum(refund_amt) 
        FROM Cancels 
        WHERE EXTRACT(MONTH FROM cancel_date) = month AND EXTRACT(YEAR FROM cancel_date) = year
        INTO refunded_registration_fees_for_month;

        IF refunded_registration_fees_for_month IS NULL THEN
            refunded_registration_fees_for_month := 0;
        END IF;
        
        SELECT COUNT(*) 
        FROM Redeems
        WHERE EXTRACT(MONTH FROM redemption_date) = month AND EXTRACT(YEAR FROM redemption_date) = year
        INTO course_registrations_via_course_package_redemptions_for_month;

        RETURN NEXT;
        
        IF (current_month = 1) THEN
            current_month := 12;
            current_year := current_year - 1;
        ELSE 
            current_month := current_month - 1;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

/* Function (30) view_manager_report (Siddarth) */


CREATE OR REPLACE FUNCTION view_manager_report()
RETURNS TABLE(manager_eid INTEGER, manager_name TEXT, total_num_of_managed_course_areas BIGINT, total_num_of_course_offerings_ended BIGINT, total_net_registration_fees NUMERIC, top_course_offering_title TEXT) AS $$
DECLARE
BEGIN
return query
With 
	Course_Offering_Purchase_Excluding_Cancels AS 
	(
		SELECT *
		FROM Registers R1 NATURAL Join Course_Offering_Sessions NATURAL JOIN Course_Offerings 
		WHERE DATE_PART('year', AGE(end_date, current_date)) = 0
		and NOT EXISTS(
		  SELECT 1
		  FROM Cancels C1
		  WHERE R1.cust_id = C1.cust_id
		  and R1.sid = C1.sid
		  and R1.launch_date = C1.launch_date
		  and R1.course_id = C1.course_id
		)
	),
	Course_Offering_Redeemed_Excluding_Cancels AS
	(
		SELECT course_id, launch_date, floor(price/num_free_registrations) as price
		FROM Redeems R1 NATURAL JOIN Course_Offering_Sessions NATURAL JOIN Course_Offerings NATURAL JOIN Buys NATURAL JOIN Course_Packages
		WHERE DATE_PART('year', AGE(end_date, current_date)) = 0
		and NOT EXISTS (
			SELECT 1
			FROM Cancels C1
			WHERE R1.cust_id = C1.cust_id
			and R1.sid = C1.sid
			and R1.launch_date = C1.launch_date
			and R1.course_id = C1.course_id
		)
	),
	Course_Offering_Purchase_Sales AS
	(
		SELECT course_id, launch_date, coalesce(sum(fees), 0) as purchase_sales
		FROM Course_Offering_Purchase_Excluding_Cancels
		GROUP BY course_id, launch_date
	),
	Course_Offering_Redeem_Sales AS
	(
		SELECT course_id, launch_date, coalesce(sum(price), 0) as redeemed_sales
		FROM Course_Offering_Redeemed_Excluding_Cancels
		GROUP BY course_id, launch_date
	),
	Course_Offering_Total_Sales_Excluding_Refunds AS
	(
		SELECT course_id, launch_date, sum(coalesce(purchase_sales, 0)) + sum(coalesce(redeemed_sales, 0)) as total_net_sales
		FROM Course_Offering_Purchase_Sales NATURAL FULL OUTER JOIN Course_Offering_Redeem_Sales
		GROUP BY course_id, launch_date
	),
	Manager_Course_Offering_Details AS
	(
		SELECT *
		FROM Course_Offering_Total_Sales_Excluding_Refunds NATURAL JOIN Courses NATURAL JOIN Course_Areas NATURAL JOIN Managers
	),
	Manager_Top_Course_Offering AS
	(
		SELECT eid, total_net_sales as top_net_sales, string_agg(title, ', ') as top_course_offering_title
		FROM Manager_Course_Offering_Details M1
		WHERE total_net_sales IN 
		(
			SELECT max(total_net_sales)
			FROM Manager_Course_Offering_Details M2
			WHERE M1.eid = M2.eid
			GROUP BY eid
		)
		GROUP BY eid, total_net_sales
		ORDER BY eid
	),
	Manager_Course_Offering_Sales_Info_With_Top_Course_Offerings AS
	(
		SELECT * 
		FROM Manager_Course_Offering_Details Natural JOIN Manager_Top_Course_Offering
	),
	Manager_Course_Offering_Details_Including_Top_Course_Offering AS
	(
		SELECT eid, employee_name, count(distinct course_area_name) as num_of_course_areas_managed, count(distinct(course_id + launch_date)) as num_of_course_offerings_managed
		FROM Managers NATURAL JOIN Employees NATURAL LEFT OUTER JOIN Course_Areas NATURAL LEFT OUTER JOIN Courses NATURAL LEFT OUTER JOIN Course_Offerings
		GROUP BY eid, employee_name
	)
	
	SELECT eid, employee_name, num_of_course_areas_managed, num_of_course_offerings_managed, coalesce(sum(total_net_sales), 0) as total_net_registration_sales, M2.top_course_offering_title
	FROM Manager_Course_Offering_Details_Including_Top_Course_Offering M1 NATURAL LEFT OUTER JOIN Manager_Course_Offering_Sales_Info_With_Top_Course_Offerings M2
	GROUP BY eid, employee_name, M2.top_course_offering_title, num_of_course_offerings_managed, num_of_course_areas_managed 
	ORDER BY eid;
END;
$$ LANGUAGE plpgsql;
