/*
End of Term headcount from Edify
*/

    SELECT a.term_desc,
           COUNT(a.sis_system_id)
      FROM export.student_term_level_version a
     WHERE a.is_enrolled IS TRUE
       AND a.term_id >= '201940'
       AND a.is_primary_level IS TRUE
       AND a.version_desc = 'End of Term'
  GROUP BY a.term_desc, a.term_id, a.version_desc
  ORDER BY a.term_id desc;
