##This script is used to download the csv files from github so they can be uploaded to Postgres. 
#There are probably better ways of doing this but to save time I just used this method because it was what I was familiar with.

library(reader)

cont_map_url = "https://raw.githubusercontent.com/SalesLoft/data-analyst-exercise/master/sql_challenge/data/continent_map.csv"
cont_map_df <- read_csv(url(cont_map_url))

conts_url <- "https://raw.githubusercontent.com/SalesLoft/data-analyst-exercise/master/sql_challenge/data/continents.csv"
conts_df <- read_csv(url(conts_url))

countries_url <- "https://raw.githubusercontent.com/SalesLoft/data-analyst-exercise/master/sql_challenge/data/countries.csv"
countries_df <- read_csv(url(countries_url))

per_cap_url <- 'https://raw.githubusercontent.com/SalesLoft/data-analyst-exercise/master/sql_challenge/data/per_capita.csv'
per_cap_df <- read_csv(url(per_cap_url))


write.csv(cont_map_df,'~/continent_map.csv',row.names = FALSE)
write.csv(conts_df,'~/continents.csv',row.names = FALSE)
write.csv(countries_df,'~/countries.csv',row.names = FALSE)
write.csv(per_cap_df,'~/per_capita.csv',row.names = FALSE)
