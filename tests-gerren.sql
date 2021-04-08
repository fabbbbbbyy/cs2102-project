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

/* Function (11) add_course_package (Gerren) */

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

/* Function (15) get_available_course_offerings (Gerren) */

/* Set 1: Verify that the function works in the normal case (Passing) */
SELECT * FROM get_available_course_offerings();

/* Set 2: Verify that the function gives accurate results when number of sessions registered increases (Insert own data, Passing) */
/* Set 3: Verify that the function gives accurate results when number of sessions registered decreases (Insert own data, Passing) */
/* Set 4: Verify that the function gives accurate results when number of sessions redeemed increases (Insert own data, Passing) */
/* Set 5: Verify that the function gives accurate results when number of sessions redeemed decreases (Insert own data, Passing) */
/* Set 6: Verify that the function gives accurate results when offerings have remaining seats which decreased 0 (Insert own data, Passing) */

/* Function (19) update_course_session (Gerren) */

/* Bugs:
ERROR:  This customer has not enough redemptions left in his package.
Number of redemptions seem to go down when course session is updated.
 */

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

/* Set 8: Verify that exception is thrown if new session does not have enough seating capacity to accomodate (Insert own data, Passing) */

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

/* Set 2: Verify that exception is thrown when removing an invalid session (Passing) */
CALL remove_session(3, '2021-03-01', 5);
CALL remove_session(3, '2021-04-01', 3);
CALL remove_session(4, '2021-03-01', 3);

/* Set 2: Verify that exception is thrown when removing a session that has at least one registration/redemption (Passing) */
CALL remove_session(1, '2021-06-01', 1);
CALL remove_session(10, '2021-06-01', 2);
CALL remove_session(2, '2021-07-01', 1);

/* Function (27) top_packages (Gerren) */

/* Set 1: Verify that the function works in the normal case (Passing) */
SELECT * FROM top_packages(1);
SELECT * FROM top_packages(2);
SELECT * FROM top_packages(3);
SELECT * FROM top_packages(4);
SELECT * FROM top_packages(5);
SELECT * FROM top_packages(50);
