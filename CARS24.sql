-- SELECT THE DATABASE
USE USED_CARS_MARKET_ANALYSIS;
-----------------------------------------------------------------------

-- FETCH TABLE
SELECT * FROM CARS;

-----------------------------------------------------------------------

-- ALTER COLUMN NAME
ALTER TABLE CARS
RENAME COLUMN ï»¿Manufacturer TO Manufacturer;

-----------------------------------------------------------------------

-- REMOVE UNNECESSERY COLUMNS 

ALTER TABLE CARS
DROP COLUMN price,
DROP COLUMN details,
DROP COLUMN engine_capacity;

-----------------------------------------------------------------------

-- UPDATE SOME INCORRECT VARIENT NAMES

SET SQL_SAFE_UPDATES = 0;

UPDATE CARS
SET VARIENT = 'Micra'
WHERE VARIENT = 'March';

UPDATE CARS 
SET VARIENT = 'H-1'
WHERE VARIENT = 'H-';

UPDATE CARS
SET VARIENT = '2 Series'
WHERE VARIENT = 'Â 2 Series';


UPDATE CARS
SET VARIENT = 'XM'
WHERE VARIENT = 'XMÂ ';

-----------------------------------------------------------------------

-- CHECK EMPTY DATA 
SELECT * FROM CARS
WHERE  INDIA_LOCATIONS = '';

SELECT * FROM CARS
WHERE  VARIENT = '';

-- UPDATE EMPTY DATA
UPDATE CARS
SET VARIENT = 'Other'
WHERE VARIENT = ''; 

SELECT * FROM CARS
WHERE  MANUFACTURER = '';

SELECT * FROM CARS
WHERE  Model = '';

SELECT * FROM CARS
WHERE  NPRICE = '';

SELECT * FROM CARS
WHERE  TRANSMISSION = '';

SELECT * FROM CARS
WHERE  FUEL_TYPE = '';

SELECT * FROM CARS
WHERE  Distance_Travelled = '';

-----------------------------------------------------------------------

-- CHECK NULL VALUES
SELECT 
    SUM(CASE
        WHEN MANUFACTURER IS NULL THEN 1
        ELSE 0
    END) AS MANUFACTURER_NULL_COUNT,
    SUM(CASE
        WHEN VARIENT IS NULL THEN 1
        ELSE 0
    END) AS VARIENT_NULL_COUNT,
    SUM(CASE
        WHEN MODEL IS NULL THEN 1
        ELSE 0
    END) AS MODEL_NULL_COUNT,
    SUM(CASE
        WHEN India_Locations IS NULL THEN 1
        ELSE 0
    END) AS LOCATIONS_NULL_COUNT,
    SUM(CASE
        WHEN FUEL_TYPE IS NULL THEN 1
        ELSE 0
    END) AS FUEL_TYPE_NULL_COUNT,
    SUM(CASE
        WHEN TRANSMISSION IS NULL THEN 1
        ELSE 0
    END) AS TRANSMISSION_NULL_COUNT,
    SUM(CASE
        WHEN NPRICE IS NULL THEN 1
        ELSE 0
    END) AS NPRICE_NULL_COUNT
FROM
    CARS;

---------------------------------------------------------------------------------------------------------

-- TOTAL COUNT OF MANUFACTURER
SELECT 
    COUNT(DISTINCT MANUFACTURER) AS TOTAL_MANUFACTURER_COUNT
FROM
    CARS;

---------------------------------------------------------------------------------------------------------

-- TOTAL COUNT OF CARS BY MANUFACTURER AND PERCENTAGE CONTRIBUTION 
SELECT 
    MANUFACTURER,
    COUNT(MANUFACTURER) AS CARS_COUNT_BY_MANUFACTURER,
    ROUND(COUNT(*) / (SELECT 
                    COUNT(*)
                FROM
                    cars) * 100,
            2) AS PERCENTAGE
FROM
    CARS
