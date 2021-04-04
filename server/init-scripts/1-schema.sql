/* SQL commands to create application schema */

/* 
Additional notes:
- This schema follows the template ER diagram from left to right as much as possible.
- The ordering for attributes are in lexographical order and primary and foreign keys are 
denoted at the bottom for consistent styling across tables.
- If a table is a combined table between entities, we will have the attributes of the overarching
entity in lexographical order, followed by the attributes of the 2nd/3rd/etc.. entity similarly
in lexographical order below it.
- Attribute types are subject to change.  
- Decided to use int data type with auto increment for primary keys
*/

drop table if exists Course_Packages, Credit_Cards, Customers, Employees, Employee_Pay_Slips, Part_Time_Employees, Full_Time_Employees,
    Administrators, Managers, Course_Areas, Instructors, Part_Time_Instructors, Full_Time_Instructors, Courses,
    Course_Offerings, Rooms, Course_Offering_Sessions, Conducts, Cancels, Registers, Buys, Redeems cascade;
  
set timezone = 'Asia/Singapore';

/* (CORRECT) */
create table Course_Packages (
    package_id serial primary key,
    course_package_name text not null,
    num_free_registrations integer not null check(num_free_registrations > 0),
    price numeric not null check(price >= 0),
    sale_start_date date not null,
    sale_end_date date not null,

  	check(sale_end_date >= sale_start_date)
);

/* (CORRECT) */
create table Credit_Cards (
  credit_card_num text primary key,
  expiry_date date not null,
  from_date date not null,
  /* CVV must be three digit, integer might not be able to save 089 */
  cvv text not null,
  
  check(credit_card_num similar to '[0-9]+'),
  check(expiry_date >= from_date),
  check(cvv similar to '[0-9]{3}')
);

/* (CORRECT) */
/* Application specs and functions 3 and 4 seem to imply a one-to-one relationship */
create table Customers (
  cust_id serial primary key,
  address text,
  /* The customer, at bare minimum, should have at least name and credit card num provided */
  name text not null,
  email text,
  /* Assume that user is from Singapore, starting digit must be 6, 8, 9, 8 digit number, check in range*/
  phone_num integer,
  credit_card_num text unique not null references Credit_Cards deferrable initially deferred
);

/* (CORRECT) */
create table Employees (
  	eid serial primary key,
    address text,
    depart_date date,
    email text,
    join_date date not null,
    /* The employee, at bare minimum, should have at least name and join date provided */
    employee_name text not null,
    /* Assume that user is from Singapore, starting digit must be 6, 8, 9, 8 digit number, check in range*/
    phone_num text,
  
  	check(depart_date >= join_date)
);

/* (CORRECT) */
create table Employee_Pay_Slips (
    amount numeric not null check(amount > 0), 
    eid integer,
    num_work_days integer check(num_work_days > 0),
    num_work_hours integer check(num_work_hours > 0),
    payment_date date,
    primary key(payment_date, eid),
    foreign key(eid) references Employees
        on delete cascade
); 

/* (CORRECT) */
/* hourly_rate not null because any row in Part_Time_Employees must exist */
create table Part_Time_Employees (
    eid integer primary key references Employees
        on delete cascade,
   /* Assuming that there can be pro-bono work, or out of good will */
    hourly_rate numeric not null check(hourly_rate >= 0)
);

/* (CORRECT) */
/* monthly_salary not null because any row in Full_Time_Employees must exist */
create table Full_Time_Employees (
    eid integer primary key references Employees
        on delete cascade,
    /* Assuming that there can be pro-bono work, or out of good will */
    monthly_salary numeric not null check(monthly_salary >= 0)
);

/* (CORRECT) */
/* Administrator is a full time emp*/
create table Administrators (
  eid integer primary key references Full_Time_Employees
      on delete cascade
);

/* (CORRECT) */
/* Manager is a full time emp*/
create table Managers (
  eid integer primary key references Full_Time_Employees
      on delete cascade
);

/* (CORRECT) */
create table Course_Areas (
    eid integer not null references Managers,
    course_area_name text primary key
);

