library(tidyverse)

chess_tournament <- read_csv("https://raw.githubusercontent.com/AngelClaudio/DataSources/master/tournamentinfo.txt",
                             col_name = ("raw"), skip = 4) %>% 
                                filter(row_number() %% 3 != 0) 


#Get a vector of player IDs
player_id = str_extract(chess_tournament$raw,"^\\d+")
player_id = player_id[!is.na(player_id)]

#Update Raw data, removing IDs
chess_tournament <- data.frame(str_replace(chess_tournament$raw,"^\\d+\\s\\|\\s",""))


#Get a vector of player names
# The player names are on only on odd rows, so get those 1st
player_name_rows <- chess_tournament %>% filter(row_number() %% 2 != 0) 
names(player_name_rows)[1] <- "col1"

# Extract from the rows with player names just the name into a Vector
player_name = trimws(str_extract(player_name_rows$col1, "^\\D+ [^\\|]"))


#Get a vector of states
# The state names are on only on odd rows, so get those 1st
state_rows <- chess_tournament %>% filter(row_number() %% 2 == 0) 
names(state_rows)[1] <- "col1"

# Extract from the rows the state names
state_name = str_extract(state_rows$col1, "[[:alpha:]]{2}")


#Get a vector of points
points = str_extract(player_name_rows$col1, "\\d.\\d")

#Get a vector of Pre-Rating
pre_rating = as.integer(str_replace_all(str_extract(state_rows$col1, ": \\s?\\d{3,4}"), ":\\s",""))

#Get a vector of all the pre-rating of chess opponents
players_opponent_ids = str_extract_all(player_name_rows$col1, "[[:upper:]]\\s+\\d+\\|")
players_opponent_ids = str_extract_all(players_opponent_ids, "\\d+")

#Merge Vectors to form a new data set
chess_tournament <- data.frame(player_id, player_name, state_name, points, pre_rating)

#Create new vector for for loop
average_opponent_rating <- vector()

for (ids in players_opponent_ids) {
    opponent_ratings <- filter(chess_tournament, player_id %in% ids)
    print(opponent_ratings)
    average_opponent_rating <- c(average_opponent_rating,  mean(opponent_ratings$pre_rating))
}

chess_tournament$average_opponent_rating <- average_opponent_rating

#Write to CSV file
write.csv(chess_tournament,"chess_tournament.csv")



