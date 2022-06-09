
    WITH FTEUG AS (
  SELECT ROUND(SUM(registered_credits)/15) AS FTE,
          term_id,
          term_desc AS Term
     FROM export.student_term_level
    WHERE is_enrolled
      AND term_id BETWEEN '201440' AND '202240'
      AND level_id = 'UG'
      AND is_primary_level
 GROUP BY term_id, term_desc
 ),

 FTEG AS (SELECT ROUND(SUM(registered_credits)/10) AS FTE,
         term_id,
         term_desc AS Term
    FROM export.student_term_level
   WHERE is_enrolled
     AND term_id BETWEEN '201440' AND '202240'
     AND level_id = 'GR'
     AND is_primary_level
GROUP BY term_id, term_desc)

  SELECT FTEUG.term,
         SUM(FTEUG.fte + COALESCE(FTEG.fte, 0)) AS FTE
     FROM fteug
LEFT JOIN fteg
       ON FTEUG.term_id = FTEG.term_id
    WHERE FTEUG.term_id BETWEEN '201440' AND '202240'
GROUP BY FTEUG.term;