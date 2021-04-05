/* SQL Commmands to load data into application */
call add_customer('Ronaldo', 'Santos Street 5', 99999999, 'ronaldo@hotmail.com', '5500000000000005','2021-10-10', '898');
call add_customer('Messi', 'Barcelona Road', 99998888, 'leomessi@hotmail.com', '5500000000000006','2021-11-10', '888');
call add_customer('Kaka', 'Milan Close', 99997777, 'kakakaka@hotmail.com', '5500000000000007','2021-12-10', '878');
call add_customer('Mbappe', 'Paris Edwood Condominum', 99996666, 'kylianM@hotmail.com', '5500000000000008','2022-01-10', '868');
call add_customer('Ozil', 'Berlin Hometown', 99995555, 'mesutozil@hotmail.com', '5500000000000009','2022-02-10', '858');
call add_customer('Pogba', 'Lorient Driveway', 99994444, 'pogba@hotmail.com', '5500000000000010','2022-03-10', '848');
call add_customer('Auba', 'Gabon Valley', 99993333, 'auba@hotmail.com', '5500000000000011','2022-04-10', '838');
call add_customer('Van Dijk', 'Amsterdam City Square', 99992222, 'vandijk@hotmail.com', '5500000000000012','2022-05-10', '828');
call add_customer('Luiz', 'Rio De Janeiro Skyscraper', 99991111, 'luiz@hotmail.com', '5500000000000013','2022-06-10', '818');
call add_customer('Maguire', 'University of London', 99990000, 'maguire@hotmail.com', '5500000000000014','2022-07-10', '808');

insert into Course_Packages(course_package_name, num_free_registrations, price, sale_start_date, sale_end_date) values('Special 1', 1, 3.50, '2021-03-24', '2021-04-24');
insert into Course_Packages(course_package_name, num_free_registrations, price, sale_start_date, sale_end_date) values('Special 2', 2, 10.0, '2021-03-24', '2021-05-24');
insert into Course_Packages(course_package_name, num_free_registrations, price, sale_start_date, sale_end_date) values('Special 3', 3, 50.0, '2021-03-24', '2021-06-24');
insert into Course_Packages(course_package_name, num_free_registrations, price, sale_start_date, sale_end_date) values('Special 4', 4, 20.0, '2021-03-24', '2021-07-24');
insert into Course_Packages(course_package_name, num_free_registrations, price, sale_start_date, sale_end_date) values('Special 5', 5, 30.0, '2021-03-24', '2021-08-24');
insert into Course_Packages(course_package_name, num_free_registrations, price, sale_start_date, sale_end_date) values('Special 6', 6, 52.50, '2021-03-24', '2021-04-24');
insert into Course_Packages(course_package_name, num_free_registrations, price, sale_start_date, sale_end_date) values('Special 7', 7, 70.0, '2021-03-24', '2021-05-24');
insert into Course_Packages(course_package_name, num_free_registrations, price, sale_start_date, sale_end_date) values('Special 8', 8, 55.0, '2021-03-24', '2021-06-24');
insert into Course_Packages(course_package_name, num_free_registrations, price, sale_start_date, sale_end_date) values('Special 9', 9, 25.0, '2021-03-24', '2021-07-24');
insert into Course_Packages(course_package_name, num_free_registrations, price, sale_start_date, sale_end_date) values('Special 10', 10, 35.0, '2021-03-24', '2021-08-24');
insert into Course_Packages(course_package_name, num_free_registrations, price, sale_start_date, sale_end_date) values('Special 11', 11, 35.0, '2021-04-24', '2021-08-24');
insert into Course_Packages(course_package_name, num_free_registrations, price, sale_start_date, sale_end_date) values('Special 12', 12, 35.0, '2021-03-24', '2021-03-29');

insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Mountain Boulevard', null, 'emily@gmail.com', '2005-05-17', 'Emily', '67892345');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Jungle Swamp', null, 'brian@live.com', '2013-08-09', 'Brian', '88112233');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Mountain Hill', null, 'mabel@gmail.com', '2014-12-25', 'Mabel', '65689231');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Swamp Jungle', null, 'abel@live.com', '2000-02-06', 'Abel', '88456781');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Mountain View', null, 'chris@yahoo.com', '2020-03-04', 'Chris', '89672345');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Kovan', null, 'tom@yahoo.com', '2020-05-04', 'Tom', '99889988');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Serangoon', null, 'betty@yahoo.com', '2020-07-04', 'Betty', '99119911');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Hougang', null, 'jessie@yahoo.com', '2020-04-04', 'Jessie', '99229922');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Bishan', null, 'julius@yahoo.com', '2020-07-22', 'Julius', '99559955');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Paya Lebar', null, 'connie@yahoo.com', '2020-12-22', 'Connie', '99559988');

insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Potong Pasir', null, 'muthu@gmail.com', '2005-05-17', 'Muthu', '67892345');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Dhoby Ghaut', null, 'ali@live.com', '2013-08-09', 'Ali', '88112233');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Harbourfront', null, 'baba@gmail.com', '2014-12-25', 'Baba', '65689231');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Chinatown', null, 'xiaole@live.com', '2000-02-06', 'Xiao Le', '88456781');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Orchard', null, 'chenchen@yahoo.com', '2020-03-04', 'Chen Chen', '89672345');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Punggol', null, 'lulu@yahoo.com', '2020-05-04', 'Lu Lu', '99889988');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Toa Payoh', null, 'ahmad@yahoo.com', '2020-07-04', 'Ahmad', '99119911');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Botanic Gardens', null, 'taufik@yahoo.com', '2020-04-04', 'Taufik', '99229922');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Sixth Avenue', null, 'firdaus@yahoo.com', '2020-07-22', 'Firdaus', '99559955');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Khatib', null, 'farhan@yahoo.com', '2020-12-22', 'Farhan', '99559988');

insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Ang Mo Kio', null, 'mueller@gmail.com', '2005-05-17', 'Mueller', '67892345');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Pasir Panjang', null, 'guzman@live.com', '2013-08-09', 'Guzman', '88112233');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Tampines', null, 'alberto@gmail.com', '2014-12-25', 'Alberto', '65689231');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Changi', null, 'xhaka@live.com', '2000-02-06', 'Xhaka', '88456781');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Bedok', null, 'rooney@yahoo.com', '2020-03-04', 'Rooney', '89672345');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Kembangan', null, 'bernado@yahoo.com', '2020-05-04', 'Bernardo', '99889988');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Paya Lebar', null, 'cascillas@yahoo.com', '2020-07-04', 'Cascillas', '99119911');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Eunos', null, 'cornelius@yahoo.com', '2020-04-04', 'Cornelius', '99229922');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Redhill', null, 'mona@yahoo.com', '2020-07-22', 'Mona', '99559955');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Tiong Avenue', null, 'ramos@yahoo.com', '2020-12-22', 'Ramos', '99559988');

insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Hillview', null, 'wawa@gmail.com', '2005-05-17', 'Lala', '67892345');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Cashew', null, 'mimi@live.com', '2013-08-09', 'Mimi', '88112233');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Beauty World', null, 'momo@gmail.com', '2014-12-25', 'Momo', '65689231');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Tan Kah Kee', null, 'dada@live.com', '2000-02-06', 'Dada', '88456781');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Stevens', null, 'didi@yahoo.com', '2020-03-04', 'Didi', '89672345');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Bukit Gombak', null, 'bibi@yahoo.com', '2020-05-04', 'Bibi', '99889988');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Woodlands', null, 'baba@yahoo.com', '2020-07-04', 'Baba', '99119911');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Yew Tee', null, 'popo@yahoo.com', '2020-04-04', 'Popo', '99229922');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Jurong East', null, 'pipi@yahoo.com', '2020-07-22', 'Pipi', '99559955');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Jurong West', null, 'wawa@yahoo.com', '2020-12-22', 'Wawa', '99559988');
insert into Employees(address, depart_date, email, join_date, employee_name, phone_num) values('Jurong Long', null, 'wawa233@yahoo.com', '2020-12-22', 'Wawa', '99559988');

insert into Part_Time_Employees(eid, hourly_rate) values(1, 9);
insert into Part_Time_Employees(eid, hourly_rate) values(2, 8);
insert into Part_Time_Employees(eid, hourly_rate) values(3, 9);
insert into Part_Time_Employees(eid, hourly_rate) values(4, 7);
insert into Part_Time_Employees(eid, hourly_rate) values(5, 11);
insert into Part_Time_Employees(eid, hourly_rate) values(6, 12);
insert into Part_Time_Employees(eid, hourly_rate) values(7, 9);
insert into Part_Time_Employees(eid, hourly_rate) values(8, 11);
insert into Part_Time_Employees(eid, hourly_rate) values(9, 9);
insert into Part_Time_Employees(eid, hourly_rate) values(10, 8);
insert into Part_Time_Employees(eid, hourly_rate) values(41, 8);

