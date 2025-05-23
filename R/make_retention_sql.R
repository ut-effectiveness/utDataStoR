#' `make_retention_sql` will generate the standard SQL query for pulling retention
#' data from Edify. This function helps in retrieving data related to student retention metrics.
#' To specify the type of retention data you would like, use the `type` parameter.
#' `r lifecycle::badge("stable")`
#'
#' @param name The name you want the SQL file to have in your sql folder. This is a string and must be provided in quotes
#' (e.g., "your_filename.sql").
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
    system_file <- 'term_to_term_retention.sql'
  } else if (type == 'cohort') {
    system_file <- 'cohort_retention.sql'
  } else {
    stop("It doesn't look like we have that type yet. ",
         "We currently support 'term_to_term' and 'cohort'. ",
         "If you would like to add another query for retention, ",
         "please bring this up at code review.")
  }

  base <- system.file('sql', package='utDataStoR')

  file <- paste(
    base,
    '/',
    'retention',
    '/',
    system_file,
    sep = ''
  )

  fs::file_copy(
    file,
    here::here('sql', name))

}
