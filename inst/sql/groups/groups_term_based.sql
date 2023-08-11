/* Term based groups
*/

SELECT a.student_id,
       b.college_id,
       b.department_desc,
       a.primary_program_id,
       a.is_degree_seeking,
       a.student_type_desc,
       a.level_desc,
       a.primary_level_class_desc,
       a.full_time_part_time_code,
       a.residency_code_desc,
       CASE
           WHEN a.student_type_code = 'H' THEN TRUE
           ELSE FALSE
        END AS is_high_school,
       CASE
           WHEN a.student_type_code = 'P' THEN TRUE
           ELSE FALSE
        END AS is_non_matriculated,
        CASE
           WHEN a.primary_major_campus_id = 'O01' THEN 'TRUE'
            ELSE 'FALSE'
            END AS online_program_student,
       CASE
           WHEN a.overall_cumulative_gpa < 2.0 THEN '0_to_1.999'
           WHEN a.overall_cumulative_gpa BETWEEN 2.0 AND 2.499 THEN '2_to_2.499'
           WHEN a.overall_cumulative_gpa BETWEEN 2.5 AND 2.999 THEN '2.5_to_2.999'
           WHEN a.overall_cumulative_gpa BETWEEN 3.0 AND 4 THEN '3_to_4'
           ELSE 'new'
        END AS gpa_band,
       a.is_pell_eligible,
       a.is_athlete
  FROM export.student_term_level a
  LEFT JOIN export.academic_programs b ON b.program_id = a.primary_program_id
 WHERE a.is_enrolled IS TRUE
   AND a.is_primary_level IS TRUE
   AND a.is_current_term IS TRUE;
