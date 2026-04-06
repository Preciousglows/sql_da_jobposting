SELECT * FROM company_dim
LIMIT 10;

SELECT * FROM job_postings_fact
LIMIT 10;

SELECT * FROM skills_dim
LIMIT 10;

SELECT * FROM skills_job_dim
LIMIT 10;


-- Skills and Skill Types for Jobs with Salary Above $70,000 posted in the first 3 months
WITH combined_jobs AS (
    SELECT job_id,
           job_title_short,
           job_posted_date,
           salary_year_avg
    FROM
        january_jobs

    UNION ALL

    SELECT job_id,
           job_title_short,
           job_posted_date,
           salary_year_avg
    FROM
        february_jobs

    UNION ALL

    SELECT job_id,
           job_title_short,
           job_posted_date,
           salary_year_avg
    FROM
        march_jobs
)
SELECT
    combined_jobs.job_id,
    combined_jobs.job_title_short,
    combined_jobs.job_posted_date,
    combined_jobs.salary_year_avg,
    sd.skills,
    sd.type
FROM
    combined_jobs
LEFT JOIN
    skills_job_dim AS sjd
ON
    combined_jobs.job_id = sjd.job_id
LEFT JOIN
    skills_dim AS sd
ON
    sjd.skill_id = sd.skill_id
WHERE
    salary_year_avg > 70000
ORDER BY
    combined_jobs.job_posted_date DESC,
    combined_jobs.salary_year_avg DESC