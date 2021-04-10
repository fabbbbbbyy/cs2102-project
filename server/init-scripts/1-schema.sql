/* SQL commands to create application schema */

/* 
Additional notes:
- This schema follows the template ER diagram from left to right as much as possible.  
- Decided to use serial (integer) data type with auto increment for primary keys.
*/

drop table if exists Course_Packages, Credit_Cards, Customers, Employees, Employee_Pay_Slips, Part_Time_Employees, Full_Time_Employees,
    Administrators, Managers, Course_Areas, Instructors, Part_Time_Instructors, Full_Time_Instructors, Courses,
    Course_Offerings, Rooms, Course_Offering_Sessions, Conducts, Cancels, Registers, Buys, Redeems cascade;
  
set timezone = 'Asia/Singapore';

create table Course_Packages (
    package_id serial primary key,
    course_package_name text not null,
    num_free_registrations integer not null check(num_free_registrations > 0),
    price numeric not null check(price >= 0),
    sale_start_date date not null,
    sale_end_date date not null,

  	CONSTRAINT sale_start_before_end check(sale_end_date >= sale_start_date)
);

create table Credit_Cards (
  credit_card_num text primary key,
  expiry_date date not null,
  from_date date not null,
  cvv text not null,
  
  CONSTRAINT does_not_expire_before_from_date check(expiry_date >= from_date),
  CONSTRAINT does_not_expire_before_current_date check(expiry_date > current_date),
  check(credit_card_num similar to '[0-9]+'),
  check(cvv similar to '[0-9]{3}')
);

create table Customers (
  cust_id serial primary key,
  address text,
  name text not null,
  email text,
  phone_num integer,
  credit_card_num text unique not null references Credit_Cards on update cascade deferrable initially deferred
);

create table Employees (
  	eid serial primary key,
    address text,
    depart_date date,
    email text,
    join_date date not null,
    employee_name text not null,
    phone_num text,
  
  	CONSTRAINT employee_joins_before_departing check(depart_date >= join_date)
);

create table Employee_Pay_Slips (
    amount numeric not null check(amount > 0), 
    eid integer,
    num_work_days integer check(num_work_days > 0),
    num_work_hours integer check(num_work_hours > 0 and num_work_hours <= 30),
    payment_date date,
    primary key(payment_date, eid),
    foreign key(eid) references Employees
        on delete cascade
); 

create table Part_Time_Employees (
    eid integer primary key references Employees
        on delete cascade,
   /* Assuming that there can be pro-bono work, or out of good will */
    hourly_rate numeric not null check(hourly_rate >= 0)
);

create table Full_Time_Employees (
    eid integer primary key references Employees
        on delete cascade,
    /* Assuming that there can be pro-bono work, or out of good will */
    monthly_salary numeric not null check(monthly_salary >= 0)
);

create table Administrators (
  eid integer primary key references Full_Time_Employees
      on delete cascade
);

create table Managers (
  eid integer primary key references Full_Time_Employees
      on delete cascade
);

create table Course_Areas (
    eid integer not null references Managers,
    course_area_name text primary key
);

create table Instructors (
    instructor_id integer references Employees
  			on delete cascade,
    course_area_name text references Course_Areas, 
    primary key(instructor_id, course_area_name)
);

create table Part_Time_Instructors (
  instructor_id integer references Part_Time_Employees
      on delete cascade,
  course_area_name text,
  foreign key(instructor_id, course_area_name) references Instructors
      on delete cascade,
  primary key(instructor_id, course_area_name)
);

create table Full_Time_Instructors (
  instructor_id integer references Full_Time_Employees
      on delete cascade,
  course_area_name text,
  foreign key(instructor_id, course_area_name) references Instructors
      on delete cascade,
  primary key(instructor_id, course_area_name)
);

create table Courses (
    course_id serial primary key,
    description text not null,
    title text unique not null,
    duration integer not null check(duration > 0),
    course_area_name text not null references Course_Areas,

    check(duration in (1, 2, 3, 4))  
);

create table Course_Offerings (
    course_id integer references Courses
  		on delete cascade,
    launch_date date,
    admin_eid integer not null references Administrators
        on delete cascade,
  	start_date date,
    end_date date,
    fees numeric not null check (fees > 0.0),
    registration_deadline date not null,
    seating_capacity integer not null check(seating_capacity >= 0), /* Could be 0 for new course offering */ 
    target_number_registrations integer not null check(target_number_registrations > 0),
    primary key(course_id, launch_date),
  
    CONSTRAINT offering_date_starts_before_end check(end_date >= start_date),
  	CONSTRAINT registration_deadline_ten_days_before_start check(registration_deadline + 10 <= start_date),
    CONSTRAINT offering_date_starts_after_launch check(start_date >= launch_date)
);

create table Rooms (
    rid serial primary key,
    seating_capacity integer not null check(seating_capacity > 0),
    location text not null
);

create table Course_Offering_Sessions (
    sid integer not null,
    launch_date date not null,
    course_id integer not null,
    session_date date not null,
    start_time_hour integer not null check(start_time_hour in (9, 10, 11, 14, 15, 16, 17)),
    end_time_hour integer not null check(end_time_hour in (10, 11, 12, 15, 16, 17, 18)),
    primary key(sid, launch_date, course_id),
    foreign key(course_id, launch_date) references Course_Offerings
          on delete cascade,

    CONSTRAINT session_on_weekdays check(extract(isodow from session_date) in (1, 2, 3, 4, 5)),
  	CONSTRAINT session_time_starts_before_end check(end_time_hour > start_time_hour)
);

create table Conducts (
    rid integer references Rooms
        on delete cascade,
  	instructor_id integer,
  	sid integer,
    course_area_name text not null,
  	launch_date date not null,
  	course_id integer not null,
    primary key(rid, instructor_id, sid, launch_date, course_id),
    foreign key(instructor_id, course_area_name) references Instructors
        on delete cascade,
  	foreign key(sid, launch_date, course_id) references Course_Offering_Sessions
        on delete cascade
);

create table Cancels (
    cust_id integer references Customers
      on delete cascade,
    cancel_date date,
    sid integer,
    launch_date date,
  	course_id integer,
    package_credit integer,
    refund_amt numeric,
    primary key(cust_id, cancel_date, sid, launch_date, course_id),
    foreign key(sid, launch_date, course_id) references Course_Offering_Sessions
  			on delete cascade
);

create table Registers (
    cust_id integer references Customers
    		on delete cascade,
    register_date date,
    sid integer,
    launch_date date,
  	course_id integer,
    primary key(cust_id, register_date, sid, launch_date, course_id),
    foreign key(sid, launch_date, course_id) references Course_Offering_Sessions
  	  	on delete cascade,

    CONSTRAINT register_date_before_launch_date check(register_date >= launch_date)
);

create table Buys (
    cust_id integer references Customers
      on delete cascade,
    package_id integer references Course_Packages
      on delete cascade,
    purchase_date date not null,
    num_remaining_redemptions integer not null,
    primary key(cust_id, package_id, purchase_date)
);

create table Redeems (
    redemption_date date,
    sid integer,
    launch_date date,
  	course_id integer,
    cust_id integer,
    package_id integer,
    purchase_date date,
    primary key(redemption_date, sid, launch_date, course_id, cust_id, package_id, purchase_date),
    foreign key(cust_id, package_id, purchase_date) references Buys
        on delete cascade,
    foreign key(sid, launch_date, course_id) references Course_Offering_Sessions
        on delete cascade,
    unique(cust_id, launch_date, course_id),

    CONSTRAINT redemption_date_before_launch_date check(redemption_date >= launch_date)
);

/* SQL commands to create application triggers */

/* Trigger (1) No two sessions for the same course offering can be conducted on the same day and same time */
CREATE OR REPLACE FUNCTION course_offering_timeslot_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
	sessionAlreadyPresent BOOLEAN;
BEGIN
	SELECT COUNT(sid) > 0 INTO sessionAlreadyPresent
  FROM Course_Offering_Sessions
  WHERE course_id = NEW.course_id AND launch_date = NEW.launch_date AND session_date = NEW.session_date 
  AND (int8range(NEW.start_time_hour, new.start_time_hour + new.end_time_hour - new.start_time_hour) && int8range(start_time_hour, end_time_hour));
  
  IF sessionAlreadyPresent = TRUE THEN
  	RAISE EXCEPTION 'There exists a session which is conducted on the same day and time.';
  ELSE
  	RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER course_offering_timeslot_verification
BEFORE INSERT OR UPDATE ON Course_Offering_Sessions
FOR EACH ROW EXECUTE FUNCTION course_offering_timeslot_verification_func();

/* Trigger (2) Start date, end date, and seating capacity of a course offering is determined by its sessions */
CREATE OR REPLACE FUNCTION set_course_offering_start_end_date_seating_capacity_func() 
RETURNS TRIGGER AS $$
DECLARE
  earliest_session_date DATE;
  latest_session_date DATE;
  updated_offering_seating_capacity INTEGER;
BEGIN
  IF (TG_OP = 'DELETE') THEN
    SELECT COALESCE(CAST(SUM(seating_capacity) AS INTEGER), 0) INTO updated_offering_seating_capacity
    FROM Course_Offering_Sessions NATURAL JOIN Conducts NATURAL JOIN Rooms
    WHERE course_id = OLD.course_id AND launch_date = OLD.launch_date;

    SELECT MIN(session_date), MAX(session_date) INTO earliest_session_date, latest_session_date
    FROM Course_Offering_Sessions
    WHERE course_id = OLD.course_id AND launch_date = OLD.launch_date;
    
  	UPDATE Course_Offerings SET start_date = earliest_session_date, end_date = latest_session_date, seating_capacity = updated_offering_seating_capacity
    WHERE course_id = OLD.course_id AND launch_date = OLD.launch_date;
    RETURN OLD;
  ELSE
    SELECT COALESCE(CAST(SUM(seating_capacity) AS INTEGER), 0) INTO updated_offering_seating_capacity
    FROM Course_Offering_Sessions NATURAL JOIN Conducts NATURAL JOIN Rooms
    WHERE course_id = NEW.course_id AND launch_date = NEW.launch_date;

    SELECT MIN(session_date), MAX(session_date) INTO earliest_session_date, latest_session_date
    FROM Course_Offering_Sessions
    WHERE course_id = NEW.course_id AND launch_date = NEW.launch_date;
    
  	UPDATE Course_Offerings SET start_date = earliest_session_date, end_date = latest_session_date, seating_capacity = updated_offering_seating_capacity
    WHERE course_id = NEW.course_id AND launch_date = NEW.launch_date;
  	RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_course_offering_start_end_date_seating_capacity
AFTER INSERT OR DELETE OR UPDATE ON Conducts
FOR EACH ROW EXECUTE FUNCTION set_course_offering_start_end_date_seating_capacity_func();

/* Trigger (3) Verify that seating capacity is equal to sum of all sessions every time Course_Offerings is inserted/updated */
CREATE OR REPLACE FUNCTION verify_course_offering_seating_capacity_func()
RETURNS TRIGGER AS $$
DECLARE
    course_offering_seating_capacity INTEGER;
BEGIN
    SELECT COALESCE(CAST(SUM(seating_capacity) AS INTEGER), 0) INTO course_offering_seating_capacity
    FROM Course_Offering_Sessions NATURAL JOIN Conducts NATURAL JOIN Rooms
    WHERE course_id = NEW.course_id AND launch_date = NEW.launch_date;

    IF NEW.seating_capacity <> course_offering_seating_capacity THEN
        RAISE NOTICE '%', NEW.seating_capacity;
        RAISE NOTICE '%', course_offering_seating_capacity;
        RAISE EXCEPTION 'Course offering seating capacity must be equal to the sum of all of its session seating capacities.';
    END IF;

  	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verify_course_offering_seating_capacity
BEFORE INSERT OR UPDATE ON Course_Offerings
FOR EACH ROW EXECUTE FUNCTION verify_course_offering_seating_capacity_func();

/* Trigger (4) Each customer can have at most one active or partially active package */
CREATE OR REPLACE FUNCTION customer_one_package_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
    current_date DATE;
    num_active_packages integer;
    num_partially_active_packages integer;
BEGIN
    SELECT CURRENT_DATE INTO current_date;

    SELECT COUNT(*) into num_active_packages 
    FROM Buys
    WHERE cust_id = NEW.cust_id
    AND num_remaining_redemptions > 0;

    IF (num_active_packages > 0) THEN
  	    RAISE EXCEPTION 'This customer already has an active package.';
    ELSE 
        RETURN NEW;
    END IF;

    SELECT COUNT(*) into num_partially_active_packages 
    FROM Buys Natural Join Redeems Natural Join Course_Offering_Sessions
    WHERE cust_id = NEW.cust_id
    AND (EXTRACT(DAY FROM current_date) - EXTRACT(DAY FROM session_date) >= 7);

    IF (num_partially_active_packages > 0) THEN 
        RAISE EXCEPTION 'This customer already has a partially active package.'; 
    ELSE 
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER customer_one_package_verification
BEFORE INSERT ON Buys
FOR EACH ROW EXECUTE FUNCTION customer_one_package_verification_func();

/* Trigger (5) Each room can be used to conduct at most one session at any time */
CREATE OR REPLACE FUNCTION room_overlapping_conduct_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
  room_already_taken BOOLEAN;
  new_session_start INTEGER;
  new_session_end INTEGER;
  new_session_date DATE;
BEGIN
  IF (TG_OP = 'INSERT') OR ((TG_OP = 'UPDATE') AND NEW.rid <> OLD.rid) THEN

    SELECT start_time_hour, end_time_hour, session_date INTO new_session_start, new_session_end, new_session_date
    FROM Course_Offering_Sessions 
    WHERE sid = NEW.sid AND course_id = NEW.course_id AND launch_date = NEW.launch_date;
    
    SELECT COUNT(sid) > 0 INTO room_already_taken
    FROM Course_Offering_Sessions NATURAL JOIN Conducts NATURAL JOIN Rooms
    WHERE rid = NEW.rid AND session_date = new_session_date
    AND (int8range(new_session_start, new_session_start + new_session_end - new_session_start) && int8range(start_time_hour, end_time_hour));

    IF room_already_taken = TRUE THEN
      RAISE EXCEPTION 'There exists a session which is conducted in the selected room at the same time';
    ELSE
      RETURN NEW;
    END IF;

  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER room_overlapping_conduct_verification
