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

/* Function (3) add_customer (Gerren) */

/* Set 1: Verify that the function works in the normal case (Passing) */
CALL add_customer('Alice', 'Buona Vista', 88889999, 'alice@gmail.com', '6500000000000005','2021-10-10', '998');
CALL add_customer('Bob', 'Holland Village', 88888888, 'bob@gmail.com', '6500000000000006','2021-11-10', '988');
CALL add_customer('Trudy', 'One-North', 88887777, 'trudy@gmail.com', '6500000000000007','2021-12-10', '978');
CALL add_customer('Eve', 'Kent Ridge', 88886666, 'eve@gmail.com', '6500000000000008','2022-01-10', '968');
CALL add_customer('Mallory', 'Haw Par Villa', 88885555, 'mallory@gmail.com', '6500000000000009','2022-02-10', '958');

/* Set 2: Verify that there cannot be insertion of the same credit card number (Passing) */
CALL add_customer('Alice', 'Buona Vista', 88889999, 'alice@gmail.com', '5500000000000005','2021-10-10', '898');
CALL add_customer('Bob', 'Holland Village', 88888888, 'bob@gmail.com', '5500000000000006','2021-11-10', '988');

/* Set 3: Verify that the function throws an exception for non-existent dates (non-leap year) (Passing) */
SELECT get_available_rooms('2022-02-29', '2022-02-29');

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

/* Function (7) get_available_instructors (Gerren) */

/* Set 1: Verify if available hours is limited if instructor teaches another session on one of the days (Passing) */
SELECT * FROM get_available_instructors(1, '2021-03-15', '2021-03-16');
SELECT * FROM get_available_instructors(2, '2021-03-15', '2021-03-16');

/* Set 2: Verify that for the same date many years before or after, teaching hours are not counted (Passing) */
SELECT * FROM get_available_instructors(1, '2018-03-15', '2018-03-16');
SELECT * FROM get_available_instructors(2, '2022-03-15', '2022-03-16');

/* Set 3: Verify that weekends are not included among the range of date input (Passing) */
SELECT * FROM get_available_instructors(3, '2021-04-09', '2021-04-12');
SELECT * FROM get_available_instructors(4, '2021-04-17', '2021-04-18');

/* Set 4: Verify that exception is thrown if course_id is invalid (Passing) */
SELECT * FROM get_available_instructors(555, '2021-04-09', '2021-04-12');
SELECT * FROM get_available_instructors(-602, '2021-04-17', '2021-04-18');
SELECT * FROM get_available_instructors(0789, '2021-04-20', '2021-04-25');

/* Set 5: Verify that exception is thrown if date range provided is invalid (Passing) */
SELECT * FROM get_available_instructors(1, '2021-03-15', '2021-03-14');
SELECT * FROM get_available_instructors(1, '2021-03-15', '2021-03-167')

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

CREATE TYPE session_info AS (session_date date, session_start_hour integer, room_id integer);

/* Set 1: Verify that the function works in the normal case (Failing) */
CALL add_course_offering(1, '2021-12-12', 50.0, '2021-12-11', 11, ARRAY[row('2022-02-18', 9, 1)::session_info]);
CALL add_course_offering(2, '2021-12-12', 50.0, '2021-12-11', 11, ARRAY[row('2022-02-18', 9, 1)::session_info, row('2022-02-19', 96, 1)::session_info]); /* Says that i does not exist in all_session_info[i] */
CALL add_course_offering(1, '2021-12-12', 50.0, '2021-12-11', 11, ARRAY[row('2022-02-18', 9, 1)::session_info, row('2022-02-18', 9, 1)::session_info,
        row('2022-02-18', 9, 1)::session_info, row('2022-02-18', 9, 1)::session_info, row('2022-02-18', 9, 1)::session_info]); /* Multiple instructors and rooms should insert correctly */

/* Set 2: Verify that the function throws an exception if the registration deadline is after the launch date (Passing) */
CALL add_course_offering(1, '2021-06-10', 50.0, '2021-06-15', 11, ARRAY['("2021-06-20", 9, 1)'::session_info]);

/* Set 3: Verify that the function throws an exception if any session is on a weekend (Passing) */
CALL add_course_offering(1, '2021-12-12', 50.0, '2021-12-11', 11, ARRAY['("2022-02-19", 9, 1)'::session_info]);
CALL add_course_offering(1, '2021-12-12', 50.0, '2021-12-11', 11, ARRAY['("2022-02-20", 9, 1)'::session_info]);

/* Set 4: Verify that the function throws an exception if the session information is empty (Passing (violates target no. registrations > 0 check)) */
CALL add_course_offering(1, '2021-12-12', 50.0, '2021-12-11', 11, '{}');

