# Code/firstsetdata.R
# tests data first day



# Each set must indicate: 
## the date the data was accessed, 
## the URL where to find the set, 
## the citation, 
## the type of data,
## the site (kong, nuup, svalbard, is, disko, ...)
## category (bio, cryo, social, ...), 
## the driver (category details),
## the variable, for bio they will start with 
  # the latin_eng formula is used for each set, which allows the names of each 
  # species to be modified automatically when necessary
    # the species group, 
    # the Latin name, 
    # the English name,
    # the information 
    # the unit
## the longitude of each data
## the latitude of each data
## the date of data collection
## the water depth of each data item
## the value



# Set up ------------------------------------------------------------------

library(tidyverse)
library(janitor)
library(ggridges)
library(ggpubr)
library(stringi)

source('users/calin/code/formulas.R') ## Need to use species names


# Data ---------------------------------------------------------------------
## Svalbard data -----------------------------------------------------------

# svalbard ivory gull population
svalbard_ivory_gull_population <- read.csv("P:/FACE-IT_data/svalbard/the-number-of-breeding-p.csv", 
                                           sep = ";") %>% # read the csv
  mutate(date_accessed = as.Date("2023-04-12"), 
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/ivory-gull/", 
         citation = "Norwegian Polar Institute (2022). The number of breeding pairs of ivory gulls in Svalbard. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/ismaake.html", 
         lon = NA, lat = NA, depth = NA, 
         Species = "Pagophila eburnea",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp," breeding population [%]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "svalbard", 
         date = as.Date(paste0(Category,"-12-31"))) %>% 
  dplyr::rename(value = Svalbard) %>% 
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>% 
  filter(!is.na(value))


# svalbard walrus population
svalbard_walrus_population <- read_delim("P:/FACE-IT_data/svalbard/walrus-population-in-sva.csv") %>% 
  pivot_longer(cols = c(`Walrus estimated numbers`, `Walrus population aerial counts`)) %>% 
  mutate(date_accessed = as.Date("2023-04-13"), 
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/walrus/", 
         citation = "Norwegian Polar Institute (2022). Walrus population in Svalbard. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/walrus-population.html", 
         lon = NA, lat = NA, depth = NA, 
         Species = "Odobenus marinus",
         nomsp = map(Species, latin_eng),
         type = case_when(name == "Walrus estimated numbers"~"estimated", 
                          name == "Walrus population aerial counts"~"aerial survey"),
         variable = paste0(nomsp, " ", type, " [n]"),
         category = "bio",
         driver ="biomass",
         site = "svalbard", 
         date = as.Date(paste0(Category,"-12-31"))) %>% 
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>% 
  filter(!is.na(value))


# svalbard (north and west) calanus population by size
svalbard_nw_calanus_mm_population <- read.csv("P:/FACE-IT_data/svalbard/average-biomass-of-zoopl.csv", sep = ";", dec = ",") %>%
  pivot_longer(cols = c(`X0.18.mm`, `X1.0.mm`, `X2.0.mm`, `Total`)) %>%
  filter(!name == "Total") %>%
  mutate(date_accessed = as.Date("2023-04-13"),
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/zooplankton-biomass-in-the-barents-sea/",
         citation = "Institute of Marine Research (2023). Average biomass of zooplankton in the Barents Sea. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/zooplankton-biomass.html",
         lon = NA, lat = NA, depth = NA,
         Species = "Zooplankton",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " ", substr(stri_replace_last(tolower(name)," ", regex = "[.]"), 2, 10)," [g/m²]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "svalbard",
         date = as.Date(paste0(Category,"-12-31"))) %>%
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>%
  filter(!is.na(value))


# svalbard (north and west) calanus population tot
svalbard_nw_calanus_tot_population <- read.csv("P:/FACE-IT_data/svalbard/average-biomass-of-zoopl.csv", sep = ";", dec = ",") %>%
  pivot_longer(cols = c(`X0.18.mm`, `X1.0.mm`, `X2.0.mm`, `Total`)) %>%
  filter(name == "Total") %>%
  mutate(date_accessed = as.Date("2023-04-13"),
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/zooplankton-biomass-in-the-barents-sea/",
         citation = "Institute of Marine Research (2023). Average biomass of zooplankton in the Barents Sea. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/zooplankton-biomass.html",
         lon = NA, lat = NA, depth = NA,
         Species = "Zooplankton",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " [g/m²]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "svalbard",
         date = as.Date(paste0(Category,"-12-31"))) %>%
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>%
  filter(!is.na(value))


