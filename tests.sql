/* Function (1) add_employee (Fabian) */

/* Set 1: Verify that the function works in the normal case (Passing) */
CALL add_employee('AA', 'My Road', '99998888', 'me@mail.com', 'Hourly', 10.0, '2000-01-01', 'Instructor', '{"Database Systems"}');
CALL add_employee('BB', 'My Road', '99998888', 'me@mail.com', 'Monthly', 1000.0, '2000-01-01', 'Instructor', '{"Database Systems"}');
CALL add_employee('CC', 'My Road', '99998888', 'me@mail.com', 'Hourly', 10.0, '2000-01-01', 'Manager', '{}');
CALL add_employee('CC', 'My Road', '99998888', 'me@mail.com', 'Hourly', 10.0, '2000-01-01', 'Administrator', '{}');

/* Set 2: Verify that the function throws an exception if the join date is after the current date (Passing) */
CALL add_employee('CC', 'My Road', '99998888', 'me@mail.com', 'Hourly', 10.0, '2022-01-01', 'Administrator', '{}'); 

/* Set 3: Verify that the function throws an exception if the salary is below 0 (Passing) */
CALL add_employee('CC', 'My Road', '99998888', 'me@mail.com', 'Hourly', -1.0, '2000-01-01', 'Administrator', '{}');
CALL add_employee('CC', 'My Road', '99998888', 'me@mail.com', 'Monthly', -1.0, '2000-01-01', 'Administrator', '{}');

/* Set 4: Verify that the function throws an exception if the course area does not exist (Passing) */
CALL add_employee('AA', 'My Road', '99998888', 'me@mail.com', 'Hourly', 10.0, '2000-01-01', 'Instructor', '{"DBMS"}');

/* Set 5: Verify that the function throws an exception if an empty array is used for an instructor (Passing) */
CALL add_employee('AA', 'My Road', '99998888', 'me@mail.com', 'Hourly', 10.0, '2000-01-01', 'Instructor', '{}'); 

/* Set 6: Verify that the function throws an exception if the course area is already being managed by a manager (Passing) */
CALL add_employee('AA', 'My Road', '99998888', 'me@mail.com', 'Hourly', 10.0, '2000-01-01', 'Manager', '{"Calculus"}');

/* Set 7: Verify that the function throws an exception if adding an administrator with non-empty course areas (Passing) */
CALL add_employee('AA', 'My Road', '99998888', 'me@mail.com', 'Hourly', 10.0, '2000-01-01', 'Administrator', '{"Calculus"}'); 

/* Function (2) remove_employee (Siddarth)*/

/* Set 1: Verify that the function works if the employee is a Administrator that DOES NOT handle ANY course offering where it's registration deadline is after the departure date (Passing) */
CALL remove_employee(11, '2021-07-01');
/* Set 2: Verify that the function throws an exception if the employee is a Administrator handling SOME course offering where it's registration deadline is after the departure date (Passing) */
CALL remove_employee(11, '2021-05-01');
/* Set 3: Verify that the function works if the employee is a Instructor who DOES NOT teach ANY course session that starts after the departure date (Passing) */
CALL remove_employee(1, '2021-08-20');
/* Set 4: Verify that the function throws an exception if the employee is an Instructor who is teaching some course session that starts after the departure date (Passing) */
CALL remove_employee(1, '2021-10-20');
/* Set 5: Verify that the function works if the employee is a Manager who is NOT managing ANY course area */
CALL remove_employee(26, '2021-11-20');
/* Set 6: Verify that the function throws an exception if the employee is a Manager who is managing some course area */
CALL remove_employee(21, '2021-11-20');
/* Set 7: Verify that the function throws an exception if the employee id is invalid (Passing) */
CALL remove_employee(100, '2021-04-05');
/* Set 8: Verify that the function throws an exception if the departure date is before the Employee's joining date (Passing) */
CALL remove_employee(2, '2013-07-05');
/* Set 9: Verify that the function throws an exception if the employee has departed already (Passing) */
CALL remove_employee(1, '2021-10-10');
CALL remove_employee(1, '2021-11-10');

/* Function (3) add_customer (Gerren) */

/* Function (4) update_credit_card (Kevin) */

/* Set 1: Verify that the function works in the normal case (both Credit_Cards and Customers tables should be updated); also check for leap years (Passing) */
CALL update_credit_card(1, '12654', '2030-12-12', '123');
CALL update_credit_card(3, '16278392', '2024-02-29', '578');

