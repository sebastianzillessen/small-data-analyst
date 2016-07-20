# required_attributes: futime, fustat,rx
# Testing the weibull assumption:
# The estimated log log lines in the graph produced should be roughly
# straight if the Weibull model is appropriate.
library("survival")
tabular_data = ovarian
m=1
tabular_data.survfit<-survfit(Surv(tabular_data$futime, tabular_data$fustat==1)~tabular_data$rx,data=tabular_data)
n=tabular_data.survfit$strata[1]
temp<-tabular_data.survfit$time[m:n]
cloglog=log(-log(tabular_data.survfit$surv[m:n]))
file = paste("file_output_",as.numeric(Sys.time()),".png", sep="")
png(file = file)
plot(log(temp), cloglog, type ="o")
m=n+1
n=n+tabular_data.survfit$strata[2]
temp=tabular_data.survfit$time[m:n]
cloglog=log(-log(tabular_data.survfit$surv[m:n]))
lines(log(temp),cloglog,type="o",col=2)
dev.off()
fileResult <- file