BEFORE INSERT OR UPDATE ON Conducts
FOR EACH ROW EXECUTE FUNCTION room_overlapping_conduct_verification_func();

/* Trigger (6) Employee can be either a full_time or part_time employee but not both */
CREATE OR REPLACE FUNCTION part_time_employee_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
	num_same_eid_records integer;
BEGIN
	SELECT COUNT(*) INTO num_same_eid_records
  FROM Full_Time_Employees
  WHERE eid = NEW.eid;
  
	IF num_same_eid_records > 0 THEN
  	RAISE EXCEPTION 'This employee is already a full time employee, and therefore cannot be a part time employee.';
  ELSE 
  	RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER part_time_employee_verification
BEFORE INSERT OR UPDATE ON Part_Time_Employees
FOR EACH ROW EXECUTE FUNCTION part_time_employee_verification_func();

CREATE OR REPLACE FUNCTION full_time_employee_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
	num_same_eid_records integer;
BEGIN
	SELECT COUNT(*) INTO num_same_eid_records
  FROM Part_Time_Employees 
  WHERE eid = NEW.eid;
  
	IF num_same_eid_records > 0 THEN
  	RAISE EXCEPTION 'This employee is already a part time employee, and therefore cannot be a full time employee.';
  ELSE 
  	RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER full_time_employee_verification
BEFORE INSERT OR UPDATE ON Full_Time_Employees
FOR EACH ROW EXECUTE FUNCTION full_time_employee_verification_func();

/* Trigger (7) A full time employee MUST either be a manager or an admin but not both */
CREATE OR REPLACE FUNCTION manager_employee_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
	num_same_administrator_eid_records integer;
  num_same_instructor_eid_records integer;
BEGIN
	SELECT COUNT(*) INTO num_same_administrator_eid_records
  FROM Administrators A
  WHERE A.eid = NEW.eid;

  SELECT COUNT(*) INTO num_same_instructor_eid_records
  FROM Instructors I
  WHERE I.instructor_id = NEW.eid;
  
	IF num_same_administrator_eid_records > 0 THEN
  	RAISE EXCEPTION 'This employee is already an administrator, and therefore cannot be a manager.';
  ELSIF num_same_instructor_eid_records > 0 THEN
  	RAISE EXCEPTION 'This employee is already an instructor, and therefore cannot be a manager.';
  ELSE 
  	RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER manager_employee_verification
BEFORE INSERT OR UPDATE ON Managers
FOR EACH ROW EXECUTE FUNCTION manager_employee_verification_func();

CREATE OR REPLACE FUNCTION administrator_employee_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
	num_same_manager_eid_records integer;
  num_same_instructor_eid_records integer;
BEGIN
	SELECT COUNT(*) INTO num_same_manager_eid_records
  FROM Managers M
  WHERE M.eid = NEW.eid;

  SELECT COUNT(*) INTO num_same_instructor_eid_records
  FROM Instructors I
  WHERE I.instructor_id = NEW.eid;
  
	IF num_same_manager_eid_records > 0 THEN
  	RAISE EXCEPTION 'This employee is already a manager, and therefore cannot be an administrator.';
  ELSIF num_same_instructor_eid_records > 0 THEN
  	RAISE EXCEPTION 'This employee is already an instructor, and therefore cannot be an administrator.';
  ELSE 
  	RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER administrator_employee_verification
BEFORE INSERT OR UPDATE ON Administrators
FOR EACH ROW EXECUTE FUNCTION administrator_employee_verification_func();

CREATE OR REPLACE FUNCTION instructor_employee_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
	num_manager_same_eid_records integer;
    num_administrator_same_eid_records integer;
BEGIN
	SELECT COUNT(*) INTO num_manager_same_eid_records
    FROM Managers
    WHERE eid = NEW.instructor_id;

    SELECT COUNT(*) INTO num_administrator_same_eid_records
    FROM Administrators
    WHERE eid = NEW.instructor_id;
  
	IF num_manager_same_eid_records > 0 THEN
  	    RAISE EXCEPTION 'This employee is already a manager, and therefore cannot be an instructor.';
    END IF;

    IF num_administrator_same_eid_records > 0 THEN
        RAISE EXCEPTION 'This employee is already an administrator, and therefore cannot be an instructor.';
    END IF;
  	
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER instructor_employee_verification
BEFORE INSERT OR UPDATE ON Instructors
FOR EACH ROW EXECUTE FUNCTION instructor_employee_verification_func();

/* Trigger (8) Check that a part-time instructor is not already a full-time instructor */
CREATE OR REPLACE FUNCTION check_instructor_is_not_full_time_instructor()
RETURNS TRIGGER AS $$
DECLARE
	count_of_full_time_instr integer;
BEGIN
    SELECT count(*) INTO count_of_full_time_instr
    FROM Full_Time_Instructors
    WHERE NEW.instructor_id  = instructor_id ;
  
    IF count_of_full_time_instr > 0 THEN
        RAISE EXCEPTION 'This instructor is already a full time instructor, and therefore cannot be a part time instructor.';
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_instructor_is_not_full_time_instructor_trigger
BEFORE INSERT OR UPDATE ON Part_Time_Instructors
FOR EACH ROW EXECUTE FUNCTION check_instructor_is_not_full_time_instructor();


CREATE OR REPLACE FUNCTION check_instructor_is_not_part_time_instructor()
RETURNS TRIGGER AS $$
DECLARE
	count_of_full_time_instr integer;
BEGIN
	SELECT count(*) INTO count_of_full_time_instr
    FROM Part_Time_Instructors
    WHERE NEW.instructor_id = instructor_id ;
  
    IF count_of_full_time_instr > 0 THEN
        RAISE EXCEPTION 'This instructor is already a part time instructor, and therefore cannot be a full time instructor.';
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_instructor_is_not_part_time_instructor_trigger
BEFORE INSERT OR UPDATE ON Full_Time_Instructors
FOR EACH ROW EXECUTE FUNCTION check_instructor_is_not_part_time_instructor();

/* Trigger (9) Instructor assigned to teach a course session must be specialised in that course area */
CREATE OR REPLACE FUNCTION check_instructor_teaches_a_course_session_they_specialise_in()
RETURNS TRIGGER AS $$
DECLARE
	is_instructor_specialised_in_course_area BOOLEAN;
BEGIN
	SELECT COUNT(*) > 0 INTO is_instructor_specialised_in_course_area
    FROM Instructors 
    WHERE instructor_id = NEW.instructor_id and NEW.course_area_name = course_area_name;

    IF is_instructor_specialised_in_course_area THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Instructor is not specialised in course area to teach the course session.';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER instructor_specialize_in_course_area_of_course_session_trigger
BEFORE INSERT OR UPDATE ON Conducts
FOR EACH ROW EXECUTE FUNCTION check_instructor_teaches_a_course_session_they_specialise_in();

/* Trigger (10) Each instructor can teach at most one course session at any hour */
CREATE OR REPLACE FUNCTION ensure_instructor_teaches_at_most_one_course_session_at_any_hour()
RETURNS TRIGGER AS $$
DECLARE
	new_assigned_session_date DATE;
    new_assigned_session_start_hour INTEGER;
    new_assigned_session_duration INTEGER;
	count_of_conflicting_course_sessions INTEGER;
