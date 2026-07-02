/* ============================================================
   SQL Data Analysis Project
   Database: BraintreeChallenge
   Tables used: countries, continents, continent_map, per_capita
   Data coverage: years 2004 - 2012
   ============================================================ */

USE BraintreeChallenge
GO

/* ============================================================
   Question 1 (Easy)
   Show all countries (country_name) that belong to Europe (EU),
   with no duplicates.
   ============================================================ */

SELECT DISTINCT c.country_name
FROM countries c
JOIN continent_map cm ON c.country_code = cm.country_code
WHERE cm.continent_code = 'EU'
ORDER BY c.country_name;

/* ============================================================
   Question 2 (Easy)
   Show the highest gdp_per_capita ever recorded, along with the
   country and year it happened in.
   ============================================================ */

SELECT TOP 1
    c.country_name,
    p.year,
    p.gdp_per_capita
FROM per_capita p
JOIN countries c ON p.country_code = c.country_code
ORDER BY p.gdp_per_capita DESC;

/* ============================================================
   Question 3 (Easy)
   Calculate the average gdp_per_capita across all countries
   for the year 2015.

   NOTE: Data only covers 2004-2012, so this query is adjusted
   to use year 2012 instead.
   ============================================================ */

SELECT AVG(gdp_per_capita) AS average_gdp_2012
FROM per_capita
WHERE year = 2012;

/* ============================================================
   Question 4 (Medium)
   Show the count of countries in each continent, ordered from
   most to least.
   ============================================================ */

SELECT 
    continent_code,
    COUNT(DISTINCT country_code) AS country_count
FROM continent_map
GROUP BY continent_code
ORDER BY country_count DESC;

/* ============================================================
   Question 5 (Medium)
   Show the names of countries that have no gdp_per_capita data
   recorded at all (exist in "countries" but not in "per_capita").
   ============================================================ */

SELECT c.country_name
FROM countries c
LEFT JOIN per_capita p ON c.country_code = p.country_code
WHERE p.country_code IS NULL;

/* ============================================================
   Question 6 (Medium)
   Calculate the average gdp_per_capita per continent for year
   2012, and show only continents whose average is greater than
   20,000.
   ============================================================ */

SELECT 
    cm.continent_code,
    AVG(p.gdp_per_capita) AS avg_gdp
FROM per_capita p
JOIN continent_map cm ON p.country_code = cm.country_code
WHERE p.year = 2012
GROUP BY cm.continent_code
HAVING AVG(p.gdp_per_capita) > 20000
ORDER BY avg_gdp DESC;

/* ============================================================
   Question 7 (Above Average)
   For each continent, show the highest gdp_per_capita value
   recorded in year 2012.
   ============================================================ */

SELECT 
    cm.continent_code,
    MAX(p.gdp_per_capita) AS highest_gdp
FROM per_capita p
JOIN continent_map cm ON p.country_code = cm.country_code
WHERE p.year = 2012
GROUP BY cm.continent_code
ORDER BY highest_gdp DESC;

/* ============================================================
   Question 8 (Above Average)
   Calculate the percent change in average gdp_per_capita for
   Asia (AS) between 2010 and 2012.
   ============================================================ */

SELECT 
    (SELECT AVG(p.gdp_per_capita)
     FROM per_capita p
     JOIN continent_map cm ON p.country_code = cm.country_code
     WHERE cm.continent_code = 'AS' AND p.year = 2010) AS avg_2010,

    (SELECT AVG(p.gdp_per_capita)
     FROM per_capita p
     JOIN continent_map cm ON p.country_code = cm.country_code
     WHERE cm.continent_code = 'AS' AND p.year = 2012) AS avg_2012,

    (
      (SELECT AVG(p.gdp_per_capita)
       FROM per_capita p
       JOIN continent_map cm ON p.country_code = cm.country_code
       WHERE cm.continent_code = 'AS' AND p.year = 2012)
      -
      (SELECT AVG(p.gdp_per_capita)
       FROM per_capita p
       JOIN continent_map cm ON p.country_code = cm.country_code
       WHERE cm.continent_code = 'AS' AND p.year = 2010)
    )
    /
    NULLIF(
      (SELECT AVG(p.gdp_per_capita)
       FROM per_capita p
       JOIN continent_map cm ON p.country_code = cm.country_code
       WHERE cm.continent_code = 'AS' AND p.year = 2010), 0
    ) * 100 AS percent_change;

/* ============================================================
   Question 9 (Hard)
   Rank the countries in Africa (AF) by gdp_per_capita in 2012,
   from highest to lowest, showing the rank next to each country.
   ============================================================ */

SELECT 
    c.country_name,
    p.gdp_per_capita,
    RANK() OVER (ORDER BY p.gdp_per_capita DESC) AS rank_in_africa
FROM per_capita p
JOIN continent_map cm ON p.country_code = cm.country_code
JOIN countries c ON p.country_code = c.country_code
WHERE cm.continent_code = 'AF'
  AND p.year = 2012
ORDER BY rank_in_africa;

/* ============================================================
   Question 10 (Hard)
   Show the top 5 countries with the highest gdp_per_capita
   growth percentage between 2010 and 2012.
   ============================================================ */

SELECT TOP 5
    c.country_name,
    p2010.gdp_per_capita AS gdp_2010,
    p2012.gdp_per_capita AS gdp_2012,
    ROUND(
        ((p2012.gdp_per_capita - p2010.gdp_per_capita) / p2010.gdp_per_capita) * 100, 
        2
    ) AS growth_percent
FROM per_capita p2010
JOIN per_capita p2012 
    ON p2010.country_code = p2012.country_code
    AND p2010.year = 2010
    AND p2012.year = 2012
JOIN countries c ON p2010.country_code = c.country_code
WHERE p2010.gdp_per_capita > 0
ORDER BY growth_percent DESC;

