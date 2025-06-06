/*
Census/3rd Week headcount
*/

SELECT a.term_desc,
       COUNT(a.student_id) AS census_headcount
FROM export.student_term_level_version a
         LEFT JOIN export.term b
                   ON a.term_id = b.term_id
WHERE a.is_enrolled IS TRUE
  AND a.is_primary_level IS TRUE
  AND a.version_desc = 'Census'
  AND DATE_PART('year', NOW()) - b.academic_year_code :: INT <= 5 -- Current year plus last 5 years
GROUP BY a.term_desc
ORDER BY a.term_desc;