/* Set 2: Verify that the function throws an exception and does not update Credit_Cards if the customer ID does not exist (Passing) */
CALL update_credit_card(100, '12345', '2030-12-12', '123');

/* Set 3: Verify that the function works even if the credit card number exists (i.e. change other credit card details) for the customer (Passing */
CALL update_credit_card(2, '5500 0000 0000 0004', '2030-12-12', '123');

/* Set 4: Verify that the CVV number must be a 3-digit number (Passing) */
CALL update_credit_card(1, '12654', '2030-12-12', 'abc');
CALL update_credit_card(1, '12654', '2030-12-12', '+');
CALL update_credit_card(1, '12654', '2030-12-12', '');
CALL update_credit_card(1, '12654', '2030-12-12', '1');
CALL update_credit_card(1, '12654', '2030-12-12', '12');
CALL update_credit_card(1, '12654', '2030-12-12', '1234');

/* Set 5: Verify that the CVV number can take 0 as its first digit (Passing) */
CALL update_credit_card(1, '12654', '2030-12-12', '089');

/* Set 6: Verify that the expiration date is after the current date (Passing) */
CALL update_credit_card(1, '12654', '2019-12-12', '123');

/* Set 7: Verify that the function throws an exception and does not update Credit_Cards if the expiration date is invalid; also check for non-leap years (Passing) */
CALL update_credit_card(1, '12654', '2023-02-29', '123');
CALL update_credit_card(1, '12654', '2030-20-20', '123');

/* Set 8: Verify that the function throws an exception and does not update Credit_Cards if the credit card number contains non-numeric characters (Passing) */
CALL update_credit_card(1, 'abcd', '2030-12-12', '123');
CALL update_credit_card(1, '+', '2030-12-12', '123');
CALL update_credit_card(1, '', '2030-12-12', '123');

/* Function (5) add_course (Fabian) */

/* Set 1: Verify that the function works in the normal case (Passing) */
CALL add_course('My DB101', 'DB101', 1, 'Database Systems');
CALL add_course('My DB101', 'DB102', 2, 'Database Systems');
CALL add_course('My DB101', 'DB103', 3, 'Database Systems');
CALL add_course('My DB101', 'DB104', 4, 'Database Systems');

/* Set 2: Verify that the function throws an exception if the duration is non within the acceptable range (Passing) */
CALL add_course('My DB101', 'DB101', 0, 'Database Systems');
CALL add_course('My DB101', 'DB101', -1, 'Database Systems');
CALL add_course('My DB101', 'DB101', 5, 'Database Systems');
CALL add_course('My DB101', 'DB101', 100, 'Database Systems');

/* Set 3: Verify that the function throws an exception if the title already exists (Passing) */
CALL add_course('My DB101', 'Introduction to Database Systems', 1, 'Database Systems');

/* Set 4: Verify that the function throws an exception if the course area does not exist (Passing) */
CALL add_course('My DB101', 'My DBMS', 1, 'DBMS');

/* Function (6) find_instructors (Siddarth) */

/* Set 1: Verify that the function works in the normal case (Passing)*/
SELECT find_instructors(2, '2021-09-01', 16);

/* Set 2: Verify that the function returns no output if the session date is on a weekend */
SELECT find_instructors(5, '2021-04-25', 10);

/* Set 3: Verify that the function returns no output if the session start hour is in between 12-2 */
SELECT find_instructors(5, '2021-01-01', 13);

/* Set 4: Verify that the function returns no output if the session start hour is before 9 */
SELECT find_instructors(5, '2021-01-01', 8);

/* Set 5: Verify that the function returns no output if the session start hour is after 18 */
SELECT find_instructors(5, '2021-01-01', 19);

/* Set 6: Verify that the function throws an exception if the session start hour is non-positive */
SELECT find_instructors(5, '2021-01-01', -2);

/* Set 7: Verify that the function throws an exception if the course id is invalid (Passing) */
SELECT find_instructors(11, '2021-01-01', 9);

/* Function (7) get_available_instructors (Gerren) */

/* Function (8) find_rooms (Kevin) */

