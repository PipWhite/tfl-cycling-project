library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)


# Start of Task 1 ------------------------------------------
# Reading in the Walking and Cycling by borough csv
WalkingCycling <- read_csv("Walking-Cycling.csv")
#Reading in tfl cycle flow and weather csv
tfl_cycle_flow_weather_unclean <- read_csv("tfl_cycle_flow_weather.csv")
#Reading in the tfl cycle hire csv
tfl_cycle_hires <- read_csv("tfl-daily-cycle-hires.csv")
#End of Task 1 ---------------------------------------------

WalkingCycling
tfl_cycle_flow_weather_unclean
tfl_cycle_hires






#Start of task 3 ------------------------------------------
#tfl_cycle_flow_weather cleaning section
#Changing some column names and creating a dataframe with relevant columns
tfl_cycle_flow_weather <- tfl_cycle_flow_weather_unclean %>% 
  rename(
    Period_F_Year = `Period and Financial year`,
    Start_P = `Start period`,
    End_P = `End period`,
    Cycle_Count_Index = `Pedal Cycle Counts Indexed`,
    Target_Index = `Periodic Target Index (adjusted for seasonality)`,
    Change_From_Last_Year = `compared to same period last year`,
    Change_From_Last_Period = `compared to previous period`,
    Compared_To_Target = `compared to target for period`,
    Current_Rolling_Avg_Compared_Last_year = `This year's rolling 13 period average compared to last year's rolling 13 period average`,
    Av_Temp_C = `Av Temp (Celsius)`,
    Av_Temp_Feel_C = `Av Feels Like temp (Celsius)`
  ) %>% 
  select(
    Period_F_Year,
    Start_P,
    End_P,
    Cycle_Count_Index,
    Target_Index,
    Change_From_Last_Year,
    Change_From_Last_Period,
    Compared_To_Target,
    Current_Rolling_Avg_Compared_Last_year,
    Av_Temp_C,
    Av_Temp_Feel_C,
    `Total Rainfall (mm)`,
    `Av Wet Hours per day`)
#Filtering out NA values
tfl_cycle_flow_weather <- tfl_cycle_flow_weather %>% 
  filter(Start_P != "NA")

#Converting character data types to date data types
tfl_cycle_flow_weather <- tfl_cycle_flow_weather %>% 
  mutate(Start_P = as.Date(Start_P, "%d-%b-%y"))

tfl_cycle_flow_weather <- tfl_cycle_flow_weather %>% 
  mutate(End_P = as.Date(End_P, "%d-%b-%y"))


#tfl_cycle_hires cleaning section
#Number of hires by day
tfl_cycle_hires_Day <- tfl_cycle_hires %>%  
  rename(
    Number_of_Bicycle_hires = `Number of Bicycle Hires...2`
  ) %>% 
  select(
    Day,
    Number_of_Bicycle_hires
  )
  
tfl_cycle_hires_Day <- tfl_cycle_hires_Day %>% 
  mutate(Day = as.Date(Day, "%d/%m/%Y"))
tfl_cycle_hires_Day

#Number of hires by month
tfl_cycle_hires_Month <- tfl_cycle_hires %>%  
  rename(
    Month = `Month...4`,
    Number_of_Bicycle_hires = `Number of Bicycle Hires...5`,
    Avg_Hire_Time_mins = `Average Hire Time (mins)`
  ) %>% 
  select(
    Month,
    Number_of_Bicycle_hires,
    Avg_Hire_Time_mins
  ) %>% 
  filter(Month != "NA")

tfl_cycle_hires_Month <- tfl_cycle_hires_Month %>% 
  mutate(Month = as.Date(paste("01", Month), format = "%b %y"))

#Number of hires by year
tfl_cycle_hires_Year <- tfl_cycle_hires %>%  
  rename(
    Number_of_Bicycle_hires = `Number of Bicycle Hires...8`
  ) %>% 
  select(
    Year,
    Number_of_Bicycle_hires
  ) %>% 
  filter(Year != "NA") %>% 
  slice(1:13) %>% 
  mutate(Number_of_Bicycle_hires = as.numeric(str_remove_all(Number_of_Bicycle_hires, ",")))



#WalkingCycling cleaning section

