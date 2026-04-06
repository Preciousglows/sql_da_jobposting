SELECT 
    job_title_short AS title,
    salary_year_avg AS salary,

    CASE
        WHEN salary_year_avg >= 100000 THEN 'High Salary'
        WHEN salary_year_avg >= 50000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL AND job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC;