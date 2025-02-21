/*
Banner FTE
Approved on
This SQL query calculates Full-Time Equivalent (FTE) values for graduate, undergraduate, and total students enrolled
for a specific term (see where statement)
Does not include any fte for CE - Continuing Education courses
It excludes test students using the cte_test_users (see the where statement e.twgrrole_role IS NULL)
*/

WITH CTE_graduate_fte AS
    /*
     This CTE pulls the graduate level fte for enrolled students
     */
    (SELECT ROUND(SUM(a.sfrstcr_credit_hr)/10, 2)  AS graduate_fte, -- FTE - Graduate Level
            b.stvterm_desc,
            a.sfrstcr_term_code
     FROM saturn.sfrstcr a
         LEFT JOIN saturn.stvterm b
             ON b.stvterm_code = a.sfrstcr_term_code
     WHERE a.sfrstcr_levl_code = 'GR'
       AND a.sfrstcr_camp_code != 'XXX'
       AND a.sfrstcr_rsts_code IN (SELECT a1.stvrsts_code
                                   FROM saturn.stvrsts a1
                                   WHERE a1.stvrsts_incl_sect_enrl = 'Y')
     GROUP BY b.stvterm_desc, a.sfrstcr_term_code),

CTE_undergrad_fte AS
    /*
     This CTE pulls the undergraduate level fte for enrolled students
     */
    (SELECT ROUND(SUM(a.sfrstcr_credit_hr)/15, 2)  AS undergrad_fte,  --FTE - Undergraduate Level
            b.stvterm_desc,
            a.sfrstcr_term_code
     FROM saturn.sfrstcr a
         LEFT JOIN saturn.stvterm b
             ON b.stvterm_code = a.sfrstcr_term_code
     WHERE a.sfrstcr_levl_code = 'UG'
       AND a.sfrstcr_camp_code != 'XXX'
       AND a.sfrstcr_rsts_code IN (SELECT a1.stvrsts_code
                                   FROM saturn.stvrsts a1
                                   WHERE a1.stvrsts_incl_sect_enrl = 'Y')
     GROUP BY b.stvterm_desc, a.sfrstcr_term_code),

cte_test_users AS
    /*
     This CTE pulls test students (so they can be removed, see the where statement)
     */
    (SELECT a.twgrrole_pidm,
                               a.twgrrole_role
                        FROM twgrrole a
                        WHERE a.twgrrole_role = 'TESTUSER')

SELECT a.sfrstcr_term_code,
       b.stvterm_desc,
       COALESCE(d.undergrad_fte, 0) AS undergrad_fte,
       COALESCE(c.graduate_fte, 0) AS graduate_fte,
       ROUND(COALESCE(c.graduate_fte, 0) + COALESCE(d.undergrad_fte, 0), 2) AS total_fte
FROM saturn.sfrstcr a
         LEFT JOIN saturn.stvterm b
                   ON b.stvterm_code = sfrstcr_term_code
         LEFT JOIN CTE_graduate_fte c
                   ON c.sfrstcr_term_code = a.sfrstcr_term_code
         LEFT JOIN CTE_undergrad_fte d
                   ON d.sfrstcr_term_code = a.sfrstcr_term_code
         LEFT JOIN cte_test_users e
                   ON e.twgrrole_pidm = a.sfrstcr_pidm
WHERE a.sfrstcr_term_code = '202420' -- change to desired term
AND e.twgrrole_role IS NULL -- removes test users
GROUP BY a.sfrstcr_term_code, b.stvterm_desc, c.graduate_fte, d.undergrad_fte;
