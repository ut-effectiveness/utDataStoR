/*
IPEDS 12 Month headcount
 */

SELECT b.academic_year_code,
       COUNT(DISTINCT a.student_id) --unduplicated students over the course of an academic year
FROM export.student_term_level_version a
         LEFT JOIN export.term b
                   ON a.term_id = b.term_id
WHERE a.is_enrolled = TRUE
  AND a.is_primary_level = TRUE
  AND a.version_desc = 'Census'
  AND DATE_PART('year', NOW()) - b.academic_year_code :: INT = 1 -- Last academic year
  AND b.season != 'Summer'                                       -- remove summer as per ipeds requirement
GROUP BY academic_year_code;
