--Looking at average renewable energy usage by continent from 2000-2018

SELECT Continent, AVG(percent_renewable) AS avg_renewable
FROM P2.dbo.sustain
WHERE Continent IS NOT NULL
GROUP BY Continent
ORDER BY avg_renewable DESC

--Africa averages the most renewable energy across the time period for this data. Query to look at low income country count vs high income

SELECT COUNT(DISTINCT(Country_Name))
FROM P2.dbo.sustain
WHERE Continent = 'Africa' AND income_classification = 'Low income'

SELECT COUNT(DISTINCT(Country_Name))
FROM P2.dbo.sustain
WHERE Continent = 'Africa' AND income_classification = 'High income'

--Must make distinction between high and low income countries

SELECT Continent, AVG(percent_renewable) AS avg_renewable
FROM P2.dbo.sustain
WHERE Continent IS NOT NULL
AND income_classification = 'High income'
GROUP BY Continent
ORDER BY avg_renewable DESC

--Grouping countries based on amount of renewable energy usage

SELECT Country_Name, Year, percent_renewable, income_classification,
CASE
	WHEN percent_renewable BETWEEN 0 AND 19.99 THEN 'Lower'
	WHEN percent_renewable BETWEEN 20 AND 39.99 THEN 'Mid'
	WHEN percent_renewable >= 40 THEN 'Upper' END AS grouping
FROM P2.dbo.sustain
WHERE income_classification = 'High income' AND Year = 2000
ORDER BY percent_renewable DESC

SELECT Country_Name, Year, percent_renewable, income_classification,
CASE
	WHEN percent_renewable BETWEEN 0 AND 19.99 THEN 'Lower'
	WHEN percent_renewable BETWEEN 20 AND 39.99 THEN 'Mid'
	WHEN percent_renewable >= 40 THEN 'Upper' END AS grouping
FROM P2.dbo.sustain
WHERE income_classification = 'High income' AND Year = 2018
ORDER BY percent_renewable DESC

--Counting by categorical groups

SELECT
COUNT(CASE WHEN percent_renewable BETWEEN 0 AND 19.99 THEN 'Lower' END) AS lower_count,
COUNT (CASE WHEN percent_renewable BETWEEN 20 AND 39.99 THEN 'Mid' END) AS mid_count,
COUNT (CASE WHEN percent_renewable >= 40 THEN 'Upper' END) AS upper_count
FROM P2.dbo.sustain
WHERE income_classification = 'High income' AND Year = 2000

SELECT
COUNT(CASE WHEN percent_renewable BETWEEN 0 AND 19.99 THEN 'Lower' END) AS lower_count,
COUNT (CASE WHEN percent_renewable BETWEEN 20 AND 39.99 THEN 'Mid' END) AS mid_count,
COUNT (CASE WHEN percent_renewable >= 40 THEN 'Upper' END) AS upper_count
FROM P2.dbo.sustain
WHERE income_classification = 'High income' AND Year = 2018

--Finding the highest renewable energy usage percent in 2000 then in 2018, among high income countries

SELECT Country_Name, Year, percent_renewable
FROM P2.dbo.sustain
WHERE income_classification = 'High income'
AND Year = 2000
ORDER BY percent_renewable DESC

SELECT Country_Name, Year, percent_renewable
FROM P2.dbo.sustain
WHERE income_classification = 'High income'
AND Year = 2018
ORDER BY percent_renewable DESC

--Finding number of countries with higher percent renewable energy usage than United States in 2000 and 2018

SELECT COUNT(*)
FROM P2.dbo.sustain
WHERE income_classification = 'High income'
AND Year = 2000
AND percent_renewable > (
						SELECT percent_renewable
						FROM P2.dbo.sustain
						WHERE Year = 2000 AND Country_Name = 'United States')

SELECT COUNT(*)
FROM P2.dbo.sustain
WHERE income_classification = 'High income'
AND Year = 2018
AND percent_renewable > (
						SELECT percent_renewable
						FROM P2.dbo.sustain
						WHERE Year = 2018 AND Country_Name = 'United States')

--Query to compare Iceland's performance with just G7 nations in 2000 and 2018

SELECT Country_Name, Year, percent_renewable
FROM P2.dbo.sustain
WHERE (Country_Name = 'Iceland' OR Country_Name = 'United States' OR Country_Name = 'United Kingdom' OR Country_Name = 'Japan' OR Country_Name = 'Italy' OR Country_Name = 'France' OR Country_Name = 'Germany' OR Country_Name = 'Canada')
AND Year = 2000
ORDER BY percent_renewable DESC

SELECT Country_Name, Year, percent_renewable
FROM P2.dbo.sustain
WHERE (Country_Name = 'Iceland' OR Country_Name = 'United States' OR Country_Name = 'United Kingdom' OR Country_Name = 'Japan' OR Country_Name = 'Italy' OR Country_Name = 'France' OR Country_Name = 'Germany' OR Country_Name = 'Canada')
AND Year = 2018
ORDER BY percent_renewable DESC

--Finding the difference in percent renewable energy usage for high income countries from 2018 and 2000

WITH R_2018 AS (
SELECT Country_Name, percent_renewable, Continent
FROM P2.dbo.sustain
WHERE Year = '2018'
AND income_classification = 'High income'),

R_2000 AS (
SELECT Country_Name, percent_renewable, Continent
FROM P2.dbo.sustain
WHERE Year = '2000'
AND income_classification = 'High income')

SELECT R_2000.Country_Name, R_2018.percent_renewable - R_2000.percent_renewable AS change_in_renewable, R_2000.Continent
FROM R_2000
JOIN R_2018
ON R_2000.Country_Name = R_2018.Country_Name
ORDER BY change_in_renewable DESC

--Repeated but just for G7 nations with Iceland for comparison

WITH R_2018 AS (
SELECT Country_Name, percent_renewable, Continent
FROM P2.dbo.sustain
WHERE (Country_Name = 'Iceland' OR Country_Name = 'United States' OR Country_Name = 'United Kingdom' OR Country_Name = 'Japan' OR Country_Name = 'Italy' OR Country_Name = 'France' OR Country_Name = 'Germany' OR Country_Name = 'Canada')
AND Year = 2018),

R_2000 AS (
SELECT Country_Name, percent_renewable, Continent
FROM P2.dbo.sustain
WHERE (Country_Name = 'Iceland' OR Country_Name = 'United States' OR Country_Name = 'United Kingdom' OR Country_Name = 'Japan' OR Country_Name = 'Italy' OR Country_Name = 'France' OR Country_Name = 'Germany' OR Country_Name = 'Canada')
AND Year = 2000)

SELECT R_2000.Country_Name, R_2018.percent_renewable - R_2000.percent_renewable AS change_in_renewable, R_2000.Continent
FROM R_2000
JOIN R_2018
ON R_2000.Country_Name = R_2018.Country_Name
ORDER BY change_in_renewable DESC