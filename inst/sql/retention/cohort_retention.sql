/*
 Cohort Retention
 Uses student term cohort table as the base table. Comprises of students in the first-time freshman cohort in the fall semester.
 Includes data to calculate Cohort Retention over time.
 */
    SELECT a.student_id,
           a.cohort_start_term_id,
           a.cohort_desc,
           a.full_time_part_time_code,
           a.cohort_degree_level_desc,
           b.term_desc,
           b.season,
           SUBSTRING(b.term_id, 1, 4) AS year,
           a.is_exclusion,
           -- Second fall return rate
           a.is_returned_next_fall,
           a.is_graduated_year_1,
           -- Third fall return rate
           a.is_returned_fall_3,
           a.is_degree_completer_2,
           -- Fourth fall return rate
           a.is_returned_fall_4,
           a.is_degree_completer_3,
           --
           c.primary_major_desc,
           c.primary_degree_id,
           c.primary_degree_desc,
           d.college_abbrv,
           d.college_desc,
           e.gender_code,
           CASE
           WHEN e.gender_code = 'M' THEN 'Male'
           WHEN e.gender_code = 'F' THEN 'Female'
           ELSE 'Unspecified'
           END AS gender_desc,
           e.ipeds_race_ethnicity,
           e.is_veteran,
           e.is_international,
           e.is_athlete,
           e.is_first_generation
     FROM export.student_term_cohort a
LEFT JOIN export.term b
       ON b.term_id = a.cohort_start_term_id
LEFT JOIN export.student_term_level_version c
       ON c.student_id = a.student_id
      AND c.term_id = a.cohort_start_term_id
      AND c.is_enrolled IS TRUE
      AND c.is_primary_level IS TRUE
      AND c.is_census_version IS TRUE
LEFT JOIN export.academic_programs d
       ON d.program_id = c.primary_program_id
LEFT JOIN export.student e
       ON e.student_id = a.student_id
    WHERE b.season = 'Fall'
      AND a.cohort_desc = 'First-Time Freshman'
      AND DATE_PART('year', NOW()) - b.academic_year_code :: INT <= 8 -- Current year plus last 8 years so that there is 5 years of data for fourth fall return rate
