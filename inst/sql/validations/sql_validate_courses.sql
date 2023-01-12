                            WITH course_attributes AS (SELECT DISTINCT ON (
                                scbcrse_subj_code,
                                scbcrse_crse_numb
                                ) scbcrse_subj_code,
                                  scbcrse_crse_numb,
                                  scbcrse_title,
                                  scbcrse_credit_hr_low,
                                  scbcrse_coll_code,
                                  scbcrse_dept_code
                             FROM banner.scbcrse
                            ORDER BY scbcrse_subj_code,
                                     scbcrse_crse_numb,
                                     scbcrse_eff_term DESC)

         /* Course Validation Query */
         SELECT DISTINCT
                      a.ssbsect_term_code AS term_id,
                      a.ssbsect_crse_numb AS course_number,
                      a.ssbsect_seq_numb AS section_number,
                      a.ssbsect_subj_code AS subject_code,
                      b.instructor_employee_id,
                      c.meet_building_id AS meet_building_id_1,
                      d.meet_building_id AS meet_building_id_2,
                      e.meet_building_id AS meet_building_id_3,
                      c.building_number AS building_number_1,
                      d.building_number AS building_number_2,
                      e.building_number AS building_number_3,
                      j.ssrsccd_sccd_code AS budget_code,
                      NULLIF(a.ssbsect_enrl, '') :: numeric AS class_size,
                      i.scbcrse_coll_code AS college_id,
                      NULLIF(a.ssbsect_cont_hr, '') :: numeric AS contact_hours,
                      c.meet_days AS meet_days_1,
                      d.meet_days AS meet_days_2,
                      e.meet_days AS meet_days_3,
                      NULLIF(a.ssbsect_insm_code, '') AS instruction_method_code,
                      i.scbcrse_dept_code AS academic_department_id,
                      c.meet_start_date,
                      c.meet_end_date,
                      g.first_name || ' ' || g.last_name AS instructor_name,
                      a.ssbsect_schd_code AS section_format_type_code,
                      COALESCE(f.course_max_credits, f.course_min_credits) AS course_max_credits,
                      f.course_min_credits,
                      f.program_type,
                      c.meet_room_number AS meet_room_number_1,
                      d.meet_room_number AS meet_room_number_2,
                      e.meet_room_number AS meet_room_number_3,
                      c.room_max_occupancy AS room_max_occupancy_1,
                      d.room_max_occupancy AS room_max_occupancy_2,
                      e.room_max_occupancy AS room_max_occupancy_3,
                      c.room_use_code AS room_use_code_1,
                      d.room_use_code AS room_use_code_2,
                      e.room_use_code AS room_use_code_3,
                      a.ssbsect_camp_code AS campus_id,
                      c.meet_start_time AS meet_start_time_1,
                      d.meet_start_time AS meet_start_time_2,
                      e.meet_start_time AS meet_start_time_3,
                      c.meet_end_time AS meet_end_time_1,
                      d.meet_end_time AS meet_end_time_2,
                      e.meet_end_time AS meet_end_time_3,
                      NULLIF(f.course_title, '') AS course_title,
                      a.ssbsect_crn AS course_reference_number,
                      a.ssbsect_activity_date,
                      c.ssrmeet_activity_date,
                      f.scbcrse_activity_date,
                      b.sirasgn_activity_date,
                      b.spriden_activity_date,
                      j.ssrsccd_activity_date,
                      COALESCE(c.bldg_activity_date, d.bldg_activity_date, e.bldg_activity_date) AS bldg_activity_date,
                      COALESCE(c.room_activity_date, d.room_activity_date, e.room_activity_date) AS room_activity_date
                 FROM banner.ssbsect a
            LEFT JOIN quad.section_instructor_assignment b
                   ON b.course_reference_number = a.ssbsect_crn
                  AND b.term_id = a.ssbsect_term_code
                  AND b.is_primary_instructor
         /* Pivot buildings and rooms on crn based on building_room_rank */
            LEFT JOIN quad.section_schedule c
                   ON c.course_reference_number = a.ssbsect_crn
                  AND c.term_id = a.ssbsect_term_code
                  AND c.building_room_rank = '1'
            LEFT JOIN quad.section_schedule d
                   ON d.course_reference_number = a.ssbsect_crn
                  AND d.term_id = a.ssbsect_term_code
                  AND d.building_room_rank = '2'
            LEFT JOIN quad.section_schedule e
                   ON e.course_reference_number = a.ssbsect_crn
                  AND e.term_id = a.ssbsect_term_code
                  AND e.building_room_rank = '3'
            LEFT JOIN quad.course f
                   ON f.course_number = a.ssbsect_crse_numb
                  AND f.subject_code = a.ssbsect_subj_code
            LEFT JOIN quad.employee g
                   ON g.employee_id = b.instructor_employee_id
            LEFT JOIN quad.term h
                   ON h.term_id = a.ssbsect_term_code
            LEFT JOIN course_attributes i
                   ON i.scbcrse_subj_code = a.ssbsect_subj_code
                  AND i.scbcrse_crse_numb = a.ssbsect_crse_numb
            LEFT JOIN banner.ssrsccd j ON j.ssrsccd_crn = a.ssbsect_crn
                  AND j.ssrsccd_term_code = a.ssbsect_term_code
                WHERE a.ssbsect_term_code >= (SELECT term_id FROM quad.term WHERE is_previous_term) -- Previous Term and forward
                  AND ssbsect_ssts_code = 'A'
                  AND ssbsect_subj_code NOT IN ('CED', 'CE');
