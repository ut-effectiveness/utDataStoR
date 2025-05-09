--pending and awarded graduates for the graduation academic year.
SELECT a.student_id,
a.graduated_term_id,
e.term_desc,
e.season,
a.graduation_date,
c.is_first_generation,
a.level_id,
a.primary_major_cip_code,
d.ipeds_award_level_code,
CASE
WHEN d.ipeds_award_level_code IN ('1A', '1B', '2') THEN 'Certificate'
WHEN d.ipeds_award_level_code IN ('3') THEN 'Associates'
WHEN d.ipeds_award_level_code IN ('5') THEN 'Bachelors'
WHEN d.ipeds_award_level_code = '7' THEN 'Masters'
ELSE 'uncategorized'
END "degree",
a.degree_id,
a.primary_major_desc,
a.primary_major_id,
a.primary_minor_desc,
d.college_desc,
d.college_id,
CASE
WHEN c.primary_visa_type_code = 'F1' AND c.us_citizenship_code = '2' THEN 'international'
WHEN b.residency_code IN ('R', 'C', 'A', 'M', 'B') THEN 'in_state'
WHEN b.residency_code IN ('N', 'G', 'H', 'S', '0') THEN 'out_of_state'
ELSE 'out_of_state'
END                        AS global_residency,
c.first_admit_country_desc,
c.first_admit_state_code,
c.first_admit_state_desc,
c.first_admit_county_desc,
EXTRACT(year FROM age(graduation_date, birth_date)) :: int as age,
c.birth_date,
c.gender_code,
c.ipeds_race_ethnicity,
a.degree_status_code
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
WHERE a.degree_status_code IN ('AW', 'PN')
AND a.graduated_term_id IN ('202430', '202440', '202520');
