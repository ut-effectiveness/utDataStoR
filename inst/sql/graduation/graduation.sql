/*
Graduation/Credentials
Approved on 20250702
This query provides a single row for every credential awarded, if a student
earns more than one credential then the student will be listed more than once
for the current graduated academic year plus 5 years.
The degrees awarded table is the base table. It is joined to the academic
programs table to get the correct college, and department data, along with the
major, cip code, IPEDS award level and the graduated degree type. It is joined
to the term table to get the season. Finally, it is joined to the student table
to get the current student demographic data.
*/

SELECT a.student_id,
       a.graduated_term_id,
       c.season,
       SUBSTRING(c.term_id, 1, 4) AS year,
       a.graduation_date,
       a.graduated_academic_year_code,
       b.college_id               AS grad_college_id,
       b.college_desc             AS grad_college_desc,
       b.college_abbrv            AS grad_college_abbrv,
       b.department_id            AS grad_department_id,
       b.department_desc          AS grad_department_desc,
       a.primary_program_id       AS grad_program_id,
       a.degree_id                AS grad_degree_id,
       CASE
           WHEN b.ipeds_award_level_code IN ('1A', '1B', '2') THEN 'Certificate'
           WHEN b.ipeds_award_level_code = '3' THEN 'Associate'
           WHEN b.ipeds_award_level_code = '5' THEN 'Bachelor'
           WHEN b.ipeds_award_level_code = '7' THEN 'Masters'
           WHEN b.ipeds_award_level_code = '8' THEN 'Post-master''s certificate'
           WHEN b.ipeds_award_level_code = '18' THEN 'Doctorate - Professional Practice'
           ELSE 'error'
           END                    AS graduated_degree_type,
       b.ipeds_award_level_code,
       b.major_id                 AS grad_major_id,
       b.major_desc               AS grad_major_desc,
       b.cip_code                 AS grad_cip_code,
       a.is_highest_undergraduate_degree_awarded,
       --Current Student Demographic Data (d table)
       d.gender_code,
       CASE
           WHEN d.gender_code = 'M' THEN 'Male'
           WHEN d.gender_code = 'F' THEN 'Female'
           ELSE 'Unspecified'
           END                    AS gender_desc,
       d.us_citizenship_code,
       d.us_citizenship_desc,
       d.is_international,
       CASE
           WHEN EXTRACT(YEAR from AGE(a.graduation_date, d.birth_date)) < 18 THEN 'less than 18'
           WHEN EXTRACT(YEAR from AGE(a.graduation_date, d.birth_date)) BETWEEN 18 and 24 THEN '18 to 24'
           WHEN EXTRACT(YEAR from AGE(a.graduation_date, d.birth_date)) BETWEEN 25 and 34 THEN '25 to 34'
           WHEN EXTRACT(YEAR from AGE(a.graduation_date, d.birth_date)) BETWEEN 35 and 44 THEN '35 to 44'
           WHEN EXTRACT(YEAR from AGE(a.graduation_date, d.birth_date)) BETWEEN 45 and 59 THEN '45 to 59'
           WHEN EXTRACT(YEAR from AGE(a.graduation_date, d.birth_date)) > 59 THEN '60 plus'
           ELSE 'Error'
           END                    AS graduation_age_band,
       d.is_first_generation,
       d.is_veteran,
       d.first_admit_country_desc,
       d.first_admit_state_desc,
       d.first_admit_county_desc,
       d.ipeds_race_ethnicity,
       CASE
           WHEN d.ipeds_race_ethnicity = 'White' THEN 'Non-Minority'
           WHEN d.ipeds_race_ethnicity = 'Unspecified' THEN 'Non-Minority'
           WHEN d.ipeds_race_ethnicity = 'Non-resident Alien' THEN 'Non-Minority'
           ELSE 'Minority'
           END                    AS minority,
       d.is_athlete               AS is_athlete_ever,
       a.is_graduated
FROM export.degrees_awarded a
         LEFT JOIN export.academic_programs b
                   ON b.program_id = a.primary_program_id
         LEFT JOIN export.term c
                   ON c.term_id = a.graduated_term_id
         LEFT JOIN export.student d
                   ON d.student_id = a.student_id
WHERE DATE_PART('year', NOW()) - a.graduated_academic_year_code :: INT <= 5 -- Current year plus last 5 years
  AND a.degree_status_code = 'AW'
