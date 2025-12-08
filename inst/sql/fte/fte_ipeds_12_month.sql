/*IPEDS 12 Month Enrollment FTE
   Approved on: 20251119
   This query calculated the fte for both graduate and undergraduate students and then creates a total fte by academic
   year. Graduate FTE is calculated by summing the attempted credits for graduate students and dividing by 24,
   while Undergraduate FTE is calculated by summing the attempted credits for undergraduate students and dividing by 30.
   The final output includes academic year description, academic year code, graduate FTE, undergraduate FTE, and total
   FTE for each academic year.
 */
WITH cte_grad AS (
  /* Calculate graduate FTE based on attempted credits */
  SELECT
      b.academic_year_code,
      b.academic_year_desc,
      ROUND(
        SUM(COALESCE(a.attempted_credits, 0)) / 24.0 -- Full time Fall and Spring graduate credit load
      , 0)::int AS census_graduate_twelve_month_fte
  FROM export.student_section_version AS a
  JOIN export.term AS b
    ON a.term_id = b.term_id
  WHERE a.is_enrolled IS TRUE
    AND a.version_desc = 'Census'
    AND a.course_level_id = 'GR'
    AND (DATE_PART('year', NOW())::int - b.academic_year_code::int) <= 5 -- last 5 academic years relative to today
  GROUP BY b.academic_year_code, b.academic_year_desc
),
cte_ugrad AS (
    /* Calculate undergraduate FTE based on attempted credits */
  SELECT
      b.academic_year_code,
      b.academic_year_desc,
      ROUND(
        SUM(COALESCE(a.attempted_credits, 0)) / 30.0 -- Full time Fall and Spring undergraduate credit load
      , 0)::int AS census_undergrad_twelve_month_fte
  FROM export.student_section_version AS a
  JOIN export.term AS b
    ON a.term_id = b.term_id
  WHERE a.is_enrolled IS TRUE
    AND a.version_desc = 'Census'
    AND a.course_level_id = 'UG'
    AND (DATE_PART('year', NOW())::int - b.academic_year_code::int) <= 5 -- last 5 academic years relative to today
  GROUP BY b.academic_year_code, b.academic_year_desc
)
SELECT
    COALESCE(a.academic_year_desc, b.academic_year_desc)        AS academic_year_desc,
    COALESCE(a.academic_year_code, b.academic_year_code)        AS academic_year_code,
    a.census_graduate_twelve_month_fte,
    b.census_undergrad_twelve_month_fte,
    (COALESCE(a.census_graduate_twelve_month_fte, 0)
     + COALESCE(b.census_undergrad_twelve_month_fte, 0))        AS total_census_twelve_month_fte
FROM cte_grad AS a
FULL OUTER JOIN cte_ugrad AS b
  ON b.academic_year_code = a.academic_year_code
ORDER BY COALESCE(a.academic_year_code, b.academic_year_code)::int,
         COALESCE(a.academic_year_desc, b.academic_year_desc);
