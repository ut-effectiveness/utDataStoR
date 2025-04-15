--USHE Graduation Submission File

/* Graduation Snapshot from Export SQL */

SELECT a.student_id,
       c.ssid,
       c.last_name,
       c.first_name,
       c.middle_name,
       c.name_suffix,
       c.first_admit_county_code,
       c.first_admit_state_code,
       c.first_admit_country_iso_code,
       c.first_admit_country_code,
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
       a.is_highest_degree_awarded,
       a.primary_major_cip_code,
       a.degree_id    AS primary_degree_id,
       a.degree_status_code,
       a.cumulative_graduation_gpa,
       b.transfer_cumulative_credits_earned,
       b.total_cumulative_ap_credits_earned,
       b.total_cumulative_clep_credits_earned,
       a.overall_cumulative_credits_earned,
       a.total_remedial_hours,
       a.level_id,
       a.total_cumulative_credits_attempted_other_sources,
       a.previous_degree_type,
       d.ipeds_award_level_code,
       d.required_credits,
       c.high_school_code,
       a.graduated_academic_year_code,
       a.graduated_term_id,
       e.financial_aid_year_id,
       e.season,
       d.college_desc,
       a.primary_major_desc,
       a.primary_major_id,
       d.college_abbrv,
       a.degree_desc,
       e.academic_year_code,
       a.is_graduated,
       a.program_code AS primary_program_id,
       d.major_desc
FROM export.student_degree_program_application_version a
         LEFT JOIN export.student_term_level_graduate_version b
                   ON b.student_id = a.student_id
                       AND b.level_id = a.level_id
                       AND b.term_id = a.graduated_term_id
         LEFT JOIN export.student c
                   ON c.student_id = a.student_id
         LEFT JOIN export.academic_programs d
                   ON d.program_id = a.program_code
         LEFT JOIN export.term e
                   ON e.term_id = a.graduated_term_id
WHERE a.degree_status_code = 'AW'
  AND EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM a.graduation_date) <= 5; -- Past 5 years