insert into Full_Time_Employees(eid, monthly_salary) values(11, 1800);
insert into Full_Time_Employees(eid, monthly_salary) values(12, 2400);
insert into Full_Time_Employees(eid, monthly_salary) values(13, 3000);
insert into Full_Time_Employees(eid, monthly_salary) values(14, 1900);
insert into Full_Time_Employees(eid, monthly_salary) values(15, 2100);
insert into Full_Time_Employees(eid, monthly_salary) values(16, 2200);
insert into Full_Time_Employees(eid, monthly_salary) values(17, 1900);
insert into Full_Time_Employees(eid, monthly_salary) values(18, 2400);
insert into Full_Time_Employees(eid, monthly_salary) values(19, 3000);
insert into Full_Time_Employees(eid, monthly_salary) values(20, 1900);
insert into Full_Time_Employees(eid, monthly_salary) values(21, 1700);
insert into Full_Time_Employees(eid, monthly_salary) values(22, 1900);
insert into Full_Time_Employees(eid, monthly_salary) values(23, 3200);
insert into Full_Time_Employees(eid, monthly_salary) values(24, 1900);
insert into Full_Time_Employees(eid, monthly_salary) values(25, 1900);
insert into Full_Time_Employees(eid, monthly_salary) values(26, 1700);
insert into Full_Time_Employees(eid, monthly_salary) values(27, 1800);
insert into Full_Time_Employees(eid, monthly_salary) values(28, 2400);
insert into Full_Time_Employees(eid, monthly_salary) values(29, 3000);
insert into Full_Time_Employees(eid, monthly_salary) values(30, 1900);
insert into Full_Time_Employees(eid, monthly_salary) values(31, 1700);
insert into Full_Time_Employees(eid, monthly_salary) values(32, 1900);
insert into Full_Time_Employees(eid, monthly_salary) values(33, 3200);
insert into Full_Time_Employees(eid, monthly_salary) values(34, 1900);
insert into Full_Time_Employees(eid, monthly_salary) values(35, 1900);
insert into Full_Time_Employees(eid, monthly_salary) values(36, 1700);
insert into Full_Time_Employees(eid, monthly_salary) values(37, 1800);
insert into Full_Time_Employees(eid, monthly_salary) values(38, 2400);
insert into Full_Time_Employees(eid, monthly_salary) values(39, 3000);
insert into Full_Time_Employees(eid, monthly_salary) values(40, 1900);

insert into Administrators(eid) values(11);
insert into Administrators(eid) values(12);
insert into Administrators(eid) values(13);
insert into Administrators(eid) values(14);
insert into Administrators(eid) values(15);
insert into Administrators(eid) values(16);
insert into Administrators(eid) values(17);
insert into Administrators(eid) values(18);
insert into Administrators(eid) values(19);
insert into Administrators(eid) values(20);

insert into Managers(eid) values(21);
insert into Managers(eid) values(22);
insert into Managers(eid) values(23);
insert into Managers(eid) values(24);
insert into Managers(eid) values(25);
insert into Managers(eid) values(26);
insert into Managers(eid) values(27);
insert into Managers(eid) values(28);
insert into Managers(eid) values(29);
insert into Managers(eid) values(30);

insert into Course_Areas(eid, course_area_name) values(21, 'Database Systems');
insert into Course_Areas(eid, course_area_name) values(21, 'Software Engineering');
insert into Course_Areas(eid, course_area_name) values(22, 'Computer Networks');
insert into Course_Areas(eid, course_area_name) values(22, 'Discrete Mathematics');
insert into Course_Areas(eid, course_area_name) values(23, 'Operating Systems');
insert into Course_Areas(eid, course_area_name) values(23, 'Statistics');
insert into Course_Areas(eid, course_area_name) values(24, 'Data Structure and Algorithms');
insert into Course_Areas(eid, course_area_name) values(24, 'Ethics');
insert into Course_Areas(eid, course_area_name) values(25, 'Programming Languages');
insert into Course_Areas(eid, course_area_name) values(25, 'Calculus');

