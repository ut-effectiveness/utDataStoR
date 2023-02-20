#' Generate Retention Sql
#'
#' `make_retention_sql` will generate the standard sql query for pulling retention
#' data from Edify
#'
#' @param name The name you want the SQL file to have in your sql folder.
#' @param type The type of retention file you want. Defaults to 'term_to_term'.
#'
#' The type parameter should be
#' term_to_term
#' cohort
#'
#' @return A sql file in your SQL folder
#' @export
#'

make_retention_sql <- function(name, type = 'term_to_term') {

  if (type == 'term_to_term') {
    file = 'term_to_term_retention.sql'
  } else if (type == 'cohort') {
    file = 'cohort_retention.sql'
  } else {
    message("It doesn't look like we have that type yet.",
            "We currently support 'term_to_term' and 'cohort'.",
            "If you would like to add another query for retention,",
            "please bring this up at code review.")
  }

  fs::file_copy(here::here('inst', 'sql', file),
                here::here('sql', name))
}
