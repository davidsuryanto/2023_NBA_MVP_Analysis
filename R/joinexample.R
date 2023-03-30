players <- data.frame(Player = c('Kobe', 'Griffin', 'KD'),
                      Tim = c('Los Angeles Lakers', 'Los Angeles Clippers', 'Brooklyn Nets'))

abb <- read.csv('data/abbreviations.csv')

players1 <- left_join(players, abb, by = c('Tim'='Team'))
