Create database Airline;
use Airline;

create table aircraft (
aircraft_id int primary key,
model varchar(250),
total_seats int 
);

insert into aircraft (aircraft_id,model,total_seats)
values (1,'Airbus A320',180),
(2,'Boeing 737',160);

create table flights (
flight_id int primary key,
aircraft_id int,
flight_number varchar(250),
departure_airport varchar(250),
arrival_airport varchar(250),
departure_time datetime,
arrival_time datetime,
FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id)
);

insert into flights 
values (101,1,'AI101', 'NAG','DEL','2025-01-15 09:00:00','2025-01-15 11:00:00'),
(102,2,'AI102','NAG','MUM','2025-01-15 14:00:00','2025-01-15 16:00:00');

create table passengers (
passenger_id int primary key,
name varchar(250),
email varchar(250),
passport_number varchar(250)
);

INSERT INTO passengers
Values (1,'Vishu Tiwari','vishu@gmail.com','P12345'),
(2,'Rahul Sharma', 'Rahul@gmail.com','P67890');

create table bookings (
booking_id int primary key,
flight_id int,
passenger_id int,
seat_number varchar(250),
booking_date date,
fare decimal,
FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id)
);

insert into bookings (booking_id, flight_id, passenger_id, seat_number, booking_date, fare)
values (1,101,1,'12A','2025-01-10',4500.00),
(2,101,2,'12B','2025-01-10',4500.00),
(3,102,1,'10A','2025-01-11',5000.00);

create table airports (
airport_code int primary key,
airport_name varchar(250),
city varchar(250)
);

INSERT INTO airports (airport_code, airport_name, city) VALUES
(1, 'Dr. Babasaheb Ambedkar International Airport', 'Nagpur'),
(2, 'Indira Gandhi International Airport', 'Delhi'),
(3, 'Chhatrapati Shivaji Maharaj International Airport', 'Mumbai');

-- List all passengers on a specific flight
SELECT p.passenger_id, p.name, p.email
FROM passengers p
JOIN bookings b ON p.passenger_id = b.passenger_id
WHERE b.flight_id = 101;

-- Calculate the occupancy rate (percentage of seats filled) for each flight
SELECT f.flight_id,
       COUNT(b.booking_id)*100.0 / a.total_seats AS occupancy_rate
FROM flights f
JOIN aircraft a ON f.aircraft_id = a.aircraft_id
LEFT JOIN bookings b ON f.flight_id = b.flight_id
GROUP BY f.flight_id, a.total_seats;

-- Find the most popular destination airport.
SELECT arrival_airport, COUNT(*) AS total_flights
FROM flights
GROUP BY arrival_airport
ORDER BY total_flights DESC
LIMIT 1;

-- Calculate the total revenue per flight
SELECT flight_id, SUM(fare) AS total_revenue
FROM bookings
GROUP BY flight_id;

-- Identify flights that are fully booked
SELECT f.flight_id
FROM flights f
JOIN aircraft a ON f.aircraft_id = a.aircraft_id
JOIN bookings b ON f.flight_id = b.flight_id
GROUP BY f.flight_id, a.total_seats
HAVING COUNT(b.booking_id) = a.total_seats;

-- Find passengers who have booked more than 5 flights
SELECT p.passenger_id, p.name, COUNT(b.booking_id) AS total_bookings
FROM passengers p
JOIN bookings b ON p.passenger_id = b.passenger_id
GROUP BY p.passenger_id, p.name
HAVING COUNT(b.booking_id) > 5;

-- List all flights departing from a specific city on a given day
SELECT f.flight_id,
       f.flight_number,
       f.departure_time
FROM flights f
JOIN airports a
  ON f.departure_airport = a.airport_code
WHERE a.city = 'Nagpur'
  AND DATE(f.departure_time) = '2025-01-15';
  
  -- Find the aircraft model used for the most flights
SELECT a.model, COUNT(f.flight_id) AS total_flights
FROM aircraft a
JOIN flights f ON a.aircraft_id = f.aircraft_id
GROUP BY a.model
ORDER BY total_flights DESC
LIMIT 1;

-- Calculate the average fare paid per route
SELECT f.departure_airport,
       f.arrival_airport,
       AVG(b.fare) AS avg_fare
FROM flights f
JOIN bookings b ON f.flight_id = b.flight_id
GROUP BY f.departure_airport, f.arrival_airport;

-- Identify flights with low occupancy (< 50%)
SELECT f.flight_id,
       COUNT(b.booking_id)*100.0 / a.total_seats AS occupancy_rate
FROM flights f
JOIN aircraft a ON f.aircraft_id = a.aircraft_id
LEFT JOIN bookings b ON f.flight_id = b.flight_id
GROUP BY f.flight_id, a.total_seats
HAVING COUNT(b.booking_id)*100.0 / a.total_seats < 50;






