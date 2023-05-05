# Load package
library(dplyr)
library(ggplot2)
library(tidyr)
library(lattice)
library(caret)
library(rpart)
library(rpart.plot)

# read files
df <- read.csv('data/NBA_Dataset.csv')
abb <- read.csv('data/abbreviations.csv')
team_stats <- read.csv('data/renamed_teams.csv')
df2 <- read.csv('data/cleaned_data.csv')
player_stats_2023 <- read.csv('data/2023_NBA_Player_Stats.csv')
players <- read.csv('data/NBA_Dataset_2.csv')
team_stats_2023 <- read.csv('data/Team_Stats_2023.csv')

# added a column of whether winning mvp that year
df <- df %>%
  group_by(season) %>%
  mutate(mvp = award_share == max(award_share))

# changed "Year" column name to "season"
names(team_stats)[names(team_stats) == "Year"] <- "season"
head(team_stats)

# merge player data to team data
team_stats <- merge(team_stats, abb, by = c("Team"))
nba_data <- merge(team_stats, df, by = c("team_id", "season"))
df <- merge(df, abb, by = c("team_id"))
player_stats_2023 <- merge(player_stats_2023, team_stats_2023, by = c("Team"))

# add a column of whether the player has a double-double season 
df <- df %>%
  mutate(double_double = (pts_per_g >= 10 & ast_per_g >= 10) |
           (pts_per_g >= 10 & trb_per_g >= 10) |
           (pts_per_g >= 10 & stl_per_g >= 10) |
           (pts_per_g >= 10 & blk_per_g >= 10) |
           (ast_per_g >= 10 & trb_per_g >= 10) |
           (ast_per_g >= 10 & stl_per_g >= 10) |
           (ast_per_g >= 10 & blk_per_g >= 10) |
           (trb_per_g >= 10 & stl_per_g >= 10) |
           (trb_per_g >= 10 & blk_per_g >= 10) |
           (stl_per_g >= 10 & blk_per_g >= 10))

df <- subset(df, !(player == "JamesOn Curry" | player == "Alex Scales"))
df <- df[complete.cases(df$ts_pct), ]