library(dplyr)

df2 <- read.csv('data/cleaned_data.csv')

mvp_stats2 <- df2 %>%
  group_by(Year) %>%
  mutate(mvp = Pts.Won == max(Pts.Won)) %>%
  filter(mvp == 'TRUE') 

recentmvp <- mvp_stats2 %>%
  select(c('Year', 'Player', 'Pos', 'Team', 'PTS', 'AST', 'TRB')) %>%
  arrange(desc(Year)) %>%
  head(5)

lowpoints <- mvp_stats2 %>%
  select(c('Year', 'Player', 'Pos', 'Team', 'PTS')) %>%
  arrange(PTS) %>%
  head(5)