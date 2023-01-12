#' Generate Validation SQL
#'
#' `sql_validate_student` will generate the standard sql query for pulling Student Validations from Edify.
#' Validations are done through Edify.
#'
#' @param data_source The server you will be full from. Edify
#' @param name The name you want the SQL file to have in your sql folder.
#'
#' @return A sql file in your SQL folder
#' @export
#'

sql_validate_student <- function(data_source, name) {
  file <- 'sql_validate_student.sql'

  fs::file_copy(here::here('inst', 'sql', file),
                here::here('sql', name))
}