GROUP BY MANUFACTURER
ORDER BY CARS_COUNT_BY_MANUFACTURER DESC;

---------------------------------------------------------------------------------------------------------

 -- TOTAL COUNT OF VARIENTS BY MANUFACTURER 
SELECT 
    MANUFACTURER,
    COUNT(DISTINCT VARIENT) AS TOTAL_VARIENT_OF_EACH_MFG
FROM
    CARS
GROUP BY MANUFACTURER
ORDER BY TOTAL_VARIENT_OF_EACH_MFG DESC;

---------------------------------------------------------------------------------------------------------

-- TOTAL COUNT OF CARS LOCATIION WISE AND PERCENTAGE 
SELECT 
    INDIA_LOCATIONS,
    COUNT(MANUFACTURER) AS CARS_COUNT_BY_LOCATION,
    (COUNT(*) / (SELECT 
            COUNT(*)
        FROM
            CARS)) * 100 AS PERCENTAGE
FROM
    CARS
GROUP BY INDIA_LOCATIONS
ORDER BY CARS_COUNT_BY_LOCATION DESC;

---------------------------------------------------------------------------------------------------------

-- TOTAL SALES BY LOCATION AND PERCENTAGE CONTIBUTION
SELECT 
    INDIA_LOCATIONS,
    SUM(ROUND(NPRICE, 2)) AS SALES_BY_LOCATION,
    (SUM(nprice) / (SELECT 
            SUM(nprice)
        FROM
            cars)) * 100 AS percentage_contribution
FROM
    CARS
GROUP BY INDIA_LOCATIONS
ORDER BY SALES_BY_LOCATION DESC;

---------------------------------------------------------------------------------------------------------

-- TOTAL SALES BY MANUFACTURER AND PERCENTAGE CONTIBUTION
SELECT 
    MANUFACTURER,
    SUM(ROUND(NPRICE, 2)) AS SALES_BY_MANUFACTURER,
    ROUND((SUM(Nprice) / (SELECT 
                    SUM(Nprice)
                FROM
                    cars)) * 100,
            2) AS percentage_contribution_Manufacturer
FROM
    CARS
GROUP BY MANUFACTURER
ORDER BY SALES_BY_MANUFACTURER DESC;

---------------------------------------------------------------------------------------------------------

-- TOTAL SALES BY MODEL
SELECT 
    MODEL, SUM(ROUND(NPRICE, 2)) AS SALES_BY_MANUFACTURER
FROM
    CARS
GROUP BY MODEL
ORDER BY SALES_BY_MANUFACTURER DESC;

---------------------------------------------------------------------------------------------------------

-- VARIANT WITH THE HIGHEST SALES FOR EACH MANUFACTURER
SELECT 
    MANUFACTURER,
    VARIENT,
    NPRICE
FROM (
    SELECT 
        MANUFACTURER,
        VARIENT,
        NPRICE,
        DENSE_RANK() OVER (PARTITION BY MANUFACTURER ORDER BY NPRICE DESC) AS RANKS,
		ROW_NUMBER() OVER (PARTITION BY MANUFACTURER ORDER BY NPRICE DESC) AS ROW_NUM
    FROM 
        CARS
) RANKED
WHERE ROW_NUM = 1;

---------------------------------------------------------------------------------------------------------

-- Most Popular Fuel Type
SELECT 
    FUEL_TYPE,
    COUNT(*) AS cars_count,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM CARS), 2) AS percentage
FROM 
    CARS
GROUP BY 
    FUEL_TYPE
ORDER BY 
    cars_count DESC;

---------------------------------------------------------------------------------------------------------

-- Transmission Type Analysis
SELECT 
    TRANSMISSION,
    COUNT(*) AS cars_count,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM CARS), 2) AS percentage
FROM 
    CARS
GROUP BY 
    TRANSMISSION
ORDER BY 
    cars_count DESC;

---------------------------------------------------------------------------------------------------------

