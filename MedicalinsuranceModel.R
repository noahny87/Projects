
Meddf<- data.frame(read.csv("Medical_insurance.csv"))



head(Meddf)
data <- Meddf[,c("age","sex","charges")]


# need to change gender to numeric variable 1 or 2 
Meddf<- Meddf %>% mutate(Sexvalue = case_when( Meddf$sex == "female"~1, 
                                                   Meddf$sex == "male"~2 ))

Meddf<-Meddf%>% mutate(Regionvalue = case_when( Meddf$region == "northeast"~1,
                                                Meddf$region == "northwest"~ 2,
                                                Meddf$region == "southeast"~ 3,
                                                Meddf$region == "southwest"~4
                                                ))
#female is 1 and male is 2 

data <- Meddf[, c("charges","children")]

ggpairs(data)
# split up to check each value 1 or 2 to see if there is a correlation between sex and charges 

ggplot(data = Meddf, mapping = aes(Meddf$children,Meddf$charges))+geom_point()

# there is a obvious correlation that more kids leads to a lower medical charge roughly a moderate negative corr. 

f.nc.in<- which(Meddf$Sexvalue == 1 & Meddf$children == 0 & Meddf$smoker == "no"& Meddf$bmi <= 30.42)


# now i have all indecies of females that have zero children we could specify it even more by age 0 - 30 and 31-70 ( i know 64 is the highest age in the set)

F.age.nc<- Meddf$age[c(f.nc.in)]
f.charges.nc<- Meddf$charges[c(f.nc.in)]
f.region.nc<- Meddf$Regionvalue[c(f.nc.in)]
# now plotting the no children ages against no children charges for females 

labels<- c("NE","NW","SE","SW")
#specify each numerical value in regionvalue for label interpretation 

#use ggpot2 package but make a custom data frame for this 
f.nc.df<- data.frame(x = F.age.nc, y1 = f.charges.nc, y2 = as.factor(f.region.nc))
ggplot(data = f.nc.df, mapping = aes(x = x, y = y1, col = y2))+
geom_point()+
  labs(title = "Medical insurance price for females w/nokids & total less than $16500")+
  scale_color_manual(values = c("red", "blue","green","black"), labels = labels)




# this was made to verify that all kid values are 0 

# now create a prediction model and run it and compare the results to the graph and see if they are correct 
set.seed(123)
testdata<-data.frame(F.age.nc= c(33,19,25,44,59),
                              f.region.nc=  c(1,3,2,4,1))
testdata<- testdata%>%mutate(regionabv = case_when(testdata$f.region.nc == 1~"NE",
                                                   testdata$f.region.nc == 2~"NW",
                                                   testdata$f.region.nc == 3~"SE",
                                                   testdata$f.region.nc == 4~"SW" ))
 # represent each number with its corresponding region abbreviation so it makes the output clearer                                                
model<- lm(f.charges.nc~F.age.nc+f.region.nc, data = Meddf)
prediction<- predict(model, newdata = testdata)
predicted<-c(prediction, testdata$regionabv)

testdata$predicted<-prediction
testdata
#Print out summary of linear regression model and look at R^2 test to see accuracy of model
summary(model)
# now use this median of bmi to go for values above and below and see if that affect how the graph is displayed 
summary(Meddf$bmi)

#use the which function above to adjust the graph and help point out how it changes by changes variables and try to spot patterns 

# for the anomaly lines being a smoker and higher BMI would lead to higher payment but being a smoker and lower BMI did lead to less payment i.e. <=30.45 
# being a non smoker but high BMI lead to lower payment than smoker and high BMI (to be expected)
# being a smoker but lower BMI lead to lower payment the smoker and high BMI but about equal payment as High BMI non smoker 
# for the absolute best way to insure a low cost medical insurance price for a female with no kids is to be a non smoker with lower BMI and young which this is all to be expected logically 
