source("R/Base_Code.R")

# LINEAR MODEL TEST
set.seed(123)

# split the data into training and testing sets
train_index <- sample(nrow(df), floor(0.7 * nrow(df)))
train_data <- df[train_index, ]
test_data <- df[-train_index, ]





### Decision Tree Model
formula <- award_share ~ mp_per_g + g + pts_per_g + trb_per_g + ast_per_g + stl_per_g + blk_per_g + fg_pct + win_loss_pct + per + ows + dws + ws_per_48 + obpm + dbpm + ts_pct
tree_model <- rpart(formula, data = train_data)
rpart.plot(tree_model)



# testing the decision tree model to the player stats from 1982-2022 to see if result match with the actual winners
tree_pred_award_share <- predict(tree_model, newdata = df)

predicted_tree_previous_mvp <- data.frame(Season = df$season, Player = df$player, Team = df$Team, Predicted_Award_Share = tree_pred_award_share, Actual_MVP = df$mvp)

predicted_tree_previous_mvp <- predicted_tree_previous_mvp[order(predicted_tree_previous_mvp$Season, -predicted_tree_previous_mvp$Predicted_Award_Share), ]
tree_top_predicted_winners <- predicted_tree_previous_mvp[!duplicated(predicted_tree_previous_mvp$Season), ]
# Only 28 out of 41 (68%) predicted results match the actual winners


# Applying the model to 2023 player stats
test_tree_2023 <- predict(tree_model, newdata = player_stats_2023)
top_10_tree_pred <- data.frame(Player = player_stats_2023$player, Team = player_stats_2023$Team, Predicted_Award_Share = test_tree_2023)
top_10_tree_pred <- top_10_tree_pred %>%
  arrange(desc(Predicted_Award_Share)) %>%
  head(5)
# Predicted Winner: Nikola Jokic






### Perform linear regression on training set
lm_model <- lm(award_share ~ mp_per_g + pts_per_g + trb_per_g + ast_per_g + stl_per_g + blk_per_g + ws + ws_per_48 + win_loss_pct + per + ts_pct, data = train_data)

# print summary of the model
summary(lm_model)


# # Testing out the model to testing set
# pred <- predict(lm_model, newdata = test_data)
# 
# rmse <- sqrt(mean((pred - test_data$award_share)^2))
# print(paste0("RMSE: ", rmse))
# 
# rsq <- summary(lm_model)$r.squared
# print(paste0("R-squared: ", rsq))




# Testing out the regression model to the 1982-2022 data set
predicted_award_share <- predict(lm_model, newdata = df)

# Create a new data frame with predicted MVP award share values and actual MVP winners
predicted_previous_mvp <- data.frame(Season = df$season, Player = df$player, Team = df$Team, Predicted_Award_Share = predicted_award_share, Actual_MVP = df$mvp)

predicted_previous_mvp <- predicted_previous_mvp[order(predicted_previous_mvp$Season, -predicted_previous_mvp$Predicted_Award_Share), ]
top_predicted_winners <- predicted_previous_mvp[!duplicated(predicted_previous_mvp$Season), ]
# Only 23 out of 41 (56%) predicted results match the actual winners





# Apply the linear regression model to NBA players 2023
prediction <- predict(lm_model, newdata = player_stats_2023)
# print(paste0(player_stats_2023$player, "'s award share: ", prediction))

# filter out the top 10 players from the prediction results
predicted_results <- data.frame(Player = player_stats_2023$player, Team = player_stats_2023$Team, Predicted_Award_Share = prediction)
top_10_lm_pred <- predicted_results %>%
  arrange(desc(Predicted_Award_Share)) %>%
  head(5)
# Predicted Winner: Nikola Jokic