/* Set 1: Verify that the function excludes the 4 overlap cases (Passing) */
/* (Top: Specified input, bottom: existing course offering session)
    X---X
      X---X
      X---X
    X---X
  X------X
    X--X
    X--X
  X------X
*/
SELECT find_rooms('2021-04-01', 15, 2);
SELECT find_rooms('2021-03-15', 15, 2);
SELECT find_rooms('2021-04-01', 14, 4);
SELECT find_rooms('2021-03-15', 14, 1);


/* Set 2: Verify that the function includes the 2 boundary touching cases (Passing) */
/* (Top: Specified input, bottom: existing course offering session)
    X---X
        X---X
        X---X
    X---X
*/
SELECT find_rooms('2021-04-01', 15, 1);
SELECT find_rooms('2021-03-15', 16, 1);

/* Set 3: Verify that the function works in the normal case; also check for leap years (Passing) */
SELECT find_rooms('2021-04-28', 9, 1);
SELECT find_rooms('2021-04-28', 9, 3);
SELECT find_rooms('2021-04-28', 14, 1);
SELECT find_rooms('2021-04-28', 14, 4);
SELECT find_rooms('2024-02-29', 14, 4);

/* Set 4: Verify that the function throws an exception if the date is a weekend (Passing) */
SELECT find_rooms('2021-04-03', 9, 1);
SELECT find_rooms('2021-04-04', 9, 1);

/* Set 5: Verify that the function throws an exception if the duration <= 0 (Passing) */
SELECT find_rooms('2021-04-28', 9, 0);
SELECT find_rooms('2021-04-28', 9, -1);

/* Set 6: Verify that the function throws an exception if the duration > 4 (Passing) */
SELECT find_rooms('2021-04-28', 9, 5);

/* Set 7: Verify that the function throws an exception if the session does not fall between 9 to 12 or 2 to 6 (Passing) */
SELECT find_rooms('2021-04-28', 9, 4);
SELECT find_rooms('2021-04-28', 15, 4);
SELECT find_rooms('2021-04-28', 8, 1);
SELECT find_rooms('2021-04-28', 18, 1);
SELECT find_rooms('2021-04-28', 12, 1);
SELECT find_rooms('2021-04-28', 13, 1);

/* Set 8: Verify that the function throws an exception if the date is invalid; also check for non-leap years (Passing) */
SELECT find_rooms('2021-02-29', 9, 1);
SELECT find_rooms('2030-20-20', 9, 1);

/* Function (9) get_available_rooms (Fabian) */

/* Set 1: Verify that the function works in the normal case (Passing) */
SELECT get_available_rooms('2021-06-01', '2021-06-01');
SELECT get_available_rooms('2021-02-02', '2021-02-03'); 

/* Set 2: Verify that the function throws an exception if the end date is after the start date (Passing) */
SELECT get_available_rooms('2021-06-02', '2021-06-01'); 

/* Set 3: Verify that the function throws an exception for non-existent dates (leap year) (Passing) */
SELECT FUNCTION get_available_rooms('2022-02-29', '2022-02-29');

/* Function (10) add_course_offering (Fabian) */

/* Function (11) add_course_package* (Gerren) */

/* Function (12) get_available_course_packages (Kevin) */

/* Set 1: Verify that the function works if the current date is the same as the end date of a course package (insert own data) (Passing) */
/* Set 2: Verify that the function works if the current date is the same as the start date of a course package (insert own data) (Passing) */
/* Set 3: Verify that the function works in the normal case (Passing) */
/* Set 4: Verify that the function excludes course packages which have later start dates than the current date (insert own data) (Passing) */
/* Set 5: Verify that the function excludes course packages which have earlier end dates than the current date (insert own data) (Passing) */
SELECT get_available_course_packages();

/* Function (13) buy_course_package (Fabian) */

/* Function (14) get_my_course_package (Siddarth) */

/* Set 1: Verify that the function works in the normal case (Passing) */
SELECT get_my_course_package(8);
/* Set 2: Verify that the function throws an exception for invalid customer id (Passing) */
SELECT get_my_course_package(11);

/* Function (15) get_available_course_offerings (Gerren) */

/* Function (16) get_available_course_sessions (Kevin) */

/* Set 1: Verify that the function works in the normal case (Passing) */
SELECT get_available_course_sessions(10, '2021-06-01');

/* Set 2: Verify that the function excludes sessions with no seats left (insert own data) (Passing) */
SELECT get_available_course_sessions(10, '2021-06-01');

/* Set 3: Verify that the function excludes sessions which have dates earlier than the current date (Passing) */
SELECT get_available_course_sessions(1, '2021-01-01');