-- Correlation Between Distance Traveled and Price
SELECT 
    DISTANCE_TRAVELLED,
    AVG(NPRICE) AS avg_price
FROM 
    CARS
GROUP BY 
    DISTANCE_TRAVELLED
ORDER BY 
    DISTANCE_TRAVELLED ASC;

---------------------------------------------------------------------------------------------------------

-- High-Performing Locations by Revenue and Car Types

SELECT 
    INDIA_LOCATIONS,
    MODEL,
    SUM(NPRICE) AS total_revenue
FROM 
    CARS
GROUP BY 
    INDIA_LOCATIONS, MODEL
ORDER BY 
    total_revenue DESC;

---------------------------------------------------------------------------------------------------------

-- Manufacturer-Wise Distance Insights
SELECT 
    MANUFACTURER,
    MIN(DISTANCE_TRAVELLED) AS min_distance,
    AVG(DISTANCE_TRAVELLED) AS avg_distance,
    MAX(DISTANCE_TRAVELLED) AS max_distance
FROM 
    CARS
GROUP BY 
    MANUFACTURER
ORDER BY 
    avg_distance DESC;

---------------------------------------------------------------------------------------------------------

-- AVERAGE PRICE BASED ON MODEL

-- Find the average price based on model
SELECT 
    MODEL,
    AVG(NPRICE) AS AVERAGE_PRICE
FROM 
    CARS
GROUP BY 
    MODEL
ORDER BY 
    AVERAGE_PRICE DESC;


-- Calculate average price by car make and model
SELECT 
    MANUFACTURER,
    MODEL,
    AVG(NPRICE) AS AVERAGE_PRICE
FROM 
    CARS
GROUP BY 
    MANUFACTURER, 
    MODEL
ORDER BY 
    AVERAGE_PRICE DESC;




-- Count the number of cars based on year of manufacture
SELECT 
    MODEL,
    COUNT(*) AS CAR_COUNT
FROM 
    CARS
GROUP BY 
    MODEL
ORDER BY 
    CAR_COUNT DESC;



-- Calculate maximum distance travelled by each car make and model
SELECT 
    MANUFACTURER,
    MODEL,
    MAX(DISTANCE_TRAVELLED) AS MAX_DISTANCE_TRAVELLED
FROM 
    CARS
GROUP BY 
    MANUFACTURER, 
    MODEL
ORDER BY 
    MAX_DISTANCE_TRAVELLED DESC;

-- Count the number of cars for each manufacturer
SELECT 
    MANUFACTURER, 
    COUNT(*) AS CAR_COUNT
FROM 
    CARS
GROUP BY 
    MANUFACTURER
ORDER BY 
    CAR_COUNT DESC;

-- Count occurrences of each car make and model combination
SELECT 
    MANUFACTURER, 
    MODEL, 
    COUNT(*) AS OCCURRENCE_COUNT
FROM 
    CARS
GROUP BY 
    MANUFACTURER, 
    MODEL
ORDER BY 
    OCCURRENCE_COUNT DESC;

-- Calculate average, minimum, and maximum prices by year of manufacture
SELECT 
    MODEL,
    AVG(NPRICE) AS AVERAGE_PRICE, 
    MIN(NPRICE) AS MIN_PRICE, 
    MAX(NPRICE) AS MAX_PRICE
FROM 
    CARS
GROUP BY 
    MODEL
ORDER BY 
    MODEL ASC;
    
-- Analyze regional variations by calculating average price by location
SELECT 
    INDIA_LOCATIONS, 
    AVG(NPRICE) AS AVERAGE_PRICE, 
    MIN(NPRICE) AS MIN_PRICE, 
    MAX(NPRICE) AS MAX_PRICE, 
    COUNT(*) AS TOTAL_CARS
FROM 
    CARS
GROUP BY 
    INDIA_LOCATIONS
ORDER BY 
    AVERAGE_PRICE DESC;