BEGIN
	/*Find new assigned course_session session date and session start_hour*/
	SELECT session_date, start_time_hour INTO new_assigned_session_date, new_assigned_session_start_hour
    FROM Course_Offering_Sessions
    WHERE NEW.sid = sid
    and NEW.launch_date = launch_date
    and NEW.course_id = course_id;
    
    SELECT duration INTO new_assigned_session_duration
    FROM Course_Offering_Sessions NATURAL JOIN Course_Offerings NATURAL JOIN Courses
    WHERE NEW.course_id = course_id;

	/*
    Find the number of course_offering_sessions with the same session_date and start_time_hour
    as the assigned course_session date and course_session 
    */
    SELECT count(*) INTO count_of_conflicting_course_sessions
    FROM Conducts NATURAL JOIN Course_Offering_Sessions
    WHERE NEW.instructor_id = instructor_id
    and 
    session_date = new_assigned_session_date
    and
    (int8range(new_assigned_session_start_hour, new_assigned_session_start_hour + new_assigned_session_duration) && int8range(start_time_hour, end_time_hour));
    
    IF count_of_conflicting_course_sessions > 1 THEN
        RAISE EXCEPTION 'Instructor is conducting another session on the same date and same time period. Hence not able to assign instructor.';
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER instructor_cannot_teach_more_than_one_course_session_at_any_hour_trigger
BEFORE INSERT OR UPDATE ON Conducts
FOR EACH ROW EXECUTE FUNCTION ensure_instructor_teaches_at_most_one_course_session_at_any_hour();

/* Trigger (11) Each instructor must not be assigned to teach two consecutive course sessions, there must be at least a one hour beak between sessions */
CREATE OR REPLACE FUNCTION instructor_has_break_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
	num_records_with_not_enough_break_time integer;
BEGIN
	WITH Already_Conducting AS (
    SELECT * 
    FROM Conducts Natural Join Course_Offering_Sessions
    WHERE instructor_id = NEW.instructor_id
  ),
  New_Conducting AS (
    SELECT * 
    FROM Course_Offering_Sessions 
    WHERE sid = NEW.sid
    AND launch_date = NEW.launch_date
    AND course_id = NEW.course_id
  ),
  Same_Date_Sessions AS (
    SELECT AC.start_time_hour as start_time, AC.end_time_hour as end_time, NC.start_time_hour as start_time_2, NC.end_time_hour as end_time_2
    FROM Already_Conducting AC, New_Conducting NC
    WHERE AC.session_date = NC.session_date
  )
  SELECT COUNT(*) 
  FROM Same_Date_Sessions
  WHERE end_time + 1 = start_time_2
  OR start_time - 1 = end_time_2
  INTO num_records_with_not_enough_break_time;

  IF num_records_with_not_enough_break_time THEN
    	RAISE EXCEPTION 'There must be at least an hour break between the teaching sessions!';
  ELSE
    	RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER instructor_has_break_verification
BEFORE INSERT OR UPDATE ON Conducts
FOR EACH ROW EXECUTE FUNCTION instructor_has_break_verification_func();

/* Trigger (12) Each part-time instructor must not teach more than 30 hours each month */
CREATE OR REPLACE FUNCTION part_time_instructor_conduct_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
	new_session_duration INTEGER;
  new_session_date DATE;
	exceedThirtyHours BOOLEAN;
BEGIN
  SELECT (end_time_hour - start_time_hour), session_date INTO new_session_duration, new_session_date
  FROM Course_Offering_Sessions
  WHERE sid = NEW.sid AND course_id = NEW.course_id AND launch_date = NEW.launch_date;
  
  SELECT SUM(end_time_hour - start_time_hour) > (30 - new_session_duration) INTO exceedThirtyHours
  FROM Conducts NATURAL JOIN Instructors NATURAL JOIN Part_Time_Instructors NATURAL JOIN Course_Offering_Sessions
  WHERE date_part('month', session_date) = date_part('month', new_session_date);
  
  IF exceedThirtyHours = TRUE THEN
  	RAISE EXCEPTION 'Part-time instructor will exceed 30 hours of teaching in specified month';
  ELSE
  	RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER part_time_instructor_conduct_verification
BEFORE INSERT OR UPDATE ON Conducts
FOR EACH ROW EXECUTE FUNCTION part_time_instructor_conduct_verification_func();

/* Trigger (13) Every course_offering_session needs to exist in conducts relation */
CREATE OR REPLACE FUNCTION check_all_course_offering_session_is_being_conducted()
RETURNS TRIGGER AS $$
DECLARE
    num_of_course_offering_sessions INTEGER;
    is_every_course_offering_session_conducted BOOLEAN;
    num_of_conducts INTEGER;
BEGIN
    SELECT COUNT(*) INTO num_of_course_offering_sessions
    FROM Course_Offering_Sessions;

    SELECT COUNT(*) = num_of_course_offering_sessions INTO is_every_course_offering_session_conducted
    FROM Course_Offering_Sessions C1
    WHERE EXISTS (
        SELECT 1
        FROM Conducts C2
        WHERE C1.sid = C2.sid
        and C1.launch_date = C2.launch_date
        and C1.course_id = C2.course_id
    );

    IF is_every_course_offering_session_conducted THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'New/updated course offering session is not being conducted. Every course offering sessions needs to be conducted by an instructor.';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER check_all_course_offering_session_is_being_conducted_trigger
AFTER INSERT OR UPDATE ON Course_Offering_Sessions
DEFERRABLE INITIAlLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION check_all_course_offering_session_is_being_conducted();

/* Trigger (14) Trigger that ensures every credit card references at least one customer */
CREATE OR REPLACE FUNCTION credit_card_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
  cust_count INTEGER;
BEGIN
  SELECT COUNT(cust_id) INTO cust_count
  FROM Customers
  WHERE Customers.credit_card_num = NEW.credit_card_num;

  IF (cust_count > 0) THEN
    RETURN NEW;
  ELSE
    RAISE EXCEPTION 'Credit Card is not owned by any Customer.';
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER credit_card_verification
BEFORE INSERT OR UPDATE ON Credit_Cards
FOR EACH ROW EXECUTE FUNCTION credit_card_verification_func();

/* Trigger (15) Every customer can register for at most 1 session from the same course_offering */
CREATE OR REPLACE FUNCTION customer_one_session_from_same_course_offering_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
	num_same_course_offering_session_registered INTEGER;
BEGIN
  WITH HELPER_TABLE AS (
    SELECT * 
    FROM Registers R 
    WHERE R.cust_id = NEW.cust_id
    AND R.launch_date = NEW.launch_date
    AND R.course_id = NEW.course_id
  )
	SELECT COUNT(*) into num_same_course_offering_session_registered 
  FROM HELPER_TABLE;

  IF (num_same_course_offering_session_registered > 1) THEN
  	RAISE EXCEPTION 'This customer already has a session with the same course offering registered.';
  ELSE 
  	RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER customer_one_session_from_same_course_offering_verification
AFTER INSERT OR UPDATE ON Registers
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION customer_one_session_from_same_course_offering_verification_func();

/* Trigger (16) Ensure register date cannot be later than registration deadline and before launch date of course offering */
CREATE OR REPLACE FUNCTION ensure_register_date_earlier_than_registration_deadline()
RETURNS TRIGGER AS $$
DECLARE
    course_offering_registration_deadline DATE;
    course_offering_launch_date DATE;
