censoring <- (nrow(tabular_data)-sum(tabular_data$fustat))/nrow(tabular_data)
result <- censoring <= 0.7