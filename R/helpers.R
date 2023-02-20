#' Generate Helper Functions
#'
#' `create_sql_dir` will generate the path used to house the sql files based on the context parameter.
#'
#' @param context The context of your project.  "project", "shiny", and "sandbox"
#' @export
#'
create_sql_dir <- function(context) {
  project_path <- here::here('sql')
  shiny_path <- here::here('inst', 'sql')
  sandbox_path <- here::here('sandbox', 'sql')

  #check for directoy and if it doesn't exist, create it.
  if(context == 'shiny' & !file.exists(project_path)) {
    dir.create(shiny_path, showWarnings = FALSE)
  } else if(context == 'sandbox' & !file.exists(sandbox_path)) {
    dir.create(sandbox_path, showWarnings = FALSE)
  } else {
    dir.create(project_path, showWarnings = FALSE)
  }
}

#' Write SQL Files Functions
#'
#' `write_sql_files` will copy and move the sql file based on the context parameter.
#'
#' @param context The context of your project.  "project", "shiny", and "sandbox"
#' @param file The name of the sql file
#' @param folder The name of the folder where the sql is stored
#' @export
#
#write sql files to correct path
write_sql_file <- function(file, folder, name, context) {
  if(context == 'shiny') {
    fs::file_copy(here::here('inst', 'sql', folder, file),
                  here::here('inst', 'sql', name), overwrite = TRUE)
  } else if(context == 'sandbox') {
    fs::file_copy(here::here('inst', 'sql', folder, file),
                  here::here('sandbox', 'sql', name), overwrite = TRUE)
  } else {
    fs::file_copy(here::here('inst', 'sql', folder, file),
                  here::here('sql', name), overwrite = TRUE)
  }

}