BEGIN

    SELECT registration_deadline, launch_date INTO course_offering_registration_deadline, course_offering_launch_date
    FROM Course_Offering_Sessions NATURAL JOIN Course_Offerings
    WHERE sid = NEW.sid
    and launch_date = NEW.launch_date
    and course_id = NEW.course_id;

    IF NEW.register_date > course_offering_registration_deadline THEN
        RAISE EXCEPTION 'Cannot register for a course offering session as the register date is later than the registration deadline.';
    ELSIF NEW.register_date < course_offering_launch_date THEN
        RAISE EXCEPTION 'Cannot register for a course offering session as the register date is earlier than course offering launch date.';
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verify_register_date_before_registration_deadline
BEFORE INSERT OR UPDATE ON Registers
FOR EACH ROW EXECUTE FUNCTION ensure_register_date_earlier_than_registration_deadline();

/* Trigger (17) Check if a Customer is trying to Register for a session he has already Redeemed */
CREATE OR REPLACE FUNCTION check_if_course_offering_session_already_redeemed()
RETURNS TRIGGER AS $$
DECLARE
    is_session_redeemed_already BOOLEAN;
    is_conflicting_with_another_registered_session BOOLEAN;
    is_conflicting_with_another_redeemed_session BOOLEAN;
    course_session_date DATE;
    course_session_duration INTEGER;
    course_session_start_hour INTEGER;
BEGIN
    /* Check if the new session is already redeemed */
    SELECT COUNT(*) > 0 INTO is_session_redeemed_already
    FROM Redeems
    WHERE cust_id = NEW.cust_id
    and sid = NEW.sid
    and launch_date = NEW.launch_date
    and course_id = NEW.course_id;

    SELECT session_date, start_time_hour, duration INTO course_session_date, course_session_start_hour, course_session_duration
    FROM Course_Offering_Sessions NATURAL JOIN Course_Offerings NATURAL JOIN Courses
    WHERE sid = NEW.sid
    and launch_date = NEW.launch_date
    and course_id = NEW.course_id;

    /*
      Check if there are any redeemed session with the same session date and time range as the new/updated register tuple
      Reason: At any one point of time, the db instance can only show that customer is attending 1 course session at most. 
    */
    SELECT COUNT(*) > 0 INTO is_conflicting_with_another_redeemed_session
    FROM Redeems NATURAL JOIN Course_Offering_Sessions
    WHERE cust_id = NEW.cust_id
    and session_date = course_session_date
    and (int8range(course_session_start_hour, course_session_start_hour + course_session_duration) && int8range(start_time_hour, end_time_hour));

    WITH
    Customer_Registered_Sessions as (
      SELECT *
      FROM Registers NATURAL JOIN Course_Offering_Sessions
      WHERE cust_id = NEW.cust_id

      EXCEPT

      SELECT *
      FROM Registers NATURAL JOIN Course_Offering_Sessions
      WHERE cust_id = NEW.cust_id
      and course_id = NEW.course_id
      and launch_date = NEW.launch_date
      and sid = NEW.sid
    )
    /* 
      Check if there are any registered session with the same session date and time range as the new/update register tuple 
      Reason: At any one point of time, the db instance can only show that customer is attending 1 course session at most. 
    */
    SELECT COUNT(*) > 0 INTO is_conflicting_with_another_registered_session
    FROM Customer_Registered_Sessions
    WHERE cust_id = NEW.cust_id
    and session_date = course_session_date
    and (int8range(course_session_start_hour, course_session_start_hour + course_session_duration) && int8range(start_time_hour, end_time_hour));

    IF is_session_redeemed_already THEN
        RAISE EXCEPTION 'Course offering session is already redeemed.';
    ELSIF is_conflicting_with_another_registered_session THEN
        RAISE EXCEPTION 'Session date and time range of course offering session conflicts with another registered course offering session';
    ELSIF is_conflicting_with_another_redeemed_session THEN
        RAISE EXCEPTION 'Session date and time range of course offering session conflicts with another redeemed course offering sessions';
    ELSE
        RETURN NEW;
    END IF;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ensure_course_offering_session_not_redeemed
BEFORE INSERT OR UPDATE ON Registers
FOR EACH ROW EXECUTE FUNCTION check_if_course_offering_session_already_redeemed();

/* Trigger (18) Check if a Customer is trying to Redeem for a session he has already Registered */
CREATE OR REPLACE FUNCTION check_if_course_offering_session_already_registered()
RETURNS TRIGGER AS $$
DECLARE
    is_session_registered_already BOOLEAN;
    is_conflicting_with_another_registered_session BOOLEAN;
    is_conflicting_wtih_another_redeemed_session BOOLEAN;
    course_session_date DATE;
    course_session_duration INTEGER;
    course_session_start_hour INTEGER;
BEGIN
    /* Check if the new session is already registerd*/
    SELECT COUNT(*) > 0 INTO is_session_registered_already
    FROM Registers
    WHERE cust_id = NEW.cust_id
    and sid = NEW.sid
    and launch_date = NEW.launch_date
    and course_id = NEW.course_id;

    SELECT session_date, start_time_hour, duration INTO course_session_date, course_session_start_hour, course_session_duration
    FROM Course_Offering_Sessions NATURAL JOIN Course_Offerings NATURAL JOIN Courses
    WHERE sid = NEW.sid
    and launch_date = NEW.launch_date
    and course_id = NEW.course_id;

    WITH
    Customer_Redeemed_Sessions as (
      SELECT *
      FROM Redeems NATURAL JOIN Course_Offering_Sessions
      WHERE cust_id = NEW.cust_id

      EXCEPT

      SELECT *
      FROM Redeems NATURAL JOIN Course_Offering_Sessions
      WHERE cust_id = NEW.cust_id
      and course_id = NEW.course_id
      and launch_date = NEW.launch_date
      and sid = NEW.sid
    )
    /* 
      Check if there are any redeemed session with the same session date and time range as the new/updated register tuple after insertion/update
      Reason: At any one point of time, the db instance can only show that customer is attending 1 course session at most.
     */
    SELECT COUNT(*) > 0 INTO is_conflicting_wtih_another_redeemed_session
    FROM Customer_Redeemed_Sessions
    WHERE cust_id = NEW.cust_id
    and session_date = course_session_date
    and (int8range(course_session_start_hour, course_session_start_hour + course_session_duration) && int8range(start_time_hour, end_time_hour));

    /* 
      Check if there are any registered session with the same session date and time range as the new/update register tuple 
      Reason: At any one point of time, the db instance can only show that customer is attending 1 course session at most. 
    */
    SELECT COUNT(*) > 0 INTO is_conflicting_with_another_registered_session
    FROM Registers NATURAL JOIN Course_Offering_Sessions
    WHERE cust_id = NEW.cust_id
    and session_date = course_session_date
    and (int8range(course_session_start_hour, course_session_start_hour + course_session_duration) && int8range(start_time_hour, end_time_hour));

    IF is_session_registered_already THEN
        RAISE EXCEPTION 'Course offering session is already registered.';
    ELSIF is_conflicting_with_another_registered_session THEN
        RAISE EXCEPTION 'Session date and time range of course offering session conflicts with another registerd course offering session';
    ELSIF is_conflicting_wtih_another_redeemed_session THEN
        RAISE EXCEPTION 'Session date and time range of course offering session conflicts with another redeemed course offering sessions';
    ELSE
        RETURN NEW;
    END IF;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ensure_course_offering_session_not_registered
