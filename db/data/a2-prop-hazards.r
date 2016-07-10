# required_attributes: futime, fustat,rx
# Proportional Hazards model
library("survival")
tabular_data.ph <- coxph(Surv(tabular_data$futime, tabular_data$fustat==1) ~ tabular_data$rx, data=tabular_data)
# testing the proportional hazards assumption -
tabular_data.zph <- cox.zph(tabular_data.ph, transform = 'log')
# if the p value resulting in this is <0.05
# then the hazards are not proportional and the assumption does not hold.
result <- tabular_data.zph$table[ , "p" ] > 0.05