insert into Instructors(instructor_id, course_area_name) values(1, 'Computer Networks');
insert into Instructors(instructor_id, course_area_name) values(1, 'Database Systems');
insert into Instructors(instructor_id, course_area_name) values(1, 'Discrete Mathematics');
insert into Instructors(instructor_id, course_area_name) values(2, 'Database Systems');
insert into Instructors(instructor_id, course_area_name) values(2, 'Ethics');
insert into Instructors(instructor_id, course_area_name) values(2, 'Calculus');
insert into Instructors(instructor_id, course_area_name) values(2, 'Software Engineering');
insert into Instructors(instructor_id, course_area_name) values(3, 'Computer Networks');
insert into Instructors(instructor_id, course_area_name) values(4, 'Data Structure and Algorithms');
insert into Instructors(instructor_id, course_area_name) values(4, 'Computer Networks');
insert into Instructors(instructor_id, course_area_name) values(4, 'Software Engineering');
insert into Instructors(instructor_id, course_area_name) values(5, 'Operating Systems');
insert into Instructors(instructor_id, course_area_name) values(6, 'Operating Systems');
insert into Instructors(instructor_id, course_area_name) values(6, 'Ethics');
insert into Instructors(instructor_id, course_area_name) values(6, 'Programming Languages');
insert into Instructors(instructor_id, course_area_name) values(7, 'Programming Languages');
insert into Instructors(instructor_id, course_area_name) values(7, 'Statistics');
insert into Instructors(instructor_id, course_area_name) values(8, 'Database Systems');
insert into Instructors(instructor_id, course_area_name) values(9, 'Calculus');
insert into Instructors(instructor_id, course_area_name) values(9, 'Operating Systems');
insert into Instructors(instructor_id, course_area_name) values(10, 'Statistics');
insert into Instructors(instructor_id, course_area_name) values(41, 'Ethics');
insert into Instructors(instructor_id, course_area_name) values(31, 'Database Systems');
insert into Instructors(instructor_id, course_area_name) values(32, 'Computer Networks');
insert into Instructors(instructor_id, course_area_name) values(33, 'Calculus');
insert into Instructors(instructor_id, course_area_name) values(34, 'Operating Systems');
insert into Instructors(instructor_id, course_area_name) values(35, 'Data Structure and Algorithms');
insert into Instructors(instructor_id, course_area_name) values(36, 'Computer Networks');
insert into Instructors(instructor_id, course_area_name) values(37, 'Database Systems');
insert into Instructors(instructor_id, course_area_name) values(38, 'Programming Languages');
insert into Instructors(instructor_id, course_area_name) values(39, 'Ethics');
insert into Instructors(instructor_id, course_area_name) values(40, 'Software Engineering');


insert into Part_Time_Instructors(instructor_id, course_area_name) values(1, 'Computer Networks');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(1, 'Database Systems');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(1, 'Discrete Mathematics');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(2, 'Database Systems');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(2, 'Ethics');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(2, 'Calculus');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(2, 'Software Engineering');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(3, 'Computer Networks');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(4, 'Data Structure and Algorithms');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(4, 'Computer Networks');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(4, 'Software Engineering');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(5, 'Operating Systems');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(6, 'Operating Systems');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(6, 'Ethics');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(6, 'Programming Languages');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(7, 'Programming Languages');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(7, 'Statistics');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(8, 'Database Systems');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(9, 'Calculus');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(9, 'Operating Systems');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(10, 'Statistics');
insert into Part_Time_Instructors(instructor_id, course_area_name) values(41, 'Ethics');

insert into Full_Time_Instructors(instructor_id, course_area_name) values(31, 'Database Systems');
insert into Full_Time_Instructors(instructor_id, course_area_name) values(32, 'Computer Networks');
insert into Full_Time_Instructors(instructor_id, course_area_name) values(33, 'Calculus');
insert into Full_Time_Instructors(instructor_id, course_area_name) values(34, 'Operating Systems');
insert into Full_Time_Instructors(instructor_id, course_area_name) values(35, 'Data Structure and Algorithms');
insert into Full_Time_Instructors(instructor_id, course_area_name) values(36, 'Computer Networks');
insert into Full_Time_Instructors(instructor_id, course_area_name) values(37, 'Database Systems');
insert into Full_Time_Instructors(instructor_id, course_area_name) values(38, 'Programming Languages');
insert into Full_Time_Instructors(instructor_id, course_area_name) values(39, 'Ethics');
insert into Full_Time_Instructors(instructor_id, course_area_name) values(40, 'Software Engineering');

