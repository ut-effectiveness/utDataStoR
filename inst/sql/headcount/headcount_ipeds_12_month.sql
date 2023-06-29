/*IPEDS 12 Month headcount

 */

  SELECT b.academic_year_code,
         COUNT(DISTINCT a.sis_system_id)
     FROM export.student_term_level_version a
LEFT JOIN export.term b
       ON a.term_id = b.term_id
    WHERE a.is_enrolled = TRUE
      AND a.is_primary_level = TRUE
      AND a.version_desc = 'Census'
      AND b.academic_year_code = '2022'
      AND b.season != 'Summer'
 GROUP BY academic_year_code;
