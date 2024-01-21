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

  ###Cleaning tfl_cycle_hires (day)
  This table will show the number of hires daily
  To clean the cycle hires data table we will first rename the columns.  
  ``rename(
    Number_of_Bicycle_hires = `Number of Bicycle Hires...2`
  )``  
  Then selecting the appropriate columns.  
  `select(
    Day,
    Number_of_Bicycle_hires
  )`  
  And finally changing the appropriate data types.  
  `mutate(Day = as.Date(Day, "%d/%m/%Y"))`  

  ### Cleaning tfl_cycle_hires (month)
  This table will show the number of hires per month  
  Firstly we will change the column names.  
  `rename(`  
  ``  Month = `Month...4`,``  
  ``  Number_of_Bicycle_hires = `Number of Bicycle Hires...5`,``  
  ``  Avg_Hire_Time_mins = `Average Hire Time (mins)` ``  
  `)`  
  Followed by selecting the appropriate columns.  
  `select(`  
  `  Month,`  
  `  Number_of_Bicycle_hires,`  
  `  Avg_Hire_Time_mins`  
  `)`  
  Then we will remove any rows with NA values.  
  `filter(Month != "NA")`  
  And finally we convert the appropriate columns to the date data type.  
  `mutate(Month = as.Date(paste("01", Month), format = "%d %b %y"))`  

  ### Cleaning tfl_cycle_hires (year)
  This table will show the number of hires per year  
  Firstly we will change the column names.  
  `` rename(
    Number_of_Bicycle_hires = `Number of Bicycle Hires...8`
  )``  
  Then slecting the appropriate columns.  
  `select(`  
    `Year,`  
    `Number_of_Bicycle_hires`  
  `)`  
  And removing rows with NA values.  
  `filter(Year != "NA")`  
  Removing all rows after row 13 as they are not needed.  
  `slice(1:13)`  
  Finally removing all the commas from a column and converting it to numeric data.  
  `mutate(Number_of_Bicycle_hires = as.numeric(str_remove_all(Number_of_Bicycle_hires, ",")))`  

  ### Cleaning WalkingCycling (London)
  Firstly we'd like to filter out all of the country regions so we only have data for London.  
  ``WalkingCycling_London <- WalkingCycling[``  
  ``!(WalkingCycling$`Local Authority`== "East Midlands"|``  
  ``    WalkingCycling$`Local Authority`== "East of England"|``  
  ``    WalkingCycling$`Local Authority`== "ENGLAND"|``  
  ``    WalkingCycling$`Local Authority`== "London"|``  
  ``    WalkingCycling$`Local Authority`== "North East"|``        
  ``    WalkingCycling$`Local Authority`== "North West"|``  
  ``    WalkingCycling$`Local Authority`== "South East"|``  
  ``    WalkingCycling$`Local Authority`== "South West"|``  
  ``    WalkingCycling$`Local Authority`== "West Midlands"),``  
`]`  
Them we will select the correct year range.  
`filter(Year != "2010/11")`  

### Cleaning WalkingCycling (Regions)
Instead of filtering out the regions we now want to keep them.  
`WalkingCycling_Regions <- WalkingCycling[`  
``  (WalkingCycling$`Local Authority`== "East Midlands"|``  
``     WalkingCycling$`Local Authority`== "East of England"|``  
``     WalkingCycling$`Local Authority`== "ENGLAND"|``  
``     WalkingCycling$`Local Authority`== "London"|``  
``     WalkingCycling$`Local Authority`== "North East"|``        
``     WalkingCycling$`Local Authority`== "North West"|``  
``     WalkingCycling$`Local Authority`== "South East"|``  
``     WalkingCycling$`Local Authority`== "South West"|``  
``     WalkingCycling$`Local Authority`== "West Midlands"),``  
`]`  
And once again filtering the correct year range.  
`filter(Year != "2010/11")`  

## Getting an overview of the data tables
We now want to get a better understaning of the different data tables. To do this we can use the summary function.  
`summary(tfl_cycle_flow_weather)`  
![image](https://github.com/PipWhite/tfl-cycling-project/assets/74298321/5d544d46-32ba-41c8-af78-593be50bcc25)

`summary(tfl_cycle_hires_Day)`  
![image](https://github.com/PipWhite/tfl-cycling-project/assets/74298321/a10ce551-2e4c-4f14-9970-c12dbed9afea)  

`summary(WalkingCycling_London)`  
![image](https://github.com/PipWhite/tfl-cycling-project/assets/74298321/b98f5195-8463-418c-8543-72050c8900b5)  

We would also like to see how many rtecords are in each local authority from the WalkingCycling_London data table.  
`WalkingCycling_London %>% 
  count(`Local Authority`)`  
![image](https://github.com/PipWhite/tfl-cycling-project/assets/74298321/e2d6d36c-1289-4b96-af72-8cfa038b9aa1)  

## Creating data visuals  
In this section we will be using the data we've prepared to create visuals that demonstrate trend.  

This code creates a line plot that shows the number of bicycle hires over time.  
`ggplot(tfl_cycle_hires_Day, `  
`       aes(Day, `  
`           Number_of_Bicycle_hires)`  
`) + geom_line()`  
![image](https://github.com/PipWhite/tfl-cycling-project/assets/74298321/1e322fec-b654-4bad-8e38-f1f147ba8a90)  
On its own it isn't very helpful but it is clear to see that their is a pattern when it comes to the number of hires.  


Next we will create a plot that shows the cycle flow as well as the average temperature to see if they line up in any way.  
`coeff <- 0.05`  
`ggplot(tfl_cycle_flow_weather, `  
`       aes(Start_P)) +`  
`  geom_line(aes(y = Cycle_Count_Index, colour = "Cycle Count Index")) +`  
`  geom_area(aes(y = Av_Temp_C/coeff, fill = "Average Temp"), alpha = 0.5) +`  
`  scale_y_continuous(`  
`    `  
`    # Features of the first axis`  
`    name = "Cycle Count Index (%)",`  
`    `  
`    # Add a second axis and specify its features`  
`    sec.axis = sec_axis( trans=~.*coeff, name="Average Temp (C)")`  
`  ) +`  
`  scale_color_manual(values = c("Cycle Count Index" = "blue")) +`  
`  labs(x = "Date", `  
`       colour = "", `  
`       fill = "", `  
`       title = "4 weekly cycle index and the average temperature against time")`  
![image](https://github.com/PipWhite/tfl-cycling-project/assets/74298321/1fa99571-a34a-47f6-8310-f6d6e8fc6436)  
From the plot it is clear to see that there is a clear correlation between the average temperature and cycle flow. To give a value to this we can do a correlation test using this line of code.  
`cor.test(tfl_cycle_flow_weather$Cycle_Count_Index, tfl_cycle_flow_weather$Av_Temp_C)`  
This gives a correlation value of 0.7131776

Next we want to join the cycle hires table with the cycle flow weather table by date using the following code.  
`joined_cycles <- tfl_cycle_hires_Day %>% `  
`  mutate(label = cut.Date(Day, tfl_cycle_flow_weather$Start_P)) %>%`  
`  mutate(datelabel = as.Date(as.character(label))) %>%`  
`  left_join(tfl_cycle_flow_weather, by = c("datelabel" = "Start_P")) %>% `  
`  filter(!is.na(Av_Temp_C))`  

 Using this newly created table we can now create a plot that shows the number of cycle hires against the average temperature over time.  
`coeff3 <- 0.00025`  
`ggplot(joined_cycles, `  
`       aes(Day)) +`  
`  geom_line(aes(y = Number_of_Bicycle_hires, colour = "Number of Bicycle Hires")) +`  
`  geom_area(aes(y = Av_Temp_C/coeff3, fill = "Average Temp"), alpha = 0.5) +`  
`  scale_y_continuous(`  
`    `  
`    # Features of the first axis`  
`    name = "Number of Bicycle Hires",`  
`    `  
`    # Add a second axis and specify its features`  
`    sec.axis = sec_axis( trans=~.*coeff3, name="Average Temp (C)")`  
`  ) +`  
`  scale_color_manual(values = c("Number of Bicycle Hires" = "blue")) +`  
`  labs(x = "Date", `  
`       colour = "", `  
`       fill = "", `  
`       title = "Daily cycle index and the average temperature against time")`  
![image](https://github.com/PipWhite/tfl-cycling-project/assets/74298321/1759b7a9-5cf2-40c2-9fdc-38feff0ff4b8)  
Looking at the plot we can see a clear correlation between the number of bicycle hires and the average temperature. 
To furthe show the correlation we can do another correlation test.  
`cor.test(joined_cycles$Number_of_Bicycle_hires, joined_cycles$Av_Temp_C)`  
This test show a 0.5782522 correlation value.  


























    
  