BEFORE INSERT OR UPDATE ON Redeems
FOR EACH ROW EXECUTE FUNCTION check_if_course_offering_session_already_registered();

/* Trigger (19) Check if end_time_hour - start_time_hour = duration from Courses */
CREATE OR REPLACE FUNCTION ensure_start_and_end_of_course_session_matches_course_duration()
RETURNS TRIGGER AS $$
DECLARE
    course_duration INTEGER;
    is_course_offering_session_start_and_end_hour_valid BOOLEAN;
BEGIN
    SELECT duration INTO course_duration
    FROM Courses
    WHERE course_id = NEW.course_id;  

    is_course_offering_session_start_and_end_hour_valid := (NEW.end_time_hour - NEW.start_time_hour) = course_duration;

    IF is_course_offering_session_start_and_end_hour_valid THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Start and end hour of course offering session does not match course duration.';
    END IF; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ensure_validity_of_start_and_end_hour_of_course_session
BEFORE INSERT OR UPDATE ON Course_Offering_Sessions
FOR EACH ROW EXECUTE FUNCTION ensure_start_and_end_of_course_session_matches_course_duration();

/* Trigger (20) Check if register date in registers is earlier than course offering session date */
CREATE OR REPLACE FUNCTION check_register_date_before_session_date()
RETURNS TRIGGER AS $$
DECLARE
    course_session_date DATE;
BEGIN
    SELECT session_date INTO course_session_date
    FROM Course_Offering_Sessions
    WHERE sid = NEW.sid 
    and launch_date = NEW.launch_date
    and course_id = NEW.course_id;

    /* Assume cannot register on the day of session itself */
    IF NEW.register_date >= course_session_date THEN
        RAISE EXCEPTION 'Cannot register for a course offering session which is over already.';
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ensure_register_date_before_session_date
BEFORE INSERT OR UPDATE ON Registers
FOR EACH ROW EXECUTE FUNCTION check_register_date_before_session_date();

/* Trigger (21) Check if redemption date in redeems is earlier than course offering session date */
CREATE OR REPLACE FUNCTION check_redemption_date_before_session_date()
RETURNS TRIGGER AS $$
DECLARE
    course_session_date DATE;
BEGIN
    SELECT session_date INTO course_session_date
    FROM Course_Offering_Sessions
    WHERE sid = NEW.sid 
    and launch_date = NEW.launch_date
    and course_id = NEW.course_id;

    /* Assume cannot redeem on the day of sesion itself */
    IF NEW.redemption_date >= course_session_date THEN
        RAISE EXCEPTION 'Cannot redeem for a course offering session which is over already.';
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ensure_redemption_date_before_session_date
BEFORE INSERT OR UPDATE ON Redeems
FOR EACH ROW EXECUTE FUNCTION check_redemption_date_before_session_date();

/* Trigger (22) Check if this Employee eventually becomes either Part_Time or Full_Time by the end of the 
block because it must be either. Deferrable initially deferred */
CREATE OR REPLACE FUNCTION check_employee_either_part_time_or_full_time_employee()
RETURNS TRIGGER AS $$
DECLARE
    is_part_time_employee BOOLEAN;
    is_full_time_employee BOOLEAN;
BEGIN
    SELECT count(distinct eid) > 0 INTO is_part_time_employee
    FROM Part_Time_Employees
    WHERE eid = NEW.eid;

    SELECT COUNT(distinct eid) > 0 INTO is_full_time_employee
    FROM Full_Time_Employees
    WHERE eid = NEW.eid;

    IF is_part_time_employee or is_full_time_employee THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Employee must either be part time or full time employee';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER ensure_employee_either_part_time_or_full_time_employee
AFTER INSERT OR UPDATE ON Employees
DEFERRABLE INITIAlLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION check_employee_either_part_time_or_full_time_employee();

/* Trigger (23) If eid is Part_Time_Employee, num_work_days must be null and num_work_hours non null */
CREATE OR REPLACE FUNCTION check_pay_slip_corresponds_to_part_time_emp()
RETURNS TRIGGER AS $$
DECLARE
    is_full_time_emp BOOLEAN;
    is_part_time_emp BOOLEAN;
BEGIN
    SELECT count(*) > 0 INTO is_full_time_emp
    FROM Full_Time_Employees
    WHERE NEW.eid = eid;

    SELECT count(*) > 0 INTO is_part_time_emp
    FROM Part_Time_Employees
    WHERE NEW.eid = eid;

    IF is_full_time_emp THEN
        IF NEW.num_work_days IS NULL THEN
            RAISE EXCEPTION 'Pay slip for full time employee does not contain number of work days for the month.';
        ELSIF NEW.num_work_hours IS NOT NULL THEN
            RAISE EXCEPTION 'Pay slip for full time employee should not contain number of work hours for the month.';
        ELSE
            RETURN NEW;
        END IF;
    END IF;

    IF is_part_time_emp THEN
        IF NEW.num_work_hours IS NULL THEN
            RAISE EXCEPTION 'Pay slip for part time employee does not contain number of work hours for the month.';
        ELSIF NEW.num_work_days IS NOT NULL THEN
            RAISE EXCEPTION 'Pay slip for part time employees should not contain number of work days for the month.';
        ELSE
            RETURN NEW;
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ensure_pay_slip_corresponds_to_part_time_emp
BEFORE INSERT OR UPDATE ON Employee_Pay_Slips
FOR EACH ROW EXECUTE FUNCTION check_pay_slip_corresponds_to_part_time_emp();

/* Trigger (24) Check if Course_Offerings has at least 1 Course_Offering_Sessions. Deferrable initially deferred. 
Prevent from just inserting into Course_Offering */
CREATE OR REPLACE FUNCTION course_offering_at_least_one_session_func()
RETURNS TRIGGER AS $$
DECLARE
  has_sessions BOOLEAN;
BEGIN
  SELECT COUNT(*) > 0 INTO has_sessions
  FROM Course_Offering_Sessions
  WHERE course_id = NEW.course_id AND launch_date = NEW.launch_date;

  IF has_sessions = FALSE THEN
    RAISE EXCEPTION 'Course offerings must have at least one session';
  END IF;

  RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER course_offering_at_least_one_session
AFTER INSERT OR UPDATE ON Course_Offerings
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION course_offering_at_least_one_session_func();

/* Trigger (25) Check if cust_id has a session with sid, launch_date, course_id in Registers or Redeems */
CREATE OR REPLACE FUNCTION cancel_session_exists_validation_func() 
RETURNS TRIGGER AS $$
DECLARE
  is_valid_registration_identifier BOOLEAN;
  is_valid_redemption_identifier BOOLEAN;
BEGIN
  SELECT COUNT(*) = 1 INTO is_valid_registration_identifier
  FROM Registers
  WHERE cust_id = NEW.cust_id AND course_id = NEW.course_id AND launch_date = NEW.launch_date AND sid = NEW.sid;
  
  SELECT COUNT(*) > 0 INTO is_valid_redemption_identifier
  FROM Redeems
  WHERE cust_id = NEW.cust_id AND course_id = NEW.course_id AND launch_date = NEW.launch_date AND sid = NEW.sid;

  IF is_valid_registration_identifier = FALSE AND is_valid_redemption_identifier = FALSE THEN
  	RAISE EXCEPTION 'Session has not been redeemed or registered by customer.';
  ELSE 
    RETURN NEW;
  END IF;
  
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER cancel_session_exists_validation
BEFORE INSERT OR UPDATE ON Cancels
FOR EACH ROW EXECUTE FUNCTION cancel_session_exists_validation_func();


