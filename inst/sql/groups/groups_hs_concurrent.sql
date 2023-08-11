/* SQL for High School Concurrent Enrollment Student */

WITH cte AS
           (
               SELECT a.budget_code,
                      b.student_type_code,
                      a.student_id,
                      a.course_id,
                      a.term_id
                 FROM export.student_section a
                          LEFT JOIN export.student_term_level b
                                    ON b.student_id = a.student_id
                                        AND b.term_id = a.term_id
                                        AND b.is_primary_level IS TRUE
                WHERE a.is_enrolled IS TRUE
                  AND a.is_current_term IS TRUE
                ORDER BY a.student_id
           ),
       concurrent_cte AS ( --this query flags student courses that are eligible for concurrent enrollment funds
           SELECT a.student_id,
                  a.term_id,
                  CASE
                      WHEN a.student_type_code = 'H' AND (a.budget_code IN ('BC', 'SF'))
                          THEN TRUE
                      ELSE FALSE
                      END AS cte_concurrent_enrollment
             FROM cte a
       )
SELECT a.student_id,
       a.term_id,
       bool_or(cte_concurrent_enrollment) AS is_concurrent_enrollment
  FROM concurrent_cte a
 GROUP BY a.student_id, a.term_id;
