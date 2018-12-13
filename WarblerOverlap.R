
# Data organization -------------------------------------------------------
library(auk)
ebd_dir <- "/Volumes/MyPassport/WarblerOverlap"

f <- file.path(ebd_dir, "data/raw_data/ebd_relAug-2018.txt")
f_clean <- file.path(ebd_dir, "data/raw_data/ebd_relAug-2018_cleaned.txt")
#auk_clean(f, f_out = f_clean, remove_text = TRUE)

f_sampling <- file.path(ebd_dir, "data/raw_data/ebd_sampling_relAug-2018.txt")
f_sampling_clean <- file.path(ebd_dir, "data/raw_data/ebd_sampling_relAug-2018_cleaned.txt")
#auk_clean(f, f_out = f_sampling_clean, remove_text = TRUE)

f_in_ebd <- file.path(ebd_dir, "data/cleaned_data/ebd_relAug-2018_cleaned.txt") #define paths to ebd file
f_in_sampling <- file.path(ebd_dir, "data/cleaned_data/ebd_sampling_relAug-2018_cleaned.txt") #define paths to sampling file
auk_ebd(file = f_in_ebd, file_sampling = f_in_sampling) #create an object referencing the file

ebd_filters <- auk_ebd(f_in_ebd, f_in_sampling) %>%
  auk_species(c("Lucy’s warbler", "Virginia’s warbler", "Nashville warbler", "Orange-crowned warbler", "Tennessee warbler", "Connecticut warbler", "Mourning warbler", "MacGillivray's warbler", "Common yellowthroat", "Kentucky warbler", "Blackpoll warbler", "Chestnut-sided warbler", "Yellow warbler", "Blackburnian warbler", "Bay-breasted warbler", "Black-throated green warbler", "Hermit warbler", "Townsend’s warbler", "Black-throated gray warbler", "Grace’s warbler", "Prairie warbler", "Yellow-rumped warbler", "Yellow-throated warbler", "Pine warbler", "Palm warbler", "Black-throated blue warbler", "Magnolia warbler", "Cape May warbler", "Northern parula", "Cerulean warbler", "Hooded warbler", "American redstart", "Louisiana waterthrush", "Northern waterthrush", "Canada warbler", "Wilson’s warbler", "Blue-winged warbler", "Golden-winged warbler", "Swainson’s warbler", "Prothonotary warbler", "Black-and-white warbler", "Worm-eating warbler", "Ovenbird", "Colima warbler", "Tropical parula", "Golden-cheeked warbler", "Kirtland’s warbler", "Red-faced warbler", "Painted redstart")) %>%
  auk_date(c("2008-12-15", "2018-07-15")) %>% #filter dates
  auk_complete()
ebd_filters

f_out_ebd <- "data/cleaned_data/ebd_Parulidae.csv"
f_out_sampling <- "data/cleaned_data/ebd_Parulidae_sampling.txt"
#ebd_filtered <- auk_filter(ebd_filters, file = f_out_ebd,
                           #file_sampling = f_out_sampling)

ebd <- read_ebd(f_out_ebd)
ebd_raw <- read_ebd(f_out_ebd, rollup = FALSE) #read in raw data with no species rollup

# Load in data --------------------------------------------------------------
library(data.table) #load data.table package in order to use the fread function
ebd<-fread("/Volumes/MyPassport/WarblerOverlap/data/ebd_Parulidae.csv",data.table=FALSE) #read in filtered ebird data as a data frame
ebd_raw2<-subset(ebd,select=-c(1,3,10,11,12,14,16,19,20,21,23,24,30,31,33,36,39,43))


ebd_ruficapilla <- subset(ebd_raw2, common_name == "Nashville Warbler") #create data frame with Nashville Warbler data
ebd_ruficapilla2 <- ebd_ruficapilla[ebd_ruficapilla$subspecies_scientific_name %in% c("Oreothlypis ruficapilla ridgwayi","Oreothlypis ruficapilla ruficapilla"),] #create data frame with data from only migratory Nashville Warbler subspecies

ebd_trichas <- subset(ebd_raw2, common_name == "Common Yellowthroat") #create data frame with Common Yellowthroat data
ebd_trichas2<-ebd_trichas[ebd_trichas$subspecies_scientific_name %in% c("Geothlypis trichas [arizela Group]","Geothlypis trichas [trichas Group]"),] #create data frame with data from only migratory Common Yellowthroat subspecies

