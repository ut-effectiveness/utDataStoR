WITH fall_cohort_terms_include AS (
  -- list of last five fall semesters for the cohorts
  SELECT DISTINCT(b.term_id) AS cohort_term
    FROM export.term b
   WHERE CAST(b.term_id AS INT) >= ( SELECT ( CAST(a.term_id AS INT) - 500 )
                                     FROM export.term a
                                     WHERE a.is_current_term = TRUE )
     AND CAST(b.term_id AS INT) <= ( SELECT CAST(a.term_id AS INT)
                                     FROM export.term a
                                     WHERE a.is_current_term = TRUE )
     AND b.season = 'Fall'
),
future_spring_terms AS (
    -- list of all future spring terms a student could return in
   SELECT CAST(CAST(cohort_term AS INT) + 80 AS VARCHAR) AS spring_term
   FROM fall_cohort_terms_include
),
future_fall_terms AS (
   -- list of all future fall terms a student could return in
   SELECT CAST(CAST(cohort_term AS INT) + 100 AS VARCHAR) AS fall_term
   FROM fall_cohort_terms_include
),
cohort_base_population AS (
   SELECT a.term_id                        AS term_id,
          CAST(a.term_id AS integer) + 80  AS next_spring_term,
          CAST(a.term_id AS integer) + 100 AS next_fall_term,
          a.student_id                     AS student_id
     FROM export.student_term_level a
    WHERE a.is_enrolled
      AND a.term_id IN (SELECT cohort_term FROM fall_cohort_terms_include)
      -- TODO: comments on justification for this filter needed
      AND a.is_degree_seeking
      -- TODO: comments on justification for this filter needed
      AND a.is_primary_level
),
current_spring_returned_population AS (
   -- Select all students enrolled in the spring semester. Here we don't
   -- care if they are degree seeking or not.
   SELECT CAST(a.term_id AS integer) AS spring_term,
          a.student_id               AS student_id,
          TRUE                       AS is_spring_returned
     FROM export.student_term_level a
    WHERE a.is_enrolled
      AND a.term_id IN (SELECT spring_term FROM future_spring_terms)
),
census_spring_returned_population AS (
   -- list of all students enrolled in spring semester as of census. Here we don't
   -- care if they are degree seeking or not
   SELECT CAST(a.term_id AS integer) AS spring_term,
          a.student_id               AS student_id,
          TRUE                       AS is_census_spring_returned
     FROM export.student_term_level_version a
    WHERE a.is_enrolled
      AND a.term_id IN (SELECT spring_term FROM future_spring_terms)
      AND a.is_census_version
),
current_fall_returned_population AS (
   -- Select all students enrolled in the fall semester. Here we don't
   -- care if they are degree seeking or not.
   SELECT CAST(a.term_id AS integer) AS fall_term,
          a.student_id               AS student_id,
          TRUE                       AS is_fall_returned
     FROM export.student_term_level a
    WHERE a.is_enrolled
      AND a.term_id IN (SELECT fall_term FROM future_fall_terms)
),
census_fall_returned_population AS (
   -- Select all students enrolled in the fall semester as of census. Here we don't
   -- care if they are degree seeking or not.
   SELECT CAST(a.term_id AS integer) AS fall_term,
          a.student_id               AS student_id,
          TRUE                       AS is_census_fall_returned
     FROM export.student_term_level_version a
    WHERE a.is_enrolled
      AND a.term_id IN (SELECT fall_term FROM future_fall_terms)
      AND a.is_census_version
)
SELECT a.student_id                                 AS student_id,
       a.term_id                                    AS term_id,
       b.spring_term                                AS next_spring_term_id,
       d.fall_term                                  AS next_fall_term_id,
       COALESCE(b.is_spring_returned, FALSE)        AS is_spring_returned,
       COALESCE(c.is_census_spring_returned, FALSE) AS is_census_spring_returned,
       COALESCE(d.is_fall_returned, FALSE)          AS is_fall_returned,
       COALESCE(e.is_census_fall_returned, FALSE)   AS is_census_fall_returned
FROM cohort_base_population a
-- The following joins use this logic:
-- If the next term, from the base population,
-- equals the term of the returned population,
-- then they are considered returned for that next term.
LEFT JOIN current_spring_returned_population b
      ON b.student_id = a.student_id
     AND b.spring_term = a.next_spring_term
LEFT JOIN census_spring_returned_population c
      ON c.student_id = a.student_id
     AND c.spring_term = a.next_spring_term
LEFT JOIN current_fall_returned_population d
      ON d.student_id = a.student_id
     AND d.fall_term = a.next_fall_term
LEFT JOIN census_fall_returned_population e
      ON e.student_id = a.student_id
     AND e.fall_term = a.next_fall_term;