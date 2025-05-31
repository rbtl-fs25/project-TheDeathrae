library(tidyverse)
library(here)

unprocessed <- read_csv(here("data/raw", "raw.csv"))

processed <- unprocessed |>
  
  filter(Timestamp > "2025-05-19 14:00:00") |> # removing test data
  mutate(across(where(is_character), tolower)) |> # all entries lower case
  select(where(~ !all(is.na(.)))) |> # remove columns without data
  mutate(id = row_number()) |> 
  select(id, everything()) |> 
  
  # general column renaming
  rename(
    "date_time" = "Timestamp",
    "age_years" = "What is your age in years?",
    "student_type" = "What study cycle are you in?",
    "semester" = "How many semesters have you been at ETH Zurich? (including current semester)",
    "consciousness" = "How conscious are you of food waste?",
    "motivation_sustainability" = "Do the following motivate you to care about food waste? [Sustainability/ environmental impact]",
    "motivation_monetary" = "Do the following motivate you to care about food waste? [Monetary cost]",
    "motivation_humanitarian" = "Do the following motivate you to care about food waste? [Humanitarian concerns]",
    "motivation_cultural" = "Do the following motivate you to care about food waste? [Cultural aspects]",
    "motivation_other" = "Does anything else motivate you to care about food waste?",
    "days_uni" = "How many days a week (Mon-Fri)... [are you typically present at university during lunch time?]",
    "days_cafeteria" = "How many days a week (Mon-Fri)... [do you typically eat lunch at a university cafeteria?]",
    "days_own" = "How many days a week (Mon-Fri)... [do you typically bring your own lunch to university?]",
    "days_external" = "How many days a week (Mon-Fri)... [do you typically buy lunch externally? (e.g. restaurant, snack from supermarket)]",
    "waste_cafeteria" = "Approximately how much of your lunch do you throw away on an average weekday in university if...  [eating in the cafeteria?]",
    "waste_own" = "Approximately how much of your lunch do you throw away on an average weekday in university if...  [bringing your own lunch?]",
    "waste_external" = "Approximately how much of your lunch do you throw away on an average weekday in university if...  [buying lunch externally?]",
    "portion_small" = "When you have lunch in university cafeterias, do you generally ask for... [a small portion if you're not sure you could finish a normal portion?]",
    "portion_large" = "When you have lunch in university cafeterias, do you generally ask for... [a large portion if you don't think a normal portion would be enough?]",
    "portion_second" = "When you have lunch in university cafeterias, do you generally ask for... [a second portion if a normal portion wasn't enough?]",
    "scenario_lunch_friend" = "If you were having a weekday lunch in university with a friend and couldn't finish your own portion, which of the following would you do first?",
    "scenario_lunch_alone" = "If you were having a weekday lunch in university alone and couldn't finish your own portion, which of the following would you do first?",
    "encouragement" = "What would encourage you most to avoid waste in the previous scenarios?",
    "food_avoidance" = "When choosing your weekday lunch, do you generally avoid choosing food that contains ingredients you expect not to be eaten?",
    "strategies" = "What other strategies do you use to reduce food waste during weekday lunches in university?"
  ) |>
  
  # general entry renaming
  mutate(
    student_type = case_when(
      student_type == "bachelor's" ~ "bachelor",
      student_type == "master's" ~ "master",
      student_type == "phd" ~ "phd"
    ),
    encouragement = case_when(
      encouragement == "having your own tupperware with you" ~ "tupperware",
      encouragement == "having access to free single-use packaging" ~ "provided_single_use",
      encouragement == "having access to reusable tupperware for a desposit (e.g. recircle)" ~ "provided_tupperware",
      encouragement == "none of those" ~ "none"
    ),
    food_avoidance = case_when(
      food_avoidance == "yes" ~ 2,
      food_avoidance == "sometimes" ~ 1,
      food_avoidance == "no" ~ 0
    ),
    strategies = case_when(
      strategies == "null" ~ NA_character_,
      TRUE ~ strategies
  )) |> 
  mutate(across(
    c(scenario_lunch_friend, scenario_lunch_alone), ~case_when(
      . == "offer leftovers to friend" ~ "pass_on",
      . == "take leftovers home" ~ "take_home",
      . == "throw away" ~ "throw_away"
  ))) |>
  mutate(across(
    c(motivation_sustainability, motivation_monetary, motivation_humanitarian, motivation_cultural, portion_small, portion_large, portion_second), ~case_when(
      . == "yes" ~ TRUE,
      . == "no" ~ FALSE
  ))) |>
  mutate(across(
    c(waste_cafeteria, waste_own, waste_external), ~case_when(
    . == "1 (near none)" ~ 1,
    . == "5 (almost all)" ~ 1,
    TRUE ~ as.integer(.)
  ))) |>
  
  # targeted entry renaming
  mutate(across(
    c(motivation_other, strategies), ~case_when(
    . == "no" ~ NA_character_,
    . == "-" ~ NA_character_,
    TRUE ~ .
  )))


write_csv(processed, here("data/processed", "processed.csv"))
