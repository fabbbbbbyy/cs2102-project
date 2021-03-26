/* This schema follows the template ER diagram from left to right as much as possible.

   The ordering for attributes are in lexographical order and primary and foreign keys are 
   denoted at the bottom for consistent styling across tables.

   If a table is a combined table between entities, we will have the attributes of the overarching
   entity in lexographical order, followed by the attributes of the 2nd/3rd/etc.. entity similarly
   in lexographical order below it.

   Attribute types are subject to change. */

/* Decided to use int data type with auto increment for primary keys */

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

insert into Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date) values('CS2030', 1, 3.50, '2021-03-24', '2021-04-24');
insert into Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date) values('CS2040', 2, 10.0, '2021-03-24', '2021-05-24');
insert into Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date) values('CS2106', 3, 0.0, '2021-03-24', '2021-06-24');
insert into Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date) values('CS1101S', 4, 20.0, '2021-03-24', '2021-07-24');
insert into Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date) values('CS2103T', 5, 30.0, '2021-03-24', '2021-08-24');

/* (CORRECT) */
create table Credit_Cards (
  number text primary key,
  expiry_date date,
  from_date date,
  cvv integer
);

insert into Credit_Cards(number, expiry_date, from_date, cvv) values('4111 1111 1111 1111', '2021-10-10', '2016-10-10', 123);
insert into Credit_Cards(number, expiry_date, from_date, cvv) values('5500 0000 0000 0004', '2022-09-09', '2017-10-10', 234);
insert into Credit_Cards(number, expiry_date, from_date, cvv) values('3400 0000 0000 009', '2023-08-08', '2018-10-10', 345);
insert into Credit_Cards(number, expiry_date, from_date, cvv) values('6011 0000 0000 0004', '2024-07-07', '2019-10-10', 456);
insert into Credit_Cards(number, expiry_date, from_date, cvv) values('2014 0000 0000 009', '2025-06-06', '2020-10-10', 567);

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

insert into Customers(address, name, email, phone, number) values('123 Road', 'Siddarth', 'siddarth@yahoo.com', 87654321, '4111 1111 1111 1111');
insert into Customers(address, name, email, phone, number) values('5 Way', 'Gerren', 'gerren@u.nus.edu', 98765432, '5500 0000 0000 0004');
insert into Customers(address, name, email, phone, number) values('Troll Bridge', 'Fabian', 'fabian@hotmail.com', 99887766, '3400 0000 0000 009');
insert into Customers(address, name, email, phone, number) values('6 Avenue', 'Kevin', 'kevin@gmail.com', 88993321, '6011 0000 0000 0004');
insert into Customers(address, name, email, phone, number) values('Jane Street', 'Larry', 'larry@mymail.com', 98723456, '2014 0000 0000 009');

/* (CORRECT) */
create table Employees (
  	eid serial primary key,
    address text,
    depart_date date,
    email text,
    join_date date,
    name text,
    phone text
);

insert into Employees(address, depart_date, email, join_date, name, phone) values('Mountain Boulevard', null, 'emily@gmail.com', '2005-05-17', 'Emily', '67892345');
insert into Employees(address, depart_date, email, join_date, name, phone) values('Jungle Swamp', '2021-01-01', 'brian@live.com', '2013-08-09', 'Brian', '88112233');
insert into Employees(address, depart_date, email, join_date, name, phone) values('Mountain Hill', null, 'mabel@gmail.com', '2014-12-25', 'Mabel', '65689231');
insert into Employees(address, depart_date, email, join_date, name, phone) values('Swamp Jungle', '2010-11-11', 'abel@live.com', '2000-02-06', 'Abel', '88456781');
insert into Employees(address, depart_date, email, join_date, name, phone) values('Mountain View', null, 'chris@yahoo.com', '2020-03-04', 'Chris', '89672345');

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
    course_id serial primary key,
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
    rid serial primary key,
    seating_capacity integer,
    location text
);

/* (CORRECT) */
create table Course_Offering_Sessions (
    sid serial,
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
  	sid integer,
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

