/*
Census headcount groups
provides unit record data, to get headcount you must group and summarize
Definitions for each of these groups can be found in the groups vignette in utDataStoR
 */
SELECT a.term_id,
       a.term_desc,
       c.season,
       a.student_id,
       a.level_id AS student_level_id,
       a.level_desc AS student_level_desc,
       a.student_type_code,
       a.student_type_desc,
       b.ipeds_race_ethnicity,
       b.gender_code,
       CASE
           WHEN b.gender_code = 'F' THEN 'Female'
           WHEN b.gender_code = 'M' THEN 'Male'
           ELSE b.gender_code
           END                        AS gender_desc,
       a.full_time_part_time_code     AS course_load_code,
       CASE
           WHEN a.full_time_part_time_code = 'F' THEN 'Full-time'
           WHEN a.full_time_part_time_code = 'P' THEN 'Part-time'
           ELSE a.full_time_part_time_code
           END AS course_load_desc,
       b.is_first_generation,
       a.is_pell_eligible,
       a.is_pell_awarded,
       a.is_subsidized_loan_awarded,
       b.is_veteran,
       a.is_athlete                   AS is_athlete_term,
       b.us_citizenship_code,
       b.us_citizenship_desc,
       b.is_international,
       a.is_degree_seeking,
       b.is_underrepresented_minority AS is_minority,
       b.first_admit_county_desc,
       b.first_admit_state_desc,
       b.first_admit_country_desc,
       a.residency_code AS tuition_residency_code,
       a.residency_code_desc AS tuition_residency_desc,
       a.residency_in_state_code AS state_residency_code,
       a.residency_in_state_desc AS state_residency_desc,
       CASE
           WHEN b.primary_visa_type_code = 'F1' AND b.us_citizenship_code = '2' THEN 'international'
           WHEN a.residency_in_state_code = 'I' THEN 'in_state'
           WHEN a.residency_in_state_code = 'O' THEN 'out_of_state'
           WHEN a.residency_in_state_code IS NULL AND a.residency_code = 'R' THEN 'in_state'
           WHEN a.residency_in_state_code IS NULL AND a.residency_code = 'A' THEN 'in_state'
           WHEN a.residency_in_state_code IS NULL AND a.residency_code = 'B' THEN 'in_state'
           WHEN a.residency_in_state_code IS NULL AND a.residency_code = 'C' THEN 'in_state'
           WHEN a.residency_in_state_code IS NULL AND a.residency_code = 'M' THEN 'in_state'
           WHEN a.residency_in_state_code IS NULL AND a.residency_code = 'N' THEN 'out_of_state'
           WHEN a.residency_in_state_code IS NULL AND a.residency_code = 'G' THEN 'out_of_state'
           WHEN a.residency_in_state_code IS NULL AND a.residency_code = 'H' THEN 'out_of_state'
           ELSE a.residency_code
           END                        AS global_residency,
       CASE
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) < 18 THEN 'less than 18'
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) BETWEEN 18 and 24 THEN '18 to 24'
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) BETWEEN 25 and 34 THEN '25 to 34'
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) BETWEEN 35 and 44 THEN '35 to 44'
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) BETWEEN 45 and 59 THEN '45 to 59'
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) > 59 THEN '60 plus'
           ELSE 'error'
           END                        AS age_band,
       CASE
           WHEN a.overall_cumulative_gpa < 2.0 THEN '0_to_1.999'
           WHEN a.overall_cumulative_gpa BETWEEN 2.0 AND 2.499 THEN '2_to_2.499'
           WHEN a.overall_cumulative_gpa BETWEEN 2.5 AND 2.999 THEN '2.5_to_2.999'
           WHEN a.overall_cumulative_gpa BETWEEN 3.0 AND 4 THEN '3_to_4'
           ELSE 'new'
           END                        AS overall_cumulative_gpa_band,
       CASE
           WHEN a.institutional_term_gpa < 2.0 THEN '0_to_1.999'
           WHEN a.institutional_term_gpa BETWEEN 2.0 AND 2.499 THEN '2_to_2.499'
           WHEN a.institutional_term_gpa BETWEEN 2.5 AND 2.999 THEN '2.5_to_2.999'
           WHEN a.institutional_term_gpa BETWEEN 3.0 AND 4 THEN '3_to_4'
           ELSE 'new'
           END                       AS institutional_term_gpa_band,
       CASE
           WHEN a.student_type_code = 'H' THEN TRUE
           ELSE FALSE
           END AS is_high_school,
       CASE
           WHEN a.student_type_code = 'P' THEN TRUE
           ELSE FALSE
           END                        AS is_non_matriculated,
       d.college_abbrv,
       d.college_id,
       d.department_desc,
       a.primary_program_id           AS program_id,
       a.primary_program_desc         AS program_desc,
       a.primary_concentration_id     AS concentration_id,
       a.primary_concentration_desc   AS concentration_desc,
       a.primary_degree_id            AS degree_id,
       a.primary_degree_desc          AS degree_desc,
       d.major_id,
       d.major_desc,
       a.primary_level_class_id.      AS class_level_id,
       a.primary_level_class_desc     AS class_level_desc,
       a.is_online_program_student,
       a.is_distance_ed_some,
       a.is_distance_ed_none,
       a.is_distance_ed_all,
       act_composite_score,
       CASE
           WHEN b.is_american_indian_alaskan = 'TRUE' THEN 'BIPOC'
           WHEN b.is_asian = 'TRUE' THEN 'BIPOC'
           WHEN b.is_black = 'TRUE' THEN 'BIPOC'
           WHEN b.is_hawaiian_pacific_islander = 'TRUE' THEN 'BIPOC'
           WHEN b.is_hispanic_latino_ethnicity = 'TRUE' THEN 'BIPOC'
           WHEN b.is_multi_racial = 'TRUE' THEN 'BIPOC'
           ELSE 'non-BIPOC'
           END                        AS BIPOC_student

FROM export.student_term_level_version a
         LEFT JOIN export.student_version b
                   ON a.version_snapshot_id = b.version_snapshot_id
                   AND a.student_id = b.student_id
         LEFT JOIN export.term c
                   ON a.term_id = c.term_id
         LEFT JOIN export.academic_programs d
                   ON a.primary_program_id = d.program_id
WHERE a.is_enrolled IS TRUE
  AND a.is_primary_level IS TRUE
  AND DATE_PART('year', NOW()) - b.academic_year_code :: INT <= 5 -- Current year plus last 5 years
  AND a.version_desc = 'Census'
ORDER BY a.student_id, a.term_id