/* Set 5: Verify that the function throws an exception if the course ID and launch date already uniquely identify a course offering (Passing) */
CALL add_course_offering(1, '2021-01-01', 50.0, '2021-12-11', 11, ARRAY['("2022-02-18", 9, 1)'::session_info]);

/* Set 6: Verify that the function throws an exception if the fees have invalid values (Passing) */
CALL add_course_offering(1, '2021-12-12', 0.0, '2021-12-11', 11, ARRAY['("2022-02-18", 9, 1)'::session_info]);
CALL add_course_offering(1, '2021-12-12', -1.0, '2021-12-11', 11, ARRAY['("2022-02-18", 9, 1)'::session_info]);

/* Set 7: Verify that the function throws an exception if the launch date is before the current date (Passing) */
CALL add_course_offering(1, '2021-01-15', 50.0, '2021-01-10', 11, ARRAY['("2021-02-02", 9, 1)'::session_info]);

/* Set 8: Verify that the function throws an exception if the launch date comes before any of the sessions (Passing) */
CALL add_course_offering(1, '2021-06-15', 50.0, '2021-06-10', 11, ARRAY['("2021-06-13", 9, 1)'::session_info]);

/* Set 9: Verify that the function throws an exception if there are no instructors left to teach a particular session (Failing) */
CALL add_course_offering(1, '2021-12-12', 50.0, '2021-12-11', 11, ARRAY[row('2022-02-18', 9, 1)::session_info, row('2022-02-18', 9, 1)::session_info,
        row('2022-02-18', 9, 1)::session_info, row('2022-02-18', 9, 1)::session_info, row('2022-02-18', 9, 1)::session_info, row('2022-02-18', 9, 1)::session_info]);

/* Function (11) add_course_package* (Gerren) */

/* Set 1: Verify that the function works in the normal case (Passing) */
CALL add_course_package('Summer Special', 10, 40.55, '2021-05-05', '2021-07-05');
CALL add_course_package('Winter Special', 14, 60.00, '2021-05-05', '2021-07-05');
CALL add_course_package('Spring Special', 20, 99.90, '2021-06-05', '2021-07-05');
CALL add_course_package('Autumn Special', 10, 27.00, '2021-06-05', '2021-07-05');
CALL add_course_package('New Year Special', 5, 31.90, '2021-06-05', '2021-07-05');

/* Set 2: Verify that constraint prevents invalid date ranges (Passing) */
CALL add_course_package('Summer Special', 10, 40.55, '2021-05-05', '2021-04-05');
CALL add_course_package('Summer Special', 10, 40.55, '2021-05-05', '2021-05-04');

/* Set 3: Verify that constraint prevents invalid prices (Passing) */
CALL add_course_package('Summer Special', 10, -300, '2021-05-05', '2021-07-05');
CALL add_course_package('Summer Special', 10, -1.20, '2021-05-05', '2021-07-05');

/* Set 4: Verify that constraint prevents invalid number of free registrations (Passing) */
CALL add_course_package('Summer Special', 0, 40.55, '2021-05-05', '2021-07-05');
CALL add_course_package('Summer Special', -2, 40.55, '2021-05-05', '2021-07-05');
CALL add_course_package('Summer Special', 2.5, 40.55, '2021-05-05', '2021-07-05');

/* Function (12) get_available_course_packages (Kevin) */

/* Set 1: Verify that the function works if the current date is the same as the end date of a course package (insert own data) (Passing) */
/* Set 2: Verify that the function works if the current date is the same as the start date of a course package (insert own data) (Passing) */
/* Set 3: Verify that the function works in the normal case (Passing) */
/* Set 4: Verify that the function excludes course packages which have later start dates than the current date (insert own data) (Passing) */
/* Set 5: Verify that the function excludes course packages which have earlier end dates than the current date (insert own data) (Passing) */
SELECT get_available_course_packages();

/* Function (13) buy_course_package (Fabian) */

/* Function (14) get_my_course_package (Siddarth) */

/* Function (15) get_available_course_offerings (Gerren) */

/* Set 1: Verify that the function works in the normal case (Passing) */
SELECT * FROM get_available_course_offerings();

/* Set 2: Verify that the function gives accurate results when number of sessions registered increases (Insert own data, Passing) */
/* Set 3: Verify that the function gives accurate results when number of sessions registered decreases (Insert own data, Passing) */
/* Set 4: Verify that the function gives accurate results when number of sessions redeemed increases (Insert own data, Passing) */
/* Set 5: Verify that the function gives accurate results when number of sessions redeemed decreases (Insert own data, Passing) */
/* Set 6: Verify that the function gives accurate results when offerings have remaining seats which decreased 0 (Insert own data, Passing) */

/* Function (16) get_available_course_sessions (Kevin) */

