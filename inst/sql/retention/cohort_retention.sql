/*
 Cohort Retention
 */
    SELECT a.student_id,
           a.cohort_start_term_id,
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
           c.primary_major_desc,
           c.primary_degree_id,
           c.primary_degree_desc,
           d.college_abbrv,
           d.college_desc,
           e.first_name,
           e.last_name,
           e.gender_code,
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
      AND c.is_enrolled
      AND c.is_primary_level
      AND c.is_census_version
LEFT JOIN export.academic_programs d
       ON d.program_id = c.primary_program_id
LEFT JOIN export.student e
       ON e.student_id = a.student_id
    WHERE b.season = 'Fall'
      AND a.cohort_desc = 'First-Time Freshman'
      AND substr(a.cohort_start_term_id, 1, 4)::int >= (SELECT substr(term_id, 1, 4)::int - 5
                                     FROM export.term
                                     WHERE is_current_term)
