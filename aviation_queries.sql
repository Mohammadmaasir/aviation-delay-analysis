CREATE DATABASE aviation_analysis;
USE aviation_analysis;

CREATE TABLE airlines (
id INT,
Airline VARCHAR (10),
Flight INT,
AirportFrom VARCHAR (10),
AirportTo VARCHAR (10),
DayOfWeek INT,
Time INT,
Length INT,
Delay INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Airlines_small.csv'
INTO TABLE airlines
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT * FROM airlines LIMIT 10;

# Query 1: Total Flights:
SELECT COUNT(*) AS Total_Flights
FROM Airlines;

# Query 2: Total Delayed Flights
SELECT
  COUNT(*) AS Total_Flights,
  SUM(Delay) AS Total_Delayed,
  ROUND(SUM(Delay) * 100.0 / COUNT(*), 2) AS Delayed_rate_percent
FROM Airlines;

# Query 3: Delay Rate by Airline
SELECT Airline,
  COUNT(*) AS total_flights,
  SUM(Delay) AS delayed_flights,
  ROUND(SUM(Delay) * 100.0 / COUNT(*), 2) AS delay_rate_percent
FROM airlines
GROUP BY Airline
ORDER BY delay_rate_percent DESC;

# Query 4: Delay Rate by Day of Week
SELECT DayOfWeek,
	   COUNT(*) AS total_flights,
       SUM(Delay) AS delayed_flights,
       ROUND(SUM(Delay) * 100.0 / COUNT(*), 2) AS delay_rate_percent
FROM airlines
GROUP BY DayOfWeek
ORDER BY DayOfWeek DESC;

# Query 5: Delay Rate by Departure Airport (Min 500 flights)
SELECT AirportFrom,
       COUNT(*) AS total_flights,
       SUM(Delay) AS delayed_flights,
       ROUND(SUM(Delay) * 100.0 / COUNT(*), 2) AS delay_rate_percent
FROM Airlines
GROUP BY AirportFrom
HAVING COUNT(*) >= 500
ORDER BY delay_rate_percent DESC
LIMIT 10;

# Query 6: Delay Rate by Arrival Airport (Min 500 flights)
SELECT 
    AirportTo,
    COUNT(*) AS total_flights,
    SUM(Delay) AS delayed_flights,
    ROUND(SUM(Delay) * 100.0 / COUNT(*), 2) AS delay_rate_percent
FROM airlines
GROUP BY AirportTo
HAVING COUNT(*) >= 500
ORDER BY delay_rate_percent DESC
LIMIT 10;

# Query 7: Top 10 Busiest Routes
SELECT 
    CONCAT(AirportFrom, ' -> ', AirportTo) AS route,
    COUNT(*) AS total_flights,
    SUM(Delay) AS delayed_flights,
    ROUND(SUM(Delay) * 100.0 / COUNT(*), 2) AS delay_rate_percent
FROM airlines
GROUP BY AirportFrom, AirportTo
ORDER BY total_flights DESC
LIMIT 10;

# Query 8: Average Flight Length by Airline
SELECT Airline,
	   COUNT(*) AS Total_Flights,
       ROUND(AVG(LENGTH), 2) AS Avg_Flight_Length_Mins,
       ROUND(AVG(LENGTH)/60 , 2) AS Avg_Flight_Length_Hours
FROM Airlines
GROUP BY Airline
ORDER BY Avg_Flight_Length_Mins DESC;

# Query 9: Delay Rate by Flight Length Category
SELECT 
    CASE 
        WHEN Length < 60 THEN 'Short (Under 1 hr)'
        WHEN Length BETWEEN 60 AND 180 THEN 'Medium (1-3 hrs)'
        WHEN Length BETWEEN 181 AND 300 THEN 'Long (3-5 hrs)'
        ELSE 'Very Long (5+ hrs)'
    END AS flight_category,
    COUNT(*) AS total_flights,
    SUM(Delay) AS delayed_flights,
    ROUND(SUM(Delay) * 100.0 / COUNT(*), 2) AS delay_rate_percent
FROM airlines
GROUP BY flight_category
ORDER BY delay_rate_percent DESC;

# Query 10: Delay Rate by Time of Day
SELECT 
    CASE 
        WHEN Time < 360 THEN 'Early Morning (12AM-6AM)'
        WHEN Time BETWEEN 360 AND 719 THEN 'Morning (6AM-12PM)'
        WHEN Time BETWEEN 720 AND 1079 THEN 'Afternoon (12PM-6PM)'
        ELSE 'Evening/Night (6PM-12AM)'
    END AS time_of_day,
    COUNT(*) AS total_flights,
    SUM(Delay) AS delayed_flights,
    ROUND(SUM(Delay) * 100.0 / COUNT(*), 2) AS delay_rate_percent
FROM airlines
GROUP BY time_of_day
ORDER BY delay_rate_percent DESC;