/* Trigger (26) Check if sale_start_date < purchase_date in Course_Packages and sale_end_date > purchase_date in Course_Packages */
CREATE OR REPLACE FUNCTION course_package_date_validation_func() 
RETURNS TRIGGER AS $$
DECLARE
    _sale_start_date date;
    _sale_end_date date;
    _current_date date;
BEGIN
    SELECT CURRENT_DATE into _current_date;

    SELECT sale_start_date, sale_end_date
    FROM Course_Packages
    WHERE package_id = NEW.package_id
    INTO _sale_start_date, _sale_end_date;

	IF _current_date > _sale_end_date THEN
      RAISE EXCEPTION 'This course package sale has already ended!';
    ELSIF _current_date < _sale_start_date THEN
      RAISE EXCEPTION 'This course package sale has not started yet!';
    ELSE 
      RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER course_package_date_validation
BEFORE INSERT OR UPDATE ON Buys
FOR EACH ROW EXECUTE FUNCTION course_package_date_validation_func();

/* Trigger (27) Changes to Redeems will be reflected in Buys */
CREATE OR REPLACE FUNCTION redeems_updates_buys_func() 
RETURNS TRIGGER AS $$
DECLARE
  num_records_with_same_cust_id_in_buys integer;
  num_records_with_not_enough_redemptions integer;
BEGIN
	SELECT COUNT(*) into num_records_with_same_cust_id_in_buys
  FROM Buys 
  WHERE cust_id = NEW.cust_id;

  SELECT COUNT(*) into num_records_with_not_enough_redemptions
  FROM Buys 
  WHERE cust_id = NEW.cust_id
  AND num_remaining_redemptions > 0;

  IF num_records_with_same_cust_id_in_buys <= 0 THEN
    RAISE EXCEPTION 'This customer does not own any course packages!';
  ELSIF num_records_with_not_enough_redemptions <= 0 THEN
    RAISE EXCEPTION 'This customer has not enough redemptions left in his package.';
  ELSE 
    UPDATE Buys
    SET num_remaining_redemptions = num_remaining_redemptions - 1
    WHERE cust_id = NEW.cust_id;

  	RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER redeems_updates_buys
BEFORE INSERT ON Redeems
FOR EACH ROW EXECUTE FUNCTION redeems_updates_buys_func();
                                                   
/* Trigger (28) Check that sessions are consecutively numbered */
CREATE OR REPLACE FUNCTION consecutive_session_numbering_func()
RETURNS TRIGGER AS $$
DECLARE
    max_sid INTEGER;
    next_session_number INTEGER;
BEGIN
    SELECT sid INTO max_sid
    FROM Course_Offering_Sessions S
    WHERE S.course_id = NEW.course_id AND S.launch_date = NEW.launch_date
    ORDER BY sid DESC
    LIMIT 1;

    IF max_sid IS NULL THEN
        next_session_number := 1;
    ELSE
        next_session_number := max_sid + 1;
    END IF;
    
    IF NEW.sid <> next_session_number THEN
  	    RAISE EXCEPTION 'Incorrect session number (next session number is %)', next_session_number;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER consecutive_session_numbering
BEFORE INSERT ON Course_Offering_Sessions
FOR EACH ROW EXECUTE FUNCTION consecutive_session_numbering_func();

/* Trigger (29) Do not allow deletion of Part Time Employees unless it is also deleted from Employees table */
CREATE OR REPLACE FUNCTION check_if_part_time_emp_exist_in_employees()
RETURNS TRIGGER AS $$
DECLARE
  does_eid_exist_in_emp BOOLEAN;
BEGIN
  SELECT COUNT(*) > 0 INTO does_eid_exist_in_emp
  FROM Employees
  WHERE eid = OLD.eid;

  IF does_eid_exist_in_emp THEN
    RAISE EXCEPTION 'Deletion of part time employee not allowed because eid of part time employee still exists in employee';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER ensure_part_time_eid_does_not_exist_in_employees
AFTER DELETE ON Part_Time_Employees
DEFERRABLE INITIALLY IMMEDIATE
FOR EACH ROW EXECUTE FUNCTION check_if_part_time_emp_exist_in_employees();

/* Trigger (30) Do not allow deletion of Full Time Employees unless it is also delete from Employees table */
CREATE OR REPLACE FUNCTION check_if_full_time_emp_exist_in_employees()
RETURNS TRIGGER AS $$
DECLARE
  does_eid_exist_in_emp BOOLEAN;
BEGIN
  SELECT COUNT(*) > 0 INTO does_eid_exist_in_emp
  FROM Employees
  WHERE eid = OLD.eid;

  IF does_eid_exist_in_emp THEN
    RAISE EXCEPTION 'Deletion of full time employee not allowed because eid of full time employee still exists in employee';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER ensure_full_time_eid_does_not_exist_in_employees
AFTER DELETE ON Full_Time_Employees
DEFERRABLE INITIALLY IMMEDIATE
FOR EACH ROW EXECUTE FUNCTION check_if_full_time_emp_exist_in_employees();

/* Trigger (31) Do not allow deletion of administrators unless it is also deleted from Full Time Employees table */
CREATE OR REPLACE FUNCTION check_if_admin_exist_in_full_time_employees()
RETURNS TRIGGER AS $$
DECLARE
  does_admin_id_exist_in_full_time_emp BOOLEAN;
BEGIN
  SELECT COUNT(*) > 0 INTO does_admin_id_exist_in_full_time_emp
  FROM Full_Time_Employees
  WHERE eid = OLD.eid;

   IF does_admin_id_exist_in_full_time_emp THEN
    RAISE EXCEPTION 'Deletion of administrator not allowed because id of administrator still exists in full time employees';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER ensure_admin_id_does_not_exist_in_full_time_employees
AFTER DELETE ON Administrators
DEFERRABLE INITIALLY IMMEDIATE
FOR EACH ROW EXECUTE FUNCTION check_if_admin_exist_in_full_time_employees();

/* Trigger (32) Do not allow deletion of manager unless it is also deleted from Full Time Employees table */
CREATE OR REPLACE FUNCTION check_if_manager_exist_in_full_time_employees()
RETURNS TRIGGER AS $$
DECLARE
  does_manager_id_exist_in_full_time_emp BOOLEAN;
BEGIN
  SELECT COUNT(*) > 0 INTO does_manager_id_exist_in_full_time_emp
  FROM Full_Time_Employees
  WHERE eid = OLD.eid;

   IF does_manager_id_exist_in_full_time_emp THEN
    RAISE EXCEPTION 'Deletion of manager not allowed because id of manager still exists in full time employees';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER ensure_manager_id_does_not_exist_in_full_time_employees
AFTER DELETE ON Managers
DEFERRABLE INITIALLY IMMEDIATE
FOR EACH ROW EXECUTE FUNCTION check_if_manager_exist_in_full_time_employees();

