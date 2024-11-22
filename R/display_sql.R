#' Display sql with comments
#'
#' This function returns the content of a specified SQL file, including any comments within
#' the file. The function should used within a sql code chunk (```sql ``` ) in R markdown within single back tick.
#' Please refer to the example section for better understanding.
#'
#' @param folder A character string specifying the folder within `inst/sql` where the SQL file is located.
#' Must be within quotes.
#' @param file A character string specifying the name of the SQL file to display. Must be within quotes.
#'
#' @importFrom readr read_file
#'
#' @return A character string containing the content of the SQL file
#' @export
#' @examples
#' # Display content of an SQL file located in inst/sql/queries/my_query.sql
#' `display_sql_with_comments("queries", "my_query.sql") `

display_sql_with_comments <- function(folder, file) {

  x <- read_file(here::here('inst', 'sql', folder, file))

  return(x)
}
