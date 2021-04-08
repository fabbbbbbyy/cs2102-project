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

/* Function (10) add_course_offering (Siddarth) */

/* Set 1: Verify that the function works in the normal case (Passing) */
CALL add_course_offering(1, '2021-05-20', 5000, '2021-05-05', 11, ARRAY[ ROW('2021-05-25', 10, 1)  ]::session_info[]);
CALL add_course_offering(1, '2021-05-20', 5000, '2021-05-05', 11, ARRAY[ ROW('2021-05-25', 10, 1), ROW('2021-05-26', 10, 1)  ]::session_info[]);

/* Set 2: Verify that the function throws an exception when there is such a course offering already in the database (Passing) */
CALL add_course_offering(1, '2021-01-01', 5000, '2021-05-05', 11, ARRAY[ ROW('2021-05-25', 10, 1)  ]::session_info[]);

/* Set 3: Verify that the function throws an exception when there is no such administrator in the database (Passing) */
CALL add_course_offering(1, '2021-05-20', 5000, '2021-05-05', 1, ARRAY[ ROW('2021-05-25', 10, 1)  ]::session_info[]);
CALL add_course_offering(1, '2021-05-20', 5000, '2021-05-05', 999, ARRAY[ ROW('2021-05-25', 10, 1)  ]::session_info[]);

/* Set 4: Verify that the function throws an exception when there is no such room in the database (Passing) */
CALL add_course_offering(1, '2021-05-20', 5000, '2021-05-05', 11, ARRAY[ ROW('2021-05-25', 10, 50)  ]::session_info[]);

/* Set 5: Verify that the function throws an exception when the launch date is already over (Passing) */
CALL add_course_offering(1, '2021-03-20', 5000, '2021-05-05', 11, ARRAY[ ROW('2021-05-25', 10, 1)  ]::session_info[]);

/* Set 6: Verify that the function throws an exception when the registration date is already over (Passing) */
CALL add_course_offering(1, '2021-05-20', 5000, '2021-03-05', 11, ARRAY[ ROW('2021-05-25', 10, 1)  ]::session_info[]);

/* Set 7: Verify that the function throws an exception when the launch date is before the registration date (Passing) */
CALL add_course_offering(1, '2021-05-20', 5000, '2021-05-27', 11, ARRAY[ ROW('2021-05-25', 10, 1)  ]::session_info[]);

/* Set 8: Verify that the function throws an exception when the session date is before the registration date (Passing) */
CALL add_course_offering(1, '2021-05-20', 5000, '2021-05-05', 11, ARRAY[ ROW('2021-05-01', 10, 1)  ]::session_info[]);

/* Set 9: Verify that the function throws an exception when the launch date is before the registration date (Passing) */
CALL add_course_offering(1, '2021-05-20', 5000, '2021-05-05', 11, ARRAY[ ROW('2021-05-01', 10, 1)  ]::session_info[]);

/* Set 10: Verify that the function only adds the course offering and not sessions and conducts when no instructors are free (Passing) */
CALL add_course_offering(1, '2021-05-20', 5000, '2021-05-05', 11, ARRAY[ ROW('2021-05-25', 10, 1)  ]::session_info[]);

/* Function (11) add_course_package* (Gerren) */

/* Function (12) get_available_course_packages (Kevin) */

/* Set 1: Verify that the function works if the current date is the same as the end date of a course package (insert own data) (Passing) */
/* Set 2: Verify that the function works if the current date is the same as the start date of a course package (insert own data) (Passing) */
/* Set 3: Verify that the function works in the normal case (Passing) */
/* Set 4: Verify that the function excludes course packages which have later start dates than the current date (insert own data) (Passing) */
/* Set 5: Verify that the function excludes course packages which have earlier end dates than the current date (insert own data) (Passing) */
SELECT get_available_course_packages();

/* Function (13) buy_course_package (Fabian) */

/* Set 1: Verify that the function works in the normal case (Passing) */
CALL buy_course_package(1, 1);

/* Set 2: Verify that the function throws exception for when customer does not exist and course package exists (Passing) */
CALL buy_course_package(9999, 1);

/* Set 3: Verify that the function throws exception for when customer exists and course package does not exist (Passing) */
CALL buy_course_package(1, 9999);

/* Set 4: Verify that the function throws exception for when the course package sale has already ended (Passing) */
CALL buy_course_package(1, 12);

/* Set 5: Verify that the function throws exception for when the course package sale has not started (Passing) */
CALL buy_course_package(1, 11);

/* Set 6: Verify that the function throws exception for when the customer already has an active/partially active package (Passing) */
CALL buy_course_package(1, 1);
CALL buy_course_package(1, 2);

/* Function (14) get_my_course_package (Siddarth) */

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

/* Function (19) update_course_session (Gerren) */

/* Function (20) cancel_registration (Kevin) */

/* Function (21) update_instructor (Fabian) */

/* Function (22) update_room (Siddarth) */

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

/* Function (27) top_packages (Gerren) */

/* Function (28) popular_courses (Kevin) */
    /* Course start date is within this year; has >= 2 offerings; for every pair of offerings, later offering has more people */

/* Function (29) view_summary_report (Fabian) */

/* Function (30) view_manager_report (Siddarth) */
