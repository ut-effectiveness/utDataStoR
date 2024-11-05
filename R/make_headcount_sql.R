#' Generate headcount Sql
#'
#' `make_headcount_sql` will generate a standard sql query for pulling headcount
#' data from Edify. This function is often used with the function [utHelpR::uth_make_outcome_count] to
#' produce pivot tables with headcount numbers. There are several types of headcounts
#' to choose from. To specify the type of headcount you would like, use the type parameter.
#' If you have questions about which version you should use in your report, please
#' contact Joy Lindsay. For more details see the headcount vignette. You can bring this
#' up by running the following code in your console.
#' \code{vignette("headcount", package = "utDataStoR")}
#'
#'
#' @param name The name you want the SQL file to have in your sql folder. This is a string and must be provided in quotes
#' (e.g., "your_filename.sql").
#' @param type The type of headcount file you want. Defaults to 'current' headcount data.
#' Other options are
#' * 'census' -- data as of the census snapshot
#' * 'census_demographic' -- headcount data with demographic data, as of census snapshot
#' * 'eot' -- data as of the end of term snapshot
#' * 'ipeds' -- data as it was reported to IPEDS
#' * 'pit' -- point in time data
#'
#' @return A sql file in your SQL folder
#' @export
#' @importFrom here here
#' @importFrom fs file_copy
#'
#'
make_headcount_sql <- function(name, type = 'current') {

  if (type == 'current') {
    system_file <- 'headcount_current.sql'
  } else if (type == 'census') {
    system_file <- 'headcount_census.sql'
  } else if (type == 'census_demographic') {
    system_file <- 'headcount_census_groups.sql'
  } else if (type == 'eot') {
    system_file <- 'headcount_end_of_term.sql'
  } else if (type == 'ipeds') {
    system_file <- 'headcount_ipeds_12_month.sql'
  } else if (type == 'pit') {
    system_file <- 'headcount_point_in_time.sql'
  } else {
    stop("It doesn't look like we have that type yet. ",
      "We currently support headcount for the following: 'census', 'current', 'end-of-term', 'ipeds', and 'point-in-time'.",
      "If you would like to add another query for headcount, ",
      "please bring this up at code review.")
  }

  base <- system.file('sql', package='utDataStoR')

  file <- paste(
    base,
    '/',
    'headcount',
    '/',
    system_file,
    sep = ''
  )

  fs::file_copy(
    file,
    here::here('sql', name))

}
