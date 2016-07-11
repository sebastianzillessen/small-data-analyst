library(survival)

#Proportional Hazards model
tabular_data.ph<-coxph(Surv(tabular_data$futime, tabular_data$fustat==1)~tabular_data$rx,data=tabular_data)
summary(tabular_data.ph)

#testing the proportional hazards assumption - if the p value resulting in this is <0.05
#then the hazards are not proportional and the assumption does not hold.
tabular_data.zph<-cox.zph(tabular_data.ph,transform = 'log')
tabular_data.zph