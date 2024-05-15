library(tidyverse)
library(tidyr)
library(ggplot2)
library(dplyr)

#import data
male_players <- read.csv("C:/Users/Kaize/Desktop/CSV/male_players.csv")
view(male_players)

#Select columns for analyze
df <- male_players %>% select( short_name, player_positions, overall,
                              pace, shooting, passing, dribbling,
                              defending, physic, 
                              goalkeeping_diving, goalkeeping_handling,
                              goalkeeping_kicking, goalkeeping_positioning,
                              goalkeeping_reflexes, goalkeeping_speed,
                              age,value_eur, wage_eur, height_cm, 
                              weight_kg,club_name, league_name, 
                              nationality_name )
                      
#Preview data
head(df,5)

#Replace NA values with 0
df <- replace(df,is.na(df),0)

#Check NA values
sum(is.na(df))

#Separate players position to 2 columns
df <- df %>% separate(col = player_positions,into = c("player_position","player_position2"),
                sep = ",")

#drop player position2 column
df <- df%>%select(-player_position2)

#Show data Structer
str(df)

#Count each players position
df %>% count(player_position)

#Categories player position forward , midfielder ,defender , goalkeeper
df <- df %>% mutate(main_position = case_when(
                   player_position == "ST" ~ "Forward",
                   player_position == "LW" ~ "Forward",
                   player_position == "RW" ~ "Forward",
                   player_position == "CF" ~ "Forward",
                   player_position == "CAM"~ "Midfielder",
                   player_position == "CM" ~ "Midfielder",
                   player_position == "CDM"~ "Midfielder",
                   player_position == "LM" ~ "Midfielder",
                   player_position == "RM" ~ "Midfielder",
                   player_position == "LWB"~ "Defender",
                   player_position == "RWB"~ "Defender",
                   player_position == "LB" ~ "Defender",
                   player_position == "CB" ~ "Defender",
                   player_position == "RB" ~ "Defender",
                   player_position == "GK" ~ "goalkeeper"))

# Question 1 
##Who is the highest overall each main position

#forward position

df %>% select(short_name,player_position,overall) %>%
       filter(df$main_position == "Forward") %>%
       head(10)

#midfielder      

df %>% select(short_name,player_position,overall) %>%
       filter(df$main_position == "Midfielder") %>%
       head(10)

#Defender

df %>% select(short_name,player_position,overall) %>%
       filter(df$main_position == "Defender") %>%
       head(10)

#Goalkeeper
df %>% select(short_name,player_position,overall) %>%
       filter(df$main_position == "goalkeeper") %>%
       head(10)


# Question 2 
##Find Top 10 player who have highest Value 
df %>% select(short_name, main_position, age,value_eur, club_name) %>%
       arrange(desc(value_eur)) %>%
       head(10)

#Highest player value is E.Haaland position forward his club is Manchester City


# Question 3
## What is relationship between age of player and price of player

cor(df$age,df$value_eur)

#visualize distribution graph player value and age  

hist(df$age)
hist(df$value_eur)

#make scatter plot for visualize correlation between age and player value

ggplot(df,aes(x = age,y =value_eur,color = "red"))+
  geom_point()+
  labs( title = "player value vs player age",
  x = "age",  
  y = "Value Eur")

#This is negative correlation if player more older value will decrease if player more younger value will increase


##Question 4
##Find top 10 player who have highest wage

df %>% select(short_name, main_position, age,
               age_eur, club_name) %>%
       arrange(desc(wage_eur)) %>%
       head(10)

#Player who have highest wage is K.De Bruyne form Manchester city


# Question 5
## What is relationship between age of player and wage of player

cor(df$age,df$wage_eur)

#make scatter plot for visualize correlation between age and player value

ggplot(df,aes(x = age,y =wage_eur,color = "blue"))+
  geom_point()+
  labs( title = "player value vs player age",
        x = "age",  
        y = "wage")

#This is negative correlation if player more older wage will decrease if player more younger wage will increase


#Question 6
## What is the club have highest total of player and show average wage of player

