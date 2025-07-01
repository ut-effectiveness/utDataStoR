/*
IPEDS Graduation Rate
Approved on 20250414
This query pulls the data needed to calculate graduation rate data over time and to provide data broken out by various demographics.
 It uses student term cohort as the base table. It is composed of students in the first-time freshman and transfer cohorts.
 It pulls data for the current year plus 10 years to go back far enough to pull 6 year graduation rate.
 It joins to the student table to get current demographic data.
 It joins to the degrees awarded table and pulls the highest degree awarded and associated degree data.
 It joins to the student term level census to pull term data based on the cohort term at census.
 It joins to the student term level end of term to pull first term gpa.
 */

SELECT
a.student_id,
a.sis_system_id,
a.cohort_start_term_id,
e.season,
SUBSTRING(e.term_id, 1, 4) AS year,
a.cohort_code,
a.cohort_code_desc,
-- updating all athletes to BA/Bachelor for NCAA reporting
b.is_athlete AS is_athlete_ever,
CASE
WHEN b.is_athlete THEN 'BA' -- if athlete, change degree level to BA
ELSE a.cohort_degree_level_code
END AS cohort_degree_level_code,
CASE
WHEN b.is_athlete THEN 'Bachelor' -- if athlete, change degree level to Bachelor
ELSE a.cohort_degree_level_desc
END AS entering_program_type,
a.cohort_desc,
a.full_time_part_time_code,
a.is_exclusion,
-- student demographic data from current (b table)
b.gender_code,
CASE
WHEN b.gender_code = 'M' THEN 'Male'
WHEN b.gender_code = 'F' THEN 'Female'
ELSE 'Unspecified'
END AS gender_desc,
b.us_citizenship_desc,
b.is_international,
-- calculating age band based on graduation date, if the student didn't graduate, then NA
CASE
WHEN EXTRACT(YEAR from AGE(c.graduation_date, b.birth_date)) < 18 THEN 'less than 18'
WHEN EXTRACT(YEAR from AGE(c.graduation_date, b.birth_date)) BETWEEN 18 and 24 THEN '18 to 24'
WHEN EXTRACT(YEAR from AGE(c.graduation_date, b.birth_date)) BETWEEN 25 and 34 THEN '25 to 34'
WHEN EXTRACT(YEAR from AGE(c.graduation_date, b.birth_date)) BETWEEN 35 and 44 THEN '35 to 44'
WHEN EXTRACT(YEAR from AGE(c.graduation_date, b.birth_date)) BETWEEN 45 and 59 THEN '45 to 59'
WHEN EXTRACT(YEAR from AGE(c.graduation_date, b.birth_date)) > 59 THEN '60 plus'
ELSE 'NA'
END AS graduation_age_band,
b.is_first_generation,
b.is_veteran,
b.first_admit_country_desc,
b.first_admit_state_desc,
b.first_admit_county_desc,
b.death_date,
b.ipeds_race_ethnicity,
CASE
WHEN b.ipeds_race_ethnicity = 'American Indian/Alaskan' THEN 'Minority'
WHEN b.ipeds_race_ethnicity = 'Asian' THEN 'Minority'
WHEN b.ipeds_race_ethnicity = 'Black/African American' THEN 'Minority'
WHEN b.ipeds_race_ethnicity = 'Hawaiian/Pacific Islander' THEN 'Minority'
WHEN b.ipeds_race_ethnicity = 'Hispanic' THEN 'Minority'
WHEN b.ipeds_race_ethnicity = 'Multiracial' THEN 'Minority'
ELSE 'Non-minority'
END AS minority,
--graduation data (c & d tables)
c.is_graduated,
c.graduated_term_id,
c.degree_id AS grad_degree_id,
CASE
    WHEN d.ipeds_award_level_code IN ('1A', '1B', '2') THEN 'Certificate'
    WHEN d.ipeds_award_level_code = '3' THEN 'Associate'
    WHEN d.ipeds_award_level_code = '5' THEN 'Bachelor'
    WHEN d.ipeds_award_level_code IS NULL THEN d.ipeds_award_level_code
ELSE 'Error'
END AS graduated_degree_type,
d.ipeds_award_level_code,
c.graduation_date,
c.primary_program_id AS grad_program_id,
d.department_id AS grad_department_id,
d.department_desc AS grad_department_desc,
d.college_desc AS grad_college_desc,
d.college_abbrv AS grad_college_abbrv,
-- calculating how many days it took to graduate;
-- days to graduate is null if the degree was awarded before the student was placed in a cohort or no degree was awarded
e.term_start_date,
CASE
WHEN c.graduation_date - e.term_start_date < 0 THEN NULL
ELSE c.graduation_date - e.term_start_date END AS days_to_graduate,
-- entering student data (f and g tables) from census
f.primary_program_id AS entering_program_id,
f.primary_degree_desc AS entering_degree_type,
COALESCE(f.primary_major_desc, g.major_desc) AS entering_major,
g.college_desc AS entering_college_desc,
g.college_abbrv AS entering_college_abbrv,
g.department_desc AS entering_department_desc,
f.is_online_program_student AS entering_is_online_program_student,
f.residency_code AS entering_residency_code,
f.residency_in_state_desc AS entering_residency_in_state_desc,
f.is_pell_eligible AS entering_pell_eligible,
f.is_pell_awarded AS entering_pell_awarded,
-- entering student data (h table) from end of term
       CASE
           WHEN h.overall_cumulative_gpa < 2.0 THEN '0_to_1.999'
           WHEN h.overall_cumulative_gpa BETWEEN 2.0 AND 2.499 THEN '2_to_2.499'
           WHEN h.overall_cumulative_gpa BETWEEN 2.5 AND 2.999 THEN '2.5_to_2.999'
           WHEN h.overall_cumulative_gpa BETWEEN 3.0 AND 4 THEN '3_to_4'
           ELSE 'not at end of term'
        END AS first_term_gpa_band

FROM export.student_term_cohort a
LEFT JOIN export.student b
    ON b.student_id = a.student_id
LEFT JOIN export.degrees_awarded c
    ON c.student_id = a.student_id
        AND c.is_highest_undergraduate_degree_awarded -- one graduation record per student
        AND c.degree_status_code = 'AW'
LEFT JOIN export.academic_programs d
    ON d.program_id = c.primary_program_id
LEFT JOIN export.term e
    ON e.term_id = a.cohort_start_term_id
LEFT JOIN export.student_term_level_version f -- Census
    ON f.student_id = a.student_id
        AND f.term_id = a.cohort_start_term_id
        AND f.version_desc = 'Census'
        AND f.is_enrolled
        AND f.is_primary_level
LEFT JOIN export.student_term_level_version h -- End of Term
    ON h.student_id = a.student_id
        AND h.term_id = a.cohort_start_term_id
        AND h.version_desc = 'End of Term'
        AND h.is_enrolled
        AND h.is_primary_level
LEFT JOIN export.academic_programs g
    ON g.program_id = f.primary_program_id
WHERE cohort_code_desc != 'Student Success'
AND DATE_PART('year', NOW()) - e.academic_year_code :: INT <= 10 -- Last 10 Years
