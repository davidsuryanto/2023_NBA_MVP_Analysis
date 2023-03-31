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
df <- merge(df, abb, by = c("team_id"))

# top 5 mvps with most mvp titles
top5_mvps <- mvp_winners %>%
  group_by(player) %>%
  summarize(total_MVPs = sum(mvp), 
            Teams = toString(Team[which(mvp == "TRUE")]),
            Years = toString(season[which(mvp == "TRUE")])) %>%
  arrange(desc(total_MVPs)) %>%
  head(5)

# top 5 players with most 20 ppg
top5_20ppg <- df %>%
  group_by(player) %>%
  summarise(total_mvp = sum(mvp == "TRUE"),
            total_20ppg_seasons = sum(pts_per_g >= 20)) %>%
  top_n(5, total_20ppg_seasons) %>%
  arrange(desc(total_20ppg_seasons))

# top 5 players with most double double stats per season
top5_dd <- df %>%
  group_by(player, season) %>%
  mutate(double_doubles = case_when(
    (pts_per_g >= 10 & ast_per_g >= 10) |
      (pts_per_g >= 10 & trb_per_g >= 10) |
      (pts_per_g >= 10 & stl_per_g >= 10) |
      (pts_per_g >= 10 & blk_per_g >= 10) |
      (ast_per_g >= 10 & trb_per_g >= 10) |
      (ast_per_g >= 10 & stl_per_g >= 10) |
      (ast_per_g >= 10 & blk_per_g >= 10) |
      (trb_per_g >= 10 & stl_per_g >= 10) |
      (trb_per_g >= 10 & blk_per_g >= 10) |
      (stl_per_g >= 10 & blk_per_g >= 10) ~ 2,
    TRUE ~ 0)) %>%
  group_by(player) %>%
  summarize(total_dd = sum(num_of_dd)) %>%
  arrange(desc(total_dd)) %>%
  head(5)

# top 5 players with the highest ppg
top5_ppg <- df %>%
  group_by(player, season, Team, mvp) %>%
  summarize(PPG = mean(pts_per_g)) %>%
  ungroup() %>%
  arrange(desc(PPG)) %>%
  head(5)

# top 5 players with the highest rpg
top5_rpg <- df %>%
  group_by(player, season, Team, mvp) %>%
  summarize(RPG = mean(trb_per_g)) %>%
  ungroup() %>%
  arrange(desc(RPG)) %>%
  head(5)

# top 5 players with the highest apg
top5_apg <- df %>%
  group_by(player, season, Team, mvp) %>%
  summarize(APG = mean(ast_per_g)) %>%
  ungroup() %>%
  arrange(desc(APG)) %>%
  head(5)

# top 5 players with the highest spg
top5_spg <- df %>%
  group_by(player, season, Team, mvp) %>%
  summarize(SPG = mean(stl_per_g)) %>%
  ungroup() %>%
  arrange(desc(SPG)) %>%
  head(5)

# top 5 players with the highest bpg
top5_bpg <- df %>%
  group_by(player, season, Team, mvp) %>%
  summarize(BPG = mean(blk_per_g)) %>%
  ungroup() %>%
  arrange(desc(BPG)) %>%
  head(5)

# Creating plots
ggplot(mvp_stats2, aes(x = PTS, y = W.L.)) + geom_point() + labs(x = "Points per game", y = "Win/Lose percentage")
ggplot(df2, aes(x = Share, y = W.L.)) + geom_point() + labs(x = "MVP Share", y = "Win/Lose percentage")
