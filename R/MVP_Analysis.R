library(dplyr)
library(ggplot2)

# read files
df <- read.csv('data/NBA_Dataset.csv')
abb <- read.csv('data/abbreviations.csv')
team_stats <- read.csv('data/renamed_teams.csv')
df2 <- read.csv('data/cleaned_data.csv')

# filter out data from 2016
df_2016 <- df %>%
  filter(season == '2016')

ggplot(df_2016, aes(x=fga_per_g, y=fg_pct)) + geom_point() + facet_wrap('pos')

# filter out NBA mvp's (1982-2022)
mvp_winners <- df %>%
  group_by(season) %>%
  mutate(mvp = award_share == max(award_share)) %>%
  filter(mvp == 'TRUE')
mvp_winners <- merge(mvp_winners, abb, by = c("team_id"))

# mvp stats from another dataset
mvp_stats2 <- df2 %>%
  group_by(Year) %>%
  mutate(mvp = Pts.Won == max(Pts.Won)) %>%
  filter(mvp == 'TRUE') 

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

# top 5 mvps
top5_mvps <- mvp_winners %>%
  group_by(Player) %>%
  summarize(total_MVPs = sum(mvp)) %>%
  arrange(desc(total_MVPs)) %>%
  head(5)

mvp_count <- table(mvp_winners$player)
top5_mvp_count <- head(sort(mvp_count, decreasing = TRUE), 5)
top5_mvp <- data.frame(Player = names(top5_mvp_count), Team = Team(top5_mvp_count), season = season(top5_mvp_count), MVP_Count = as.numeric(top5_mvp_count))

# Creating plots
ggplot(mvp_stats2, aes(x = PTS, y = W.L.)) + geom_point() + labs(x = "Points per game", y = "Win/Lose percentage")
ggplot(df2, aes(x = Share, y = W.L.)) + geom_point() + labs(x = "MVP Share", y = "Win/Lose percentage")
