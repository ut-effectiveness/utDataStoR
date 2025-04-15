Tableau Credentials Awarded Dashboard:

/* Graduation SQL from export for the Tableau credentials awarded dashboard */

SELECT a.student_id,
a.graduated_term_id,
e.season,
a.graduation_date,
a.level_id,
a.degree_id,
a.primary_major_desc,
a.primary_major_id,
d.college_desc,
d.college_id,
c.is_veteran,
c.gender_code,
c.ipeds_race_ethnicity
FROM export.degrees_awarded a
LEFT JOIN export.student_term_level b
ON b.student_id = a.student_id
AND b.level_id = a.level_id
AND b.term_id = a.graduated_term_id
LEFT JOIN export.student c
ON c.student_id = a.student_id
LEFT JOIN export.academic_programs d
ON d.program_id = a.primary_program_id
LEFT JOIN export.term e
ON e.term_id = a.graduated_term_id
WHERE a.degree_status_code = 'AW'
AND a.graduated_term_id >= '201230'
