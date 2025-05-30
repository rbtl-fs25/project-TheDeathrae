library(readr)
library(googlesheets4)

raw <- read_sheet("https://docs.google.com/spreadsheets/d/1MBd5pOhVV3SIyqT8iwFFAf5LiRK3lbRDGvhVYhaqqEw/edit?resourcekey=&gid=1360760891#gid=1360760891")

raw |> 
  mutate(across(everything(), as.character))

write_csv(raw, "data/raw/raw.csv")
