/*
Banner Headcount query
Approved on 20230719
This query pulls enrolled students for a specific term (see where a.sfrstcr_term_code =)
and removes any test students enrolled (see the cte query and the where b.twgrrole IS NULL)
note that the a.sfrstcr_camp_code is not XXX or ACE
this query provides an unduplicated count of enrolled students by term
this query is the equivalent of Edify headcount current if ran on REPT and for the same term
 */

WITH basic_headcount AS (SELECT DISTINCT a.sfrstcr_term_code,
                                         a.sfrstcr_pidm
                         FROM saturn.sfrstcr a
                         WHERE a.sfrstcr_rsts_code IN (SELECT a1.stvrsts_code
                                                       FROM saturn.stvrsts a1
                                                       WHERE a1.stvrsts_incl_sect_enrl = 'Y')
                           AND (a.sfrstcr_camp_code NOT IN ('XXX', 'ACE'))),
     cte_test_users AS (SELECT a.twgrrole_pidm,
                               a.twgrrole_role
                        FROM twgrrole a
                        WHERE a.twgrrole_role = 'TESTUSER')
SELECT a.sfrstcr_term_code,
      COUNT(a.sfrstcr_pidm)
FROM basic_headcount a
LEFT JOIN cte_test_users b ON b.twgrrole_pidm = a.sfrstcr_pidm
WHERE a.sfrstcr_term_code = '202440' -- change to desired term
AND b.twgrrole_role IS NULL -- removes test users
GROUP BY a.sfrstcr_term_code;