/* Trigger (33) Do not allow deletion of part time instructor unless it is also deleted from Part Time Employees table */
CREATE OR REPLACE FUNCTION check_if_part_time_instruc_id_exist_in_part_time_employees()
RETURNS TRIGGER AS $$
DECLARE
  does_part_time_instruc_id_exist_in_part_time_emp BOOLEAN;
BEGIN
  SELECT COUNT(*) > 0 INTO does_part_time_instruc_id_exist_in_part_time_emp
  FROM Part_Time_Employees
  WHERE eid = OLD.instructor_id;

   IF does_part_time_instruc_id_exist_in_part_time_emp THEN
    RAISE EXCEPTION 'Deletion of part time instructor not allowed because id of part time instructor still exists in part time employees';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER ensure_part_time_instruc_id_does_not_exist_in_part_time_employees
AFTER DELETE ON Part_Time_Instructors
DEFERRABLE INITIALLY IMMEDIATE
FOR EACH ROW EXECUTE FUNCTION check_if_part_time_instruc_id_exist_in_part_time_employees();

/* Trigger (34) Do not allow deletion of full time instructor unless it is also deleted from Full Time Employees table */
CREATE OR REPLACE FUNCTION check_if_full_time_instruc_id_exist_in_full_time_employees()
RETURNS TRIGGER AS $$
DECLARE
  does_full_time_instruc_id_exist_in_full_time_emp BOOLEAN;
BEGIN
  SELECT COUNT(*) > 0 INTO does_full_time_instruc_id_exist_in_full_time_emp
  FROM Full_Time_Employees
  WHERE eid = OLD.instructor_id;

   IF does_full_time_instruc_id_exist_in_full_time_emp THEN
    RAISE EXCEPTION 'Deletion of full time instructor not allowed because id of full time instructor still exists in full time employees';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER ensure_full_time_instruc_id_does_not_exist_in_full_time_employees
AFTER DELETE ON Full_Time_Instructors
DEFERRABLE INITIALLY IMMEDIATE
FOR EACH ROW EXECUTE FUNCTION check_if_full_time_instruc_id_exist_in_full_time_employees();

/* Trigger (35) Prevent deletion of a session that has already been redeemed and attended */
CREATE OR REPLACE FUNCTION delete_redeems_func()
RETURNS TRIGGER AS $$
DECLARE
  _session_date date;
BEGIN
    SELECT session_date
    FROM Course_Offering_Sessions C
    WHERE C.sid = OLD.sid
    AND C.launch_date = OLD.launch_date
    AND C.course_id = OLD.course_id
    INTO _session_date;

    IF _session_date < current_date THEN
      RAISE EXCEPTION 'The redeemed session has already been attended and cannot be deleted from the records.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER delete_redeems_trigger
AFTER DELETE ON Redeems
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION delete_redeems_func();

/* Trigger (36) Prevent deletion of a package that has already been used */
CREATE OR REPLACE FUNCTION delete_buys_func()
RETURNS TRIGGER AS $$
DECLARE
  _has_redeemed boolean;
BEGIN
  SELECT COUNT(*) > 0
  FROM Redeems R
  WHERE R.cust_id = OLD.cust_id
  AND R.package_id = OLD.package_id
  AND R.purchase_date = OLD.purchase_date
  INTO _has_redeemed;

  IF _has_redeemed = TRUE THEN
    RAISE EXCEPTION 'This customer has already redeemed a session with his package, thus we cannot delete this record.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER delete_buys_trigger
AFTER DELETE ON Buys
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION delete_buys_func();

/* Trigger (37) Prevent deletion of a session that has already been attended */
CREATE OR REPLACE FUNCTION delete_registers_func()
RETURNS TRIGGER AS $$
DECLARE
  _session_date date;
BEGIN
  SELECT session_date
  FROM Course_Offering_Sessions C
  WHERE C.sid = OLD.sid
  AND C.launch_date = OLD.launch_date
  AND C.course_id = OLD.course_id
  INTO _session_date;

  IF _session_date < current_date THEN
    RAISE EXCEPTION 'The registered session has already been attended and cannot be deleted from the records.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER delete_registers_trigger
AFTER DELETE ON Registers
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION delete_registers_func();

/* Trigger (38) Prevent deletion of a session that has already been conducted */
CREATE OR REPLACE FUNCTION delete_conducts_func()
RETURNS TRIGGER AS $$
DECLARE
  _session_date date;
BEGIN
  SELECT session_date
  FROM Course_Offering_Sessions C
  WHERE C.sid = OLD.sid
  AND C.launch_date = OLD.launch_date
  AND C.course_id = OLD.course_id
  INTO _session_date;

  IF _session_date < current_date THEN
    RAISE EXCEPTION 'The session has already been conducted and cannot be deleted from the records.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER delete_conducts_trigger
AFTER DELETE ON Conducts
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION delete_conducts_func();

/* Trigger (39) Prevent deletion of a session that is already over */
CREATE OR REPLACE FUNCTION delete_session_func()
RETURNS TRIGGER AS $$
BEGIN
  IF OLD.session_date < current_date THEN
    RAISE EXCEPTION 'The session is already over and cannot be deleted from the records.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER delete_session_trigger
AFTER DELETE ON Course_Offering_Sessions
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION delete_session_func();

/* Trigger (40) Prevent deletion of an offering if it's the only offering */
CREATE OR REPLACE FUNCTION delete_course_offering_func()
RETURNS TRIGGER AS $$
DECLARE
  _end_date date;
  _is_only_course_offering boolean;
BEGIN
  IF _end_date < current_date THEN
    RAISE EXCEPTION 'The offering is already over and cannot be deleted from the records.';
  END IF;

  SELECT COUNT(*) <= 0
  FROM Course_Offerings C
  WHERE C.course_id = OLD.course_id
  AND C.launch_date = OLD.launch_date
  INTO _is_only_course_offering;

  IF _is_only_course_offering = TRUE THEN
    RAISE EXCEPTION 'The offering is the only course offering for a particular course and cannot be deleted.';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER delete_course_offering_trigger
AFTER DELETE ON Course_Offerings
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW EXECUTE FUNCTION delete_course_offering_func();

/* Trigger (41) Ensure redemption date cannot be later than registration deadline and before launch date of course offering */
CREATE OR REPLACE FUNCTION ensure_redemption_date_constraints()
RETURNS TRIGGER AS $$
DECLARE
    course_offering_registration_deadline DATE;
    course_offering_launch_date DATE;
BEGIN

    SELECT registration_deadline, launch_date INTO course_offering_registration_deadline, course_offering_launch_date
    FROM Course_Offering_Sessions NATURAL JOIN Course_Offerings
    WHERE sid = NEW.sid
    and launch_date = NEW.launch_date
    and course_id = NEW.course_id;

    IF NEW.redemption_date > course_offering_registration_deadline THEN
        RAISE EXCEPTION 'Cannot redeeem for a course offering session as the redemption date is later than the registration deadline.';
    ELSIF NEW.redemption_date < course_offering_launch_date THEN
        RAISE EXCEPTION 'Cannot redeem for a course offering session as the redemption date is earlier than course offering launch date.';
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verify_registration_date_valid
BEFORE INSERT OR UPDATE ON Redeems
FOR EACH ROW EXECUTE FUNCTION ensure_redemption_date_constraints();
