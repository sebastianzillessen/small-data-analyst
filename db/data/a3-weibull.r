# required_attributes: futime, fustat,rx
# Testing the weibull assumption:
# The estimated log log lines in the graph produced should be roughly
# straight if the Weibull model is appropriate.
library("survival")
m=1
ovarian.survfit<-survfit(Surv(ovarian$futime, ovarian$fustat==1)~ovarian$rx,data=ovarian)
n=ovarian.survfit$strata[1]
temp<-ovarian.survfit$time[m:n]
cloglog=log(-log(ovarian.survfit$surv[m:n]))
plot(log(temp), cloglog, type ="s")
m=n+1
n=n+ovarian.survfit$strata[2]
temp=ovarian.survfit$time[m:n]
cloglog=log(-log(ovarian.survfit$surv[m:n]))
lines(log(temp),cloglog,type="s",col=2)