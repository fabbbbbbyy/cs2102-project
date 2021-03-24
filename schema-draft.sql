/* This schema follows the template ER diagram from left to right as much as possible.

   The ordering for attributes are in lexographical order and primary and foreign keys are 
   denoted at the bottom for consistent styling across tables.

   If a table is a combined table between entities, we will have the attributes of the overarching
   entity in lexographical order, followed by the attributes of the 2nd/3rd/etc.. entity similarly
   in lexographical order below it.

   Attribute types are subject to change. */

/* Decided to use int data type with auto increment for primary keys */

/* (CORRECT) */
create table Course_Packages (
    package_id integer primary key,
    name text,
    num_free_registrations integer,
    price numeric,
    sale_start_date date,
    sale_end_date date
);

/* (CORRECT) */
create table Credit_Cards (
  number integer primary key,
  expiry_date date,
  from_date date,
  cvv integer
);

/* (CORRECT) */
/* Application specs and functions 3 and 4 seem to imply a one-to-one relationship */
create table Customers (
  cust_id integer primary key,
  address text,
  name text,
  email text,
  phone text,
  number integer unique not null references Credit_Cards
);

/* (CORRECT) */
create table Employees (
  	eid integer primary key,
    address text,
    depart_date date,
    email text,
    join_date date,
    name text,
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
    eid integer references Employees
  			on delete cascade,
    name text references Course_Areas, /*specialize relationship*/
    primary key(eid, name)
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
    course_id integer primary key,
    description text,
    duration integer,
    name text not null references Course_Areas,
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
    primary key(course_id, launch_date)
);

/* (CORRECT) */
create table Rooms (
    rid integer primary key,
    seating_capacity integer,
    location text
);

/* (CORRECT) */
create table Course_Offering_Sessions (
    sid integer,
    session_date date,
    start_time timestamp,
    end_time timestamp,
    launch_date date not null,
    course_id integer not null,
    primary key (sid, launch_date, course_id),
    foreign key(course_id, launch_date) references Course_Offerings
          on delete cascade
);

/* (CORRECT) */
create table Conducts (
    rid integer references Rooms
        on delete cascade,
  	eid integer,
    name text,
  	sid integer not null,
  	launch_date date not null,
  	course_id integer not null,
    foreign key(eid, name) references Instructors
        on delete cascade,
  	foreign key(sid, launch_date, course_id) references Course_Offering_Sessions
        on delete cascade,
    primary key(rid, eid, sid)
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