insert into Courses(description, title, duration, course_area_name) values('Drop table if exists', 'Introduction to Database Systems', 1, 'Database Systems');
insert into Courses(description, title, duration, course_area_name) values('IP/TCP', 'Introduction to Computer Networks', 2, 'Computer Networks');
insert into Courses(description, title, duration, course_area_name) values('Unix is the best', 'Introduction to Operating Systems', 1, 'Operating Systems');
insert into Courses(description, title, duration, course_area_name) values('O(1)', 'Introduction to Data Structure and Algorithms', 2, 'Data Structure and Algorithms');
insert into Courses(description, title, duration, course_area_name) values('Metacircular evaluation', 'Introduction to Programming Languages', 1, 'Programming Languages');
insert into Courses(description, title, duration, course_area_name) values('SOLID', 'Introduction to Software Engineering', 2, 'Software Engineering');
insert into Courses(description, title, duration, course_area_name) values('Modus Ponens', 'Introduction to Discrete Mathematics', 1, 'Discrete Mathematics');
insert into Courses(description, title, duration, course_area_name) values('Gaussian of Gaussians', 'Instroduction to Statistics', 2, 'Statistics');
insert into Courses(description, title, duration, course_area_name) values('Utilitarian > Deontology', 'Introduction to Ethics', 1, 'Ethics');
insert into Courses(description, title, duration, course_area_name) values('dy/dx', 'Introduction to Calculus', 2, 'Calculus');

insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(1, '2021-01-01', 11, '2021-02-01', '2021-03-01', 300, '2021-01-15', 0, 50);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(2, '2021-02-01', 12, '2021-03-01', '2021-04-01', 450, '2021-02-15', 0, 50);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(3, '2021-03-01', 13, '2021-04-01', '2021-05-03', 300, '2021-03-15', 0, 50);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(4, '2021-01-01', 14, '2021-02-01', '2021-03-01', 300, '2021-01-15', 0, 50);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(5, '2021-02-01', 15, '2021-03-01', '2021-04-01', 300, '2021-02-15', 0, 50);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(6, '2021-03-01', 16, '2021-04-01', '2021-05-03', 300, '2021-03-15', 0, 50);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(7, '2021-01-01', 17, '2021-02-01', '2021-03-01', 300, '2021-01-15', 0, 50);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(8, '2021-02-01', 18, '2021-03-01', '2021-04-01', 300, '2021-02-15', 0, 50);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(9, '2021-03-01', 19, '2021-04-01', '2021-05-03', 300, '2021-03-15', 0, 50);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(10, '2021-01-01', 20, '2021-02-01', '2021-03-01', 300, '2021-01-15', 0, 50);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(1, '2021-06-01', 11, '2021-07-01', '2021-08-02', 450, '2021-06-15', 0, 70);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(2, '2021-07-01', 12, '2021-08-02', '2021-09-01', 450, '2021-07-15', 0, 70);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(3, '2021-08-01', 13, '2021-09-01', '2021-10-01', 450, '2021-08-15', 0, 70);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(4, '2021-06-01', 14, '2021-07-01', '2021-08-02', 450, '2021-06-15', 0, 70);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(5, '2021-07-01', 15, '2021-08-02', '2021-09-01', 450, '2021-07-15', 0, 70);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(6, '2021-08-01', 16, '2021-09-01', '2021-10-01', 450, '2021-08-15', 0, 70);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(7, '2021-06-01', 17, '2021-07-01', '2021-08-02', 450, '2021-06-15', 0, 70);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(8, '2021-07-01', 18, '2021-08-02', '2021-09-01', 450, '2021-07-15', 0, 70);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(9, '2021-08-01', 19, '2021-09-01', '2021-10-01', 450, '2021-08-15', 0, 70);
insert into Course_Offerings(course_id, launch_date, admin_eid, start_date, end_date, fees, registration_deadline, seating_capacity, target_number_registrations) values(10, '2021-06-01', 20, '2021-07-01', '2021-08-01', 450, '2021-06-15', 0, 70);

