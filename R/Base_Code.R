# Load package
library(dplyr)
library(ggplot2)

# read files
df <- read.csv('data/NBA_Dataset.csv')
abb <- read.csv('data/abbreviations.csv')
team_stats <- read.csv('data/renamed_teams.csv')
df2 <- read.csv('data/cleaned_data.csv')
