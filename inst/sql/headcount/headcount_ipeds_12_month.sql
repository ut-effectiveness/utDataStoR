/*
IPEDS 12 Month headcount
Approved on 20250305
This query pulls an unduplicated count of enrolled students for the last academic year
(this query is typically run in the fall for the previous academic year)
using the census version table (see where a.version_desc = 'Census')
 */

SELECT b.academic_year_code,
       COUNT(DISTINCT a.student_id) --unduplicated students over the course of an academic year
FROM export.student_term_level_version a
         LEFT JOIN export.term b
                   ON a.term_id = b.term_id
WHERE a.is_enrolled IS TRUE
  AND a.is_primary_level IS TRUE
  AND a.version_desc = 'Census'
  AND DATE_PART('year', NOW()) - b.academic_year_code :: INT = 1 -- Last academic year
GROUP BY academic_year_code;