/* (CORRECT) */
/*Instructor is a employee*/
create table Instructors (
    instructor_id integer references Employees
  			on delete cascade,
   /* Specialize relationship */
    course_area_name text references Course_Areas, 
    primary key(instructor_id, course_area_name)
);

/* (CORRECT) */
create table Part_Time_Instructors (
  instructor_id integer references Part_Time_Employees
      on delete cascade,
  course_area_name text,
  foreign key(instructor_id, course_area_name) references Instructors
      on delete cascade,
  primary key(instructor_id, course_area_name)
);

/* (CORRECT) */
create table Full_Time_Instructors (
  instructor_id integer references Full_Time_Employees
      on delete cascade,
  course_area_name text,
  foreign key(instructor_id, course_area_name) references Instructors
      on delete cascade,
  primary key(instructor_id, course_area_name)
);

/* (CORRECT) */
create table Courses (
    course_id serial primary key,
    description text not null,
    title text not null,
    duration integer not null check(duration > 0),
    course_area_name text not null references Course_Areas,

    check(duration in (1, 2, 3, 4))  
);

/* (CORRECT) */
/*encapsulates Handles weak entity and Has relationship*/
create table Course_Offerings (
    course_id integer references Courses
  		on delete cascade,
    launch_date date,
    admin_eid integer not null references Administrators
        on delete cascade,
  	/* start_date and end_date can be null when there are no sessions initially */
  	start_date date,
    end_date date,
    fees numeric not null,
    registration_deadline date not null,
    seating_capacity integer not null check(seating_capacity > 0), 
    target_number_registrations integer not null check(target_number_registrations > 0),
    primary key(course_id, launch_date),
  
    check(end_date >= start_date),
  	check(registration_deadline + 10 <= start_date)
);

/* (CORRECT) */
create table Rooms (
    rid serial primary key,
    seating_capacity integer not null check(seating_capacity > 0),
    location text not null
);

/* (CORRECT) */
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

    check(extract(isodow from session_date) in (1, 2, 3, 4, 5)),
  	check(end_time_hour > start_time_hour)
);

/* (CORRECT) */
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

/* (CORRECT) */
create table Cancels (
    cust_id integer references Customers
      on delete cascade,
    cancel_date date,
    sid integer,
    launch_date date,
  	course_id integer,
    package_credit integer not null,
    refund_amt numeric not null,
    primary key(cust_id, cancel_date, sid, launch_date, course_id),
    foreign key(sid, launch_date, course_id) references Course_Offering_Sessions
  			on delete cascade
);

/* (CORRECT) */
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
    constraint register_date_before_launch_date check(register_date >= launch_date)
);

/* (CORRECT) */
/* num_remaining_redemptions not null because any transaction in Buys has already occurred */
create table Buys (
    cust_id integer references Customers
      on delete cascade,
    package_id integer references Course_Packages
      on delete cascade,
    purchase_date date not null,
    num_remaining_redemptions integer not null,
    primary key(cust_id, package_id, purchase_date)
);

/* (CORRECT) */
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
        on delete cascade
);

/* SQL commands to create application triggers */

/* Trigger (1) No two sessions for the same course offering can be conducted on the same day and same time (Gerren) */
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

/* Trigger (2) Start date and end date of course offering is determined by the dates of its earliest and latest sessions (Gerren) */
CREATE OR REPLACE FUNCTION set_course_offering_start_end_date_func() 
RETURNS TRIGGER AS $$
DECLARE
	earliest_session_date DATE;
  latest_session_date DATE;
BEGIN
  IF (TG_OP = 'DELETE') THEN
    SELECT MIN(session_date), MAX(session_date) INTO earliest_session_date, latest_session_date
    FROM Course_Offering_Sessions
    WHERE course_id = OLD.course_id AND launch_date = OLD.launch_date;
    
  	UPDATE Course_Offerings SET start_date = earliest_session_date, end_date = latest_session_date
    WHERE course_id = OLD.course_id AND launch_date = OLD.launch_date;
    RETURN OLD;
  ELSE
    SELECT MIN(session_date), MAX(session_date) INTO earliest_session_date, latest_session_date
    FROM Course_Offering_Sessions
    WHERE course_id = NEW.course_id AND launch_date = NEW.launch_date;
    
  	UPDATE Course_Offerings SET start_date = earliest_session_date, end_date = latest_session_date
    WHERE course_id = NEW.course_id AND launch_date = NEW.launch_date;
  	RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_course_offering_start_end_date
