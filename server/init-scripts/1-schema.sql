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

/* (CORRECT) */
create table Course_Packages (
    package_id serial primary key,
    name text,
    num_free_registrations integer,
    price numeric,
    sale_start_date date,
    sale_end_date date
);

/* (CORRECT) */
create table Credit_Cards (
  number text primary key,
  expiry_date date,
  from_date date,
  cvv integer
);

/* (CORRECT) */
/* Application specs and functions 3 and 4 seem to imply a one-to-one relationship */
create table Customers (
  cust_id serial primary key,
  address text,
  name text,
  email text,
  phone text,
  number text unique not null references Credit_Cards
);

/* (CORRECT) */
create table Employees (
  	eid serial primary key,
    address text,
    depart_date date,
    email text,
    join_date date,
    employee_name text,
    phone text
);

/* (CORRECT) */
create table Employee_Pay_Slips (
    amount numeric, 
    eid integer,
    num_work_days integer,
    num_work_hours integer,
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
    hourly_rate numeric not null
);

/* (CORRECT) */
/* monthly_salary not null because any row in Full_Time_Employees must exist */
create table Full_Time_Employees (
    eid integer primary key references Employees
        on delete cascade,
    monthly_salary numeric not null
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
    name text primary key
);

/* (CORRECT) */
/*Instructor is a employee*/
create table Instructors (
    instructor_id integer references Employees
  			on delete cascade,
    course_area_name text references Course_Areas, /*specialize relationship*/
    primary key(instructor_id, course_area_name)
);

/* (CORRECT) */
create table Part_Time_Instructors (
  eid integer references Part_Time_Employees
      on delete cascade,
  name text,
  foreign key(eid, name) references Instructors
      on delete cascade,
  primary key(eid, name)
);

/* (CORRECT) */
create table Full_Time_Instructors (
  eid integer references Full_Time_Employees
      on delete cascade,
  name text,
  foreign key(eid, name) references Instructors
      on delete cascade,
  primary key(eid, name)
);

/* (CORRECT) */
create table Courses (
    course_id serial primary key,
    description text,
    duration integer,
    course_area_name text not null references Course_Areas,
    title text
);

/* (CORRECT) */
/*encapsulates Handles weak entity and Has relationship*/
create table Course_Offerings (
    course_id integer references Courses
  		on delete cascade,
    launch_date date,
    admin_eid integer not null references Administrators
        on delete cascade,
    end_date date,
    fees numeric,
    registration_deadline date,
    seating_capacity integer, 
    start_date date,
    target_number_registrations integer,
    primary key(course_id, launch_date),
    check(end_date >= start_date)
);

/* (CORRECT) */
create table Rooms (
    rid serial primary key,
    seating_capacity integer,
    location text
);

/* (CORRECT) */
create table Course_Offering_Sessions (
    sid serial,
    session_date date,
    start_time_hour integer,
    end_time_hour integer,
    launch_date date not null,
    course_id integer not null,
    primary key (sid, launch_date, course_id),
    foreign key(course_id, launch_date) references Course_Offerings
          on delete cascade,

    check (extract(dow from session_date) not in (0, 6)),
  	check (end_time_hour > start_time_hour)
);

/* (CORRECT) */
create table Conducts (
    rid integer references Rooms
        on delete cascade,
  	instructor_id integer,
    course_area_name text,
  	sid integer,
  	launch_date date not null,
  	course_id integer not null,
    foreign key(instructor_id, course_area_name) references Instructors
        on delete cascade,
  	foreign key(sid, launch_date, course_id) references Course_Offering_Sessions
        on delete cascade,
    primary key(rid, instructor_id, sid)
);

/* (CORRECT) */
create table Cancels (
    cancel_date date,
    cust_id integer references Customers
  			on delete cascade,
    launch_date date,
    package_credit integer,
    refund_amt integer,
    sid integer,
  	course_id integer,
    primary key(cust_id, cancel_date, launch_date, sid, course_id),
    foreign key(sid, launch_date, course_id) references Course_Offering_Sessions
  			on delete cascade
);

/* (CORRECT) */
create table Registers (
    cust_id integer references Customers
    		on delete cascade,
    launch_date date,
    register_date date,
    sid integer,
  	course_id integer,
    primary key(cust_id, register_date,  launch_date, sid, course_id),
    foreign key(sid, launch_date, course_id) references Course_Offering_Sessions
  	  	on delete cascade
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
    primary key(cust_id, purchase_date, package_id)
);

create table Redeems (
    cust_id integer,
    redemption_date date,
    launch_date date,
  	course_id integer,
    purchase_date date,
    package_id integer,
    sid integer,
    primary key(cust_id, redemption_date, launch_date, course_id, purchase_date, package_id, sid),
    foreign key(cust_id, purchase_date, package_id) references Buys
        on delete cascade,
    foreign key(sid, launch_date, course_id) references Course_Offering_Sessions
        on delete cascade
);

/* SQL or PL/pgSQL routines for trigger implementations */
/* A full time employee MUST either be a manager or an admin but not both */
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

/* Instructor MUST be either a full time or part time instructor but not both (Siddarth)*/
CREATE OR REPLACE FUNCTION check_instructor_is_not_full_time_instructor()
RETURNS TRIGGER AS $$
DECLARE
	count_of_full_time_instr integer;
BEGIN
    SELECT count(*) INTO count_of_full_time_instr
    FROM Full_Time_Instructors
    WHERE NEW.eid = eid;
  
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
    WHERE NEW.eid = eid;
  
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

/* Employee can be either a full_time or part_time employee but not both */ 
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

/* Each instructor can teach at most one course session at any hour */
CREATE OR REPLACE FUNCTION ensure_instructor_teaches_at_most_one_course_session_at_any_hour()
RETURNS TRIGGER AS $$
DECLARE
	new_assigned_session_date date;
    new_assigned_session_start_hour integer;
    new_assigned_session_duration integer;
	count_of_conflicting_course_sessions integer;
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
    
    IF count_of_conflicting_course_sessions >= 1 THEN
        RAISE EXCEPTION 'Instructor is already teaching another course which conflicts with the period of the new assigned session.';
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER instructor_cannot_teach_more_than_one_course_session_at_any_hour_trigger
BEFORE INSERT OR UPDATE ON Conducts
FOR EACH ROW EXECUTE FUNCTION ensure_instructor_teaches_at_most_one_course_session_at_any_hour();