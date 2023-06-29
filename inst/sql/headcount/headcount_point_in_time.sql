/* daily headcount

*/

SELECT term_id,
       date,
       date_part('week', date) - 11 AS week,
       days_to_class_start,
       COUNT(DISTINCT student_id) AS headcount
FROM export.daily_enrollment
WHERE term_id = '202340'
AND is_enrolled IS TRUE
GROUP BY term_id, date, days_to_class_start
ORDER BY date DESC;
