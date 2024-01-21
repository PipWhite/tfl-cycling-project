# TFL(Transport for London) Cycling project

## Project Brief
This project was done as part of a business intelligence programming module while studying for my bachelors. The goal of this project was to use the publicly available TFL data to visually show a pattern using R. This would include using the libraries; readr, dplyr, ggplot2, tidyr, and stringr.
The tasks involved included; reading in csv files, understanding the files I would be working with, cleaning the data within the files, summarising the clean data, and finally using ggplot2 to visualise the data to show correlation. For my project I chose to look at cycling data and demonstrate how temperature and rainfall affects the amounts of cyclists recorded.

## Loading the data into Posit Cloud  
After downloading the csv files we needed from the TFL website, we would then save them in the same folder as our R script. These can then be read into Posit cloud using the readr library as follows:  
`WalkingCycling <- read_csv("Walking-Cycling.csv")`  
`tfl_cycle_flow_weather_unclean <- read_csv("tfl_cycle_flow_weather.csv")`  
`tfl_cycle_hires <- read_csv("tfl-daily-cycle-hires.csv")`  

## Viewing the data tables  
Now that the data has been read into Posit cloud, we want to look at the data to gain a better understanding of it. To do this we use the print function as follows:  
`print(WalkingCycling)`  
`print(tfl_cycle_flow_weather_unclean)`  
`print(tfl_cycle_hires)`  

## Cleaning the data  
In this step we want to ensure that all the data is correct and easy to understand. This includes changing column names, removing blank coloumns, removing NA values, converting data types, and removing unnecessary rows.
### Cleaning tfl_cycle_flow_weather  
Starting with the data table with the cycle and weather data, we first rename the columns.  
`rename(`  
   `` Period_F_Year = `Period and Financial year`,``  
   `` Start_P = `Start period`,``  
   `` End_P = `End period`,``  
   `` Cycle_Count_Index = `Pedal Cycle Counts Indexed`,``  
   `` Target_Index = `Periodic Target Index (adjusted for seasonality)`,``  
   `` Change_From_Last_Year = `compared to same period last year`,``  
   `` Change_From_Last_Period = `compared to previous period`,``  
   `` Compared_To_Target = `compared to target for period`,``  
   `` Current_Rolling_Avg_Compared_Last_year = `This year's rolling 13 period average compared to last year's rolling 13 period average`,``  
   `` Av_Temp_C = `Av Temp (Celsius)`,``  
   `` Av_Temp_Feel_C = `Av Feels Like temp (Celsius)``  
  `)`  
  After changing the column names we can then remove any blank and unwanted columns by selecting on the columns we need.  
  `select(`
  `  Period_F_Year,`  
  `  Start_P,`  
  `  End_P,`  
  `  Cycle_Count_Index,`  
  `  Target_Index,`  
  `  Change_From_Last_Year,`  
  `  Change_From_Last_Period,`  
  `  Compared_To_Target,`  
  `  Current_Rolling_Avg_Compared_Last_year,`   
  `  Av_Temp_C,`  
  `  Av_Temp_Feel_C,`  
  ``  `Total Rainfall (mm)`,``  
  ``  `Av Wet Hours per day`) ``  
Then we can filter out any rows with NA values.  
`filter(Start_P != "NA")`  
Finally we can convert the date columns to the correct data type,  
`mutate(Start_P = as.Date(Start_P, "%d-%b-%y")) %>% 
  mutate(End_P = as.Date(End_P, "%d-%b-%y"))`
























    
  
