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
    course_package_name text not null,
    num_free_registrations integer not null check(num_free_registrations > 0),
    price numeric not null check(price >= 0),
    sale_start_date date not null,
    sale_end_date date not null,

  	CONSTRAINT sale_start_before_end check(sale_end_date >= sale_start_date)
);

/* (CORRECT) */
create table Credit_Cards (
  credit_card_num text primary key,
  expiry_date date not null,
  from_date date not null,
  /* CVV must be three digit, integer might not be able to save 089 */
  cvv text not null,
  
  CONSTRAINT does_not_expire_before_from_date check(expiry_date >= from_date),
  CONSTRAINT does_not_expire_before_current_date check(expiry_date > current_date)
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
  
  	CONSTRAINT employee_joins_before_departing check(depart_date >= join_date)
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
    title text unique not null,
    duration integer not null check(duration > 0),
    course_area_name text not null references Course_Areas  
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
  
    CONSTRAINT offering_date_starts_before_end check(end_date >= start_date),
  	CONSTRAINT registration_deadline_ten_days_before_start check(registration_deadline + 10 <= start_date)
);

/* (CORRECT) */
create table Rooms (
    rid serial primary key,
    seating_capacity integer not null check(seating_capacity > 0),
    location text not null
);

/* (CORRECT) */
create table Course_Offering_Sessions (
    sid serial,
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

/* (CORRECT) */
create table Conducts (
    rid integer references Rooms
        on delete cascade,
  	instructor_id integer,
  	sid integer,
    course_area_name text not null,
  	launch_date date not null,
  	course_id integer not null,
    primary key(rid, instructor_id, sid),
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

    CONSTRAINT register_date_before_launch_date check(register_date >= launch_date)
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
        on delete cascade,

    CONSTRAINT redemption_date_before_launch_date check(redemption_date >= launch_date)
);