          /* Graduation Validation Query */
            SELECT a.student_id,
                   a.sis_system_id,
                   a.program_code as primary_program_id,
                   c.dixie_ssn AS ssn,
                   c.last_name,
                   c.first_name,
                   c.middle_name,
                   c.name_suffix,
                   c.first_admit_county_code,
                   c.birth_date,
                   c.gender_code,
                   c.ipeds_race_ethnicity,
                   c.ethnicity_code,
                   c.ethnicity_desc,
                   c.is_hispanic_latino_ethnicity,
                   c.is_asian,
                   c.is_black,
                   c.is_american_indian_alaskan,
                   c.is_hawaiian_pacific_islander,
                   c.is_white,
                   c.is_international,
                   c.is_other_race,
                   a.graduation_date,
                   a.primary_major_cip_code,
                   a.degree_id,
                   a.cumulative_graduation_gpa,
                   b.transfer_cumulative_credits_earned,
                   b.total_cumulative_ap_credits_earned,
                   b.total_cumulative_clep_credits_earned,
                   b.overall_cumulative_credits_earned,
                   a.total_remedial_hours,
                   a.total_cumulative_credits_attempted_other_sources,
                   a.previous_degree_type, -- add to export
                   d.ipeds_award_level_code,
                   d.required_credits,
                   c.latest_high_school_code AS high_school_code,
                   a.graduated_academic_year_code,
                   a.graduated_term_id AS term_id,
                   e.term_type AS season,
                   a.primary_major_college_desc,
                   a.primary_major_desc,
                   a.degree_desc,
            -- TODO: Add activity dates here
                   a.shrdgmr_activity_date,
                   b.shrtgpa_activity_date,
                   b.stvmajr_activity_date,
                   c.sabsupl_activity_date,
                   c.spriden_activity_date,
                   c.goradid_activity_date,
                   c.spbpers_activity_date,
                   d.gorsdav_activity_date
              FROM quad.student_degree_program_application a
         LEFT JOIN quad.student_term_level b
                ON b.student_id = a.student_id
               AND b.level_id = a.level_id
               AND b.term_id = a.graduated_term_id
         LEFT JOIN quad.student c
                ON c.student_id = a.student_id
        LEFT JOIN quad.supplemental_programs d
               ON d.program_id = a.program_code
           LEFT JOIN quad.term e
                   ON e.term_id = a.graduated_term_id
             WHERE a.degree_status_code = 'AW'
               AND EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM graduation_date) <= 5; -- Past 5 years
