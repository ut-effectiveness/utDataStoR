/*
This SQL query calculates IPEDS 12 Month Enrollment FTE.

-- IPEDS - based on 24 UG and 30 GR And is based on Census

The total attempted credits for UG and GR are summed then divided
by 24 for Undergraduate and 30 for Graduate to create FTE for
each level.

The totals for Undergraduate FTE and Graduate FTE are added together to
get the 12 Month Enrollment FTE by academic year.
*/

WITH CTE_combined_twelve_month_fte AS (
    SELECT
        b.academic_year_code,
        b.academic_year_desc,
        ROUND(SUM(CASE
                       WHEN a.course_level_id = 'GR'
                       THEN a.attempted_credits
                       ELSE 0 END) / 24, 0) AS census_graduate_twelve_month_fte,
        ROUND(SUM(CASE
                       WHEN a.course_level_id = 'UG'
                       THEN a.attempted_credits
                       ELSE 0 END) / 30, 0) AS census_undergrad_twelve_month_fte
    FROM
        export.student_section_version a
    LEFT JOIN
        export.term b
           ON a.term_id = b.term_id
    WHERE a.is_enrolled IS TRUE
      AND a.version_desc = 'Census'
 GROUP BY b.academic_year_desc, b.academic_year_code
)
SELECT a.academic_year_desc,
    a.academic_year_code,
    a.census_graduate_twelve_month_fte,
    a.census_undergrad_twelve_month_fte,
    (a.census_graduate_twelve_month_fte + a.census_undergrad_twelve_month_fte) AS total_census_twelve_month_fte
FROM
    CTE_combined_twelve_month_fte a
WHERE DATE_PART('year', NOW()) - a.academic_year_code :: INT <= 5
GROUP BY a.academic_year_desc, a.academic_year_code, a.census_graduate_twelve_month_fte, a.census_undergrad_twelve_month_fte
ORDER BY a.academic_year_desc , academic_year_code;
