SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AS date
FROM
    job_postings_fact;


--Average salary by schedule type for jobs posted after June 1, 2023
SELECT AVG(salary_year_avg) AS salary,
       AVG(salary_hour_avg) AS salary_hourly,
       job_schedule_type AS schedule_type
FROM 
    job_postings_fact
WHERE job_posted_date::DATE > '2023-06-01'
GROUP BY job_schedule_type;

--Helpful query to find timezone names and offsets
SELECT name, abbrev, utc_offset, is_dst 
FROM pg_timezone_names 
ORDER BY name;


--Number of job postings by month for the year 2023, adjusting for Eastern Time
SELECT 
    COUNT(job_id) AS id,
    EXTRACT(MONTH FROM job_posted_date::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month
FROM
    job_postings_fact
WHERE job_posted_date >= '2023-01-01' AND job_posted_date < '2024-01-01'
GROUP BY month
ORDER BY month;

SELECT *
FROM job_postings_fact
LIMIT 10;

SELECT *
FROM company_dim
LIMIT 10;


--Companies that offered health insurance in the months of April, May, and June
SELECT
    c.name AS company,
    j.job_title_short AS title,
    j.job_health_insurance AS health_insurance,
    EXTRACT(MONTH FROM j.job_posted_date) AS month
FROM
    job_postings_fact AS j
JOIN company_dim AS c ON j.company_id = c.company_id
WHERE 
    j.job_health_insurance = true
    AND EXTRACT(MONTH FROM j.job_posted_date) IN(4,5,6) --April, May, June

