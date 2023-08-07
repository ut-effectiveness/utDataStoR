/* FTE Graduate by Credit Hour Type - Census
*/

SELECT b.term_desc,
       b.season,
          SUM(a.attempted_credits) as attmp_cred,
          ROUND(SUM(a.attempted_credits)/10, 2) as attmp_cred_fte,
          a.course_level_id,
          a.version_desc
     FROM export.student_section_version a
LEFT JOIN export.term b
       ON a.term_id = b.term_id
    WHERE a.is_enrolled = TRUE
      AND a.version_desc = 'Census'
      AND a.course_level_id = 'GR'
      AND DATE_PART('year', NOW()) - b.academic_year_code :: INT <= 5
GROUP BY a.course_level_id, b.season, b.term_desc, a.version_desc;
