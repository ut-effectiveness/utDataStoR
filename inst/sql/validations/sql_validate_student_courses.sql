               /* Student Course Validation Query */
               SELECT a.term_id,
                      a.student_id,
                      a.sis_system_id,
                      b.dixie_ssn AS ssn,
                      a.subject_code,
                      a.course_number,
                      a.section_number,
                      a.attempted_credits,
                      a.earned_credits,
                      a.contact_hours,
                      a.part_term_weeks,
                      a.final_grade,
                      b.latest_high_school_code,
                      a.budget_code,
                      a.attribute_code,
                      a.attribute_desc,
                      a.course_reference_number,
                      a.course_level_id,
               -- TODO Add activity dates here
                      a.ssbsect_activity_date
                 FROM quad.student_section a
            LEFT JOIN quad.student b ON b.student_id = a.student_id
                WHERE a.is_enrolled = TRUE
                  AND a.term_id >= (SELECT term_id FROM quad.term WHERE is_previous_term)
             ORDER BY a.student_id,
                      a.course_reference_number;
