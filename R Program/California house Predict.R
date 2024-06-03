##load library
library(readr)
library(ggplot2)
library(tidyverse)
library(caret)


##import .csv
California_housing <- read.csv("~/CSV/California-housing.csv")

##preview data
head(California_housing)

##show data structure
str(California_housing)

## Create new variables for prepare model
df <-  California_housing %>% select(-longitude,-latitude)

head(df)

##import library psych for summary statistics data set
library(psych)

describe(df)

## lock random sample for use 
set.seed(42)
df2 <- sample_frac(df , 0.1)

str(df2)


# Count the number of NA values in each column
colSums(is.na(df2))

#Replace NA with means values
df2$total_bedrooms[is.na(df2$total_bedrooms)] <- mean(df2$total_bedrooms
                                                    ,na.rm = TRUE)
#check NA values
colSums(is.na(df2))


##Create dummy variables using the model.matrix function

dummy_df<- data.frame(df2, model.matrix(~ ocean_proximity  - 1,
                                            df2))

##Remove the original 'Ocean_proximity' column
dummy_df$ocean_proximity <- NULL

head(dummy_df)


##house price distribution

ggplot(dummy_df, aes(median_house_value))+
  geom_histogram()+
  labs(title = "histogram of median house value",
       x = "median house values")


## Create split data function
## split data 80% train, 20% test

split_data <- function(df) {
  set.seed(42)
  n <- nrow( dummy_df )
  train_id <- sample(1:n, size = 0.8 *n)
  train_df <- dummy_df[train_id, ]
  test_df <- dummy_df[-train_id, ]
  # return
  list( training = train_df, 
        testing = test_df ) 
}

prep_data <- split_data(dummy_df)
train_df <- prep_data[[1]]
test_df <- prep_data[[2]]


## Train Multiple Linear Regression model
set.seed(42)
lmhousing <- train(median_house_value ~ . ,
                  data = train_df,
                  method = 'lm',
                  na.action = na.exclude)
lmhousing

#model summary
summary(lmhousing)

##predicted

Predictedhouse <- predict(lmhousing ,newdata = test_df )
Predictedhouse

# mean absolute error
mae <- mean(abs(Predictedhouse - test_df$median_house_value))
mae

#mean squared error
mse <- mean((Predictedhouse - test_df$median_house_value)**2)
mse

# root mean squared error
rmse <- sqrt(mean((Predictedhouse - test_df$median_house_value)**2))
rmse


cal_mae <- function(actual, pred){
  error <- actual - pred
  mean(abs(error))
}

cal_mse <- function(actual, pred){
  error <- actual - pred
  mean(error ** 2)
}

cal_rmse <- function(actual, pred){
  error <- actual - pred
  sqrt(mean(error ** 2))
}


cal_mae(test_df$median_house_value , Predictedhouse)
cal_mse(test_df$median_house_value , Predictedhouse)
cal_rmse(test_df$median_house_value , Predictedhouse)


varImp(lmhousing)

#plot linear regression graph

houseplot <- ggplot(df, aes(x = median_income,
                              y = median_house_value))+
            geom_point()+
            labs(title = "House price per median values",x ='House Median Values',
            y = 'House price')

houseplot + geom_abline(aes(intercept = 45086 , slope = 41794), 
                            col = 'blue')         
         

         