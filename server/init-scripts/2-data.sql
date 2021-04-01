/* SQL Commmands to load data into application */

insert into Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date) values('Introduction to Database Systems', 1, 3.50, '2021-03-24', '2021-04-24');
insert into Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date) values('Introduction to Computer Networks', 2, 10.0, '2021-03-24', '2021-05-24');
insert into Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date) values('Introduction to Operating Systems', 3, 0.0, '2021-03-24', '2021-06-24');
insert into Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date) values('Introduction to Data Structure and Algorithms', 4, 20.0, '2021-03-24', '2021-07-24');
insert into Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date) values('Introduction to Programming Languages', 5, 30.0, '2021-03-24', '2021-08-24');

insert into Credit_Cards(number, expiry_date, from_date, cvv) values('4111 1111 1111 1111', '2021-10-10', '2016-10-10', 123);
insert into Credit_Cards(number, expiry_date, from_date, cvv) values('5500 0000 0000 0004', '2022-09-09', '2017-10-10', 234);
insert into Credit_Cards(number, expiry_date, from_date, cvv) values('3400 0000 0000 009', '2023-08-08', '2018-10-10', 345);
insert into Credit_Cards(number, expiry_date, from_date, cvv) values('6011 0000 0000 0004', '2024-07-07', '2019-10-10', 456);
insert into Credit_Cards(number, expiry_date, from_date, cvv) values('2014 0000 0000 009', '2025-06-06', '2020-10-10', 567);

insert into Customers(address, name, email, phone, number) values('123 Road', 'Siddarth', 'siddarth@yahoo.com', 87654321, '4111 1111 1111 1111');
insert into Customers(address, name, email, phone, number) values('5 Way', 'Gerren', 'gerren@u.nus.edu', 98765432, '5500 0000 0000 0004');
insert into Customers(address, name, email, phone, number) values('Troll Bridge', 'Fabian', 'fabian@hotmail.com', 99887766, '3400 0000 0000 009');
insert into Customers(address, name, email, phone, number) values('6 Avenue', 'Kevin', 'kevin@gmail.com', 88993321, '6011 0000 0000 0004');
insert into Customers(address, name, email, phone, number) values('Jane Street', 'Larry', 'larry@mymail.com', 98723456, '2014 0000 0000 009');

insert into Employees(address, depart_date, email, join_date, employee_name, phone) values('Mountain Boulevard', null, 'emily@gmail.com', '2005-05-17', 'Emily', '67892345');
insert into Employees(address, depart_date, email, join_date, employee_name, phone) values('Jungle Swamp', null, 'brian@live.com', '2013-08-09', 'Brian', '88112233');
insert into Employees(address, depart_date, email, join_date, employee_name, phone) values('Mountain Hill', null, 'mabel@gmail.com', '2014-12-25', 'Mabel', '65689231');
insert into Employees(address, depart_date, email, join_date, employee_name, phone) values('Swamp Jungle', null, 'abel@live.com', '2000-02-06', 'Abel', '88456781');
insert into Employees(address, depart_date, email, join_date, employee_name, phone) values('Mountain View', null, 'chris@yahoo.com', '2020-03-04', 'Chris', '89672345');
insert into Employees(address, depart_date, email, join_date, employee_name, phone) values('Kovan', null, 'tom@yahoo.com', '2020-05-04', 'Tom', '99889988');
insert into Employees(address, depart_date, email, join_date, employee_name, phone) values('Serangoon', null, 'betty@yahoo.com', '2020-07-04', 'Betty', '99119911');
insert into Employees(address, depart_date, email, join_date, employee_name, phone) values('Hougang', null, 'jessie@yahoo.com', '2020-04-04', 'Jessie', '99229922');
insert into Employees(address, depart_date, email, join_date, employee_name, phone) values('Bishan', null, 'julius@yahoo.com', '2020-07-22', 'Julius', '99559955');


insert into Part_Time_Employees(eid, hourly_rate) values(1, 9);
insert into Part_Time_Employees(eid, hourly_rate) values(2, 8);

