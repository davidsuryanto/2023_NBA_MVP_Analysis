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

# mvp stats from another dataset
mvp_stats2 <- df2 %>%
  group_by(Year) %>%
  mutate(mvp = Pts.Won == max(Pts.Won)) %>%
  filter(mvp == 'TRUE') 

# top 5 mvps with most mvp titles
top5_mvps <- mvp_winners %>%
  group_by(player) %>%
  summarize(total_MVPs = sum(mvp), 
            Team = toString(Team[which(mvp == "TRUE")]),
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

# Select the top 5 players with the most double-double stats
top5_dd <- df %>% 
  group_by(player) %>% 
  summarize(total_dd = sum(double_double, na.rm = TRUE), 
            Teams = toString(Team[which(double_double == "TRUE")]),
            Years = toString(season[which(double_double == "TRUE")]), 
            total_mvp = sum(mvp == "TRUE")) %>% 
  ungroup() %>% 
  top_n(5, total_dd)

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

# Effects of ppg towards mvp share shown in graph
ggplot(df, aes(x = award_share, y = pts_per_g)) +
  geom_point() +
  facet_wrap('mvp')
  xlab("Award Share") +
  ylab("Points Per Game") +
  ggtitle("MVP Share - Points Per Game")
  
# Effects of win share towards mvp share shown in graph
ggplot(df, aes(x = award_share, y = ws)) +
  geom_point() +
  facet_wrap('mvp')
  xlab("Award Share") +
  ylab("Win Share") +
  ggtitle("MVP Share - Win Share")
  
# Nikola Jokic performance consistency over the years
jokic_stats <- subset(df, player == "Nikola Jokić")
jokic_stats_subset <- jokic_stats %>%
  pivot_longer(cols = c("pts_per_g", "ast_per_g", "trb_per_g", "blk_per_g", "stl_per_g"),
               names_to = "Stat", values_to = "Value")
ggplot(jokic_stats_subset, aes(x = season, y = Value, color = Stat)) +
  geom_line() +
  ggtitle("Nikola Jokic's Stats") +
  xlab("Season") +
  ylab("Value")

# Giannis Antetokounmpo performance consistency over the years
giannis_stats <- subset(df, player == "Giannis Antetokounmpo")
giannis_stats_subset <- giannis_stats %>%
  pivot_longer(cols = c("pts_per_g", "ast_per_g", "trb_per_g", "blk_per_g", "stl_per_g"),
               names_to = "Stat", values_to = "Value")
ggplot(giannis_stats_subset, aes(x = season, y = Value, color = Stat)) +
  geom_line() +
  ggtitle("Giannis Antetokounmpo's Stats") +
  xlab("Season") +
  ylab("Value")

# Joel Embiid performance consistency over the years
embiid_stats <- subset(df, player == "Joel Embiid")
embiid_stats_subset <- embiid_stats %>%
  pivot_longer(cols = c("pts_per_g", "ast_per_g", "trb_per_g", "blk_per_g", "stl_per_g"),
               names_to = "Stat", values_to = "Value")
ggplot(embiid_stats_subset, aes(x = season, y = Value, color = Stat)) +
  geom_line() +
  ggtitle("Joel Embiid's Stats") +
  xlab("Season") +
  ylab("Value")

# top 5's mvp candidates
mvp_candidate_2022 <- df %>%
  filter(season == 2022 & player %in% c("Nikola Jokić", "Giannis Antetokounmpo", "Joel Embiid", "Luka Dončić", "Jayson Tatum")) %>%
  select(player, season, Team, g, pts_per_g, trb_per_g, ast_per_g, blk_per_g, stl_per_g, fg_pct, per, ws, win_loss_pct, award_share, double_double,mvp)

mvp_candidate_2021 <- df %>%
  filter(season == 2021 & player %in% c("Nikola Jokić", "Joel Embiid", "Stephen Curry", "Giannis Antetokounmpo", "Luka Dončić")) %>%
  select(player, season, Team, g, pts_per_g, trb_per_g, ast_per_g, blk_per_g, stl_per_g, fg_pct, per, ws, win_loss_pct, award_share, double_double,mvp)

mvp_candidate_2020 <- df %>%
  filter(season == 2020 & player %in% c("Giannis Antetokounmpo", "LeBron James", "James Harden", "Luka Dončić", "Kawhi Leonard")) %>%
  select(player, season, Team, g, pts_per_g, trb_per_g, ast_per_g, blk_per_g, stl_per_g, fg_pct, per, ws, win_loss_pct, award_share, double_double,mvp)

mvp_candidate_2019 <- df %>%
  filter(season == 2019 & player %in% c("Giannis Antetokounmpo", "James Harden", "Paul George", "Nikola Jokić", "Stephen Curry")) %>%
  select(player, season, Team, g, pts_per_g, trb_per_g, ast_per_g, blk_per_g, stl_per_g, fg_pct, per, ws, win_loss_pct, award_share, double_double,mvp)

mvp_candidate_2018 <- df %>%
  filter(season == 2018 & player %in% c("James Harden", "LeBron James", "Anthony Davis", "Damian Lillard", "Russell Westbrook")) %>%
  select(player, season, Team, g, pts_per_g, trb_per_g, ast_per_g, blk_per_g, stl_per_g, fg_pct, per, ws, win_loss_pct, award_share, double_double,mvp)

# Creating plots
ggplot(mvp_stats2, aes(x = PTS, y = W.L.)) + geom_point() + labs(x = "Points per game", y = "Win/Lose percentage")
ggplot(df2, aes(x = Share, y = W.L.)) + geom_point() + labs(x = "MVP Share", y = "Win/Lose percentage")