/* Function (17) register_session (Fabian) */

/* Function (18) get_my_registrations (Siddarth) */

/* Set 1: Verify that the function works in the normal case (Passing) */
SELECT get_my_registrations(8);

/* Set 2: Verify that the function throws an exception for invalid customer id (Passing) */
SELECT get_my_registrations(12);

/* Function (19) update_course_session (Gerren) */

/* Function (20) cancel_registration (Kevin) */

/* Function (21) update_instructor (Fabian) */

/* Function (22) update_room (Siddarth) */

/* Set 1: Verify that the function works in the normal case (Passing) */
CALL update_room(8, '2021-07-01', 1, 4);
/* Set 2: Verify that the function throws an exception if the new room id is invalid (Passing) */
CALL update_room(8, '2021-07-01', 1, 15);
/* Set 3: Verify that the function throws an exception if the new room's seating capacity is lesser than course session seating capacity (Passing) */
CALL update_room(10, '2021-06-01', 3, 5);
/* Set 4: Verify that the function throws an exception if the new room has a concurrent session (Passing) */
CALL update_room(10, '2021-06-01', 3, 8);
/* Set 5: Verify that the function throws an exception if the course session is invalid (Passing) */
CALL update_room(8, '2021-01-01', 1, 1);

/* Function (23) remove_session (Gerren) */

/* Function (24) add_session (Kevin) */

/* Set 1: Verify that the function works in the normal case (inserts into Course_Offering_Sessions and Conducts,
   and updates seating capacity, start date (trigger), and end date (trigger) in Course_Offerings (Passing) */
CALL add_session(1, '2021-06-01', 4, '2021-07-09', 9, 1, 1);
CALL add_session(1, '2021-06-01', 4, '2021-07-01', 9, 1, 1);
CALL add_session(1, '2021-06-01', 4, '2021-08-15', 9, 1, 1);

/* Set 2: Verify that the function throws an exception if (course_id, launch_date) does not exist (Passing) */
CALL add_session(1, '2021-06-02', 4, '2021-07-09', 9, 1, 1);

/* Set 3: Verify that the function throws an exception if the instructor with instructor_id does not exist (Passing) */
CALL add_session(1, '2021-06-01', 4, '2021-07-09', 9, 100, 1);

/* Set 4: Verify that the function throws an exception if the instructor does not specialise in the course area (trigger) (Passing) */
CALL add_session(1, '2021-06-01', 4, '2021-07-09', 9, 2, 1);

/* Set 5: Verify that the function throws an exception if the room does not exist (Passing) */
CALL add_session(1, '2021-06-01', 4, '2021-07-09', 9, 1, 100);

/* Set 6: Verify that the function throws an exception if session time is invalid (Passing) */
CALL add_session(1, '2021-06-01', 4, '2021-07-12', 8, 1, 1);
CALL add_session(1, '2021-06-01', 4, '2021-07-12', 18, 1, 1);
CALL add_session(1, '2021-06-01', 4, '2021-07-12', 12, 1, 1);
CALL add_session(1, '2021-06-01', 4, '2021-07-12', 13, 1, 1);

/* Set 7: Verify that the function throws an exception if session time overlaps with an existing session (Passing) */
CALL add_session(1, '2021-06-01', 3, '2021-07-16', 14, 1, 1);

/* Set 8: Verify that the function throws an exception if the current date is past the registration deadline (Passing) */
CALL add_session(1, '2021-01-01', 1, '2021-07-09', 9, 1, 1);

/* Set 9: Verify that the function throws an exception if the session number is too small or big (Passing) */
CALL add_session(1, '2021-06-01', 2, '2021-07-09', 9, 1, 1);
CALL add_session(1, '2021-06-01', 5, '2021-07-09', 9, 1, 1);

/* Function (25) pay_salary (Fabian) */

/* Function (26) promote_courses (Siddarth) */

/* Set 1: Verify that the function works in the normal case (Passing) */
SELECT promote_courses();

/* Function (27) top_packages (Gerren) */

/* Function (28) popular_courses (Kevin) */
    /* Course start date is within this year; has >= 2 offerings; for every pair of offerings, later offering has more people */

/* Function (29) view_summary_report (Fabian) */

/* Function (30) view_manager_report (Siddarth) */

/* Set 1: Verify that the function works in the normal case (Passing) */
SELECT view_manager_report();