Values <- df %>% group_by(club_name) %>%
  summarise(total_price = sum(value_eur),
            Avg_price = mean(value_eur)) %>%
  arrange(desc(total_price)) %>%
  head(10)

print(Avg_club)

#visualization
ggplot(Avg_club,aes(x = total_price, y = club_name))+
  geom_col()+
  labs(title = "Player values by club",
       x = "Average Price",
       y = "Club Name")


#Question 7
##What is the club have highest total wage of player and show average wage of player

Wage <- df %>% group_by(club_name) %>%
       summarise(total_wage = sum(wage_eur),
                 Avg_wage = mean(wage_eur)) %>%
       arrange(desc(total_wage)) %>%
       head(10)

print(Wage)

#Visualization
ggplot(Wage ,aes(x = total_wage, y = club_name))+
  geom_col()+
  labs(title = "Player wage by club",
       x = "Average Price",
       y = "Club Name")


#Question 8 
##who is highest player overall in each league

#Premier League
df%>% select(short_name,league_name,club_name,
             overall) %>% 
             filter(league_name == "Premier League") %>%
             arrange(desc(overall)) %>%
             head(10)
#La Liga
df%>% select(short_name,league_name,club_name,
             overall) %>% 
             filter(league_name == "La Liga") %>%
             arrange(desc(overall)) %>%
             head(10)

#Bundesliga
df%>% select(short_name,league_name,club_name,
             overall) %>% 
  filter(league_name == "Bundesliga") %>%
  arrange(desc(overall)) %>%
  head(10)

#Serie A
df%>% select(short_name,league_name,club_name,
             overall) %>% 
  filter(league_name == "Serie A") %>%
  arrange(desc(overall)) %>%
  head(10)

#Ligue 1
df%>% select(short_name,league_name,club_name,
             overall) %>% 
  filter(league_name == "Ligue 1") %>%
  arrange(desc(overall)) %>%
  head(10)


#Question 9 
##who is highest values in each top 5 football league

#Premier League
df%>% select(short_name,league_name,
             club_name, overall,
             value_eur) %>% 
  filter(league_name == "Premier League") %>%
  arrange(desc(value_eur)) %>%
  head(10)

#La Liga
df%>% select(short_name,league_name,
             club_name, overall,
             value_eur) %>% 
  filter(league_name == "La Liga") %>%
  arrange(desc(value_eur)) %>%
  head(10)

#Bundesliga
df%>% select(short_name,league_name,
             club_name, overall,
             value_eur) %>% 
  filter(league_name == "Bundesliga") %>%
  arrange(desc(value_eur)) %>%
  head(10)

#Serie A
df%>% select(short_name,league_name,
             club_name, overall,
             value_eur) %>% 
  filter(league_name == "Serie A") %>%
  arrange(desc(value_eur)) %>%
  head(10)

#Ligue 1
df%>% select(short_name,league_name,
             club_name, overall,
             value_eur) %>% 
  filter(league_name == "Ligue 1") %>%
  arrange(desc(value_eur)) %>%
  head(10)


#Question 10
##who is highest wage in each top 5 football league

#Premier League
df%>% select(short_name,league_name,
             club_name, overall,
             wage_eur) %>% 
  filter(league_name == "Premier League") %>%
  arrange(desc(wage_eur)) %>%
  head(10)

#La Liga
df%>% select(short_name,league_name,
             club_name, overall,
             wage_eur) %>% 
  filter(league_name == "La Liga") %>%
  arrange(desc(wage_eur)) %>%
  head(10)

#Bundesliga
df%>% select(short_name,league_name,
             club_name, overall,
             wage_eur) %>% 
  filter(league_name == "Bundesliga") %>%
  arrange(desc(wage_eur)) %>%
  head(10)

#Serie A
df%>% select(short_name,league_name,
             club_name, overall,
             wage_eur) %>% 
  filter(league_name == "Serie A") %>%
  arrange(desc(wage_eur)) %>%
  head(10)

#Ligue 1
df%>% select(short_name,league_name,
             club_name, overall,
             wage_eur) %>% 
  filter(league_name == "Ligue 1") %>%
  arrange(desc(wage_eur)) %>%
  head(10)





