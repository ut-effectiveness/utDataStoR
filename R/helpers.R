#' `create_sql_dir` will generate the path used to house the sql files based on the context parameter.
#' The create_sql_dir function checks if a directory for SQL files exists based on the specified
#' context (project, shiny, or sandbox) and creates one if it doesn't. This ensures the correct folder
#' structure is set up for different project environments.
#' `r lifecycle::badge("stable")`
#'
#' @param context The context of your project.  Options are: "project", "shiny", or "sandbox".
#' If not specified, "project" is used by default.
#'
#' @export
#'
create_sql_dir <- function(context = "project") {
  # Set the folder paths for different contexts
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

  warning("This function will be deprecated and be no longer supported within one year.
    Please use the 'utHelpR::make_standard_folders()' function instead for improved functionality and support.")
}

#' `write_sql_files` will copy and move the sql file based on the context parameter.
#' The write_sql_file function copies a specified SQL file from a source folder to a target directory,
#' determined by the context (shiny, sandbox, or project). Using the `fs::file_copy` function,
#' it places the file in the appropriate path (e.g., in the inst/sql folder for shiny, sandbox/sql for
#' sandbox, or the main sql directory otherwise).
#' `r lifecycle::badge("stable")`
#'
#' @param context The context of your project.  "project", "shiny", and "sandbox"
#' @param file The name of the SQL file that you want to copy to a new location
#' @param folder The name of the folder where the sql is stored
#' @param name The name for the sql file you want to create. This is a string and must be provided in quotes
#' (e.g., "your_filename.sql").
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

