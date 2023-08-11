/* Distance Education Status
*/

SELECT a.student_id,
       a.is_distance_ed_all,
       a.is_distance_ed_some,
       a.is_distance_ed_none
  FROM export.student_term_level a
 WHERE a.is_enrolled IS TRUE
   AND a.is_primary_level IS TRUE
   AND a.is_current_term IS TRUE;
