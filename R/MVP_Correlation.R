source("R/Base_Code.R")



# Only 581 NBA players received MVP votes from year 1982-2022
train <- subset(df, award_share > 0)

mvp_winners <- df %>%
  group_by(season) %>%
  mutate(mvp = award_share == max(award_share)) %>%
  filter(mvp == 'TRUE')

mvps <- mvp_winners %>%
  select(season, player, pos, Team, pts_per_g, ast_per_g, trb_per_g, stl_per_g, blk_per_g) %>%
  arrange(desc(season))

### WIN/LOSS PCT EFFECTS ON AWARD SHARE
mvp_win_loss <- mvp_winners %>%
  select(player, Team, season, win_loss_pct, mvp) %>%
  arrange(desc(win_loss_pct))
# Only 11 out of the 41 (26.8%) 1982-2022 MVP winners have win/loss percentage below 70%

# graph showing the correlation between win/loss pct and award shares
award_share_wlp <- ggplot(mvp_winners, aes(x = win_loss_pct, y = award_share)) +
  geom_point() +
  xlab("Win/Loss Percentage") +
  ylab("MVP Share") +
  ggtitle("Win/Loss Percentage - Award Share") + 
  stat_smooth(method = lm)

lm_wlp <- lm(award_share ~ win_loss_pct, data = train)
summary(lm_wlp)



### AVERAGE PER RATING FOR MVP AND NON-MVP WINNERS

non_mvp_winners <- filter(df, mvp == 'FALSE')

lm_per <- lm(award_share ~ per, data = train)
summary(lm_per)

# simple regression on award_share ~ per
award_share_per <- ggplot(train, aes(award_share, per)) +
  geom_point() +
  xlab("MVP Share") +
  ylab("Player Efficiency Rating (PER)") +
  ggtitle("Award Share ~ PER") +
  stat_smooth(method = lm)

# The difference between the average per for mvp and non-mvp winners is 15.6
mvp_avg_per <- mean(mvp_winners$per)
non_mvp_avg_per <- mean(non_mvp_winners$per)
# mvp_avg_per = 28.3 and non_mvp_avg_per = 12.7




### WIN SHARES AFFECT ON THE NUMBER OF VOTES PLAYERS GET
mvp_avg_ws <- mean(mvp_winners$ws)
non_mvp_avg_ws <- mean(non_mvp_winners$ws)
# mvp_avg_ws = 16.02 and non_mvp_avg_ws = 2.62 -> difference: 13.4

lm_ws <- lm(award_share ~ ws, data = train)
summary(lm_ws)

# simple regression on award_share ~ ws
award_share_ws <- ggplot(df, aes(award_share, ws)) +
  geom_point() +
  xlab("MVP Share") +
  ylab("Win Share") +
  ggtitle("MVP Share ~ Win Share") +
  stat_smooth(method = lm)




### True shooting percentage - award share
mvp_avg_ts_pct <- mean(mvp_winners$ts_pct)
non_mvp_avg_ts_pct <- mean(non_mvp_winners$ts_pct)
# mvp_avg_ts_pct = 59.3% and non_mvp_avg_ts_pct = 51.3% -> difference: 8%

lm_ts_pct <- lm(award_share ~ ts_pct, data = train)
summary(lm_ts_pct)

# simple regression on award_share ~ ts_pct
award_share_ts <- ggplot(train, aes(award_share, ts_pct)) +
  geom_point() +
  xlab("MVP Share") +
  ylab("True Shooting %") +
  ggtitle("MVP Share ~ TS%") +
  stat_smooth(method = lm)




# ##### AWARDS_SHARE ~ PPG, APG, RPG, SPG, BPG
# ggplot(train, aes(award_share, pts_per_g)) +
#   geom_point() +
#   stat_smooth(method = lm)
# # ppg matters!
# ggplot(train, aes(award_share, ast_per_g)) +
#   geom_point() +
#   stat_smooth(method = lm)
# # apg matters
# ggplot(train, aes(award_share, trb_per_g)) +
#   geom_point() +
#   stat_smooth(method = lm)
# # rpg matters
# ggplot(train, aes(award_share, stl_per_g)) +
#   geom_point() +
#   stat_smooth(method = lm)
# # spg does not really matter
# ggplot(train, aes(award_share, blk_per_g)) +
#   geom_point() +
#   stat_smooth(method = lm)
# # bpg does not really matter