# svalbard (south and east) calanus population by size
svalbard_se_calanus_mm_population <- read.csv("P:/FACE-IT_data/svalbard/average-biomass-of-zoopl (2).csv", sep = ";", dec = ",") %>%
  pivot_longer(cols = c(`X0.18.mm`, `X1.0.mm`, `X2.0.mm`, `Total`)) %>%
  filter(!name == "Total") %>%
  mutate(date_accessed = as.Date("2023-04-13"),
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/zooplankton-biomass-in-the-barents-sea/",
         citation = "Institute of Marine Research (2023). Average biomass of zooplankton in the Barents Sea. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/zooplankton-biomass.html",
         lon = NA, lat = NA, depth = NA,
         Species = "Zooplankton",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " ", substr(stri_replace_last(tolower(name)," ", regex = "[.]"), 2, 10)," [g/m²]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "svalbard",
         date = as.Date(paste0(Category,"-12-31"))) %>%
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>%
  filter(!is.na(value))


# svalbard (south and east) calanus population tot
svalbard_se_calanus_tot_population <- read.csv("P:/FACE-IT_data/svalbard/average-biomass-of-zoopl (2).csv", sep = ";", dec = ",") %>%
  pivot_longer(cols = c(`X0.18.mm`, `X1.0.mm`, `X2.0.mm`, `Total`)) %>%
  filter(name == "Total") %>%
  mutate(date_accessed = as.Date("2023-04-13"),
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/zooplankton-biomass-in-the-barents-sea/",
         citation = "Institute of Marine Research (2023). Average biomass of zooplankton in the Barents Sea. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/zooplankton-biomass.html",
         lon = NA, lat = NA, depth = NA,
         Species = "Zooplankton",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " [g/m²]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "svalbard",
         date = as.Date(paste0(Category,"-12-31"))) %>%
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>%
  filter(!is.na(value))


# svalbard  kittiwake population
svalbard_kittiwakke_population <- read.csv("P:/FACE-IT_data/svalbard/black-legged-kittiwake-p.csv", sep = ";", dec = ",") %>%
  pivot_longer(cols = c(`Fuglehuken`, `Bjørnøya`, `Grumant`, `Sofiekammen`, `Ossian.Sars`, `Tschermakfjellet`, `Alkhornet`, `Amsterdamya`)) %>%
  filter(name == "Bjørnøya") %>% 
  mutate(date_accessed = as.Date("2023-04-13"),
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/black-legged-kittiwake/",
         citation = "Norwegian Polar Institute (2022). Black-legged kittiwake population size, as percentage of the average in the colony. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/black-legged-kittiwake.html",
         lon = NA, lat = NA, depth = NA,
         Species = "Rissa tridactyla",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " population [% average in the colony]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "svalbard",
         date = as.Date(paste0(Category,"-12-31"))) %>%
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>%
  filter(!is.na(value))


# svalbard Brünnich’s guillemot population
svalbard_brguillemot_population <- read.csv("P:/FACE-IT_data/svalbard/brnnichs-guillemot-breed.csv", sep = ";", dec = ",") %>%
  pivot_longer(cols = c(`Diabas`, `Alkhornet`, `Sofiekammen`, `Grumant`, `Tschermakfjellet`, `Fuglehuken`, `Ossian.Sarsfjellet`, `Bjørnøya..southern.part`, `Bjørnøya..Evjebukta`, `Jan.Mayen`)) %>%
  filter(name == "Fuglehuken") %>% 
  mutate(date_accessed = as.Date("2023-04-14"),
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/brunnichs-guillemot/",
         citation = "Norwegian Polar Institute (2022). Brünnich’s guillemot breeding populations, percentage of colony average. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/brunnichs-guillemot.html",
         lon = NA, lat = NA, depth = NA,
         Species = "Uria lomvia",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " breeding population [%]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "svalbard",
         date = as.Date(paste0(Category,"-12-31"))) %>%
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>%
  filter(!is.na(value))


# svalbard Hooded seal population
svalbard_cycr_population <- read.csv("P:/FACE-IT_data/svalbard/population-size-of-hoode.csv", sep = ";", dec = ",") %>%
  pivot_longer(cols = c(`Modelled.production.of.pups`, `Modelled.total.stock.size`, `Survey.counts.of.pups`)) %>% 
  mutate(date_accessed = as.Date("2023-04-14"),
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/hooded-seal/",
         citation = "Institute of Marine Research (2022). Population size of hooded seals in the West Ice. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/hooded-seal.html",
         lon = NA, lat = NA, depth = NA,
         Species = "Cystophora cristata",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp," ", str_replace_all(tolower(name),"\\."," ")," [n]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "svalbard",
         date = as.Date(paste0(Category,"-12-31"))) %>%
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>%
  filter(!is.na(value))


