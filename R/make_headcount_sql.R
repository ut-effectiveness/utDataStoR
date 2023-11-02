#' Generate headcount Sql
#'
#' `make_headcount_sql` will generate the standard sql query for pulling headcount
#' data from Edify
#'
#' @param name The name you want the SQL file to have in your sql folder.
#' @param type The type of head count file you want. Defaults to 'current' headcount data.
#' Other options:
#' 'census' data collected at 3rd week,
#' 'eot' end of term data,
#' 'ipeds' data sent to IPEDS,
#' and 'pit' point in time data,
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
