  WITH cohort_terms AS (
      -- list of last five fall semesters for the cohorts
      SELECT DISTINCT(b.term_id) AS cohort_term
        FROM export.term b
       WHERE CAST(b.term_id AS INT) >= (
           SELECT CAST(a.term_id AS INT) - 500
             FROM export.term a
            WHERE is_current_term = TRUE
       )
         AND CAST(b.term_id AS INT) <= (
           SELECT CAST(a.term_id AS INT)
             FROM export.term a
            WHERE is_current_term = TRUE
       )
         AND b.term_type = 'Fall'
  ),
       spring_terms AS (
           -- list of spring terms the students return in
           SELECT CAST(CAST(cohort_term AS INT) + 80 AS VARCHAR) AS spring_term
             FROM cohort_terms
       ),
       fall_terms AS (
           -- list of fall terms the students return in
           SELECT CAST(CAST(cohort_term AS INT) + 100 AS VARCHAR) AS fall_term
             FROM cohort_terms
       ),
       cohort_population AS (
           SELECT a.term_id                        AS cohort_term,
                  CAST(a.term_id AS integer) + 80  AS spring_term,
                  CAST(a.term_id AS integer) + 100 AS fall_term,
                  a.sis_system_id                  AS pidm,
                  a.student_id                     AS d_number
             FROM export.student_term_level a
            WHERE a.is_enrolled
              AND a.term_desc LIKE 'Fall%'
              AND a.term_id IN (SELECT cohort_term FROM cohort_terms)
              AND a.is_degree_seeking
              AND a.is_primary_level
       ),
       current_spring_returned_population AS (
           -- Select all students enrolled in the spring semester. Here we don't
           -- care if they are degree seeking or not.
           SELECT CAST(a.term_id AS integer) AS spring_term,
                  a.sis_system_id            AS pidm,
                  TRUE                       AS is_spring_returned
             FROM student_term_level a
            WHERE a.is_enrolled
              AND a.term_desc LIKE 'Spring%'
              AND a.term_id IN (SELECT spring_term FROM spring_terms)
       ),
       census_spring_returned_population AS (
           -- list of all students enrolled in spring semester as of census. Here we don't
           -- care if they are degree seeking or not
           SELECT CAST(a.term_id AS integer) AS spring_term,
                  a.sis_system_id            AS pidm,
                  TRUE                       AS is_census_spring_returned
             FROM student_term_level_version a
            WHERE a.is_enrolled
              AND a.term_desc LIKE 'Spring%'
              AND a.term_id IN (SELECT spring_term FROM spring_terms)
              AND a.is_census_version
       ),
       current_fall_returned_population AS (
           -- Select all students enrolled in the fall semester. Here we don't
           -- care if they are degree seeking or not.
           SELECT CAST(a.term_id AS integer) AS fall_term,
                  a.sis_system_id            AS pidm,
                  TRUE                       AS is_fall_returned
             FROM student_term_level a
            WHERE a.is_enrolled
              AND a.term_desc LIKE 'Fall%'
              AND a.term_id IN (SELECT fall_term FROM fall_terms)
       ),
       census_fall_returned_population AS (
           -- Select all students enrolled in the fall semester as of census. Here we don't
           -- care if they are degree seeking or not.
           SELECT CAST(a.term_id AS integer) AS fall_term,
                  a.sis_system_id            AS pidm,
                  TRUE                       AS is_census_fall_returned
             FROM student_term_level_version a
            WHERE a.is_enrolled
              AND a.term_desc LIKE 'Fall%'
              AND a.term_id IN (SELECT fall_term FROM fall_terms)
              AND a.is_census_version
       )
SELECT a.cohort_term,
       COALESCE(b.spring_term, '0')                 AS spring_term,
       COALESCE(d.fall_term, '0')                   AS fall_term,
       a.pidm,
       a.d_number,
       COALESCE(b.is_spring_returned, FALSE)        AS is_spring_returned,        -- returned next spring
       COALESCE(c.is_census_spring_returned, FALSE) AS is_census_spring_returned, -- census returned next spring
       COALESCE(d.is_fall_returned, FALSE)          AS is_fall_returned,           -- returned next fall   Add census returned next fall
       COALESCE(e.is_census_fall_returned, FALSE)   AS census_returned_next_fall
  FROM cohort_population a
           LEFT JOIN current_spring_returned_population b
                     ON b.pidm = a.pidm
                         AND b.spring_term = a.spring_term
           LEFT JOIN census_spring_returned_population c
                     ON c.pidm = a.pidm
                         AND c.spring_term = a.spring_term
           LEFT JOIN current_fall_returned_population d
                     ON d.pidm = a.pidm
                         AND d.fall_term = a.fall_term
           LEFT JOIN census_fall_returned_population e
                     ON e.pidm = a.pidm
                         AND e.fall_term = a.fall_term;