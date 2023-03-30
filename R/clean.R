library(dplyr)
library(ggplot2)

df <- read.csv('data/NBA_Dataset.csv')

modified_df <- df %>%
  select(season, player, award_share) %>%
  group_by(season) %>%
  mutate(mvp = award_share == max(award_share))

df_2016 <- df %>%
  filter(season == '2016')

ggplot(df_2016, aes(x=fga_per_g, y=fg_pct)) + geom_point() + facet_wrap('pos')
