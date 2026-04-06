/*
Question: What are the most in-demand skills for data analyst roles?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for data analyst roles
-Focus on all job postings.
- Why? Retrives the top 5 skills with the highest demand in the job market,
  providing insights into the most valuable skills for job seekers.
*/

SELECT 
    sd.skills,
    COUNT(sjd.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim AS sjd ON job_postings_fact.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home = true
GROUP BY
    sd.skills
ORDER BY
    demand_count DESC
LIMIT 5;