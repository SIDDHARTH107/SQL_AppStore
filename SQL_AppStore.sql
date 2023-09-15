--Connect to the Dataset

CREATE TABLE applestore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

--As SQL Lite has the limit that it can handle files upto 4mb so we divided our original dataset 
--4 different datasets having size less than 4mb
--Now in editor we combined all the datasets using UNION ALL method 
--so that we can start our tasksAppleStore

--Indentify the StakeHolder
--So, in our case our stakeholder is an aspiring app developer who needs data driven insights 
--decide what type of app to build.
--So, they are seeking answers regarding that.AppleStore

--Exploratory Data Analysis

--1. Check the number of unique apps in both tables AppleStore
SELECT COUNT(DISTINCT id) AS UniqueAppIds
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIds
FROM applestore_description_combined

--Check any missing values in key fields
SELECT COUNt(*) AS MissingValues
FROM AppleStore
WHERE track_name IS NULL OR
      user_rating IS NULL OR
      prime_genre IS Null
      
SELECT COUNt(*) AS MissingValues
FROM applestore_description_combined
WHERE app_desc IS NULL

--Find out the number of apps per genre
SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

--Get an overview of Apps Ratings
SELECT MIN(user_rating) AS minrating,
       MAX(user_rating) AS maxrating,
       AVG(user_rating) AS avgrating
FROM AppleStore

--Finding insights for our Stakeholder
**Data Analysis**
--Determine whether paid apps have higher ratings than free apps
SELECT CASE
           WHEN price > 0 THEN 'Paid'
           ELSE 'Free'
       END AS App_Type,
       avg(user_rating) AS Avg_Ratig
FROM AppleStore
GROUP BY App_Type

--Check if apps with more supported languages have higher ratings
SELECT CASE
           WHEN lang_num < 10 THEN '<10 languages'
           WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
           ELSE '>30 languages'
       END AS language_bucket,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP By language_bucket
ORDER BY Avg_Rating DESC

--Check genres with low ratings
SELECT prime_genre,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating ASC
LIMIT 10

--Check if there is any correlation between the length of the app description and the user rating 
SELECT CASE
           WHEN length(b.app_desc) < 500 THEN 'Short'
           WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
           ELSE 'Long'
       END AS description_length_bucket,
       avg(a.user_rating) AS average_rating
FROM AppleStore AS A
JOIN applestore_description_combined AS B
ON A.id = B.id
GROUP BY description_length_bucket
ORDER BY average_rating DESC

--Check the top rated apps for each genre
SELECT prime_genre,
       track_name,
       user_rating
FROM (
      SELECT 
      prime_genre,
      track_name,
      user_rating,
      RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
      FROM AppleStore
     ) AS a
WHERE
a.rank = 1