# svalbard (east) harp seal population
svalbard_cycr_population <- read.csv("P:/FACE-IT_data/svalbard/population-size-of-hoode.csv", sep = ";", dec = ",") %>%
    pivot_longer(cols = c(`Modelled.production.of.pups`, `Modelled.total.stock.size`, `Survey.counts.of.pups`)) %>% 
    mutate(date_accessed = as.Date("2023-04-14"),
           URL = "https://mosj.no/en/indikator/fauna/marine-fauna/hooded-seal/",
           citation = "Institute of Marine Research (2022). Population size of hooded seals in the West Ice. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/hooded-seal.html",
           lon = NA, lat = NA, depth = NA,
           Species = "Cystophora cristata",
           nomsp = map(Species, latin_eng),
           variable = paste0(nomsp," ", str_replace_all(tolower(name),"\\."," ")," [n]"),
           category = "bio",
           driver ="biomass",
           type = "in situ",
           site = "svalbard",
           date = as.Date(paste0(Category,"-12-31"))) %>%
    dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>%
    filter(!is.na(value))





## Kong data ---------------------------------------------------------------

# kong glaucous gull population
kong_glaucous_gull_population <- read_delim("P:/FACE-IT_data/kongsfjorden/glaucous-gull-population.csv") %>% 
  mutate(date_accessed = as.Date("2023-04-11"), 
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/glaucous-gull/", 
         citation = "Norwegian Polar Institute (2022). Glaucous gull population, as percentage of the average in the colony. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/glaucous-gull.html", 
         lon = NA, lat = NA, depth = NA, 
         Species = "Larus hyperboreus",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " breeding population [%]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "kong", 
         date = as.Date(paste0(Category,"-12-31"))) %>% 
  dplyr::rename(value = Kongsfjorden) %>% 
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>% 
  filter(!is.na(value))



# kong eiders
kong_eiders_stock <- read.csv("P:/FACE-IT_data/kongsfjorden/breeding-population-of-c.csv", sep = ";") %>% 
  mutate(date_accessed = as.Date("2023-04-12"), 
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/common-eider/", 
         citation = "Norwegian Polar Institute (2022). Breeding population of common eiders in Kongsfjorden, number of breeding pairs. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/common-eider.html", 
         lon = NA, lat = NA, depth = NA, 
         Species = "Somateria mollissima borealis",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " breeding pairs [n]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "kong", 
         date = as.Date(paste0(Category,"-12-31"))) %>% 
  dplyr::rename(value = Common.eider) %>% 
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>% 
  filter(!is.na(value))


# kong seabird
kong_seabird <- read.csv("P:/FACE-IT_data/kongsfjorden/Descamps_Strom_Ecology_data.csv", sep = ",", skip = 3, header = TRUE) %>%
  remove_empty(which = "cols") %>% 
  filter(Colony == "Kongsfjorden")%>% 
  mutate(date_accessed = as.Date("2023-04-12"), 
         URL = "https://data.npolar.no/dataset/0ea572cd-1e4c-47a3-b2a5-5d7cc75aaeb4", 
         citation = "Descamps, S., & Strøm, H. (2021). Seabird monitoring data from Svalbard, 2009-2018 [Data set]. Norwegian Polar Institute. https://doi.org/10.21334/npolar.2021.0ea572cd", 
         lon = NA, lat = NA, depth = NA, 
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " colony count [n]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "kong", 
         date = as.Date(paste0(YR,"-12-31"))) %>% 
  dplyr::rename(value = Count) %>% 
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>% 
  filter(!is.na(value))


# kong calanus population
kong_calanus_population <- read.csv("P:/FACE-IT_data/kongsfjorden/calanus-species-composit.csv", sep = ";", dec = ",") %>% 
  pivot_longer(cols = c(`Proportion.of.Atlantic.species`, `Proportion.of.Arctic.species`)) %>% 
  mutate(date_accessed = as.Date("2023-04-13"), 
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/zooplankton-species-composition-in-kongsfjorden/", 
         citation = "Norwegian Polar Institute (2022). Calanus species composition in Kongsfjorden. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/zooplankton-species-composition.html", 
         lon = NA, lat = NA, depth = NA, 
         Species = substr(str_replace_all(tolower(name),"\\."," "),15, 30),
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " [%]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "kong", 
         date = as.Date(paste0(Category,"-12-31"))) %>% 
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>% 
  filter(!is.na(value))


