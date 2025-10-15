/*
 Term to Term Retention
 Approved on 20250204
 This query pulls the data needed to calculate term to retention over time (both Come Back rate and Return rate) and to provide data broken out by various demographics.
 It uses student term outcome as the base table. Includes students enrolled as of census.
 It is composed of students in the first-time freshman and transfer cohort in the fall semester.
 It pulls data for the current year plus 5 years.
 */

   SELECT a.student_id,
          a.term_id,
          b.term_desc,
          b.season,
          SUBSTRING(a.term_id, 1, 4) AS year,
          a.is_returned_next_spring,
          a.is_returned_next_fall,
          a.is_graduated
            OR a.is_degree_completer_certificate
            OR a.is_degree_completer_associates
            OR a.is_degree_completer_bachelors
            OR a.is_degree_completer_masters
            OR a.is_degree_completer_doctorate AS is_credential_completer,
          c.primary_major_desc,
          c.primary_degree_id,
          c.primary_degree_desc,
          d.college_abbrv,
          d.college_desc,
          a.is_degree_seeking,
          c.level_desc,
          c.student_type_desc,
          c.full_time_part_time_code,
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
          COALESCE(f.cohort_desc, 'None') AS cohort_desc
     FROM export.student_term_outcome a
LEFT JOIN export.term b
       ON b.term_id = a.term_id
LEFT JOIN export.student_term_level_version c
       ON c.student_id = a.student_id
      AND c.term_id = a.term_id
      AND c.is_enrolled IS TRUE
      AND c.is_primary_level IS TRUE
      AND c.is_census_version IS TRUE
LEFT JOIN export.academic_programs d
       ON d.program_id = c.primary_program_id
LEFT JOIN export.student e
       ON e.student_id = a.student_id
LEFT JOIN export.student_term_cohort f
       ON f.student_id = a.student_id
      AND f.cohort_desc IN ('First-Time Freshman', 'Transfer')
    WHERE a.is_enrolled_census IS TRUE
      AND b.season = 'Fall'
      AND DATE_PART('year', NOW()) - b.academic_year_code :: INT <= 5 -- Current year plus last 5 years
