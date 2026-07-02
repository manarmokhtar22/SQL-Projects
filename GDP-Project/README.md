# SQL Data Analysis Project — Countries & GDP per Capita

A SQL portfolio project analyzing global GDP per capita data across countries and continents, using **Microsoft SQL Server (SSMS)**.

## About the Data
- **Tables used:** `countries`, `continents`, `continent_map`, `per_capita`
- **Years covered:** 2004 – 2012
- **Source:** World Bank–style GDP per capita dataset

> **Note:** This dataset structure is based on a public SQL interview challenge (Braintree Data Analyst challenge). The questions and all SQL solutions below are my own original work.

## How to Run This Project
1. This project assumes a database (`BraintreeChallenge`) with the four tables described above — `countries`, `continents`, `continent_map`, and `per_capita` — based on the Braintree Data Analyst interview dataset. No schema file is included in this repo; you'll need a database with matching table structure and data to run the queries.
2. Open `SQL_Project_Questions.sql` in SQL Server Management Studio (SSMS).
3. Run each query individually to see the results.

## Tools Used
- Microsoft SQL Server Management Studio (SSMS)
- T-SQL (JOINs, GROUP BY, HAVING, Subqueries, Window Functions)

## Skills Demonstrated
- Table joins across multiple related tables
- Aggregate functions (`COUNT`, `AVG`, `MAX`, `SUM`)
- Filtering with `WHERE` and `HAVING`
- Subqueries and correlated subqueries
- Window functions (`RANK() OVER`)
- Self joins for year-over-year comparisons
- Handling missing/NULL data with `LEFT JOIN`

---

## Questions & Results

### 1. All countries in Europe (EU)
```sql
SELECT DISTINCT c.country_name
FROM countries c
JOIN continent_map cm ON c.country_code = cm.country_code
WHERE cm.continent_code = 'EU'
ORDER BY c.country_name;
```
**Result:** 51 European countries returned, from Albania to United Kingdom.

---

### 2. Highest gdp_per_capita ever recorded
```sql
SELECT TOP 1
    c.country_name,
    p.year,
    p.gdp_per_capita
FROM per_capita p
JOIN countries c ON p.country_code = c.country_code
ORDER BY p.gdp_per_capita DESC;
```
**Result:** **Monaco**, in **2008**, with a gdp_per_capita of **193,892.33**.

---

### 3. Average gdp_per_capita across all countries (2012)
```sql
SELECT AVG(gdp_per_capita) AS average_gdp_2012
FROM per_capita
WHERE year = 2012;
```
**Result:** Average gdp_per_capita for 2012 = **14,005.94**.

---

### 4. Count of countries per continent
```sql
SELECT 
    continent_code,
    COUNT(DISTINCT country_code) AS country_count
FROM continent_map
GROUP BY continent_code
ORDER BY country_count DESC;
```
**Result:**
| Continent | Country Count |
|---|---|
| AF (Africa) | 59 |
| EU (Europe) | 57 |
| AS (Asia) | 55 |
| NA (North America) | 43 |
| OC (Oceania) | 26 |
| SA (South America) | 14 |
| AN (Antarctica) | 5 |

---

### 5. Countries with no gdp_per_capita data recorded
```sql
SELECT c.country_name
FROM countries c
LEFT JOIN per_capita p ON c.country_code = p.country_code
WHERE p.country_code IS NULL;
```
**Result:** 21 rows returned, mostly regional groupings and territories (e.g. "East Asia and the Pacific (IFC classification)", Korea Dem. Rep., Somalia, Myanmar, "Not classified"). Highlights a data-quality issue where some non-country entities exist in the `countries` table.

---

### 6. Continents with average gdp_per_capita > 20,000 (2012)
```sql
SELECT 
    cm.continent_code,
    AVG(p.gdp_per_capita) AS avg_gdp
FROM per_capita p
JOIN continent_map cm ON p.country_code = cm.country_code
WHERE p.year = 2012
GROUP BY cm.continent_code
HAVING AVG(p.gdp_per_capita) > 20000
ORDER BY avg_gdp DESC;
```
**Result:** Only **Europe (EU)** qualified, with an average gdp_per_capita of **26,283.41**.

---

### 7. Highest gdp_per_capita per continent (2012)
```sql
SELECT 
    cm.continent_code,
    MAX(p.gdp_per_capita) AS highest_gdp
FROM per_capita p
JOIN continent_map cm ON p.country_code = cm.country_code
WHERE p.year = 2012
GROUP BY cm.continent_code
ORDER BY highest_gdp DESC;
```
**Result:**
| Continent | Highest GDP |
|---|---|
| EU | 103,858.02 |
| AS | 93,825.30 |
| NA | 84,460.33 |
| OC | 67,441.59 |
| AF | 24,035.71 |
| SA | 15,452.17 |

---

### 8. Percent change in Asia's average gdp_per_capita (2010 → 2012)
```sql
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
```
**Result:**
| Year | Average GDP |
|---|---|
| 2010 | 12,981.53 |
| 2012 | 15,852.38 |

**Percent change: +22.11%**

---

### 9. Ranking African countries by gdp_per_capita (2012)
```sql
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
```
**Result (top 5):**
| Rank | Country | GDP per Capita |
|---|---|---|
| 1 | Equatorial Guinea | 24,035.71 |
| 2 | Seychelles | 12,782.73 |
| 3 | Gabon | 11,256.52 |
| 4 | Mauritius | 8,119.55 |
| 5 | South Africa | 7,351.76 |

Countries with no recorded data (e.g. Djibouti, Libya) tied at the lowest rank with `NULL` values, demonstrating how `RANK()` handles ties.

---

### 10. Top 5 countries by gdp_per_capita growth (2010 → 2012)
```sql
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
```
**Result:**
| Rank | Country | 2010 | 2012 | Growth % |
|---|---|---|---|---|
| 1 | Mongolia | 2,285.65 | 3,672.97 | 60.7% |
| 2 | Papua New Guinea | 1,382.14 | 2,184.16 | 58.03% |
| 3 | Turkmenistan | 4,392.72 | 6,797.73 | 54.75% |
| 4 | Ethiopia | 301.84 | 454.80 | 50.67% |
| 5 | Macao SAR, China | 53,045.88 | 78,275.15 | 47.56% |

---

## Key Insights
- Europe (EU) had the highest average gdp_per_capita in 2012 (26,283.41), well above every other continent.
- Monaco recorded the highest single gdp_per_capita value ever in the dataset — 193,892.33 in 2008.
- Asia's average gdp_per_capita grew by 22.11% between 2010 and 2012, showing strong regional economic growth.
- Mongolia had the fastest gdp_per_capita growth of any country between 2010–2012, at 60.7%.
- Several country entries (e.g. "Not classified", regional groupings) had no recorded gdp_per_capita data, highlighting a data-quality issue worth flagging in real-world analysis.

## Files in this Repository
- `SQL_Project_Questions.sql` — all 10 questions with their SQL queries
- `README.md` — this file, with results and explanations
