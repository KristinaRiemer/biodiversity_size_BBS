library(rdataretriever)
library(ggplot2)
library(dplyr)

#-------FUNCTIONS---------
#TODO: doc string
download_BBS = function(raw_file_path){
  if(!file.exists("raw_data/breed_bird_survey_counts.csv")){
    rdataretriever::install("breed-bird-survey", "csv", data_dir = "raw_data/")
  }
}

#-------RUN FUNCTIONS---------
download_BBS("raw_data/breed_bird_survey_counts.csv")

# Read in all BBS datasets
BBS_counts = read.csv("raw_data/breed_bird_survey_counts.csv") #each row is one species per one route
BBS_region_codes = read.csv("raw_data/breed_bird_survey_region_codes.csv") #region codes for each US state & CA province
BBS_routes = read.csv("raw_data/breed_bird_survey_routes.csv") #location of each route, >5000 total
BBS_species = read.csv("raw_data/breed_bird_survey_species.csv") #species codes & taxonomic info
BBS_weather = read.csv("raw_data/breed_bird_survey_weather.csv")

# Exploratory stats & figures
ggplot(data = BBS_routes, aes(x = longitude, y = latitude)) +
  borders("world") +
  geom_point(size = 0.1, color = "red", alpha = 0.5)

ggplot(data = BBS_routes, aes(x = longitude, y = latitude)) +
  borders("usa") +
  geom_point(size = 0.3, color = "red", alpha = 0.5)

#one country, one state, one route, one year
test_site = BBS_counts %>% 
  filter(countrynum == 840, statenum == 2, route == 1, year == 1967) %>% #TODO: change to groupby
  summarize(number_species = n())
