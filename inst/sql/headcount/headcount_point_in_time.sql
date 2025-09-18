/*
daily point in time headcount
Approved on 20250305
This query pulls the daily headcount (enrolled students) for the current term
(see where is_current_term IS TRUE)
The query also provides the date, the week
(calculates the interval between each date and the earliest registration start date, converts this interval to seconds, converts the difference from seconds to week),
and the days to the start of class
(zero is the first day of class, negative days are before class starts, positive counts are after class starts)
*/

SELECT a.term_id,
       date,
       CEIL(EXTRACT(EPOCH FROM AGE(date, MIN(b.registration_start_date) OVER ())) / (7 * 24 * 60 * 60)) AS week_number,
       a.days_to_class_start,
       COUNT(DISTINCT a.student_id) AS headcount
FROM export.daily_enrollment a
         LEFT JOIN export.term b
                   ON a.term_id = b.term_id
WHERE a.is_current_term IS TRUE -- Only pulling current term
  AND a.is_enrolled IS TRUE
GROUP BY a.term_id, date, a.days_to_class_start, b.registration_start_date
ORDER BY date DESC;
