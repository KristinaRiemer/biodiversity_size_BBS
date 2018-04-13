library(rdataretriever)

#-------FUNCTIONS---------
download_BBS = function(raw_file_path){
  if(!file.exists("raw_data/breed_bird_survey_counts.csv")){
    rdataretriever::install("breed-bird-survey", "csv", data_dir = "raw_data/")
  }
}

#-------RUN FUNCTIONS---------
download_BBS("raw_data/breed_bird_survey_counts.csv")

#one route = one site? 
BBS_counts = read.csv("raw_data/breed_bird_survey_counts.csv")
BBS_region_codes = read.csv("raw_data/breed_bird_survey_region_codes.csv") #region codes for each US state & CA province
BBS_routes = read.csv("raw_data/breed_bird_survey_routes.csv") #location of each route, >5000 total
BBS_species = read.csv("raw_data/breed_bird_survey_species.csv") #species codes & taxonomic info
BBS_weather = read.csv("raw_data/breed_bird_survey_weather.csv")
