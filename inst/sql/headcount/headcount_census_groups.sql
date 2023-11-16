SELECT a.term_id,
       a.term_desc,
       c.season,
       a.student_id,
       a.level_id,
       a.student_type_desc,
       b.ipeds_race_ethnicity,
       b.gender_code,
       a.full_time_part_time_code,
       b.is_first_generation,
       a.is_pell_eligible,
       a.is_pell_awarded,
       b.is_veteran,
       a.is_athlete AS is_athlete_current_term,
       b.us_citizenship_desc,
       b.is_international,
       a.is_degree_seeking,
       a.is_subsidized_loan_awarded,
       b.is_underrepresented_minority,
       b.first_admit_county_desc,
       b.first_admit_state_desc,
       b.first_admit_country_desc,
       CASE
           WHEN b.primary_visa_type_code = 'F1' AND b.us_citizenship_code = '2' THEN 'international'
           WHEN a.residency_in_state_code = 'I' THEN 'in_state'
           WHEN a.residency_in_state_code = 'O' THEN 'out_of_state'
           ELSE a.residency_code
           END AS residency,
       CASE
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) < 18 THEN 'less than 18'
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) BETWEEN 18 and 24 THEN '18 to 24'
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) BETWEEN 25 and 34 THEN '25 to 34'
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) BETWEEN 35 and 44 THEN '35 to 44'
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) BETWEEN 45 and 59 THEN '45 to 59'
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) > 59 THEN '60 plus'
           ELSE 'error'
           END AS age_band,
       CASE
           WHEN a.overall_cumulative_gpa < 2.0 THEN '0_to_1.999'
           WHEN a.overall_cumulative_gpa BETWEEN 2.0 AND 2.499 THEN '2_to_2.499'
           WHEN a.overall_cumulative_gpa BETWEEN 2.5 AND 2.999 THEN '2.5_to_2.999'
           WHEN a.overall_cumulative_gpa BETWEEN 3.0 AND 4 THEN '3_to_4'
           ELSE 'new'
           END AS gpa_band,
       CASE
           WHEN a.student_type_code = 'P' THEN TRUE
           ELSE FALSE
           END AS is_non_matriculated,
       d.college_abbrv,
       d.major_desc,
       a.primary_degree_id,
       d.department_desc,
       a.primary_level_class_desc,
       a.is_distance_ed_some,
       a.is_distance_ed_none,
       a.is_distance_ed_all,
       AVG(act_composite_score) AS Average_ACT_composite,
       CASE
           WHEN b.is_american_indian_alaskan = 'TRUE' THEN 'BIPOC'
           WHEN b.is_asian = 'TRUE' THEN 'BIPOC'
           WHEN b.is_black = 'TRUE' THEN 'BIPOC'
           WHEN b.is_hawaiian_pacific_islander = 'TRUE' THEN 'BIPOC'
           WHEN b.is_hispanic_latino_ethnicity = 'TRUE' THEN 'BIPOC'
           WHEN b.is_multi_racial = 'TRUE' THEN 'BIPOC'
           ELSE 'non-BIPOC'
           END AS BIPOC_student_headcount


FROM export.student_term_level_version a
         LEFT JOIN export.student_version b
                   ON a.version_snapshot_id = b.version_snapshot_id
                       AND a.student_id = b.student_id
         LEFT JOIN export.term c
                   ON a.term_id = c.term_id
         LEFT JOIN export.academic_programs d
                   ON a.primary_program_id = d.program_id
WHERE a.is_enrolled = TRUE
  AND a.is_primary_level = TRUE
  AND DATE_PART('year', NOW()) - c.academic_year_code :: INT <= 3
  AND a.version_desc = 'Census'
  GROUP BY a.term_id, a.term_desc, c.season, a.student_id, a.level_id,
           a.student_type_desc, b.ipeds_race_ethnicity, b.gender_code,
           a.full_time_part_time_code, b.is_first_generation,
           a.is_pell_eligible, a.is_pell_awarded, b.is_veteran,
           a.is_athlete, b.us_citizenship_desc, b.is_international,
           a.is_degree_seeking, a.is_subsidized_loan_awarded, b.is_underrepresented_minority,
           b.first_admit_county_desc, b.first_admit_state_desc, b.first_admit_country_desc, CASE
           WHEN b.primary_visa_type_code = 'F1' AND b.us_citizenship_code = '2' THEN 'international'
           WHEN a.residency_in_state_code = 'I' THEN 'in_state'
           WHEN a.residency_in_state_code = 'O' THEN 'out_of_state'
           ELSE a.residency_code
           END, CASE
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) < 18 THEN 'less than 18'
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) BETWEEN 18 and 24 THEN '18 to 24'
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) BETWEEN 25 and 34 THEN '25 to 34'
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) BETWEEN 35 and 44 THEN '35 to 44'
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) BETWEEN 45 and 59 THEN '45 to 59'
           WHEN EXTRACT(YEAR from AGE(current_date, b.birth_date)) > 59 THEN '60 plus'
           ELSE 'error'
           END, CASE
           WHEN a.overall_cumulative_gpa < 2.0 THEN '0_to_1.999'
           WHEN a.overall_cumulative_gpa BETWEEN 2.0 AND 2.499 THEN '2_to_2.499'
           WHEN a.overall_cumulative_gpa BETWEEN 2.5 AND 2.999 THEN '2.5_to_2.999'
           WHEN a.overall_cumulative_gpa BETWEEN 3.0 AND 4 THEN '3_to_4'
           ELSE 'new'END,
           CASE
           WHEN a.student_type_code = 'P' THEN TRUE
           ELSE FALSE
           END,
           d.college_abbrv, d.major_desc, a.primary_degree_id, d.department_desc,
           a.primary_level_class_desc, a.is_distance_ed_some, a.is_distance_ed_none,
           a.is_distance_ed_all,
           CASE
           WHEN b.is_american_indian_alaskan = 'TRUE' THEN 'BIPOC'
           WHEN b.is_asian = 'TRUE' THEN 'BIPOC'
           WHEN b.is_black = 'TRUE' THEN 'BIPOC'
           WHEN b.is_hawaiian_pacific_islander = 'TRUE' THEN 'BIPOC'
           WHEN b.is_hispanic_latino_ethnicity = 'TRUE' THEN 'BIPOC'
           WHEN b.is_multi_racial = 'TRUE' THEN 'BIPOC'
           ELSE 'non-BIPOC'
           END;
