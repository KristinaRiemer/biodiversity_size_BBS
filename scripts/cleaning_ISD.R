library(dplyr)

# NEON rodent species list
read_raw = read.csv("read_etal_code_data/raw_NEON_mammal_data.csv")
read_clean = read.csv("read_etal_code_data/final_NEON_mammal_data.csv")

taxonID_lookup = read_raw %>% 
  select(taxonID, scientificName) %>% 
  distinct(taxonID, .keep_all = TRUE)

rodent_sp_list = read_clean %>% 
  select(taxonID) %>% 
  distinct(taxonID) %>% 
  left_join(., taxonID_lookup) %>% 
  select(scientificName)

# BBS bird species list
BBS_counts = read.csv("raw_data/breed_bird_survey_counts.csv")
BBS_species = read.csv("raw_data/breed_bird_survey_species.csv") #species codes & taxonomic info

BBS_species$genus_species = paste(BBS_species$genus, BBS_species$species)

aou_lookup = BBS_species %>% 
  mutate(genus_species = paste(genus, species)) %>% 
  select(aou, genus_species)

bird_sp_list = BBS_counts %>% 
  select(aou) %>% 
  distinct(aou) %>% 
  left_join(., aou_lookup) %>% 
  select(genus_species)

# Vertnet species list
vn = read.csv("raw_data/stats_data.csv")
vn_counts = vn %>% 
  group_by(clean_genus_species) %>% 
  summarise(individuals = n())

# How many of first two are in last
rodents_vn = left_join(rodent_sp_list, vn_counts, by = c("scientificName" = "clean_genus_species"))
length(which(!is.na(rodents_vn$individuals))) / nrow(rodents_vn) * 100

birds_vn = left_join(bird_sp_list, vn_counts, by = c("genus_species" = "clean_genus_species"))
length(which(!is.na(birds_vn$individuals))) / nrow(birds_vn) * 100
