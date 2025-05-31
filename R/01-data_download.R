library(googlesheets4)
library(tidyverse)
library(here)

raw <- read_sheet("https://docs.google.com/spreadsheets/d/1MBd5pOhVV3SIyqT8iwFFAf5LiRK3lbRDGvhVYhaqqEw/edit?resourcekey=&gid=1360760891#gid=1360760891")

raw <- raw |> 
  mutate(across(everything(), as.character))

write_csv(raw, here("data/raw", "raw.csv"))
