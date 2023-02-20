SELECT a.term_id,
       a.term_desc,
       a.term_start_date,
       a.census_date,
       a.academic_year_code,
       a.academic_year_desc
  FROM term a
 WHERE CAST(a.term_id AS INT) BETWEEN 201840 AND 202240
   AND RIGHT(a.term_id, 2) IN ('20', '40')
