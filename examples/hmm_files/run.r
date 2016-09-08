require(rjags)
require(coda.discrete.utils)
require(ggplot2)
set.seed(14718)

data <- read.csv( file="texting-data.csv", header = FALSE)$V1



model <- jags.model(
  'model.bugs', data = list('T' = data, 'numberOfDays' = length(data)))

samples <- 
  jags.samples(model,
               c('segment'), 
               100000) 


coda.pmf(samples)
