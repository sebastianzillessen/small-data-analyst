#loading the required libraries
library(survival)
library(xtable)

#Overview of the data
names(ovarian)

head(ovarian)

dim(ovarian)

xtable(ovarian)

#Proportion of censored cases - a patient is censored if fustat=0 
#(the event has not been observed yet so we know they were followed for at leas the value in futime )
#no censoring = 0, mild censoring < 0.7, heavy censoring >= 0.7

censoring.prop<-(nrow(ovarian)-sum(ovarian$fustat))/nrow(ovarian)

#Kaplan meier model
ovarian.survfit<-survfit(Surv(ovarian$futime, ovarian$fustat==1)~ovarian$rx,data=ovarian)
    
ovarian.survdiff<-survdiff(Surv(ovarian$futime, ovarian$fustat==1)~ovarian$rx,data=ovarian)
ovarian.survdiff
    
plot(ovarian.survfit,conf.int=FALSE,col=c("black","grey"), lty=1:2,xlab="Months", ylab="Survival")
title("Kaplan Meier for Survival Ovarian data by treatment")
legend("bottomright", c("1","2"), lty = c(1,2)) 
    
#Proportional Hazards model
ovarian.ph<-coxph(Surv(ovarian$futime, ovarian$fustat==1)~ovarian$rx,data=ovarian)
summary(ovarian.ph)

#testing the proportional hazards assumption - if the p value resulting in this is <0.05 
#then the hazards are not proportional and the assumption does not hold.
ovarian.zph<-cox.zph(ovarian.ph,transform = 'log')
ovarian.zph

plot(ovarian.zph)
title("Schoenfeld residuals versus log(time)")

#Testing the weibull assumption: The estimated log–log lines in the graph produced should be roughly 
#straight if 
#the Weibull model is appropriate.
m=1
n=ovarian.survfit$strata[1]
temp<-ovarian.survfit$time[m:n]
cloglog=log(-log(ovarian.survfit$surv[m:n]))
plot(log(temp), cloglog, type ="s")
m=n+1
n=n+ovarian.survfit$strata[2]
temp=ovarian.survfit$time[m:n]
cloglog=log(-log(ovarian.survfit$surv[m:n]))
lines(log(temp),cloglog,type="s",col=2)

#If the slope is 1 then this is a special case where the exponential distribution can be used
#- not relevant at the moment.