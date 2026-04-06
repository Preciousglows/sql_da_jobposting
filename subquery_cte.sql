SELECT * FROM skills_job_dim
LIMIT 10;

SELECT * FROM skills_dim
LIMIT 10;

SELECT * FROM job_postings_fact
LIMIT 10;

SELECT * FROM company_dim
LIMIT 10;

-- Find the top 5 most common skills required across all job postings, along with the count of how many job postings require each skill.
SELECT 
    sd.skills,
    top_5_skills.skill_job_count
FROM(
    SELECT 
        skill_id,
        COUNT(job_id) AS skill_job_count
    FROM
        skills_job_dim AS sjd
    GROUP BY 
        skill_id
    ORDER BY 
        skill_job_count DESC
    LIMIT 5
    ) AS top_5_skills
JOIN
    skills_dim AS sd 
    ON 
        top_5_skills.skill_id = sd.skill_id


WITH job_postings_per_company AS (
    SELECT
        company_id,
        COUNT(job_id) AS job_count
    FROM
        job_postings_fact
    GROUP BY
        company_id
)
SELECT
    cd.name AS company_name,
    job_postings_per_company.job_count AS job_count,

    CASE
        WHEN job_postings_per_company.job_count < 10 THEN 'Small'
        WHEN job_postings_per_company.job_count BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS company_size
FROM
    company_dim AS cd
JOIN
    job_postings_per_company
    ON job_postings_per_company.company_id = cd.company_id    