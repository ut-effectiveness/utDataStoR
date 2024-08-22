/*
daily headcount
*/

SELECT term_id,
       date,
       date_part('week', date) - 11 AS week,
       days_to_class_start,
       COUNT(DISTINCT student_id) AS headcount
FROM export.daily_enrollment
WHERE is_current_term IS TRUE -- Only pulling current term
  AND is_enrolled IS TRUE
GROUP BY term_id, date, days_to_class_start
ORDER BY date DESC;
