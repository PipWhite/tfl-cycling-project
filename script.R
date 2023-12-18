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

#Start of task 2 -------------------------------------------
print(WalkingCycling)
print(tfl_cycle_flow_weather_unclean)
print(tfl_cycle_hires)
#End of task 2 ---------------------------------------------

#Start of task 3 ------------------------------------------
#tfl_cycle_flow_weather cleaning section
#Changing some column names and creating a dataframe with relevant columns
tfl_cycle_flow_weather <- tfl_cycle_flow_weather_unclean %>% 
  # renaming columns to be easier to read
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
  # Selecting appropriate columns, leaving out any blank columns
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
    `Av Wet Hours per day`) %>% 
  #Filtering out NA values
  filter(Start_P != "NA") %>% 
  #Converting character data types to date data types
  mutate(Start_P = as.Date(Start_P, "%d-%b-%y")) %>% 
  mutate(End_P = as.Date(End_P, "%d-%b-%y"))


#tfl_cycle_hires cleaning section
#Number of hires by day
tfl_cycle_hires_Day <- tfl_cycle_hires %>%  
  # renaming columns for easier reading
  rename(
    Number_of_Bicycle_hires = `Number of Bicycle Hires...2`
  ) %>% 
  #selecting appropriate columns
  select(
    Day,
    Number_of_Bicycle_hires
  ) %>% 
  #Changing data type to date
  mutate(Day = as.Date(Day, "%d/%m/%Y"))
tfl_cycle_hires_Day

#Number of hires by month
tfl_cycle_hires_Month <- tfl_cycle_hires %>%  
  #renaming columns for easier reading
  rename(
    Month = `Month...4`,
    Number_of_Bicycle_hires = `Number of Bicycle Hires...5`,
    Avg_Hire_Time_mins = `Average Hire Time (mins)`
  ) %>% 
  #Selecting the appropriate columns
  select(
    Month,
    Number_of_Bicycle_hires,
    Avg_Hire_Time_mins
  ) %>% 
  #Removing NA values in the month column
  filter(Month != "NA") %>% 
  #converting to the date data type
  mutate(Month = as.Date(paste("01", Month), format = "%d %b %y"))

#Number of hires by year
tfl_cycle_hires_Year <- tfl_cycle_hires %>%  
  #Renaming columns for easier reading
  rename(
    Number_of_Bicycle_hires = `Number of Bicycle Hires...8`
  ) %>% 
  #Selecting the appropriate columns
  select(
    Year,
    Number_of_Bicycle_hires
  ) %>% 
  #Removing rows with NA values in the YEar column
  filter(Year != "NA") %>% 
  #removing all rows after row 13
  slice(1:13) %>% 
  #Removing the commas from a column and converting it to a numeric data type
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

#Filtering out all exept the country regions
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

# retrieving the mean from the cycle count index and the target index
summary(tfl_cycle_flow_weather)

# retreving the mean amount of hires
summary(tfl_cycle_hires_Day)


summary(WalkingCycling_London)
#Counting how many recording there are in each local authority
WalkingCycling_London %>% 
  count(`Local Authority`)

#End of task 4 ----------------------------------------



#Start of task 5 --------------------------------------

#Cycle hires by day
ggplot(tfl_cycle_hires_Day, 
       aes(Day, 
           Number_of_Bicycle_hires)
) + geom_line()

#cycle flow and average temperature against time
coeff <- 0.05

ggplot(tfl_cycle_flow_weather, 
       aes(Start_P)) +
  geom_line(aes(y = Cycle_Count_Index, colour = "Cycle Count Index")) +
  geom_area(aes(y = Av_Temp_C/coeff, fill = "Average Temp"), alpha = 0.5) +
  scale_y_continuous(
    
    # Features of the first axis
    name = "Cycle Count Index (%)",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis( trans=~.*coeff, name="Average Temp (C)")
  ) +
  scale_color_manual(values = c("Cycle Count Index" = "blue")) +
  labs(x = "Date", 
       colour = "", 
       fill = "", 
       title = "4 weekly cycle index and the average temperature against time")

#The correlation of the visualised data
cor.test(tfl_cycle_flow_weather$Cycle_Count_Index, tfl_cycle_flow_weather$Av_Temp_C)


#Joining the cycle hires table with the cycle flow weather table 
joined_cycles <- tfl_cycle_hires_Day %>% 
  mutate(label = cut.Date(Day, tfl_cycle_flow_weather$Start_P)) %>%
  mutate(datelabel = as.Date(as.character(label))) %>%
  left_join(tfl_cycle_flow_weather, by = c("datelabel" = "Start_P")) %>% 
  filter(!is.na(Av_Temp_C))

#Number of cycle hires and the average temp against time
coeff3 <- 0.00025
ggplot(joined_cycles, 
       aes(Day)) +
  geom_line(aes(y = Number_of_Bicycle_hires, colour = "Number of Bicycle Hires")) +
  geom_area(aes(y = Av_Temp_C/coeff3, fill = "Average Temp"), alpha = 0.5) +
  scale_y_continuous(
    
    # Features of the first axis
    name = "Number of Bicycle Hires",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis( trans=~.*coeff3, name="Average Temp (C)")
  ) +
  scale_color_manual(values = c("Number of Bicycle Hires" = "blue")) +
  labs(x = "Date", 
       colour = "", 
       fill = "", 
       title = "Daily cycle index and the average temperature against time")

#The correlation of the visualised data
cor.test(joined_cycles$Number_of_Bicycle_hires, joined_cycles$Av_Temp_C)
 #End of task 5 ----------------------------------------