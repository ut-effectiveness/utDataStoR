#' Generate FTE SQL
#' `r lifecycle::badge("deprecated")`
#'
#' `sql_fte` was intended to generate the standard sql query for pulling FTE from Edify, REPT
#' of DSCIR. We have deprecated this function and will use "make_fte_sql()" instead.
#'
#' @param data_source The server to pull FTE data from. Options are: "Edify", "REPT", or "DSCIR". Defaults to "Edify".
#' @param name The name you want the SQL file to have in your sql folder. This is a string and must be provided in quotes
#' (e.g., "your_filename.sql").
#'
#' @return A sql file in your SQL folder
#' @export
#'

sql_fte <- function(data_source = 'Edify', name) {

  base <- system.file('sql', package='utDataStoR')

  file <- paste(
    base,
    '/',
    'fte',
    '/',
    'fte_off_edify.sql',
    sep = ''
  )

  fs::file_copy(
    file,
    here::here('sql', name))

  warning("This function has been deprecated and is no longer supported.
    Please use the 'make_fte_sql' function instead for improved functionality and support.")
}