# kong  kittiwake population
kong_kittiwakke_population <- read.csv("P:/FACE-IT_data/svalbard/black-legged-kittiwake-p.csv", sep = ";", dec = ",") %>%
  pivot_longer(cols = c(`Fuglehuken`, `Bjørnøya`, `Grumant`, `Sofiekammen`, `Ossian.Sars`, `Tschermakfjellet`, `Alkhornet`, `Amsterdamya`)) %>%
  filter(name == "Ossian.Sars") %>% 
  mutate(date_accessed = as.Date("2023-04-13"),
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/black-legged-kittiwake/",
         citation = "Norwegian Polar Institute (2022). Black-legged kittiwake population size, as percentage of the average in the colony. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/black-legged-kittiwake.html",
         lon = NA, lat = NA, depth = NA,
         Species = "Rissa tridactyla",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " population [% average in the colony]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "kong",
         date = as.Date(paste0(Category,"-12-31"))) %>%
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>%
  filter(!is.na(value))


# kong Brünnich’s guillemot population
kong_brguillemot_population <- read.csv("P:/FACE-IT_data/svalbard/brnnichs-guillemot-breed.csv", sep = ";", dec = ",") %>%
  pivot_longer(cols = c(`Diabas`, `Alkhornet`, `Sofiekammen`, `Grumant`, `Tschermakfjellet`, `Fuglehuken`, `Ossian.Sarsfjellet`, `Bjørnøya..southern.part`, `Bjørnøya..Evjebukta`, `Jan.Mayen`)) %>%
filter(name == "Ossian.Sarsfjellet") %>% 
  mutate(date_accessed = as.Date("2023-04-14"),
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/brunnichs-guillemot/",
         citation = "Norwegian Polar Institute (2022). Brünnich’s guillemot breeding populations, percentage of colony average. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/brunnichs-guillemot.html",
         lon = NA, lat = NA, depth = NA,
         Species = "Uria lomvia",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " breeding population [%]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "kong",
         date = as.Date(paste0(Category,"-12-31"))) %>%
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>%
  filter(!is.na(value))








## Barents data ------------------------------------------------------------

# barents polar cod biomass
barents_polar_cod <- read.csv("P:/FACE-IT_data/svalbard/biomass-of-polar-cod-in.csv", sep = ";", dec = ",") %>% 
  mutate(date_accessed = as.Date("2023-04-11"), 
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/biomass-of-polar-cod-in-the-barents-sea/", 
         citation = "Institute of Marine Research (2022). Biomass of polar cod in the Barents Sea. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/polar-cod.html", 
         lon = NA, lat = NA, depth = NA, 
         Species = "Boreogadus saida",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " [10^6 kg]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "barents sea", 
         date = as.Date(paste0(Category,"-12-31"))) %>% 
  dplyr::rename(value = Biomass) %>% 
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>% 
  filter(!is.na(value))


# barents capelin stock
barents_capelin_stock <- read.csv("P:/FACE-IT_data/svalbard/capelin-stock-in-the-bar.csv",sep = ";" , dec = ",") %>% 
  pivot_longer(cols = c(`Mature.stock`, `Immature.stock`)) %>% 
  mutate(date_accessed = as.Date("2023-04-12"), 
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/capelin-stock-in-the-barents-sea/", 
         citation = "Institute of Marine Research (2022). Capelin stock in the Barents Sea. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/capelin.html", 
         lon = NA, lat = NA, depth = NA, 
         Species = "Mallotus villosus",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " ", str_replace(tolower(name),"\\."," ") ," [10^6 kg]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "barents sea", 
         date = as.Date(paste0(Category,"-12-31"))) %>% 
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>% 
  filter(!is.na(value))


# barents golden redfish population
barents_golden_redfish_population <- read_delim("P:/FACE-IT_data/svalbard/stock-of-golden-redfish.csv") %>% 
  pivot_longer(cols = c(`Mature stock`, `Immature stock`)) %>% 
  mutate(date_accessed = as.Date("2023-04-12"), 
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/golden-redfish-stock-in-the-barents-sea/", 
         citation = "Institute of Marine Research (2023). Stock of golden redfish in the Barents Sea. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: https://mosj.no/en/indikator/fauna/marine-fauna/golden-redfish-stock-in-the-barents-sea/", 
         lon = NA, lat = NA, depth = NA, 
         Species = "Sebastes norvegicus",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " ", tolower(name) ," [10^3 kg]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "barents sea", 
         date = as.Date(paste0(Category,"-12-31"))) %>% 
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>% 
  filter(!is.na(value))



