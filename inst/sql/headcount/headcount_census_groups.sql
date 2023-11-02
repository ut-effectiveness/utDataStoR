SELECT a.term_id,
       a.term_desc,
       c.season,
       a.student_id,
       a.level_id,
       b.ipeds_race_ethnicity,
       b.gender_code,
       a.full_time_part_time_code,
       b.is_first_generation,
       a.is_pell_eligible,
       b.is_veteran,
       a.is_athlete,
       a.is_degree_seeking,
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
       d.college_abbrv,
       d.major_desc
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
  AND DATE_PART('year', NOW()) - c.academic_year_code :: INT <= 5
  AND a.version_desc = 'Census';
