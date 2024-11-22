/*
This SQL query calculates annualized FTE for USHE.

USHE uses End of Term data to calculate their annualized FTE.

They add the total FTE by each term (Summer, Fall, Spring) and
divide by 2 to get Annualized FTE.
*/

WITH CTE_fte AS
         (SELECT CASE
                     WHEN b.season = 'Summer' THEN to_char(CAST(b.academic_year_code AS INTEGER) + 1, 'FM9999') --format mask
                     ELSE b.academic_year_code
                 END AS ushe_academic_year_code,
                 CASE
                     WHEN a.course_level_id = 'GR'
                         THEN ROUND(SUM(a.attempted_credits) / 10, 2)
                         ELSE 0
                 END AS eot_graduate_fte,
                 CASE
                     WHEN a.course_level_id = 'UG'
                         THEN ROUND(SUM(a.attempted_credits) / 15, 2)
                         ELSE 0
                 END AS eot_undergrad_fte
          FROM export.student_section_version a
          LEFT JOIN export.term b ON a.term_id = b.term_id
          WHERE a.is_enrolled IS TRUE
            AND a.version_desc = 'End of Term'
          GROUP BY a.term_id,
                   a.course_level_id,
                   b.season,
                   b.academic_year_code)
SELECT ushe_academic_year_code,
       ROUND(SUM(eot_undergrad_fte/2),2) AS eot_undergrad_fte,
       ROUND(SUM(eot_graduate_fte/2),2) AS eot_graduate_fte,
       ROUND(SUM((eot_graduate_fte + eot_undergrad_fte)/2),2) AS eot_total_fte
FROM CTE_fte
WHERE DATE_PART('year', NOW()) - ushe_academic_year_code :: INT <= 5 -- Current year plus last 5 years
GROUP BY ushe_academic_year_code
ORDER BY ushe_academic_year_code;
