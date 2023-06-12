/*
 Add our standard headcount query to this folder
*/

  SELECT a.term_desc,
         COUNT(a.sis_system_id)
    FROM export.student_term_level a
   WHERE a.is_enrolled IS TRUE
     AND a.term_id = '202340' --Change term(s) here
     AND a.is_primary_level IS TRUE
GROUP BY a.term_desc;
