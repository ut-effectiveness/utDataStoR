load(here::here('sandbox', 'fake_data', 'fake_data_raw.rda'))

fake_id <- function(id_length, col_length, unique) {
  # id_length is the length of the id number
  # col_length is how many id numbers you will need
  # unique is if you want each id to be unique


  # use in integer_list to generate list of integers to sample from
  finish_num <- paste(rep(9, id_length), collapse = "")
  # random selection of integers
  integer_list <- sample(1:finish_num, col_length, replace = unique)
  # format the integers
  stringr::str_pad(integer_list, id_length, pad = '0')
}

# Create true false columns
tf <- function(sample_size) {
  sample(c(TRUE, FALSE), sample_size, replace = TRUE)
}

make_gender_col <- function(sample_size) {
  sample(c('M', 'F'), sample_size, replace = TRUE)
}

# put the columns in alphabetic order
order_cols <- function(data_df) {
  data_df %>%
    select(order(colnames(data_df)))
}


make_count_days <- function(term_start_date, term_id) {

  count_start_date = lubridate::ymd(term_start_date) - 120
  count_end_date = lubridate::ymd(term_start_date) + 100

  tibble(
    date = seq(count_start_date, count_end_date, 'day'),
    days_to_class_start = -120:100,
    term_id = term_id
  )
}

make_individual_enrollment_df <- function(day) {
  tibble(
    days_to_term_start = -120:100,
    is_enrolled =  purrr::map_lgl(-120:100, function(x) ifelse(x < day, FALSE, TRUE))
  )
}

make_enrollment_jumps <- function(total) {
  # total is the total enrollment for a semester

  # jump holds the size of the jumps. The period before the first day of class
  # is 120 days. jump contains the numbers of student enrollments that occur in
  # the time period for each jump.
  jump <- vector()
  jump[1] = floor(.30*total) # uniform spread of enrollments from -120 to 0
  jump[2] = floor(.10*total) # jump over -100 to -90 days
  jump[3] = floor(.20*total) # jump over -80 to -70 days
  jump[4] = floor(.15*total)
  jump[5] = floor(.10*total)
  jump[6] = total - sum(jump)

  c(
    sample(-120:0, jump[1], replace = TRUE), # uniform enrollments
    sample(-100:-90, jump[2], replace = TRUE), # enrollment jump 1
    sample(-80:-70, jump[3], replace = TRUE), # enrollment jump 2
    sample(-60:-40, jump[4], replace = TRUE), # enrollment jump 3
    sample(-50:-40, jump[5], replace = TRUE), # enrollment jump 4
    sample(-20:-10, jump[6], replace = TRUE)
  )
}
