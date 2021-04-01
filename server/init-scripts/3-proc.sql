/* SQL or PL/pgSQL routines for function implementations */

/*Function (1) add_employee*/

/* Function (2) remove_employee */
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
  SELECT count(distinct course_id) INTO num_of_registration_after_depart_date
  FROM Course_Offerings
  WHERE admin_eid = NEW.eid and registration_deadline > NEW.depart_date;
  
  SELECT count(distinct c1.course_id) INTO num_of_courses_session_after_depart_date
  FROM Conducts c1, Course_Offering_Sessions c2
  WHERE c1.eid = NEW.eid and c1.course_id = c2.course_id
  and c2.launch_date > NEW.depart_date;
  
  SELECT count(distinct c.name) INTO num_of_course_area_emp_managing
  FROM Managers m, Course_Areas c
  WHERE m.eid = NEW.eid and m.eid = c.eid;
  
  IF num_of_registration_after_depart_date > 0 THEN
  	RAISE EXCEPTION 'Employee is an administraot who is handling some course offering where its registration deadline is after employee departure date. Hence employee cannot be removed.';
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

/* Function (3) add_customer*/

/* Function (4) update_credit_card*/
CREATE OR REPLACE PROCEDURE update_credit_card(customer_id INTEGER, credit_card_no TEXT, expiration_date DATE, CVV_code INTEGER)
AS $$
DECLARE
	previous_credit_card_number TEXT;
BEGIN
  SELECT number INTO previous_credit_card_number
  FROM Customers C
  WHERE C.cust_id = customer_id;

  DELETE FROM Credit_Cards WHERE number = previous_credit_card_number;
  INSERT INTO Credit_Cards(number, expiry_date, from_date, cvv) VALUES(credit_card_no, expiration_date, CURRENT_DATE, CVV_code);

  UPDATE Customers
  SET number = credit_card_no
  WHERE cust_id = customer_id;
END;
$$ LANGUAGE plpgsql;

/* Function (5) add_course*/

/* Function (6) find_instructors*/
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
    WHERE i.instructor_id = c2.eid 
    			and c2.course_id = c1.course_id /*Find courses that the instructor teaches*/
    			and c1.session_date = new_session_date /*Find the course sessions that instructor teaches on the input session_date*/
          and (int8range(new_session_start_hour, new_session_start_hour + session_duration) && int8range(c1.start_time_hour, c1.end_time_hour))
  );

END;
$$ LANGUAGE plpgsql;

/* Function (7) get_available_instructors*/

/* Function (8) find_rooms*/

/* Function (9) get_available_rooms*/

/* Function (10) add_course_offering*/

/* Function (11) add_course_package*/

/* Function (12) get_available_course_packages*/

/* Function (13) buy_course_package*/

/* Function (14) get_my_course_package*/

/* Function (15) get_available_course_offerings*/

/* Function (16) get_available_course_sessions*/

/* Function (17) register_session*/

/* Function (18) get_my_registrations*/
CREATE OR REPLACE FUNCTION get_my_registrations(customer_id integer)
RETURNS TABLE(course_name text, course_fees numeric, session_date date, session_start_hour integer, session_duration integer, instructor_name text) AS $$
DECLARE
	current_date date;
BEGIN
	SELECT CURRENT_DATE INTO current_date;
  
  return query
  /*{course_id, sid, launch_date, session_date, fees, start_time}*/
  SELECT title as course_name, fees as course_fees, C1.session_date, start_time_hour as session_start_hour, duration as session_duration, employee_name as instructor_name
  FROM (Registers R NATURAL JOIN Course_Offering_Sessions C1 NATURAL JOIN Course_Offerings C2 NATURAL JOIN Conducts NATURAL JOIN Courses) inner join Employees on instructor_id = eid
  WHERE cust_id = customer_id
  and registration_deadline > current_date
  ORDER BY session_date asc, session_start_hour asc;

END;
$$ LANGUAGE plpgsql;

/* Function (19) update_course_session*/

/* Function (20) cancel_registration*/

/* Function (21) update_instructor*/

/* Function (22) update_room*/

/* Function (23) remove_session*/

/* Function (24) add_session*/

/* Function (25) pay_salary*/

/* Function (26) promote_courses*/
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
$$ LANGUAGE plpgsql

/* Function (27) top_packages*/

/* Function (28) popular_courses*/

/* Function (29) view_summary_report*/

/* Function (30) view_manager_report*/
