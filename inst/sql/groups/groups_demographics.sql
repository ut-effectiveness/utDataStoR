/*
Demographic Groups
*/
SELECT a.student_id,
       CASE
           WHEN a.gender_code = 'M' THEN 'Male'
           WHEN a.gender_code = 'F' THEN 'Female'
           ELSE 'Unspecified'
           END AS gender_desc,
       a.ipeds_race_ethnicity,
       a.us_citizenship_desc,
       a.is_international,
       CASE
              WHEN EXTRACT(YEAR from AGE(current_date, a.birth_date)) < 18 THEN 'less than 18'
              WHEN EXTRACT(YEAR from AGE(current_date, a.birth_date)) BETWEEN 18 and 24 THEN '18 to 24'
              WHEN EXTRACT(YEAR from AGE(current_date, a.birth_date)) BETWEEN 25 and 34 THEN '25 to 34'
              WHEN EXTRACT(YEAR from AGE(current_date, a.birth_date)) BETWEEN 35 and 44 THEN '35 to 44'
              WHEN EXTRACT(YEAR from AGE(current_date, a.birth_date)) BETWEEN 45 and 59 THEN '45 to 59'
              WHEN EXTRACT(YEAR from AGE(current_date, a.birth_date)) > 59 THEN '60 plus'
              ELSE 'error'
          END AS age_band,
       a.is_first_generation,
       a.is_athlete,
       a.is_veteran,
       a.first_admit_country_desc,
       a.first_admit_state_desc,
       a.first_admit_county_desc
  FROM export.student a
