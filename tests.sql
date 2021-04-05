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

/* Function (12) get_available_course_packages (Kevin) */

/* Set 1: Verify that the function works if the current date is the same as the end date of a course package (insert own data) (Passing) */
/* Set 2: Verify that the function works if the current date is the same as the start date of a course package (insert own data) (Passing) */
/* Set 3: Verify that the function works in the normal case (Passing) */
/* Set 4: Verify that the function excludes course packages which have later start dates than the current date (insert own data) (Passing) */
/* Set 5: Verify that the function excludes course packages which have earlier end dates than the current date (insert own data) (Passing) */
SELECT get_available_course_packages();

/* Function (16) get_available_course_sessions (Kevin) */

/* Set 1: Verify that the function works in the normal case (Passing) */
SELECT get_available_course_sessions(10, '2021-06-01');

/* Set 2: Verify that the function excludes sessions with no seats left (insert own data) (Passing) */
SELECT get_available_course_sessions(10, '2021-06-01');

/* Set 3: Verify that the function excludes sessions which have dates earlier than the current date (Passing) */
SELECT get_available_course_sessions(1, '2021-01-01');

/* Function (20) cancel_registration (Kevin) */

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

/* Function (28) popular_courses (Kevin) */
    /* Course start date is within this year; has >= 2 offerings; for every pair of offerings, later offering has more people */
