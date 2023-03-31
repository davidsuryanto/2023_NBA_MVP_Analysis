source("R/Base_Code.R")

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
  group_by(player) %>%
  summarize(total_MVPs = sum(mvp), 
            Teams = toString(Team[which(mvp == "TRUE")]),
            Years = toString(season[which(mvp == "TRUE")])) %>%
  arrange(desc(total_MVPs)) %>%
  head(5)

# Creating plots
ggplot(mvp_stats2, aes(x = PTS, y = W.L.)) + geom_point() + labs(x = "Points per game", y = "Win/Lose percentage")
ggplot(df2, aes(x = Share, y = W.L.)) + geom_point() + labs(x = "MVP Share", y = "Win/Lose percentage")
