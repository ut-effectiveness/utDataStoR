WITH FTEUG AS (
    SELECT ROUND(SUM(sfrstcr_credit_hr)/15)  AS FTE, -- FTE - Undergraduate Level
                 stvterm_desc,
                 sfrstcr_term_code
           FROM sfrstcr a
      LEFT JOIN saturn.sgbstdn b
             ON b.sgbstdn_pidm = a.sfrstcr_pidm
             AND b.sgbstdn_term_code_eff = (SELECT MAX(b1.sgbstdn_term_code_eff)
                                              FROM saturn.sgbstdn b1
                                             WHERE b1.sgbstdn_pidm = b.sgbstdn_pidm
                                               AND b1.sgbstdn_term_code_eff <= a.sfrstcr_term_code)
           INNER JOIN stvterm aa
           ON a.sfrstcr_term_code = aa.stvterm_code
          WHERE sgbstdn_levl_code = 'UG'
            AND sfrstcr_term_code BETWEEN '201440' AND '202240'
            AND a.sfrstcr_camp_code != 'XXX'
            AND a.sfrstcr_rsts_code IN (SELECT a1.stvrsts_code
                                          FROM saturn.stvrsts a1
                                         WHERE a1.stvrsts_incl_sect_enrl = 'Y')
       GROUP BY stvterm_desc, sfrstcr_term_code
),
    FTEG AS (SELECT ROUND(SUM(sfrstcr_credit_hr)/10)  AS FTE, -- FTE - Graduate Level
                 stvterm_desc
           FROM sfrstcr a
                LEFT JOIN saturn.sgbstdn b
                       ON b.sgbstdn_pidm = a.sfrstcr_pidm
                      AND b.sgbstdn_term_code_eff = (SELECT MAX(b1.sgbstdn_term_code_eff)
                                              FROM saturn.sgbstdn b1
                                             WHERE b1.sgbstdn_pidm = b.sgbstdn_pidm
                                               AND b1.sgbstdn_term_code_eff <= a.sfrstcr_term_code)
           INNER JOIN stvterm bb
                  ON a.sfrstcr_term_code = bb.stvterm_code
          WHERE sfrstcr_levl_code = 'GR'
            AND sfrstcr_term_code BETWEEN '201440' AND '202240'
            AND sfrstcr_camp_code != 'XXX'
            AND sfrstcr_rsts_code IN (SELECT a1.stvrsts_code
                                 FROM saturn.stvrsts a1
                                WHERE a1.stvrsts_incl_sect_enrl = 'Y')
       GROUP BY stvterm_desc)
SELECT FTEUG.stvterm_desc as Term,
       SUM(FTEUG.fte + COALESCE(FTEG.fte, 0)) AS FTE
  FROM fteug
LEFT JOIN fteg
       ON FTEG.stvterm_desc = FTEUG.stvterm_desc
  WHERE sfrstcr_term_code BETWEEN '201440' AND '202240'
GROUP BY FTEUG.stvterm_desc;