ebd_coronata <- subset(ebd_raw2, common_name == "Yellow-rumped Warbler") #create data frame with Yellow-rumped Warbler data
ebd_coronata2<-ebd_coronata[ebd_coronata$subspecies_scientific_name %in% c("Setophaga coronata coronata","Setophaga coronata audubon"),] #create data frame with data from only migratory Yellow-rumped Warbler subspecies

ebd_petechia<-subset(ebd_raw2, common_name == "Yellow Warbler") #create data frame with Yellow Warbler data
ebd_petechia2<-ebd_petechia[ebd_petechia$subspecies_scientific_name %in% c("Setophaga petechia [aestiva Group]"),] #create data frame with data from only migratory Yellow Warbler subspecies



ebd_raw3 <- droplevels( ebd_raw2[-which(ebd_raw2$common_name == "Nashville Warbler"), ] ) #remove Nashville warbler data from main eBird dataframe
ebd_raw3 <- droplevels( ebd_raw3[-which(ebd_raw2$common_name == "Common Yellowthroat"), ] ) #remove Common Yellowthroat data from main eBird dataframe
ebd_raw3 <- droplevels( ebd_raw3[-which(ebd_raw2$common_name == "Yellow-rumped Warbler"), ] ) #remove Yellow-rumped warbler data from main eBird dataframe
ebd_raw3 <- droplevels( ebd_raw3[-which(ebd_raw2$common_name == "Yellow Warbler"), ] ) #remove Yellow warbler data from main eBird dataframe


ebird_data<-rbind(ebd_raw3, ebd_ruficapilla2, ebd_trichas2, ebd_coronata2, ebd_petechia2) #recombine data from all species with non-migratory subspecies removed

ebird_data$observation_date <- as.Date(ebird_data$observation_date, format= "%Y-%m-%d") #convert dates into objects of class "Date" representing calendar dates 


