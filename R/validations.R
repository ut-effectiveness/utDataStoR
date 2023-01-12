#' Generate Validation SQL
#'
#' `sql_validate_student` will generate the standard sql query for pulling Student Validations from Edify.
#' Validations are done through Edify.
#'
#' @param data_source The server you will be full from. Edify
#' @param name The name you want the SQL file to have in your sql folder.
#' @param context The context of your project.  "project", "shiny", and "sandbox"
#'
#' @return A sql file in your SQL folder
#' @export
#'

sql_validate_student <- function(data_source, name, context) {
  file <- 'sql_validate_student.sql'

  #creates the folder based on context param.
  create_sql_dir(context)

  #write sql files to correct path
  write_sql_file(file, name, context)
}

#' `sql_validate_student_courses` will generate the standard sql query for pulling Student Course Validations from Edify.
#' Validations are done through Edify.
#'
#' @param data_source The server you will be full from. Edify
#' @param name The name you want the SQL file to have in your sql folder.
#' @param context The context of your project.  "project", "shiny", and "sandbox"
#'
#' @return A sql file in your SQL folder
#' @export
#'

sql_validate_student_courses <- function(data_source, name, context) {
  file <- 'sql_validate_student_courses.sql'

  project_path <- here::here('sql')
  shiny_path <- here::here('inst', 'sql')
  sandbox_path <- here::here('sandbox', 'sql')

  #check for directoy and if it doesn't exist, create it.
  if(context == 'shiny' & !file.exists(project_path)) {
    dir.create(shiny_path)
  } else if(context == 'sandbox' & !file.exists(sandbox_path)) {
    dir.create(sandbox_path)
  } else {
    dir.create(project_path)
  }

  #write sql files to correct path
  if(context == 'shiny') {
    fs::file_copy(here::here('inst', 'sql', 'validations', file),
                  here::here('inst', 'sql', name), overwrite = FALSE)
  } else if(context == 'sandbox') {
    fs::file_copy(here::here('inst', 'sql', 'validations', file),
                  here::here('sandbox', 'sql', name), overwrite = FALSE)
  } else {
    fs::file_copy(here::here('inst', 'sql', 'validations', file),
                  here::here('sql', name), overwrite = FALSE)
  }
}

#' `sql_validate_courses` will generate the standard sql query for pulling Course Validations from Edify.
#' Validations are done through Edify.
#'
#' @param data_source The server you will be full from. Edify
#' @param name The name you want the SQL file to have in your sql folder.
#' @param context The context of your project.  "project", "shiny", and "sandbox"
#'
#' @return A sql file in your SQL folder
#' @export
#'

sql_validate_courses <- function(data_source, name, context) {
  file <- 'sql_validate_courses.sql'
  project_path <- here::here('sql')
  shiny_path <- here::here('inst', 'sql')
  sandbox_path <- here::here('sandbox', 'sql')

  #check for directoy and if it doesn't exist, create it.
  if(context == 'shiny' & !file.exists(project_path)) {
    dir.create(shiny_path)
  } else if(context == 'sandbox' & !file.exists(sandbox_path)) {
    dir.create(sandbox_path)
  } else {
    dir.create(project_path)
  }

  #write sql files to correct path
  if(context == 'shiny') {
    fs::file_copy(here::here('inst', 'sql', 'validations', file),
                  here::here('inst', 'sql', name), overwrite = TRUE)
  } else if(context == 'sandbox') {
    fs::file_copy(here::here('inst', 'sql', 'validations', file),
                  here::here('sandbox', 'sql', name), overwrite = TRUE)
  } else {
    fs::file_copy(here::here('inst', 'sql', 'validations', file),
                  here::here('sql', name), overwrite = TRUE)
  }
}

#' `sql_validate_graduation` will generate the standard sql query for pulling Graduation Validations from Edify.
#' Validations are done through Edify.
#'
#' @param data_source The server you will be full from. Edify
#' @param name The name you want the SQL file to have in your sql folder.
#' @param context The context of your project.  "project", "shiny", and "sandbox"
#'
#' @return A sql file in your SQL folder
#' @export
#'