insert into Rooms(seating_capacity, location) values(10, 'Kevin Main House');
insert into Rooms(seating_capacity, location) values(20, 'Kevin Bedroom');
insert into Rooms(seating_capacity, location) values(30, 'Kevin Living Room');
insert into Rooms(seating_capacity, location) values(40, 'Kevin Toilet');
insert into Rooms(seating_capacity, location) values(10, 'Kevin Underground Dungeon');
insert into Rooms(seating_capacity, location) values(20, 'Kevin Tuition Centre');
insert into Rooms(seating_capacity, location) values(30, 'Kevin Google Office');
insert into Rooms(seating_capacity, location) values(40, 'Kevin Kitchen');
insert into Rooms(seating_capacity, location) values(5, 'Kevin Garden');
insert into Rooms(seating_capacity, location) values(15, 'Kevin Third House');
insert into Rooms(seating_capacity, location) values(25, 'Kevin Mansion');

BEGIN TRANSACTION;
SET CONSTRAINTS check_all_course_offering_session_is_being_conducted_trigger DEFERRED;
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-01-01', 1, '2021-02-02', 9, 10);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-01-01', 1, '2021-02-10', 14, 15);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-01-01', 1, '2021-02-25', 16, 17);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-02-01', 2, '2021-03-04', 9, 11);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-02-01', 2, '2021-03-15', 14, 16);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-02-01', 2, '2021-04-01', 16, 18);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-03-01', 3, '2021-04-01', 9, 10);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-03-01', 3, '2021-04-15', 14, 15);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-03-01', 3, '2021-05-03', 16, 17);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-01-01', 4, '2021-02-01', 9, 11);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-01-01', 4, '2021-02-15', 14, 16);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-01-01', 4, '2021-03-01', 16, 18);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-02-01', 5, '2021-03-01', 9, 10);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-02-01', 5, '2021-03-15', 14, 15);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-02-01', 5, '2021-04-01', 16, 17);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-03-01', 6, '2021-04-01', 9, 11);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-03-01', 6, '2021-04-15', 14, 16);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-03-01', 6, '2021-05-03', 16, 18);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-01-01', 7, '2021-02-05', 9, 10);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-01-01', 7, '2021-02-15', 14, 15);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-01-01', 7, '2021-03-01', 16, 17);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-02-01', 8, '2021-03-01', 9, 11);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-02-01', 8, '2021-03-15', 14, 16);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-02-01', 8, '2021-04-01', 16, 18);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-03-01', 9, '2021-04-01', 9, 10);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-03-01', 9, '2021-04-15', 14, 15);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-03-01', 9, '2021-05-03', 16, 17);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-01-01', 10, '2021-02-03', 9, 11);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-01-01', 10, '2021-02-17', 14, 16);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-01-01', 10, '2021-03-03', 16, 18);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-06-01', 1, '2021-07-02', 9, 10);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-06-01', 1, '2021-07-16', 14, 15);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-06-01', 1, '2021-08-03', 16, 17);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-07-01', 2, '2021-08-02', 9, 11);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-07-01', 2, '2021-08-16', 14, 16);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-07-01', 2, '2021-09-01', 16, 18);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-08-01', 3, '2021-09-01', 9, 10);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-08-01', 3, '2021-09-15', 14, 15);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-08-01', 3, '2021-10-01', 16, 17);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-06-01', 4, '2021-07-02', 9, 11);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-06-01', 4, '2021-07-16', 14, 16);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-06-01', 4, '2021-08-03', 16, 18);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-07-01', 5, '2021-08-02', 9, 10);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-07-01', 5, '2021-08-16', 14, 15);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-07-01', 5, '2021-09-01', 16, 17);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-08-01', 6, '2021-09-01', 9, 11);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-08-01', 6, '2021-09-15', 14, 16);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-08-01', 6, '2021-10-01', 16, 18);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-06-01', 7, '2021-07-01', 9, 10);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-06-01', 7, '2021-07-15', 14, 15);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-06-01', 7, '2021-08-02', 16, 17);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-07-01', 8, '2021-08-02', 9, 11);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-07-01', 8, '2021-08-16', 14, 16);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-07-01', 8, '2021-09-01', 16, 18);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-08-01', 9, '2021-09-01', 9, 10);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-08-01', 9, '2021-09-15', 14, 15);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-08-01', 9, '2021-10-01', 16, 17);

insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(1, '2021-06-01', 10, '2021-07-01', 9, 11);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(2, '2021-06-01', 10, '2021-07-15', 14, 16);
insert into Course_Offering_Sessions(sid, launch_date, course_id, session_date, start_time_hour, end_time_hour) values(3, '2021-06-01', 10, '2021-08-02', 16, 18);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(1, 1, 1, 'Database Systems', '2021-01-01', 1);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(1, 1, 2, 'Database Systems', '2021-01-01', 1);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(1, 1, 3, 'Database Systems', '2021-01-01', 1);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(2, 1, 1, 'Computer Networks', '2021-02-01', 2);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(2, 1, 2, 'Computer Networks', '2021-02-01', 2);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(2, 1, 3, 'Computer Networks', '2021-02-01', 2);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(3, 5, 1, 'Operating Systems', '2021-03-01', 3);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(3, 5, 2, 'Operating Systems', '2021-03-01', 3);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(3, 5, 3, 'Operating Systems', '2021-03-01', 3);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(4, 4, 1, 'Data Structure and Algorithms', '2021-01-01', 4);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(4, 4, 2, 'Data Structure and Algorithms', '2021-01-01', 4);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(4, 4, 3, 'Data Structure and Algorithms', '2021-01-01', 4);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(5, 7, 1, 'Programming Languages', '2021-02-01', 5);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(5, 7, 2, 'Programming Languages', '2021-02-01', 5);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(5, 7, 3, 'Programming Languages', '2021-02-01', 5);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(6, 40, 1, 'Software Engineering', '2021-03-01', 6);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(6, 40, 2, 'Software Engineering', '2021-03-01', 6);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(6, 40, 3, 'Software Engineering', '2021-03-01', 6);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(7, 1, 1, 'Discrete Mathematics', '2021-01-01', 7);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(7, 1, 2, 'Discrete Mathematics', '2021-01-01', 7);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(7, 1, 3, 'Discrete Mathematics', '2021-01-01', 7);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(8, 10, 1, 'Statistics', '2021-02-01', 8);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(8, 10, 2, 'Statistics', '2021-02-01', 8);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(8, 10, 3, 'Statistics', '2021-02-01', 8);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(9, 39, 1, 'Ethics', '2021-03-01', 9);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(9, 39, 2, 'Ethics', '2021-03-01', 9);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(9, 39, 3, 'Ethics', '2021-03-01', 9);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(10, 33, 1, 'Calculus', '2021-01-01', 10);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(10, 33, 2, 'Calculus', '2021-01-01', 10);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(10, 33, 3, 'Calculus', '2021-01-01', 10);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(1, 1, 1, 'Database Systems', '2021-06-01', 1);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(1, 1, 2, 'Database Systems', '2021-06-01', 1);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(1, 1, 3, 'Database Systems', '2021-06-01', 1);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(2, 1, 1, 'Computer Networks', '2021-07-01', 2);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(2, 1, 2, 'Computer Networks', '2021-07-01', 2);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(2, 1, 3, 'Computer Networks', '2021-07-01', 2);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(3, 5, 1, 'Operating Systems', '2021-08-01', 3);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(3, 5, 2, 'Operating Systems', '2021-08-01', 3);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(3, 5, 3, 'Operating Systems', '2021-08-01', 3);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(4, 4, 1, 'Data Structure and Algorithms', '2021-06-01', 4);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(4, 4, 2, 'Data Structure and Algorithms', '2021-06-01', 4);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(4, 4, 3, 'Data Structure and Algorithms', '2021-06-01', 4);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(5, 7, 1, 'Programming Languages', '2021-07-01', 5);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(5, 7, 2, 'Programming Languages', '2021-07-01', 5);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(5, 7, 3, 'Programming Languages', '2021-07-01', 5);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(6, 40, 1, 'Software Engineering', '2021-08-01', 6);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(6, 40, 2, 'Software Engineering', '2021-08-01', 6);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(6, 40, 3, 'Software Engineering', '2021-08-01', 6);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(7, 1, 1, 'Discrete Mathematics', '2021-06-01', 7);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(7, 1, 2, 'Discrete Mathematics', '2021-06-01', 7);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(7, 1, 3, 'Discrete Mathematics', '2021-06-01', 7);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(8, 10, 1, 'Statistics', '2021-07-01', 8);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(8, 10, 2, 'Statistics', '2021-07-01', 8);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(8, 10, 3, 'Statistics', '2021-07-01', 8);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(9, 39, 1, 'Ethics', '2021-08-01', 9);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(9, 39, 2, 'Ethics', '2021-08-01', 9);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(9, 39, 3, 'Ethics', '2021-08-01', 9);

insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(10, 33, 1, 'Calculus', '2021-06-01', 10);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(10, 33, 2, 'Calculus', '2021-06-01', 10);
insert into Conducts(rid, instructor_id, sid, course_area_name, launch_date, course_id) values(10, 33, 3, 'Calculus', '2021-06-01', 10);
COMMIT;

insert into Cancels(cust_id, cancel_date, sid, launch_date, course_id, package_credit, refund_amt) values(1, '2021-01-03', 1, '2021-01-01', 1, 0, 300);
insert into Cancels(cust_id, cancel_date, sid, launch_date, course_id, package_credit, refund_amt) values(2, '2021-01-03', 1, '2021-01-01', 1, 0, 0);
insert into Cancels(cust_id, cancel_date, sid, launch_date, course_id, package_credit, refund_amt) values(8, '2021-05-02', 1, '2021-02-01', 2, 0, 0);

insert into Registers(cust_id, register_date, sid, launch_date, course_id) values(1, '2021-01-02', 1, '2021-01-01', 1);
insert into Registers(cust_id, register_date, sid, launch_date, course_id) values(2, '2021-01-02', 1, '2021-01-01', 1);
insert into Registers(cust_id, register_date, sid, launch_date, course_id) values(3, '2021-01-02', 1, '2021-01-01', 1);
insert into Registers(cust_id, register_date, sid, launch_date, course_id) values(4, '2021-01-02', 1, '2021-01-01', 1);
insert into Registers(cust_id, register_date, sid, launch_date, course_id) values(5, '2021-01-02', 1, '2021-01-01', 1);
insert into Registers(cust_id, register_date, sid, launch_date, course_id) values(6, '2021-01-02', 1, '2021-01-01', 1);
insert into Registers(cust_id, register_date, sid, launch_date, course_id) values(7, '2021-01-02', 1, '2021-01-01', 1);
insert into Registers(cust_id, register_date, sid, launch_date, course_id) values(8, '2021-01-02', 1, '2021-01-01', 1);
insert into Registers(cust_id, register_date, sid, launch_date, course_id) values(9, '2021-01-02', 1, '2021-01-01', 1);
insert into Registers(cust_id, register_date, sid, launch_date, course_id) values(8, '2021-06-02', 1, '2021-06-01', 7);
insert into Registers(cust_id, register_date, sid, launch_date, course_id) values(8, '2021-02-10', 2, '2021-02-01', 2);

insert into Buys values(1, 1, '2021-04-02', 5);
insert into Buys values(2, 1, '2021-04-02', 5);
insert into Buys values(3, 1, '2021-04-02', 5);
insert into Buys values(4, 1, '2021-04-02', 5);
insert into Buys values(5, 2, '2021-04-02', 5);
insert into Buys values(6, 2, '2021-04-02', 5);
insert into Buys values(7, 2, '2021-04-02', 5);
insert into Buys values(8, 3, '2021-04-02', 0);
insert into Buys values(8, 7, '2021-04-02', 5);
insert into Buys values(9, 3, '2021-04-02', 5);
insert into Buys values(10, 4, '2021-04-02', 5);

/* This doesn't work because the trigger prevents you from redeeming when you have no more sessions in Buys! */
insert into Redeems(redemption_date, sid, launch_date, course_id, cust_id, package_id, purchase_date) values('2021-07-01', 3, '2021-06-01', 10, 8, 7, '2021-04-02');
insert into Redeems(redemption_date, sid, launch_date, course_id, cust_id, package_id, purchase_date) values('2021-07-01', 2, '2021-06-01', 10, 8, 7, '2021-04-02');
insert into Redeems(redemption_date, sid, launch_date, course_id, cust_id, package_id, purchase_date) values('2021-08-01', 3, '2021-07-01', 8, 8, 7, '2021-04-02');
insert into Redeems(redemption_date, sid, launch_date, course_id, cust_id, package_id, purchase_date) values('2021-03-01', 1, '2021-02-01', 2, 8, 7, '2021-04-02');