AFTER INSERT OR DELETE OR UPDATE ON Course_Offering_sessions
FOR EACH ROW EXECUTE FUNCTION set_course_offering_start_end_date_func();

/* Trigger (3) */

/* Trigger (4) */

/* Trigger (5) */

/* Trigger (6) */

/* Trigger (7) Each room can be used to conduct at most one session at any time (Gerren) */
CREATE OR REPLACE FUNCTION room_overlapping_conduct_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
  room_already_taken BOOLEAN;
  new_session_start INTEGER;
  new_session_end INTEGER;
  new_session_date DATE;
BEGIN
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
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER room_overlapping_conduct_verification
BEFORE INSERT OR UPDATE ON Conducts
FOR EACH ROW EXECUTE FUNCTION room_overlapping_conduct_verification_func();

/* Trigger (8) */
CREATE OR REPLACE FUNCTION part_time_employee_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
	num_same_eid_records integer;
BEGIN
	SELECT COUNT(*) INTO num_same_eid_records
  FROM Full_Time_Employees FTE
  WHERE FTE.eid = NEW.eid;
  
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
  FROM Part_Time_Employees PTE
  WHERE PTE.eid = NEW.eid;
  
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

/* Trigger (9) */
CREATE OR REPLACE FUNCTION manager_employee_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
	num_same_eid_records integer;
    num_instructor_same_eid_records integer;
BEGIN
	SELECT COUNT(*) INTO num_same_eid_records
    FROM Administrators A
    WHERE A.eid = NEW.eid;

    SELECT COUNT(*) INTO num_instructor_same_eid_records
    FROM Instructors
    WHERE instructor_id = NEW.eid;
  
	IF num_same_eid_records > 0 THEN
  	    RAISE EXCEPTION 'This employee is already an administrator, and therefore cannot be a manager.';
    END IF;
    
    IF num_instructor_same_eid_records > 0 THEN
        RAISE EXCEPTION 'This employee is already an instructor, and therefore cannot be a manager.';
    END IF; 
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER manager_employee_verification
BEFORE INSERT OR UPDATE ON Managers
FOR EACH ROW EXECUTE FUNCTION manager_employee_verification_func();

CREATE OR REPLACE FUNCTION administrator_employee_verification_func() 
RETURNS TRIGGER AS $$
DECLARE
	num_same_eid_records integer;
    num_instructor_same_eid_records integer;
BEGIN
	SELECT COUNT(*) INTO num_same_eid_records
    FROM Managers M
    WHERE M.eid = NEW.eid;

    SELECT COUNT(*) INTO num_instructor_same_eid_records
    FROM Instructors
    WHERE instructor_id = NEW.eid;
  
	IF num_same_eid_records > 0 THEN
  	    RAISE EXCEPTION 'This employee is already a manager, and therefore cannot be an administrator.';
    END IF;

    IF num_instructor_same_eid_records > 0 THEN
        RAISE EXCEPTION 'This employee is already an instructor, and therefore cannot be a administrator.';
    END IF;

    RETURN NEW;
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

/* Trigger (10) */

/* Trigger (11) (Siddarth) */
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

/* Trigger (12) (Siddarth) */
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

/* Trigger (13) (Siddarth) */
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

/* Trigger (14) */

/* Trigger (15) Each part-time instructor must not teach more than 30 hours each month (Gerren) */
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

/* Trigger (16) */

/* Trigger (17) */

/* Trigger (18) */

/* Trigger (19) */

/* Trigger (20) */

/* Trigger (21) Trigger that ensures every credit card references at least one customer (Gerren) */
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

/* Trigger (22) */