sql_validate_graduation <- function(data_source, name, context) {
  file <- 'sql_validate_graduation.sql'
  project_path <- here::here('sql')
  shiny_path <- here::here('inst', 'sql')
  sandbox_path <- here::here('sandbox', 'sql')

  #check for directoy and if it doesn't exist, create it.
  if(context == 'shiny' & !file.exists(project_path)) {
    dir.create(shiny_path)
  } else if(context == 'sandbox' & !file.exists(sandbox_path)) {
    dir.create(sandbox_path)
  } else {
    dir.create(project_path)
  }

  #write sql files to correct path
  if(context == 'shiny') {
    fs::file_copy(here::here('inst', 'sql', 'validations', file),
                  here::here('inst', 'sql', name), overwrite = TRUE)
  } else if(context == 'sandbox') {
    fs::file_copy(here::here('inst', 'sql', 'validations', file),
                  here::here('sandbox', 'sql', name), overwrite = TRUE)
  } else {
    fs::file_copy(here::here('inst', 'sql', 'validations', file),
                  here::here('sql', name), overwrite = TRUE)
  }
}

#' `sql_validate_rooms` will generate the standard sql query for pulling Rooms Validations from Edify.
#' Validations are done through Edify.
#'
#' @param data_source The server you will be full from. Edify
#' @param name The name you want the SQL file to have in your sql folder.
#' @param context The context of your project.  "project", "shiny", and "sandbox"
#'
#' @return A sql file in your SQL folder
#' @export
#'

sql_validate_rooms <- function(data_source, name, context) {
  file <- 'sql_validate_rooms.sql'
  project_path <- here::here('sql')
  shiny_path <- here::here('inst', 'sql')
  sandbox_path <- here::here('sandbox', 'sql')

  #check for directoy and if it doesn't exist, create it.
  if(context == 'shiny' & !file.exists(project_path)) {
    dir.create(shiny_path)
  } else if(context == 'sandbox' & !file.exists(sandbox_path)) {
    dir.create(sandbox_path)
  } else {
    dir.create(project_path)
  }

  #write sql files to correct path
  if(context == 'shiny') {
    fs::file_copy(here::here('inst', 'sql', 'validations', file),
                  here::here('inst', 'sql', name), overwrite = TRUE)
  } else if(context == 'sandbox') {
    fs::file_copy(here::here('inst', 'sql', 'validations', file),
                  here::here('sandbox', 'sql', name), overwrite = TRUE)
  } else {
    fs::file_copy(here::here('inst', 'sql', 'validations', file),
                  here::here('sql', name), overwrite = TRUE)
  }
}

#' `sql_validate_buildings` will generate the standard sql query for pulling Building Validations from Edify.
#' Validations are done through Edify.
#'
#' @param data_source The server you will be full from. Edify
#' @param name The name you want the SQL file to have in your sql folder.
#' @param context The context of your project.  "project", "shiny", and "sandbox"
#'
#' @return A sql file in your SQL folder
#' @export
#'

sql_validate_buildings <- function(data_source, name, context) {
  file <- 'sql_validate_buildings.sql'
  project_path <- here::here('sql')
  shiny_path <- here::here('inst', 'sql')
  sandbox_path <- here::here('sandbox', 'sql')

  #check for directoy and if it doesn't exist, create it.
  if(context == 'shiny' & !file.exists(project_path)) {
    dir.create(shiny_path)
  } else if(context == 'sandbox' & !file.exists(sandbox_path)) {
    dir.create(sandbox_path)
  } else {
    dir.create(project_path)
  }

  #write sql files to correct path
  if(context == 'shiny') {
    fs::file_copy(here::here('inst', 'sql', 'validations', file),
                  here::here('inst', 'sql', name), overwrite = TRUE)
  } else if(context == 'sandbox') {
    fs::file_copy(here::here('inst', 'sql', 'validations', file),
                  here::here('sandbox', 'sql', name), overwrite = TRUE)
  } else {
    fs::file_copy(here::here('inst', 'sql', 'validations', file),
                  here::here('sql', name), overwrite = TRUE)
  }
}