insert into Full_Time_Employees(eid, monthly_salary) values(3, 1200);
insert into Full_Time_Employees(eid, monthly_salary) values(4, 1800);
insert into Full_Time_Employees(eid, monthly_salary) values(5, 2400);
insert into Full_Time_Employees(eid, monthly_salary) values(6, 3000);
insert into Full_Time_Employees(eid, monthly_salary) values(7, 1900);
insert into Full_Time_Employees(eid, monthly_salary) values(8, 1500);
insert into Full_Time_Employees(eid, monthly_salary) values(9, 1600);


insert into Administrators(eid) values(3);
insert into Administrators(eid) values(4);

insert into Managers(eid) values(5);
insert into Managers(eid) values(6);

insert into Course_Areas(eid, name) values(5, 'Database');
insert into Course_Areas(eid, name) values(5, 'Computer Networks');
insert into Course_Areas(eid, name) values(6, 'Operating Systems');

insert into Instructors(instructor_id, course_area_name) values(7, 'Database');
insert into Instructors(instructor_id, course_area_name) values(7, 'Computer Networks');
insert into Instructors(instructor_id, course_area_name) values(8, 'Operating Systems');
insert into Instructors(instructor_id, course_area_name) values(9, 'Operating Systems');
insert into Instructors(instructor_id, course_area_name) values(9, 'Database');
insert into Instructors(instructor_id, course_area_name) values(9, 'Computer Networks');
insert into Instructors(instructor_id, course_area_name) values(1, 'Computer Networks');
insert into Instructors(instructor_id, course_area_name) values(2, 'Database');

insert into Part_Time_Instructors(eid, name) values(1, 'Computer Networks');
insert into Part_Time_Instructors(eid, name) values(2, 'Database');

insert into Full_Time_Instructors(eid, name) values(7, 'Database');
insert into Full_Time_Instructors(eid, name) values(7, 'Computer Networks');
insert into Full_Time_Instructors(eid, name) values(8, 'Operating Systems');
insert into Full_Time_Instructors(eid, name) values(9, 'Operating Systems');
insert into Full_Time_Instructors(eid, name) values(9, 'Database');
insert into Full_Time_Instructors(eid, name) values(9, 'Computer Networks');

insert into Courses(description, duration, course_area_name, title) values('aaaaaa', 1, 'Database', 'bbbbb');
insert into Courses(description, duration, course_area_name, title) values('aaaaaa', 1, 'Computer Networks', 'bbbbb');
insert into Courses(description, duration, course_area_name, title) values('aaaaaa', 1, 'Operating Systems', 'bbbbb');

insert into Course_Offerings(course_id, launch_date, admin_eid, end_date, fees, registration_deadline, seating_capacity, start_date, target_number_registrations) values(1, '2021-01-01', 3, '2021-12-14', 500, '2021-11-24', 500, '2021-10-14', 500);
insert into Course_Offerings(course_id, launch_date, admin_eid, end_date, fees, registration_deadline, seating_capacity, start_date, target_number_registrations) values(2, '2021-02-01', 3, '2021-05-16', 500, '2021-04-24', 500, '2021-05-14', 500);
insert into Course_Offerings(course_id, launch_date, admin_eid, end_date, fees, registration_deadline, seating_capacity, start_date, target_number_registrations) values(3, '2021-02-01', 3, '2021-05-16', 500, '2021-04-24', 500, '2021-05-14', 500);

insert into Rooms(seating_capacity) values(700);
insert into Rooms(seating_capacity) values(800);
insert into Rooms(seating_capacity) values(900);


insert into Course_Offering_Sessions(session_date, start_time_hour, end_time_hour, launch_date, course_id) values('2021-11-24', 10, 12, '2021-01-01', 1);
insert into Course_Offering_Sessions(session_date, start_time_hour, end_time_hour, launch_date, course_id) values('2021-11-25', 10, 12, '2021-02-01', 2);

insert into Conducts(rid, instructor_id, course_area_name, sid, launch_date, course_id) values(1, 7, 'Database', 1, '2021-01-01', 1);
insert into Conducts(rid, instructor_id, course_area_name, sid, launch_date, course_id) values(1, 9, 'Computer Networks', 2, '2021-02-01', 2);

insert into Registers(cust_id, launch_date, register_date, sid, course_id) values(1, '2021-01-01', '2020-02-13', 1, 1);
insert into Registers(cust_id, launch_date, register_date, sid, course_id) values(1, '2021-02-01', '2020-01-13', 2, 2);