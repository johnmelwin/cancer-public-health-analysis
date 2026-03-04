# Data set: 2015 Cancer Data 
# Source: https://www.cancer.org/

## STEP 1: Setup and Pre-Analysis of data

# Remove scientific notation and supress warnings
options(scipen=999)
options(warn=-1)
#View the head of the data
head(df)
# view the number of rows and columns
dim(df)
# get the summary of cancer data
summary(df)



### STEP 2: Cleaning and pre-processing data

# Remove NA rows
df <- na.omit(df)

# Replacing '*' values in fiveYearTrend predictor variable
df$fiveYearTrend=gsub("\\*","unknown",df$fiveYearTrend)


# Feature generation: Creating a new predictor variable (Region) based on state location.
# Region predictor variable will be used for model creation
for(i in 1:nrow(df))
{
  if(df$State[i] == "AL" | df$State[i] == "DE" | df$State[i] == "DC" | df$State[i] == "FL" | df$State[i] == "GA" | df$State[i] == "MD" | df$State[i] == "NC" | df$State[i] == "SC" | df$State[i] == "VA" | df$State[i] == "WV" | df$State[i] == "KY" | df$State[i] == "MS" | df$State[i] == "TN" | df$State[i] == "AR" | df$State[i] == "LA" | df$State[i] == "OK" | df$State[i] == "TX")
  {
    df$Region[i] = "South"
  }
  
  else if(df$State[i] == "CT" | df$State[i] == "ME" | df$State[i] == "MA" | df$State[i] == "NH" | df$State[i] == "RI" | df$State[i] == "VT" | df$State[i] == "NJ" | df$State[i] == "NY" | df$State[i] == "PA")
  {
    df$Region[i] = "NorthEast"
  }
  
  else if(df$State[i] == "IN" | df$State[i] == "IL" | df$State[i] == "MI" | df$State[i] == "OH" | df$State[i] == "WI" | df$State[i] == "IA" | df$State[i] == "KS" | df$State[i] == "MN" | df$State[i] == "MO" | df$State[i] == "NE" | df$State[i] == "ND" | df$State[i] == "SD")
  {
    df$Region[i] = "Midwest"
  }
  
  else
  {
    df$Region[i] = "West"
  }
  
}

# Converting fiveYearTrend variable to categorical variable
for(i in 1:nrow(df))
{
  if(df$fiveYearTrend[i] < 0)
  {
    df$catfiveYearTrend[i] = "low"
  }
  else if(df$fiveYearTrend[i]  == "unknown" )
  {
    df$catfiveYearTrend[i] = "unknown"
  }
  else if(df$fiveYearTrend[i] == 0 )
  {
    df$catfiveYearTrend[i] = "stable"
  }
  else if(df$fiveYearTrend[i] > 0 )
  {
    df$catfiveYearTrend[i] = "high"
  }
  
  else
  {
    df$catfiveYearTrend[i] = "unknown"
  }
}

#convert recent trend to categorical values
df$recentTrend = as.factor(df$recentTrend)
df$recentTrend[is.na(df$recentTrend)] <- 0
df$recentTrend[df$recentTrend == "*"] <- "unknown"


#convert rectrend to categorical values
df$recTrend = as.factor(df$recTrend)
df$recTrend[is.na(df$recTrend)] <- 0
df$recTrend[df$recTrend == "*"] <- "unknown"


df <- na.omit(df)
## STEP 3: Build Models

### MODEL 1

#Build model to predict deathRate with PovertyEst, popEst2015, catfiveYearTrend, deathRate, medIncome
fit1 = lm(deathRate ~ PovertyEst + popEst2015 +  incidenceRate + avgDeathsPerYear+medIncome, data=df)
summary(fit1)


#convert recent trend to categorical values
df$State = as.factor(df$State)


### MODEL 2

# checking correlation between predictor variables 
cor(df[,c(  'PovertyEst', 'popEst2015', 'incidenceRate', 'avgAnnCount' , 'deathRate' , 'avgDeathsPerYear' , 'medIncome'  )])


# remove poverty estimate as it is highly correlated with population estimate variable and also it is not significantly contributing
#remove avgDeathsPerYear(R square will increase)
#remove recent trend
#including region feature which was generated

df$fiveYearTrend[is.na(df$fiveYearTrend)] <- 0
df$catfiveYearTrend = as.factor(df$catfiveYearTrend)
df$fiveYearTrend = as.integer(df$fiveYearTrend)
fit2 = lm(deathRate ~ . -Name -State- avgDeathsPerYear -catfiveYearTrend -countyCode - recTrend - recentTrend  -avgAnnCount, data = df)
summary(fit2)


### MODEL 3

#add interaction term popEst2015*medIncome(selected after different combinations)
fit3 = lm(deathRate ~ . -Name -State- avgDeathsPerYear -catfiveYearTrend -countyCode - recTrend - recentTrend  -avgAnnCount + popEst2015*medIncome, data = df)
summary(fit3)


## STEP 5: Checking the assumptions for fourth model-> fit3

# 1: linear relationships
plot(df$PovertyEst, fit3$residuals)
abline(0,0)
# No linear relationship

plot(df$medIncome, fit3$residuals)
abline(0,0)
# No linear relationship

plot(df$popEst2015, fit3$residuals)
abline(0,0)
# No major linear relationship

plot(df$fiveYearTrend, fit3$residuals)
abline(0,0)
# No linear relationship

plot(df$incidenceRate, fit3$residuals)
abline(0,0)
# No linear relationship


# 2: multicollinearity
# checking correlation between predictor variables 
cor(df[,c(  'PovertyEst', 'popEst2015', 'incidenceRate', 'avgAnnCount' , 'deathRate' , 'avgDeathsPerYear' , 'medIncome'  )])
# removed poverty estimate as it is highly correlated with population estimate variable and also it is not significantly contributing

# 3: independent error terms
acf(fit3$residuals, lag.max=5)
# Lag-1 in between the two ACF blue lines so no problem here

# 4: errors follow normal distribution
hist(fit3$residuals)
# looks Normal so the fit is good

#5. heterosckadacity -> changing variance
plot(fit3, which = 1)
# No channging variance plot looks good!

#STEP 6: Selecting Model 
# After checking assumptions, model-3 passes all tests and explains maximum variability with the least and most important factors so model-3 it is selected.