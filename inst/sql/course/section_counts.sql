/*
Section Counts
Approved on 20251119
This SQL query retrieves detailed information for course sections, including term details, course identifiers, section
  information, and campus descriptions. It uses the student_section_version table as the base to capture enrolled
  sections and includes version indicators for census and end-of-term snapshots.
  The student_section_version table (in cte_section_summary) joins to the term table to provide term information, and to
  the course_version table for course information. It also joins to the academic_programs table to bring in college
  abbreviations. Additionally, it aggregates attributes from the course_attribute table to flag supplemental instruction,
  zero-cost textbooks, honors status, and general education designation for each section. The data is filtered to
  include only sections from the current academic year and the previous five years, and it returns one row per
  combination of term, course reference number, and version indicators.
 */

WITH cte_course_attributes AS (
/* Pulls the course attributes. Only used in the cte_selected_attributes CTE */
    SELECT term_id,
           course_registration_number,
           attribute_code,
           attribute_desc
    FROM quad.course_attribute),

     cte_selected_attributes AS (
/* Aggregates attributes to ONE row per (term_id, course_registration_number)*/
         SELECT term_id,
                course_registration_number,
                BOOL_OR(attribute_code = 'SI') AS is_supp_inst,
                BOOL_OR(attribute_code = 'ZTC') AS is_zero_cost_text,
                BOOL_OR(attribute_code = 'HON') AS is_honors,
                BOOL_OR(attribute_code IN ('AI', 'CP', 'EN', 'FA', 'FL', 'GC', 'HU', 'IL', 'LAB', 'LS', 'MA', 'PS',
                                           'SS')) AS is_general_education
         FROM cte_course_attributes
         GROUP BY term_id, course_registration_number),

     cte_college_abbrv AS (
/* Pulls distinct college abbreviations from academic_programs table */
         SELECT DISTINCT college_id,
                         college_abbrv
         FROM export.academic_programs),

     cte_section_summary AS (
/* Pulls distinct section information from student_section_version table for enrolled students to get one row per
   (term_id, course_reference_number and version indicators)*/
         SELECT DISTINCT term_id,
                         course_reference_number,
                         subject_code,
                         course_number,
                         section_number,
                         course_id,
                         course_level_id,
                         CASE
                             WHEN course_level_id = 'UG' THEN 'Undergraduate'
                             WHEN course_level_id = 'GR' THEN 'Graduate'
                             ELSE course_level_id
                             END AS course_level_desc,
                         budget_code,
                         CASE
                             WHEN budget_code LIKE 'B%' THEN 'Budget-Related'
                             WHEN budget_code LIKE 'S%' THEN 'Self-Support'
                             ELSE budget_code
                             END AS budgetrel_selfsup,
                         section_format_type_code,
                         section_format_type_desc,
                         instruction_method_code,
                         instruction_method_desc,
                         campus_id,
                         CASE
                             WHEN campus_id IN ('A01', 'AC1', 'AU1', 'ACE', 'OU1') THEN 'Main Campus'
                             WHEN campus_id LIKE 'B%' THEN 'Hurricane Center'
                             WHEN campus_id LIKE 'C%' OR campus_id = 'UOS' THEN 'High School Site'
                             WHEN campus_id = 'O03' THEN 'Other Site'
                             WHEN campus_id IN ('O01', 'V01') THEN 'Online or Virtual'
                             WHEN campus_id LIKE 'I%' THEN 'Out of Country Site'
                             WHEN campus_id = 'H' THEN 'Other Leased Site'
                             WHEN campus_id = 'Z' THEN 'Out of State Site'
                             ELSE campus_id
                             END AS campus_id_desc,
                         class_size,
                         version_snapshot_id,
                         is_census_version,
                         is_end_of_term_version
         FROM export.student_section_version
         WHERE is_enrolled
           AND campus_id <> 'XXX'
           AND version_desc <> 'Current'
           AND term_id >= '201940')

SELECT a.term_id,
       b.term_desc,
       b.season,
       SUBSTRING(a.term_id, 1, 4) AS year,
       b.academic_year_code,
       a.subject_code,
       a.course_number,
       a.section_number,
       a.course_reference_number,
       c.course_title,
       c.course_desc,
       a.course_level_id,
       a.course_level_desc,
       a.budget_code,
       a.budgetrel_selfsup,
       a.section_format_type_code,
       a.section_format_type_desc,
       a.instruction_method_code,
       a.instruction_method_desc,
       a.campus_id,
       a.campus_id_desc,
       a.class_size,
       a.version_snapshot_id,
       a.is_census_version,
       a.is_end_of_term_version,
       c.program_type,
       CASE
           WHEN c.program_type = 'A' THEN 'Academic'
           WHEN c.program_type = 'P' THEN 'Apprentice'
           WHEN c.program_type = 'V' THEN 'Vocational'
           ELSE c.program_type
           END AS program_type_desc,
       d.college_abbrv,
       d.college_id,
       c.academic_department_id,
       COALESCE(e.is_supp_inst, FALSE) AS is_supp_inst,
       COALESCE(e.is_zero_cost_text, FALSE) AS is_zero_cost_text,
       COALESCE(e.is_honors, FALSE) AS is_honors,
       COALESCE(e.is_general_education, FALSE) AS is_general_education
FROM cte_section_summary a
         LEFT JOIN export.term b
                   ON a.term_id = b.term_id
         LEFT JOIN export.course_version c
                   ON a.course_id = c.course_id
                       AND a.version_snapshot_id = c.version_snapshot_id
         LEFT JOIN cte_college_abbrv d
                   ON c.college_id = d.college_id
         LEFT JOIN cte_selected_attributes e
                   ON a.term_id = e.term_id
                       AND a.course_reference_number = e.course_registration_number
WHERE DATE_PART('year', NOW()) - b.academic_year_code::INT <= 5

