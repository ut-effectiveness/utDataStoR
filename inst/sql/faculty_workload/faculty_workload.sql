/*
Faculty Workload
Approved on 20251203
This query provides a unified view of faculty workload by combining both
instructional and non-instructional activities for each instructor during a given term.
It distinguishes between student-facing metrics and instructor-facing metrics by
introducing two types of credit hours: student credit hours, which reflect the
credit value of a course from the student perspective, and instructional credit
hours, which represent the instructor’s share of teaching responsibility based
on their percentage of responsibility for the course.

The query uses a UNION to merge data from instructional and non-instructional
workload sources, standardizing fields across both. For instructional records, it
calculates instructional credit hours using the
formula credit_hours_adjusted × (percentage_of_responsibility_adjusted / 100.0),
while student credit hours are taken directly from the course’s credit value.
Non-instructional records are included with zero values for credit hours
and teaching metrics, but retain workload hours for general and
university-level assignments. The result is a comprehensive dataset
that supports accurate reporting and analysis of faculty effort across roles,
departments, and colleges. */

WITH cte_college_abbrv AS (
    SELECT college_id,
           college_abbrv
    FROM export.academic_programs
)

--Non-Instructional Workload
SELECT a.term_id,
       a.employee_id,
       c.first_name || ' ' || c.last_name AS instructor_name,
       a.non_instructional_type_code || '-' || a.non_instructional_type_desc AS CRS_NIST,
       0 AS class_size,
       0 AS student_credit_hours,
       0 AS instructional_credit_hours,
       0 AS percent_of_responsibility,
       contract_type_code,
       contract_type_desc,
       CASE
           WHEN substr(a.position,1,3) IN ('FAC', 'FPT') THEN 'Full-Time Faculty'
           WHEN substr(a.position,1,3) = 'GOL' THEN 'Overload'
           ELSE 'Part-Time Instructor (PTI)'
       END AS instructional_role,
       b.college_abbrv,
       a.college_code || ' - ' || a.college_desc AS college,
       a.department_code || ' - ' || a.department_desc AS department,
       0 AS instructional_workload,
       CASE
           WHEN a.non_instructional_type_code NOT IN ('ATH','FACS','FSEC','FSEN','FYE','HON','URC1','URC2')
           THEN a.non_instructional_workload
           ELSE 0
       END AS non_instructional_workload,
       CASE
           WHEN a.non_instructional_type_code IN ('ATH','FACS','FSEC','FSEN','FYE','HON','URC1','URC2')
           THEN a.non_instructional_workload
           ELSE 0
       END AS university_workload
FROM export.non_instructional_workload a
LEFT JOIN cte_college_abbrv b ON b.college_id = a.college_code
LEFT JOIN export.employee c ON a.employee_id = c.employee_id
WHERE a.non_instructional_workload > 0

UNION

--Instructional Workload
SELECT term_id,
       instructor_employee_id AS employee_id,
       instructor_first_name || ' ' || instructor_last_name AS instructor_name,
       subject_code || '-' || course_number AS CRS_NIST,
       round(class_size_adjusted,2) AS class_size,
       round(credit_hours_adjusted,2) AS student_credit_hours,
       round(credit_hours_adjusted * (percentage_of_responsibility_adjusted / 100.0), 2) AS instructional_credit_hours,
       round(percentage_of_responsibility_adjusted,2) AS percent_of_responsibility,
       contract_type_code,
       contract_type_desc,
       CASE
           WHEN substr(position,1,3) IN ('FAC', 'FPT') THEN 'Full-Time Faculty'
           WHEN substr(position,1,3) = 'GOL' THEN 'Overload'
           ELSE 'Part-Time Instructor (PTI)'
       END AS instructional_role,
       course_college_abbrv AS college_abbrv,
       course_college_id || ' - ' || course_college_desc AS college,
       course_department_id || ' - ' || course_department_desc AS department,
       instructional_workload AS instructional_workload,
       0 AS non_instructional_workload,
       0 AS university_workload
FROM export.instructional_section_workload
WHERE is_primary_section = TRUE
ORDER BY term_id, employee_id, instructional_role;
