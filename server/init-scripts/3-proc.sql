/* SQL or PL/pgSQL routines for function implementations */

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

/*Function (1) add_employee*/

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

/* Function (2) remove_employee */

/* Function (3) add_customer*/

/* Function (4) update_credit_card*/

/* Function (5) add_course*/
CREATE OR REPLACE PROCEDURE add_course(course_description text, course_title text, duration integer,
course_area text) 
AS $$
BEGIN
    INSERT INTO Courses (description, title, duration, course_area_name)
        VALUES (course_description, course_title, duration, course_area);
END;
$$ LANGUAGE plpgsql;

/* Function (6) find_instructors*/

/* Function (7) get_available_instructors*/

/* Function (8) find_rooms*/

/* Function (9) get_available_rooms*/


/* Function (10) add_course_offering*/

/* Function (11) add_course_package*/

/* Function (12) get_available_course_packages*/

/* Function (13) buy_course_package*/
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

/* Function (14) get_my_course_package*/

/* Function (15) get_available_course_offerings*/

/* Function (16) get_available_course_sessions*/

/* Function (17) register_session*/
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

/* Function (18) get_my_registrations*/

/* Function (19) update_course_session*/

/* Function (20) cancel_registration*/

/* Function (21) update_instructor*/
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

/* Function (22) update_room*/

/* Function (23) remove_session*/

/* Function (24) add_session*/

/* Function (25) pay_salary*/
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

/* Function (26) promote_courses*/

/* Function (27) top_packages*/

/* Function (28) popular_courses*/

/* Function (29) view_summary_report*/
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

/* Function (30) view_manager_report*/
