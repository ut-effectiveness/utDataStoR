/*FTE End of Term
Approved on 20250115
This SQL query calculates Full-Time Equivalent (FTE) values for graduate, undergraduate, and total students enrolled
for the most recent year plus 5 years of data (see where add DATE_PART)
in end of term versions of courses (see where a.version_desc =)
Does not include any FTE for CE - Continuing Education courses
*/

WITH CTE_graduate_fte AS
         (SELECT a.term_id,
                 ROUND(SUM(a.attempted_credits) / 10, 2) as end_of_term_graduate_fte
          FROM export.student_section_version a
          WHERE a.is_enrolled IS TRUE
            AND a.version_desc = 'End of Term'
            AND a.course_level_id = 'GR'
          GROUP BY a.term_id),

     CTE_undergrad_fte AS
         (SELECT a.term_id,
                 ROUND(SUM(a.attempted_credits) / 15, 2) as end_of_term_undergrad_fte
          FROM export.student_section_version a
          WHERE a.is_enrolled IS TRUE
            AND a.version_desc = 'End of Term'
            AND a.course_level_id = 'UG'
          GROUP BY a.term_id)

SELECT b.term_desc,
       COALESCE(d.end_of_term_undergrad_fte, 0) AS end_of_term_undergrad_fte,
       COALESCE(c.end_of_term_graduate_fte, 0) AS end_of_term_graduate_fte,
       ROUND(COALESCE(c.end_of_term_graduate_fte, 0) + COALESCE(d.end_of_term_undergrad_fte, 0), 2) AS end_of_term_total_fte
FROM export.student_section_version a
         LEFT JOIN export.term b
                   ON a.term_id = b.term_id
         LEFT JOIN CTE_graduate_fte c
                   ON a.term_id = c.term_id
         LEFT JOIN CTE_undergrad_fte d
                   ON a.term_id = d.term_id
WHERE a.is_enrolled IS TRUE
  AND a.version_desc = 'End of Term'
  AND DATE_PART('year', NOW()) - b.academic_year_code :: INT <= 5 -- Current year plus last 5 years
GROUP BY b.term_desc, c.end_of_term_graduate_fte, d.end_of_term_undergrad_fte
ORDER BY b.term_desc;
