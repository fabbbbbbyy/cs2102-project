insert into Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date) values('CS2030', 1, 3.50, '2021-03-24', '2021-04-24');
insert into Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date) values('CS2040', 2, 10.0, '2021-03-24', '2021-05-24');
insert into Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date) values('CS2106', 3, 0.0, '2021-03-24', '2021-06-24');
insert into Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date) values('CS1101S', 4, 20.0, '2021-03-24', '2021-07-24');
insert into Course_Packages(name, num_free_registrations, price, sale_start_date, sale_end_date) values('CS2103T', 5, 30.0, '2021-03-24', '2021-08-24');

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

insert into Employees(address, depart_date, email, join_date, name, phone) values('Mountain Boulevard', null, 'emily@gmail.com', '2005-05-17', 'Emily', '67892345');
insert into Employees(address, depart_date, email, join_date, name, phone) values('Jungle Swamp', '2021-01-01', 'brian@live.com', '2013-08-09', 'Brian', '88112233');
insert into Employees(address, depart_date, email, join_date, name, phone) values('Mountain Hill', null, 'mabel@gmail.com', '2014-12-25', 'Mabel', '65689231');
insert into Employees(address, depart_date, email, join_date, name, phone) values('Swamp Jungle', '2010-11-11', 'abel@live.com', '2000-02-06', 'Abel', '88456781');
insert into Employees(address, depart_date, email, join_date, name, phone) values('Mountain View', null, 'chris@yahoo.com', '2020-03-04', 'Chris', '89672345');