create database netflix_db
-- SCHEMAS of Netflix

use netflix_db
CREATE TABLE netflix_movie
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

SELECT * FROM netflix_movie


-- Netflix Data Analysis using SQL
-- Solutions of 11 business problems

-- 1. Count the number of Movies vs TV Shows

SELECT 
	type,
	COUNT(*)
FROM netflix_movie
GROUP BY 1

-- 2. Find the most common rating for movies and TV shows

SELECT type, rating, rating_count
FROM (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rnk
    FROM Netflix_movie
    GROUP BY type, rating
) AS sub
WHERE rnk = 1;
‘’’



-- 3. List all movies released in a specific year (e.g., 2021)

SELECT * 
FROM netflix_movie
WHERE release_year = 2021


-- 4. Find the top 5 countries with the most content on Netflix

SELECT new_country, COUNT(show_id) AS total_content
FROM (
    SELECT 
        SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', n.digit), ',', -1) AS new_country, 
        show_id
    FROM netflix_movie
    JOIN (
        SELECT 1 AS digit UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL 
        SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL 
        SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
    ) AS n 
    ON CHAR_LENGTH(country) - CHAR_LENGTH(REPLACE(country, ',', '')) >= n.digit - 1
) AS split_countries
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;



-- 5. Identify the longest movie


SELECT * 
FROM netflix_movie
WHERE type = 'Movie' 
AND duration = (SELECT MAX(duration) FROM netflix_movie WHERE type = 'Movie');




-- 6. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * 
from Netflix_movie
where director ='Daniel Espinosa'



-- 7. List all TV shows with more than 5 seasons

SELECT *, 
       CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) AS seasons
FROM Netflix_movie
WHERE type = 'TV Show' 
AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;

8. What are the top 5 years with the highest percentage of total Netflix releases in India?
SELECT 
    country, 
    release_year, 
    COUNT(show_id) AS total_release, 
    ROUND(
        COUNT(show_id) / NULLIF(
            (SELECT COUNT(show_id) FROM netflix_movie WHERE country = 'India'), 0
        ) * 100, 2
    ) AS avg_release
FROM netflix_movie 
WHERE country = 'India' 
GROUP BY country, release_year 
ORDER BY avg_release DESC 
LIMIT 5;









-- 9. List all movies that are documentaries
select * 
from netflix_movie 
where listed_in  like'%Documentaries%';




-- 10. Find all content without a director
SELECT * FROM netflix
WHERE director IS NULL


-- 11.	Find How Many Movies Actor ‘'%Ama Qamata, Khosi Ngema, Gail Mabalane, Thabang Molaba, Dillon Windvogel, Natasha Thahane, Arno Greeff, Xolile Tshabalala, Getmore Sithole, Cindy Mahlangu, Ryle De Morny, Greteli Fincham, Sello Maake Ka-Ncube, Odwa Gwanya, Mekaila Mathys, Sandi Schultz, Duane Williams, Shamilla Miller, Patrick Mofokeng’ Appeared in the last 10 years
SELECT* FROM netflix_movie 
 where casts 
like '%Ama Qamata, Khosi Ngema, Gail Mabalane, Thabang Molaba, Dillon Windvogel, Natasha Thahane, Arno Greeff, Xolile Tshabalala, Getmore Sithole, Cindy Mahlangu, Ryle De Morny, Greteli Fincham, Sello Maake Ka-Ncube, Odwa Gwanya, Mekaila Mathys, Sandi Schultz, Duane Williams, Shamilla Miller, Patrick Mofokeng%'  And release_year >
 extract(year from current_date)-10
