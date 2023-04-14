source("R/Base_Code.R")

# a model that determines the top 10 best performing players in each season
set.seed(123)

# split data into 80% training and 20% testing
trainIndex <- createDataPartition(df$player, p = 0.8, list = FALSE, times = 1)
train <- df[trainIndex,]
test <- df[-trainIndex,]

# perform linear regression on training set
lm_model <- lm(award_share ~ pts_per_g + trb_per_g + ast_per_g + stl_per_g + blk_per_g + ws + win_loss_pct + per, data = train)

# print summary of the model
summary(lm_model)

# mvp_candidate_2018 <- subset(df, award_share > 0 & season == 2018)
# lm_2018 <- lm(award_share ~ ws, data = mvp_candidate_2018)
# summary(lm_2018)
# 
# train_data <- subset(df, award_share > 0)
# lm_model <- lm(award_share ~ pts_per_g + trb_per_g + ast_per_g + stl_per_g + blk_per_g + ws + win_loss_pct + per, data = train_data)

train_data <- subset(df, award_share > 0)

### WIN/LOSS PCT EFFECTS ON AWARD SHARE
mvp_win_loss <- mvp_winners %>%
  select(player, Team, season, win_loss_pct, mvp) 
# Only 11 out of the 41 (26.8%) 1982-2022 MVP winners have win/loss percentage below 70%

# graph showing the correlation between win/loss pct and award shares
ggplot(mvp_winners, aes(x = win_loss_pct, y = award_share)) +
  geom_point() +
  xlab("Win/Loss Percentage") +
  ylab("Award Share") +
  ggtitle("Win/Loss Percentage - Award Share")

lm_ws <- lm(award_share ~ ws, data = train_data)
summary(lm_ws)

### AVERAGE PER RATING FOR MVP AND NON-MVP WINNERS
mvp_winners <- df %>%
  group_by(season) %>%
  mutate(mvp = award_share == max(award_share)) %>%
  filter(mvp == 'TRUE')

non_mvp_winners <- filter(df, mvp == 'FALSE')

mvp_avg_per <- mean(mvp_winners$per)
non_mvp_avg_per <- mean(non_mvp_winners$per)
# The difference between the average per for mvp and non-mvp winners is 15.6