# barents beaked redfish population
barents_beaked_redfish_population <- read.csv("P:/FACE-IT_data/svalbard/stock-of-beaked-redfish.csv", sep = ";") %>% 
  pivot_longer(cols = c(`Mature.stock`, `Immature.stock`)) %>% 
  mutate(date_accessed = as.Date("2023-04-12"), 
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/bestanden-av-snabeluer-i-barentshavet/", 
         citation = "Institute of Marine Research (2022). Stock of beaked redfish in the Barents Sea. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/deep-sea-redfish.html", 
         lon = NA, lat = NA, depth = NA, 
         Species = "Sebastes mentella",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " ", str_replace(tolower(name),"\\."," ") ," [10^6 kg]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "barents sea", 
         date = as.Date(paste0(Category,"-12-31"))) %>% 
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>% 
  filter(!is.na(value))


# barents northeast arctic cod population
barents_northeast_cod_population <- read.csv("P:/FACE-IT_data/svalbard/stock-of-northeast-arcti.csv", sep = ";") %>% 
  pivot_longer(cols = c(`Immature.stock`, `Spawning.stock`)) %>% 
  mutate(date_accessed = as.Date("2023-04-12"), 
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/stock-of-northeast-arctic-cod/", 
         citation = "Institute of Marine Research (2022). Stock of Northeast Arctic cod in the Barents Sea. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/northeast-arctic-cod.html", 
         lon = NA, lat = NA, depth = NA, 
         Species = "Gadus morhua",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " ", str_replace(tolower(name),"\\."," ") ," [10^6 kg]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "barents sea", 
         date = as.Date(paste0(Category,"-12-31"))) %>% 
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>% 
  filter(!is.na(value))


# barents young herring population
barents_young_herring_population <- read.csv("P:/FACE-IT_data/svalbard/biomass-index-for-young.csv", sep = ";", dec = ",") %>% 
  pivot_longer(cols = c(`X1.year.olds`, `X2.year.old`, `X3.year.old`)) %>%
  mutate(date_accessed = as.Date("2023-04-13"),
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/bestanden-av-ungsild-i-barentshavet/",
         citation = "Institute of Marine Research (2022). Biomass index for young herring 1–3 years in the Barents Sea. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/young-herring-population.html",
         lon = NA, lat = NA, depth = NA,
         Species = "Clupea harengus",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " ", substr(str_replace_all(tolower(name),"\\."," "),2, 11)," [n]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "barents sea",
         date = as.Date(paste0(Category,"-12-31"))) %>%
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>%
  filter(!is.na(value))








## Is data -----------------------------------------------------------------

# is  kittiwake population
is_kittiwakke_population <- read.csv("P:/FACE-IT_data/svalbard/black-legged-kittiwake-p.csv", sep = ";", dec = ",") %>%
  pivot_longer(cols = c(`Fuglehuken`, `Bjørnøya`, `Grumant`, `Sofiekammen`, `Ossian.Sars`, `Tschermakfjellet`, `Alkhornet`, `Amsterdamya`)) %>%
  filter(name == "Tschermakfjellet"| name == "Alkhornet") %>% 
  mutate(date_accessed = as.Date("2023-04-13"),
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/black-legged-kittiwake/",
         citation = "Norwegian Polar Institute (2022). Black-legged kittiwake population size, as percentage of the average in the colony. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/black-legged-kittiwake.html",
         lon = NA, lat = NA, depth = NA,
         Species = "Rissa tridactyla",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " population [% average in the colony]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "is",
         date = as.Date(paste0(Category,"-12-31"))) %>%
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>%
  filter(!is.na(value))


