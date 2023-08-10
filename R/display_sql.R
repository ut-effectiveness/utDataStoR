#' Display sql with comments
#'
#' @param file The name of the sql file you want to display.
#' @param folder The name of the folder from inst containing the sql file.
#'
#'
#' @importFrom readr read_file
#'
#' @return A sql file in your SQL folder
#' @export

display_sql_with_comments <- function(folder, file) {

  x <- read_file(here::here('inst', 'sql', folder, file))

  return(x)
}
