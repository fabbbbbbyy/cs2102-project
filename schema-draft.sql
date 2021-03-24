/* This schema follows the template ER diagram from left to right as much as possible. 

   The ordering for attributes are in lexographical order and primary and foreign keys are 
   denoted at the bottom for consistent styling across tables. 

   If a table is a combined table between entities, we will have the attributes of the overarching
   entity in lexographical order, followed by the attributes of the 2nd/3rd/etc.. entity similarly
   in lexographical order below it. 

   Attribute types are subject to change. */

create table Course_Packages (
    package_id integer primary key,
    name text,
    num_free_registrations integer,
    price numeric,
    sale_start_date date,
    sale_end_date date
);

create table Credit_Cards (
  number integer primary key,
  expiry_date date,
  from_date date,
  cvv integer
);

create table Customers (
  cust_id integer primary key,
  address text,
  name text,
  email text,
  phone text,
  credit_card_number integer unique not null references Credit_Cards
);

create table Employees (
    address text,
    depart_date date,
    eid integer primary key,
    email text,
    join_date date,
    name text,
    phone text,
);

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

/* hourly_rate not null because any row in Part_Time_Employees must exist */
create table Part_Time_Employees (
    eid integer primary key references Employees
        on delete cascade,
    hourly_rate numeric not null
);

/* monthly_salary not null because any row in Full_Time_Employees must exist */
create table Full_Time_Employees (
    eid integer primary key references Employees
        on delete cascade,
    monthly_salary numeric not null
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
    name text primary key
);

create table Instructors (
    eid integer references Employees
  			on delete cascade,
    name text references Course_Areas,
    primary key(eid, name)
);

create table Part_Time_Instructors (
  eid integer primary key references Instructors
      references Part_Time_Employees
      on delete cascade
);

create table Full_Time_Instructors (
  eid integer primary key references Instructors
      references Full_Time_Employees
      on delete cascade
);

create table Courses (
    course_id integer primary key,
    description text,
    duration integer,
    name text not null references Course_Areas,
    title text
);

/*encapsulates Handles weak entity and Has relationship*/
create table Course_Offerings (
    course_id integer references Courses
  		on delete cascade,
    aeid integer not null references Administrators(eid),
    end_date date,
    fees numeric,
    launch_date date, 
    registration_deadline date,
    seating_capacity integer, 
    start_date date,
    target_number_registrations integer,
    primary key(course_id, launch_date)
);

create table Rooms (
    rid integer primary key,
    seating_capacity integer,
    location text
);

/*Encapuslates Consists weak entity and Conducts(ternary relationship with Rooms and Instructors) relationship*/
create table Course_Offering_Sessions (
    sid integer,
    session_date date,
  	instructor_id integer,
  	specialization text,
    start_time timestamp,
    end_time timestamp,
    rid integer not null references Room,
    launch_date date not null,
    course_id integer not null,
    primary key (sid, launch_date, course_id, instructor_id, specialization),
    foreign key(course_id, launch_date) references Course_Offerings
          on delete cascade,
  	foreign key(instructor_id, specialization) references Instructors(eid, name)
);

create table Cancels (
    cancel_date date,
    cust_id integer references Customers,
    launch_date date,
    package_credit integer,
    refund_amt integer,
    sid integer,
  	specialization text,
  	instructor_id integer,
  	course_id integer,
    primary key(cust_id, cancel_date, launch_date, sid, course_id, instructor_id, specialization),
    foreign key(sid, launch_date, course_id, instructor_id, specialization) references Course_Offering_Sessions 
);

create table Registers (
    cust_id integer references Customers,
    launch_date date,
    register_date date,
    sid integer,
  	instructor_id integer,
  	specialization text,
  	course_id integer,
    primary key(cust_id, register_date,  launch_date, sid, course_id, instructor_id, specialization),
    foreign key(sid, launch_date, course_id, instructor_id, specialization) references Course_Offering_Sessions
);

/* num_remaining_redemptions not null because any transaction in Buys has already occurred */
create table Buys (
    cust_id integer references Customers,
    package_id integer references Course_Packages,
    purchase_date date,
    num_remaining_redemptions integer not null,
    primary key(cust_id, purchase_date, package_id)
);

create table Redeems (
    cust_id integer,
    redemption_date date,
    launch_date date,
  	course_id integer,
  	instructor_id integer,
  	specialization text,
    purchase_date date,
    package_id integer,
    sid integer,
    primary key(cust_id, sid, launch_date, package_id, redemption_date),
    foreign key(cust_id, purchase_date, package_id) references Buys,
    foreign key(sid, launch_date, course_id, instructor_id, specialization) references Course_Offering_Sessions 
);