#Filtering out country regions
WalkingCycling_London <- WalkingCycling[
  !(WalkingCycling$`Local Authority`== "East Midlands"|
      WalkingCycling$`Local Authority`== "East of England"|
      WalkingCycling$`Local Authority`== "ENGLAND"|
      WalkingCycling$`Local Authority`== "London"|
      WalkingCycling$`Local Authority`== "North East"|      
      WalkingCycling$`Local Authority`== "North West"|
      WalkingCycling$`Local Authority`== "South East"|
      WalkingCycling$`Local Authority`== "South West"|
      WalkingCycling$`Local Authority`== "West Midlands"),
] %>% 
  filter(Year != "2010/11")
#Only regions
WalkingCycling_Regions <- WalkingCycling[
  (WalkingCycling$`Local Authority`== "East Midlands"|
      WalkingCycling$`Local Authority`== "East of England"|
      WalkingCycling$`Local Authority`== "ENGLAND"|
      WalkingCycling$`Local Authority`== "London"|
      WalkingCycling$`Local Authority`== "North East"|      
      WalkingCycling$`Local Authority`== "North West"|
      WalkingCycling$`Local Authority`== "South East"|
      WalkingCycling$`Local Authority`== "South West"|
      WalkingCycling$`Local Authority`== "West Midlands"),
] %>% 
  filter(Year != "2010/11")

#End of task 3 ----------------------------------------



#Start of task 4 --------------------------------------

summary(tfl_cycle_flow_weather)

summary(tfl_cycle_hires_Day)

summary(WalkingCycling_London)
WalkingCycling_London %>% 
  count(`Local Authority`)

#End of task 4 ----------------------------------------



#Start of task 5 --------------------------------------

ggplot(tfl_cycle_hires_Day, 
       aes(Day, 
           Number_of_Bicycle_hires)
) + geom_line()

#cycle flow by temp
ggplot(tfl_cycle_flow_weather, 
       aes(Start_P)) +
  geom_line(aes(y = Av_Temp_C, colour = "Red")) +
  geom_line(aes(y = Cycle_Count_Index, colour = "Blue")) 

#cycle flow by rainfall
ggplot(tfl_cycle_flow_weather, 
       aes(Start_P)) +
  geom_line(aes(y = `Total Rainfall (mm)`, colour = "Red")) +
  geom_line(aes(y = Cycle_Count_Index, colour = "Blue")) 
#End of task 5 ----------------------------------------


WalkingCycling %>% count(Year)
WalkingCycling %>% count(Frequency)
#Filtered only showing results where frequency is 1x per week
WalkingCycling_1_per_week <- WalkingCycling %>% 
  filter(Frequency == "1x per week")

WalkingCycling_1_per_week

#Filtering out country regions
WalkingCycling_1_per_week_London_regions <- WalkingCycling_1_per_week[
  !(WalkingCycling_1_per_week$`Local Authority`== "East Midlands"|
      WalkingCycling_1_per_week$`Local Authority`== "East of England"|
      WalkingCycling_1_per_week$`Local Authority`== "ENGLAND"|
      WalkingCycling_1_per_week$`Local Authority`== "London"|
      WalkingCycling_1_per_week$`Local Authority`== "North East"|      
      WalkingCycling_1_per_week$`Local Authority`== "North West"|
      WalkingCycling_1_per_week$`Local Authority`== "South East"|
      WalkingCycling_1_per_week$`Local Authority`== "South West"|
      WalkingCycling_1_per_week$`Local Authority`== "West Midlands"),
] %>% 
  filter(Year != "2010/11")

WalkingCycling_1_per_week_London_regions
#Making data frame for regions
WalkingCycling_1_per_week_country_regions <- WalkingCycling_1_per_week[
  (WalkingCycling_1_per_week$`Local Authority`== "East Midlands"|
     WalkingCycling_1_per_week$`Local Authority`== "East of England"|
     WalkingCycling_1_per_week$`Local Authority`== "ENGLAND"|
     WalkingCycling_1_per_week$`Local Authority`== "London"|
     WalkingCycling_1_per_week$`Local Authority`== "North East"|      
     WalkingCycling_1_per_week$`Local Authority`== "North West"|
     WalkingCycling_1_per_week$`Local Authority`== "South East"|
     WalkingCycling_1_per_week$`Local Authority`== "South West"|
     WalkingCycling_1_per_week$`Local Authority`== "West Midlands"),
]
WalkingCycling_1_per_week_country_regions
#plotting percentages of walking for London region 2011 - 2018
ggplot(WalkingCycling_1_per_week_London_regions, 
       aes(Year, 
           `Walking_%`, 
           colour = `Local Authority`,
           group = `Local Authority`)
) + geom_line()

