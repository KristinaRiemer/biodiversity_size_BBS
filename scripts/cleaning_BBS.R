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
#TODO: refactor to read in all datasets in more automated way
BBS_counts = read.csv("raw_data/breed_bird_survey_counts.csv") #each row is one species per one route
BBS_region_codes = read.csv("raw_data/breed_bird_survey_region_codes.csv") #region codes for each US state & CA province
BBS_routes = read.csv("raw_data/breed_bird_survey_routes.csv") #location of each route, >5000 total
BBS_species = read.csv("raw_data/breed_bird_survey_species.csv") #species codes & taxonomic info
BBS_weather = read.csv("raw_data/breed_bird_survey_weather.csv")

#-------EXPLORATORY---------
BBS_counts$unique_route = paste(BBS_counts$countrynum, BBS_counts$statenum, BBS_counts$route, sep = "-")

ggplot(BBS_counts, aes(x = log(speciestotal))) +
  geom_histogram()

# Plot number of routes per year
routes_by_year_df = BBS_counts %>% 
  group_by(year) %>% 
  summarize(routes = n_distinct(unique_route))

ggplot(routes_by_year_df, aes(x = year, y = routes)) +
  geom_point()

# Plot route spatial locations
ggplot(data = BBS_routes, aes(x = longitude, y = latitude)) +
  borders("world") +
  geom_point(size = 0.1, color = "red", alpha = 0.5)

ggplot(data = BBS_routes, aes(x = longitude, y = latitude)) +
  borders("usa") +
  geom_point(size = 0.3, color = "red", alpha = 0.5)

# Plot number of species at each unique route and year by latitude
number_species_df = BBS_counts %>% 
  group_by(countrynum, statenum, route, year) %>% 
  summarize(number_species = n())
#TODO: calculate species richness (Chao?) from number of species
range(number_species_df$number_species)

number_species_lat_df = left_join(number_species_df, BBS_routes, by = c("countrynum", "statenum", "route"))
ggplot(data = number_species_lat_df, aes(x = latitude, y = number_species)) +
  geom_point()

# Plot species body size distributions per route and year (115,966 of these plots max)

#TODO: use number of each species per unique route & year + Thibault et al. method
#to generate ISD for each species 

#TODO: generate size probability density for each row based on number of
#individuals of that species and randomly sampling size for each individual

#TODO: filter species by minimum number of individuals at site? 

#TODO: switch plotting methods to ggplot

# Code for a single plot (one route and one year, all species)
single_route_year_df = BBS_counts %>% 
  filter(unique_route == "840-2-1", year == 1967, speciestotal > 1)

single_route_year_df$fake_mean_mass = rnorm(nrow(single_route_year_df), mean = 100, sd = 30)
plot(-2, xlim = c(0, 200), ylim = c(0, 0.5))
for(i in 1:nrow(single_route_year_df)){
  individual_masses = rnorm(single_route_year_df$speciestotal[i], mean = single_route_year_df$fake_mean_mass[i], sd = 2)
  lines(density(individual_masses))
}
