--IPEDS Completions

/* IPEDS completion from Export */

SELECT a.student_id,
c.ipeds_race_ethnicity,
c.gender_code,
d.ipeds_award_level_code,
a.primary_major_cip_code AS cip_code,
a.primary_major_id,
a.secondary_major_id,
a.degree_status_code,
a.degree_id,
a.graduation_date,
c.birth_date,
a.graduated_academic_year_code,
a.is_highest_degree_awarded
FROM export.student_degree_program_application_version a
--LEFT JOIN export.student_term_level_graduate_version b
--ON b.student_id = a.student_id
--AND b.level_id = a.level_id
--AND b.term_id = a.graduated_term_id
LEFT JOIN export.student c
ON c.student_id = a.student_id
LEFT JOIN export.academic_programs d
ON d.program_id = a.program_code
LEFT JOIN export.term e
ON e.term_id = a.graduated_term_id
WHERE a.degree_status_code = 'AW'
AND EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM a.graduation_date) <= 5; -- Past 5 years
