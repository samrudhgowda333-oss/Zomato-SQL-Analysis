--Step 1: Load and explore Data

CREATE TABLE zomato (
    Restaurant_ID NUMBER,
    Restaurant_Name VARCHAR2(255),
    Country_Code NUMBER,
    City VARCHAR2(100),
    Address VARCHAR2(500),
    Locality VARCHAR2(200),
    Locality_Verbose VARCHAR2(200),
    Longitude NUMBER,
    Latitude NUMBER,
    Cuisines VARCHAR2(500),
    Average_Cost_for_two NUMBER,
    Currency VARCHAR2(100),
    Has_Table_booking VARCHAR2(10),
    Has_Online_delivery VARCHAR2(10),
    Switch_to_order_menu Varchar2(20),
    Price_range NUMBER,
    Aggregate_rating NUMBER(3,2),
    Rating_color VARCHAR2(50),
    Rating_text VARCHAR2(50),
    Votes NUMBER
);

select * from zomato;

-- Focus on India only (Country_Code = 1)
-- Check rating distribution

SELECT Rating_text,
       COUNT(*) AS rating_count
FROM zomato
WHERE Country_Code = 1
GROUP BY Rating_text
ORDER BY rating_count DESC;

--Step 2: Analyse Queries
-- Q1: Which cities in India have the most restaurants?

SELECT * 
FROM
    (SELECT CITY,COUNT(*) AS total_restaurant
    FROM zomato
    WHERE country_code = 1
    GROUP BY city
    ORDER BY total_restaurant desc)
    WHERE ROWNUM <= 10;
    
-- Q2: Most popular cuisines in India

SELECT * 
FROM (
    SELECT cuisines, COUNT(*) AS total_cuisines,
    ROUND(AVG(aggregate_rating),2) AS avg_rating
    FROM zomato
    WHERE country_code = 1
    AND Cuisines IS NOT NULL
    GROUP BY Cuisines
    ORDER BY COUNT(*)DESC)
WHERE ROWNUM <= 10;

-- Q3: Online delivery adoption by city

SELECT *
FROM (
    SELECT city, COUNT(*) AS total,
    SUM(
        CASE 
            WHEN Has_Online_Delivery = 'Yes' THEN 1
            ELSE 0
        END
        ) AS With_Delivery,
        ROUND(
            100 * SUM(
                CASE 
                    WHEN Has_Online_Delivery = 'Yes' THEN 1
                    ELSE 0 
                END
            )/COUNT(*),
        1
    ) AS Delivery_PCT
FROM zomato 
WHERE country_code = 1
GROUP BY city
HAVING COUNT(*) > 50
ORDER BY 
    100 * 
        SUM(
            CASE WHEN Has_Online_Delivery = 'Yes'THEN 1
            ELSE 0
        END
    )/COUNT(*) DESC
)
WHERE ROWNUM <= 10;

-- Q4: Does table booking affect ratings?

SELECT Has_Table_booking,
       COUNT(*) AS restaurants,
       ROUND(AVG(Aggregate_rating), 2) AS avg_rating,
       ROUND(AVG(Votes), 0) AS avg_votes
FROM zomato
WHERE Country_Code = 1
  AND Aggregate_rating > 0
GROUP BY Has_Table_booking;


-- Q5: Price range vs average rating

SELECT
    CASE 
        WHEN Average_Cost_for_two < 300
            THEN 'low (under 300)'
        WHEN Average_Cost_for_two BETWEEN 300 AND 700
            THEN 'Mid (300 - 700)'
        WHEN Average_Cost_for_two BETWEEN 700 AND 1500
            THEN 'Premium (700 - 1500)'
        ELSE 'Fine Dining (1500+)'
    END AS price_category,
 
    COUNT(*) AS restaurant_count,
    ROUND(AVG(aggregate_rating),2) AS avg_rating,
    ROUND(AVG(votes),0) AS avg_votes

FROM zomato
WHERE country_code = 1
 AND aggregate_rating > 0
GROUP BY
    CASE 
        WHEN Average_Cost_for_two < 300
            THEN 'low (under 300)'
        WHEN Average_Cost_for_two BETWEEN 300 AND 700
            THEN 'Mid (300 - 700)'
        WHEN Average_Cost_for_two BETWEEN 700 AND 1500
            THEN 'Premium (700 - 1500)'
        ELSE 'Fine Dining (1500+)'
    END

ORDER BY AVG(aggregate_rating) DESC;

-- Q6: Best value restaurants with these criteria : high rating, low cost, high votes

SELECT *
FROM (
    SELECT Restaurant_Name,
           City,
           Cuisines,
           Average_Cost_for_two,
           Aggregate_rating,
           Votes
    FROM zomato
    WHERE Country_Code = 1
      AND Aggregate_rating >= 4.0
      AND Average_Cost_for_two <= 500
      AND Votes >= 200
    ORDER BY Aggregate_rating DESC,
             Votes DESC
)
WHERE ROWNUM <= 20;

-- Q7: Which city has the most Excellent rated restaurants?

SELECT *
FROM (
    SELECT City,
           COUNT(*) AS excellent_restaurants
    FROM zomato
    WHERE Country_Code = 1
      AND Rating_text = 'Excellent'
    GROUP BY City
    ORDER BY COUNT(*) DESC
)
WHERE ROWNUM <= 10;

-- Q8: Correlation — do more votes mean higher rating?

SELECT
    CASE
        WHEN Votes < 100
            THEN 'Low votes (under 100)'
        WHEN Votes BETWEEN 100 AND 500
            THEN 'Medium (100-500)'
        WHEN Votes BETWEEN 500 AND 2000
            THEN 'High (500-2000)'
        ELSE 'Very High (2000+)'
    END AS vote_category,

    COUNT(*) AS restaurants,
    ROUND(AVG(Aggregate_rating), 2) AS avg_rating

FROM zomato

WHERE Country_Code = 1
  AND Aggregate_rating > 0

GROUP BY
    CASE
        WHEN Votes < 100
            THEN 'Low votes (under 100)'
        WHEN Votes BETWEEN 100 AND 500
            THEN 'Medium (100-500)'
        WHEN Votes BETWEEN 500 AND 2000
            THEN 'High (500-2000)'
        ELSE 'Very High (2000+)'
    END

ORDER BY AVG(Aggregate_rating) DESC;

 
    