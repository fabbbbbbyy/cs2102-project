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
call add_course_package('Summer Special', 10, 40.55, '2021-05-05', '2021-07-05');
call add_course_package('Winter Special', 14, 60.00, '2021-05-05', '2021-07-05');
call add_course_package('Spring Special', 20, 99.90, '2021-06-05', '2021-07-05');
call add_course_package('Autumn Special', 10, 27.00, '2021-06-05', '2021-07-05');
call add_course_package('New Year Special', 5, 31.90, '2021-06-05', '2021-07-05');

/* Set 2: Verify that constraint prevents invalid date ranges (Passing) */
call add_course_package('Summer Special', 10, 40.55, '2021-05-05', '2021-04-05');
call add_course_package('Summer Special', 10, 40.55, '2021-05-05', '2021-05-04');

/* Set 3: Verify that constraint prevents invalid prices (Passing) */
call add_course_package('Summer Special', 10, -300, '2021-05-05', '2021-07-05');
call add_course_package('Summer Special', 10, -1.20, '2021-05-05', '2021-07-05');

/* Set 4: Verify that constraint prevents invalid number of free registrations (Passing) */
call add_course_package('Summer Special', 0, 40.55, '2021-05-05', '2021-07-05');
call add_course_package('Summer Special', -2, 40.55, '2021-05-05', '2021-07-05');
call add_course_package('Summer Special', 2.5, 40.55, '2021-05-05', '2021-07-05');

/* Function (15) get_available_course_offerings (Gerren) */

/* Set 1: (Passing) */

/* Set 2: (Passing) */
/* Set 3: (Passing) */
/* Set 4: (Passing) */
/* Set 5: (Passing) */

/* Function (19) update_course_session (Gerren) */
/* Set 1: (Passing) */
/* Set 2: (Passing) */
/* Set 3: (Passing) */
/* Set 4: (Passing) */
/* Set 5: (Passing) */

/* Function (23) remove_session (Gerren) */
/* Set 1: (Passing) */
/* Set 2: (Passing) */
/* Set 3: (Passing) */
/* Set 4: (Passing) */
/* Set 5: (Passing) */

/* Function (27) top_packages (Gerren) */
/* Set 1: (Passing) */
/* Set 2: (Passing) */
/* Set 3: (Passing) */
/* Set 4: (Passing) */
/* Set 5: (Passing) */


