--DSCIR FTE

SELECT ( -- FTE - Undergraduate Level
                  SELECT round(sum(sc_att_cr)/15 + sum(nvl(sc_contact_hrs,0))/45,2)
                  FROM   student_courses sc, courses c
                  WHERE  sc.dsc_crn   = c.dc_crn
                  AND    sc.dsc_term_code = c.dsc_term_code
                  AND    sc.dsc_term_code = '202143'
                  AND    c_level != 'G'
              )+(
                  -- FTE - Graduate Level
                  SELECT nvl(round(sum(sc_att_cr)/10 + sum(nvl(sc_contact_hrs,0))/45,2),0)
                  FROM   student_courses sc, courses c
                  WHERE  sc.dsc_crn   = c.dc_crn
                  AND    sc.dsc_term_code = c.dsc_term_code
                  AND    sc.dsc_term_code = '202143'
                  AND    c_level = 'G'
                ) AS FTE
        FROM    DUAL;

SELECT ( -- FTE - Undergraduate Level
                  SELECT round(sum(sc_att_cr)/15)
                  FROM   student_courses sc, courses c
                  WHERE  sc.dsc_crn   = c.dc_crn
                  AND    sc.dsc_term_code = c.dsc_term_code
                  AND    sc.dsc_term_code = '202143'
                  AND    c_level != 'G'
              )+(
                  -- FTE - Graduate Level
                  SELECT round(sum(sc_att_cr)/10)
                  FROM   student_courses sc, courses c
                  WHERE  sc.dsc_crn   = c.dc_crn
                  AND    sc.dsc_term_code = c.dsc_term_code
                  AND    sc.dsc_term_code = '202143'
                  AND    c_level = 'G'
                ) AS FTE
        FROM    DUAL;


