/*
 Term to term retention
 */
   SELECT a.student_id,
          a.term_id,
          b.term_desc,
          b.season,
          SUBSTRING(a.term_id, 1, 4) AS year,
          a.is_returned_next_spring,
          a.is_returned_next_fall,
          a.is_degree_seeking,
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
          e.is_first_generation,
          COALESCE(f.is_exclusion, FALSE) AS is_exclusion,
          COALESCE(f.cohort_start_term_id, 'None') AS cohort_start_term_id,
          COALESCE(f.cohort_desc, 'None') AS cohort_type
     FROM export.student_term_outcome a
LEFT JOIN export.term b
       ON b.term_id = a.term_id
LEFT JOIN export.student_term_level_version c
       ON c.student_id = a.student_id
      AND c.term_id = a.term_id
      AND c.is_enrolled
      AND c.is_primary_level
      AND c.is_census_version
LEFT JOIN export.academic_programs d
       ON d.program_id = c.primary_program_id
LEFT JOIN export.student e
       ON e.student_id = a.student_id
LEFT JOIN export.student_term_cohort f
       ON f.student_id = a.student_id
      AND f.cohort_desc IN ('First-Time Freshman', 'Transfer')
    WHERE a.is_enrolled_census
      AND b.season = 'Fall'
      AND substr(a.term_id, 1, 4)::int >= (SELECT substr(term_id, 1, 4)::int - 5
                                     FROM export.term
                                     WHERE is_current_term)
