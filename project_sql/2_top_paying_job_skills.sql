-- Question: What skills are required for the top-paying data analyst jobs?
-- - Use the top 10 highest-paying Data Analyst roles identified in the previous question.
-- - Add the specific skills required for these roles
-- - Why? It provides a detailed look at which high-paying jobs demand certain skills,
-- helping job seekers understand which skills to develop that align with top salaries.

WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        cd.name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim AS cd
    ON
        job_postings_fact.company_id = cd.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    sd.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim AS sjd ON top_paying_jobs.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
ORDER BY top_paying_jobs.salary_year_avg DESC;