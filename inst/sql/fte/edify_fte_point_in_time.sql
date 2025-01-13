/*
Edify FTE Point in Time
This SQL query calculates from Edify the Full-Time Equivalent (FTE) values for graduate, undergraduate, and total on a daily basis.
It details for the current term, the date, number of days until term start, undergradate fte, graduate fte and total fte.

 */

WITH cte_undergrad_fte AS (SELECT a.term_id,
       a.date AS enrollment_date,
       date_part('week', a.date) - 11 AS week,
       a.days_to_class_start,
       SUM(ROUND(a.institutional_attempted_credits/15, 2)) AS undergrad_fte
FROM export.daily_enrollment a
WHERE a.is_current_term = TRUE
AND a.is_enrolled
AND a.level_id = 'UG'
GROUP BY a.term_id, a.date, a.days_to_class_start
ORDER BY a.date DESC),

cte_graduate_fte AS (SELECT b.term_id,
       b.date AS enrollment_date,
       date_part('week', b.date) - 11 AS week,
       b.days_to_class_start,
       SUM(ROUND(b.institutional_attempted_credits/10, 2)) AS graduate_fte
FROM export.daily_enrollment b
WHERE b.is_current_term = TRUE
AND b.is_enrolled
AND b.level_id = 'GR'
GROUP BY b.term_id, b.date, b.days_to_class_start
ORDER BY b.date DESC)

SELECT a.term_id,
       a.enrollment_date,
       a.week,
       a.days_to_class_start,
       COALESCE(a.undergrad_fte, 0) AS undergrad_fte,
       COALESCE(b.graduate_fte, 0) AS graduate_fte,
       a.undergrad_fte + b.graduate_fte AS total_fte
FROM cte_undergrad_fte a
LEFT JOIN cte_graduate_fte b
    ON b.term_id = a.term_id
   AND b.enrollment_date = a.enrollment_date
GROUP BY a.term_id, a.enrollment_date, a.week, a.days_to_class_start, a.undergrad_fte, b.graduate_fte
ORDER BY a.enrollment_date DESC;
