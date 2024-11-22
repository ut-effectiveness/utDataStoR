#' Generate fte sql
#'
#' `make_fte_sql` function will generate the standard SQL query for pulling Full-Time
#' Equivalent (FTE) data from Edify.This function allows users to retrieve FTE data based on
#' different available data sources. Use the `type` parameter to select the specific FTE data
#' type. Available options are: "current", "census" and "eot" (end of term). For more details see
#' the fte (full time quivalent) vignette. You can bring this up by running the following code in
#' your console: \code{vignette("full_time_equivalent", package = "utDataStoR")}
#'
#' @param name The name you want the SQL file to have in your sql folder. This is a string and
#' must be provided in quotes (e.g., "your_filename.sql").
#' @param type The type of fte file you want. Defaults to 'current' fte data.
#' Other options are
#' * 'current' -- data as of the current snapshot
#' * 'census_demographic' -- fte data with demographic data, as of census snapshot
#' * 'eot' -- data as of the end of term snapshot
#'
#' @return A sql file in your SQL folder
#' @export
#' @importFrom here here
#' @importFrom fs file_copy
#'
#' @examples
make_fte_sql <- function(name, type = 'current') {

  if (type == 'current') {
    system_file <- 'fte_total_current.sql'
  } else if (type == 'census') {
    system_file <- 'fte_total_census.sql'
  } else if (type == 'eot') {
    system_file <- 'fte_total_end_of_term.sql'
  } else {
    stop("It doesn't look like we have that type yet. ",
         "We currently support fte for the following: 'census', 'current', 'end-of-term'.",
         "If you would like to add another query for fte, ",
         "please bring this up at code review.")
  }

  base <- system.file('sql', package='utDataStoR')

  file <- paste(
    base,
    '/',
    'fte',
    '/',
    system_file,
    sep = ''
  )

  fs::file_copy(
    file,
    here::here('sql', name))

}
