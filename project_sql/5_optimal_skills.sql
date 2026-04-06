/*
Answer: What are the most optimal skills to learn(aka it's in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles.
- Concentrates on remote positions with specified salaries
-Why? Targets skills that offer job security(high demand) and financial benefits(high salary),
offering strategic insights for career dvelopment in the data analysis field.
*/

WITH skills_demand AS(
    SELECT 
        sd.skill_id,
        sd.skills,
        COUNT(sjd.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim AS sjd ON job_postings_fact.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        job_work_from_home = true AND
        salary_year_avg IS NOT NULL
    GROUP BY
        sd.skill_id
), average_salary_per_skill AS (
    SELECT
        sjd.skill_id,
        ROUND(AVG(salary_year_avg), 2) AS average_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim AS sjd ON job_postings_fact.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND
        salary_year_avg IS NOT NULL
        AND
        job_work_from_home = true
    GROUP BY
        sjd.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    skills_demand.demand_count,
    average_salary_per_skill.average_salary
FROM
    skills_demand
INNER JOIN
    average_salary_per_skill
    ON skills_demand.skill_id = average_salary_per_skill.skill_id
WHERE
    skills_demand.demand_count > 10
ORDER BY
    average_salary DESC,
    demand_count DESC

LIMIT 25;

--rewriting the same query more concisely

SELECT 
    sd.skill_id,
    sd.skills,
    COUNT(sjd.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg), 2) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim AS sjd ON job_postings_fact.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home = true AND
    salary_year_avg IS NOT NULL
GROUP BY
    sd.skill_id
HAVING
    COUNT(sjd.job_id) > 10
ORDER BY
    average_salary DESC,
    demand_count DESC
LIMIT 25;