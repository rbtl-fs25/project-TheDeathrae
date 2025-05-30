library(tidyverse)

raw <- read_csv("data/raw/raw.csv")

processed <- raw |>
  rename("date_time" = "Timestamp") |> 
  filter(date_time > "2025-05-19 14:00:00")

write_csv(processed, "data/processed/processed.csv")