/* Set 1: Verify that the function works in the normal case (Passing) */
SELECT get_available_course_sessions(10, '2021-06-01');

/* Set 2: Verify that the function excludes sessions with no seats left (insert own data) (Passing) */
SELECT get_available_course_sessions(10, '2021-06-01');

/* Set 3: Verify that the function excludes sessions which have dates earlier than the current date (Passing) */
SELECT get_available_course_sessions(1, '2021-01-01');

/* Function (17) register_session (Fabian) */

/* Function (18) get_my_registrations (Siddarth) */

/* Function (19) update_course_session (Gerren) */

/* Pre-processing */
INSERT INTO Registers(cust_id, register_date, sid, launch_date, course_id) VALUES(8, '2021-06-02', 1, '2021-06-01', 1);

/* Useful visualisation queries */
SELECT cust_id, session_date, course_id, launch_date, sid, start_time_hour, end_time_hour
FROM Redeems NATURAL JOIN Course_Offering_Sessions
UNION
SELECT cust_id, session_date, course_id, launch_date, sid, start_time_hour, end_time_hour
FROM Registers NATURAL JOIN Course_Offering_Sessions

ORDER BY cust_id, session_date;

/* Set 1: Verify that the function works in the normal case (Passing) */
CALL update_course_session(8, 2, '2021-07-01', 2);
CALL update_course_session(8, 1, '2021-06-01', 2);

/* Set 2: Verify that exception is thrown if session to be updated is already over (Passing) */
CALL update_course_session(3, 1, '2021-01-01', 3);
CALL update_course_session(8, 2, '2021-02-01', 3);

/* Set 3: Verify that exception is thrown if new to be updated with is already over (Insert own data, Passing) */

/* Set 4: Verify that exception is thrown if customer is already in the session he/she wishes to change to (Passing) */
CALL update_course_session(8, 10, '2021-06-01', 2);

/* Set 5: Verify that exception is thrown if customer's new session clashes with another session which he is already in (Passing) */
CALL update_course_session(8, 10, '2021-06-01', 3);

/* Set 6: Verify that exception is thrown if customer is invalid (Passing) */
CALL update_course_session(888, 2, '2021-07-01', 2);
CALL update_course_session(0, 2, '2021-07-01', 2);
CALL update_course_session(-8, 2, '2021-07-01', 2);

/* Set 7: Verify that exception is thrown if session number / course identifier is invalid (Passing) */
CALL update_course_session(8, 2, '2021-07-01', 4);
CALL update_course_session(8, 2, '2021-08-01', 2);

/* Set 8: Verify that exception is thrown if customer did not register for the offering which new session belongs to (Passing) */
CALL update_course_session(8, 7, '2021-06-01', 2);

/* Set 9: Verify that exception is thrown if new session does not have enough seating capacity to accomodate (Insert own data, Passing) */

/* Function (20) cancel_registration (Kevin) */

/* Function (21) update_instructor (Fabian) */

/* Function (22) update_room (Siddarth) */

/* Function (23) remove_session (Gerren) */

/* Pre-processing */
INSERT INTO Registers(cust_id, register_date, sid, launch_date, course_id) VALUES(8, '2021-06-02', 1, '2021-06-01', 1);

/* Set 1: Verify that the function works in the normal case (Passing) */
CALL remove_session(3, '2021-03-01', 3);
CALL remove_session(3, '2021-08-01', 1);

/* Set 2: Verify that exception is thrown when removing a session that has commenced (Passing) */
CALL remove_session(1, '2021-01-01', 1);
CALL remove_session(2, '2021-02-01', 1);
CALL remove_session(3, '2021-03-01', 1);

/* Set 3: Verify that exception is thrown when removing an invalid session (Passing) */
CALL remove_session(3, '2021-03-01', 5);
CALL remove_session(3, '2021-04-01', 3);
CALL remove_session(4, '2021-03-01', 3);

/* Set 4: Verify that exception is thrown when removing a session that has at least one registration/redemption (Passing) */
CALL remove_session(1, '2021-06-01', 1);
CALL remove_session(10, '2021-06-01', 2);
CALL remove_session(2, '2021-07-01', 1);

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

/* Function (27) top_packages (Gerren) */

/* Set 1: Verify that the function works in the normal case (Passing) */
SELECT * FROM top_packages(1);
SELECT * FROM top_packages(2);
SELECT * FROM top_packages(3);
SELECT * FROM top_packages(4);
SELECT * FROM top_packages(5);
SELECT * FROM top_packages(50);

/* Function (28) popular_courses (Kevin) */
/* Course start date is within this year; has >= 2 offerings; for every pair of offerings, later offering has more people */

/* Function (29) view_summary_report (Fabian) */

/* Function (30) view_manager_report (Siddarth) */