# is Brünnich’s guillemot population
is_brguillemot_population <- read.csv("P:/FACE-IT_data/svalbard/brnnichs-guillemot-breed.csv", sep = ";", dec = ",") %>%
  pivot_longer(cols = c(`Diabas`, `Alkhornet`, `Sofiekammen`, `Grumant`, `Tschermakfjellet`, `Fuglehuken`, `Ossian.Sarsfjellet`, `Bjørnøya..southern.part`, `Bjørnøya..Evjebukta`, `Jan.Mayen`)) %>%
  filter(name == "Diabas"|name == "Tschermakfjellet"|name == "Alkhornet") %>% 
  mutate(date_accessed = as.Date("2023-04-14"),
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/brunnichs-guillemot/",
         citation = "Norwegian Polar Institute (2022). Brünnich’s guillemot breeding populations, percentage of colony average. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/brunnichs-guillemot.html",
         lon = NA, lat = NA, depth = NA,
         Species = "Uria lomvia",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " breeding population [%]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "svalbard",
         date = as.Date(paste0(Category,"-12-31"))) %>%
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>%
  filter(!is.na(value))































# EU ----------------------------------------------------------------------
# EU (east) harp seal population
EU_epagr_population <- read.csv("P:/FACE-IT_data/EU_arctic/production-of-pups-and-e.csv", sep = ";", dec = ",") %>%
  pivot_longer(cols = c(`Modelled.production.of.pups`, `Modelled.total.stock.size`, `Survey.counts.of.pups`)) %>% 
  mutate(date_accessed = as.Date("2023-04-14"),
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/harp-seal/",
         citation = "Institute of Marine Research (2022). Production of pups and estimated population size for harp seal in the East Ice. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/harp-seal.html",
         lon = NA, lat = NA, depth = NA,
         Species = "Pagophilus groenlandicus",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " ", str_replace_all(tolower(name),"\\."," ")," [n]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "east ice",
         date = as.Date(paste0(Category,"-12-31"))) %>%
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>%
  filter(!is.na(value))


# EU (west) harp seal population
EU_wpagr_population <- read.csv("P:/FACE-IT_data/EU_arctic/production-of-pups-and-e.csv", sep = ";", dec = ",") %>%
  pivot_longer(cols = c(`Modelled.production.of.pups`, `Modelled.total.stock.size`, `Survey.counts.of.pups`)) %>% 
  mutate(date_accessed = as.Date("2023-04-14"),
         URL = "https://mosj.no/en/indikator/fauna/marine-fauna/harp-seal/",
         citation = "Institute of Marine Research (2022). Production of pups and estimated population size for harp seal in the West Ice. Environmental monitoring of Svalbard and Jan Mayen (MOSJ). URL: http://www.mosj.no/en/fauna/marine/harp-seal.html",
         lon = NA, lat = NA, depth = NA,
         Species = "Pagophilus groenlandicus",
         nomsp = map(Species, latin_eng),
         variable = paste0(nomsp, " ", str_replace_all(tolower(name),"\\."," ")," [n]"),
         category = "bio",
         driver ="biomass",
         type = "in situ",
         site = "west ice",
         date = as.Date(paste0(Category,"-12-31"))) %>%
  dplyr::select(date_accessed, URL, citation, type, site, category, driver, variable, lon, lat, date, depth, value) %>%
  filter(!is.na(value))

# Other -------------------------------------------------------------------




## Datasets ----------------------------------------------------------------

kong_data <- rbind(kong_glaucous_gull_population, 
                   kong_eiders_stock,
                   kong_seabird, 
                   kong_calanus_population,
                   kong_kittiwakke_population,
                   kong_brguillemot_population)

barents_data <- rbind(barents_polar_cod, 
                      barents_beaked_redfish_population, 
                      barents_capelin_stock, 
                      barents_golden_redfish_population, 
                      barents_northeast_cod_population, 
                      barents_young_herring_population)

svalbard_data <- rbind(svalbard_ivory_gull_population, 
                       svalbard_nw_calanus_mm_population,
                       svalbard_nw_calanus_tot_population,
                       svalbard_se_calanus_mm_population,
                       svalbard_se_calanus_tot_population,
                       svalbard_walrus_population,
                       svalbard_brguillemot_population)

is_data <- rbind(is_kittiwakke_population,
                 is_brguillemot_population)
EU_data <- rbind(EU_epagr_population,
                 EU_wpagr_population)

EU_arctic_data <- rbind(kong_data,
                     barents_data,
                     svalbard_data,
                     is_data,
                     EU_data)

arctic_data_eu <- rbind(barents_data, EU_data)



## Save data ---------------------------------------------------------------

save(EU_arctic_data, file = "users/calin/data/EU_arctic_data.RData")

save(kong_data, file = "users/calin/data/kong_data.RData")
save(svalbard_data, file = "users/calin/data/svalbard_data.RData")
save(is_data, file = "users/calin/data/is_data.RData")
save(arctic_data_eu, file = "users/calin/data/arctic_data_eu.RData")




