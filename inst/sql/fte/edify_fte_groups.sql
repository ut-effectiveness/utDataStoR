/*
Edify FTE Groups
This SQL query calculates the Full-Time Equivalent (FTE) values for graduate, undergraduate, and total students enrolled
in courses at Census over the last 5 years.
Does not include any FTE for CE - Continuing Education courses
This query combines two CTE's. cte_enrolled_snapshot provides student student demographic and term based data on students who were enrolled the last 5 years.
cte_student_course_snapshot provides the courses, course demographics and fte associated with each course over the last 5 years.
 */

WITH cte_enrolled_snapshot AS
         /*
          This CTE provides student demographic and term based data on students who were enrolled over the last 5 years.
          */
         (WITH cte_five_years_ago AS
                   /*
                    This CTE takes the current year minus the academic year if the result is greater than or equal to 5, then it provides term data.
                    */
                   (SELECT term_id,
                           term_desc,
                           SUBSTRING(term_id, 1, 4) AS year,
                           season
                    FROM export.term
                    WHERE DATE_PART('year', NOW()) - academic_year_code :: INT <= 5),

               cte_student_demo AS
                   /*
                    This CTE provides demographic data from the student_version table.
                    */
                   (SELECT g.student_id,
                           g.gender_code,
                           CASE
                               WHEN gender_code = 'M' THEN 'Male'
                               WHEN gender_code = 'F' THEN 'Female'
                               ELSE 'Unspecified'
                               END AS gender_desc,
                           g.ipeds_race_ethnicity,
                           CASE
                               WHEN g.ipeds_race_ethnicity = 'American Indian/Alaskan'
                                   THEN 'Minority'
                               WHEN g.ipeds_race_ethnicity = 'Asian'
                                   THEN 'Minority'
                               WHEN g.ipeds_race_ethnicity = 'Black/African American'
                                   THEN 'Minority'
                               WHEN g.ipeds_race_ethnicity = 'Hawaiian/Pacific Islander'
                                   THEN 'Minority'
                               WHEN g.ipeds_race_ethnicity = 'Hispanic'
                                   THEN 'Minority'
                               WHEN g.ipeds_race_ethnicity = 'Multiracial'
                                   THEN 'Minority'
                               ELSE 'Non-minority'
                               END AS minority,
                           g.us_citizenship_desc,
                           g.is_international,
                           CASE
                               WHEN EXTRACT(YEAR from AGE(current_date, g.birth_date)) < 18
                                   THEN 'less than 18'
                               WHEN EXTRACT(YEAR from AGE(current_date, g.birth_date)) BETWEEN 18 and 24
                                   THEN '18 to 24'
                               WHEN EXTRACT(YEAR from AGE(current_date, g.birth_date)) BETWEEN 25 and 34
                                   THEN '25 to 34'
                               WHEN EXTRACT(YEAR from AGE(current_date, g.birth_date)) BETWEEN 35 and 44
                                   THEN '35 to 44'
                               WHEN EXTRACT(YEAR from AGE(current_date, g.birth_date)) BETWEEN 45 and 59
                                   THEN '45 to 59'
                               WHEN EXTRACT(YEAR from AGE(current_date, g.birth_date)) > 59
                                   THEN '60 plus'
                               ELSE 'error'
                               END AS age_band,
                           g.is_first_generation,
                           g.is_veteran,
                           g.first_admit_country_desc,
                           g.first_admit_state_desc,
                           g.first_admit_county_desc,
                           g.version_snapshot_id
                    FROM export.student_version g)

          SELECT d.term_id,
                 a.term_desc,
                 a.season,
                 a.year,
                 d.version_desc,
                 d.version_snapshot_id,
                 d.student_id,
                 d.residency_code,
                 CASE
                     WHEN d.residency_code = 'R' THEN 'Resident'
                     WHEN d.residency_code = 'A' THEN 'Resident'
                     WHEN d.residency_code = 'B' THEN 'Resident'
                     WHEN d.residency_code = 'C' THEN 'Resident'
                     WHEN d.residency_code = 'M' THEN 'Resident'
                     WHEN d.residency_code = 'N' THEN 'Non-Resident'
                     WHEN d.residency_code = 'G' THEN 'Non-Resident'
                     WHEN d.residency_code = 'H' THEN 'Non-Resident'
                     ELSE 'Unknown'
                     END AS residency,
                 d.residency_in_state_desc,
                 d.is_degree_seeking,
                 d.student_type_desc,
                 d.is_online_program_student,
                 g.gender_desc,
                 g.ipeds_race_ethnicity,
                 g.minority,
                 g.us_citizenship_desc,
                 g.is_international,
                 g.age_band,
                 g.is_first_generation,
                 g.is_veteran,
                 g.first_admit_country_desc,
                 g.first_admit_state_desc,
                 g.first_admit_county_desc
          FROM export.student_term_level_version d
                   INNER JOIN cte_five_years_ago a
                              ON d.term_id = a.term_id
                   LEFT JOIN cte_student_demo g
                             ON d.version_snapshot_id = g.version_snapshot_id
                                 AND d.student_id = g.student_id
          WHERE d.version_desc = 'Census'
            AND d.is_enrolled = TRUE
            AND d.is_primary_level = TRUE),

     cte_student_course_snapshot AS
         /*
          This CTE provides the courses, course demographics and fte associated with each course for the last 5 years.
          */
         (WITH cte_five_years_ago AS
                   /*
                    This CTE takes the current year minus the academic year if the result is greater than or equal to 5, then it provides term data.
                    */
                   (SELECT term_id,
                           term_desc,
                           season
                    FROM export.term
                    WHERE DATE_PART('year', NOW()) - academic_year_code :: INT <= 5),

               cte_college_abbrv AS
                   /*
                    This CTE provides a distinct list of college id's and abbreviations.
                    */
                   (SELECT DISTINCT college_id, college_abbrv
                    FROM export.academic_programs)

          SELECT b.term_id,
                 a.term_desc,
                 a.season,
                 b.version_snapshot_id,
                 b.version_desc,
                 b.student_id,
                 b.attempted_credits,
                 CASE
                     WHEN b.course_level_id = 'GR' THEN b.attempted_credits / 10
                     WHEN b.course_level_id = 'UG' THEN b.attempted_credits / 15
                     END AS fte,
                 b.course_level_id,
                 c.college_abbrv,
                 b.academic_department_id,
                 b.subject_code,
                 b.course_number,
                 b.section_number,
                 b.course_reference_number,
                 b.section_format_type_desc,
                 b.instruction_method_desc,
                 b.budget_code,
                 CASE
                     WHEN b.budget_code = 'BA' THEN 'Budget-Related'
                     WHEN b.budget_code = 'BC' THEN 'Budget-Related'
                     WHEN b.budget_code = 'BU' THEN 'Budget-Related'
                     WHEN b.budget_code = 'SD' THEN 'Self-Support'
                     WHEN b.budget_code = 'SF' THEN 'Self-Support'
                     WHEN b.budget_code = 'SM' THEN 'Self-Support'
                     ELSE 'Unknown'
                     END AS budget_desc
          FROM export.student_section_version b
                   INNER JOIN cte_five_years_ago a
                              ON b.term_id = a.term_id
                   LEFT JOIN cte_college_abbrv c
                             ON c.college_id = b.college_id
          WHERE b.version_desc = 'Census'
            AND b.is_enrolled = TRUE
            AND b.course_level_id IN ('GR', 'UG'))

SELECT e.term_id,
       e.term_desc,
       e.season,
       e.year,
       e.student_id,
       f.attempted_credits,
       f.fte,
       f.course_level_id,
       f.college_abbrv,
       f.academic_department_id,
       f.subject_code,
       f.course_number,
       f.section_number,
       f.course_reference_number,
       f.section_format_type_desc,
       f.instruction_method_desc,
       f.budget_code,
       f.budget_desc,
       e.residency_code,
       e.residency,
       e.residency_in_state_desc,
       e.is_online_program_student,
       e.is_degree_seeking,
       e.student_type_desc,
       e.gender_desc,
       e.ipeds_race_ethnicity,
       e.minority,
       e.us_citizenship_desc,
       e.is_international,
       e.age_band,
       e.is_first_generation,
       e.is_veteran,
       e.first_admit_country_desc,
       e.first_admit_state_desc,
       e.first_admit_county_desc,
       e.version_desc
FROM cte_enrolled_snapshot e
         LEFT JOIN cte_student_course_snapshot f
                   ON f.version_snapshot_id = e.version_snapshot_id
                       AND f.student_id = e.student_id
                       AND f.term_id = e.term_id
                       AND f.version_desc = e.version_desc
