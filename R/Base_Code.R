# Load package
library(dplyr)
library(ggplot2)

# read files
df <- read.csv('data/NBA_Dataset.csv')
abb <- read.csv('data/abbreviations.csv')
team_stats <- read.csv('data/renamed_teams.csv')
df2 <- read.csv('data/cleaned_data.csv')
stats_2023 <- read.csv('data/2023_NBA_Player_Stats.csv')
