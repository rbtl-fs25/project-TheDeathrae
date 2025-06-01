library(googlesheets4)
library(tidyverse)

raw <- read_sheet("https://docs.google.com/spreadsheets/d/1MBd5pOhVV3SIyqT8iwFFAf5LiRK3lbRDGvhVYhaqqEw/edit?resourcekey=&gid=1360760891#gid=1360760891")

raw |> 
  mutate(across(everything(), as.character)) |> # necessary due to differing data types in some columns from testing
  write_csv(here::here("data/raw/university-lunch-food-waste_raw.csv"))