winter_2008<-ebird_data[(ebird_data$observation_date > "2008-12-15" & ebird_data$observation_date < "2009-01-31"),] #filter all data from 12/15/2008 to 1/31/2009 into a new data frame called winter_2008
summer_2009<-ebird_data[(ebird_data$observation_date > "2009-06-01" & ebird_data$observation_date < "2009-07-15"),] #filter all data from 6/1/2009 to 7/15/2009 into a new data frame called summer_2009
winter_2009<-ebird_data[(ebird_data$observation_date > "2009-12-15" & ebird_data$observation_date < "2010-01-31"),] #filter all data from 12/15/2009 to 1/31/2010 into a new data frame called winter_2009
summer_2010<-ebird_data[(ebird_data$observation_date > "2010-06-01" & ebird_data$observation_date < "2010-07-15"),] #filter all data from 6/1/2010 to 7/15/2010 into a new data frame called summer_2010
winter_2010<-ebird_data[(ebird_data$observation_date > "2010-12-15" & ebird_data$observation_date < "2011-01-31"),] #filter all data from 12/15/2010 to 1/31/2011 into a new data frame called winter_20010
summer_2011<-ebird_data[(ebird_data$observation_date > "2011-06-01" & ebird_data$observation_date < "2011-07-15"),] #filter all data from 6/1/2011 to 7/15/2011 into a new data frame called summer_2011
winter_2011<-ebird_data[(ebird_data$observation_date > "2011-12-15" & ebird_data$observation_date < "2012-01-31"),] #filter all data from 12/15/2011 to 1/31/2012 into a new data frame called winter_2011
summer_2012<-ebird_data[(ebird_data$observation_date > "2012-06-01" & ebird_data$observation_date < "2012-07-15"),] #filter all data from 6/1/2012 to 7/15/2012 into a new data frame called summer_2012
winter_2012<-ebird_data[(ebird_data$observation_date > "2012-12-15" & ebird_data$observation_date < "2013-01-31"),] #filter all data from 12/15/2012 to 1/31/2013 into a new data frame called winter_2012
summer_2013<-ebird_data[(ebird_data$observation_date > "2013-06-01" & ebird_data$observation_date < "2013-07-15"),] #filter all data from 6/1/2013 to 7/15/2013 into a new data frame called summer_2013
winter_2013<-ebird_data[(ebird_data$observation_date > "2013-12-15" & ebird_data$observation_date < "2014-01-31"),] #filter all data from 12/15/2013 to 1/31/2014 into a new data frame called winter_2013
summer_2014<-ebird_data[(ebird_data$observation_date > "2014-06-01" & ebird_data$observation_date < "2014-07-15"),] #filter all data from 6/1/2014 to 7/15/2014 into a new data frame called summer_2014
winter_2014<-ebird_data[(ebird_data$observation_date > "2014-12-15" & ebird_data$observation_date < "2015-01-31"),] #filter all data from 12/15/2014 to 1/31/2015 into a new data frame called winter_2014
summer_2015<-ebird_data[(ebird_data$observation_date > "2015-06-01" & ebird_data$observation_date < "2015-07-15"),] #filter all data from 6/1/2015 to 7/15/2015 into a new data frame called summer_2015
winter_2015<-ebird_data[(ebird_data$observation_date > "2015-12-15" & ebird_data$observation_date < "2016-01-31"),] #filter all data from 12/15/2015 to 1/31/2016 into a new data frame called winter_2015
summer_2016<-ebird_data[(ebird_data$observation_date > "2016-06-01" & ebird_data$observation_date < "2016-07-15"),] #filter all data from 6/1/2016 to 7/15/2016 into a new data frame called summer_2016
winter_2016<-ebird_data[(ebird_data$observation_date > "2016-12-15" & ebird_data$observation_date < "2017-01-31"),] #filter all data from 12/15/2016 to 1/31/2017 into a new data frame called winter_2016
summer_2017<-ebird_data[(ebird_data$observation_date > "2017-06-01" & ebird_data$observation_date < "2017-07-15"),] #filter all data from 6/1/2017 to 7/15/2017 into a new data frame called summer_2017
winter_2017<-ebird_data[(ebird_data$observation_date > "2017-12-15" & ebird_data$observation_date < "2018-01-31"),] #filter all data from 12/15/2017 to 1/31/2018 into a new data frame called winter_2017
summer_2018<-ebird_data[(ebird_data$observation_date > "2018-06-01" & ebird_data$observation_date < "2018-07-15"),] #filter all data from 6/1/2018 to 7/15/2018 into a new data frame called summer_2018


ebird_data2<-rbind(winter_2008, summer_2009, winter_2009, summer_2010, winter_2010, summer_2011, winter_2011, summer_2012, winter_2012, summer_2013, winter_2013, summer_2014, winter_2014, summer_2015, winter_2015, summer_2016, winter_2016, summer_2017, winter_2017, summer_2018) #combine summer and winter data from all years into one data frame
write.csv(ebird_data2, file = "/Volumes/MyPassport/WarblerOverlap/data/ebird_data_final.csv") #save all necessary ebird data in csv file

# make world map with coordinates as plotted points --------------------------------------------------------------
library(data.table)
ebird_data3<-fread("/Volumes/MyPassport/WarblerOverlap/data/ebird_data_final.csv",data.table=FALSE)
library(ggplot2)
world<-map_data("world")
world_map<-ggplot() + geom_polygon(data = world, aes(x=long, y = lat, group = group)) + 
  coord_fixed(1.3)
  labs <- data.frame(
  long = ebird_data3$longitude,
  lat = ebird_data3$latitude,
  stringsAsFactors = FALSE
  )
world_map + 
  geom_point(data = ebird_data3, aes(x = longitude, y = latitude,color=common_name), size = 1)

# exploratory data analysis -----------------------------
library(ggplot2)

#Visualize number of each warbler species by country.


#ggplot(data=ebird_data3,mapping = aes(x = country_code, y = common_name)) +
  labs(title = "Species observations by country", x = "Country",y = "Species") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + #make x-axis labels vertical
  geom_bar(stat="identity")

#ggplot(data=ebird_data3,mapping = aes(x = country_code, y = common_name,fill=common_name)) +
  labs(title = "Species observations by country", x = "Country",y = "Species") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + #make x-axis labels vertical
  geom_bar(stat="identity")


species_location_table<-table(ebird_data3$common_name, ebird_data3$country_code)
species_location_table