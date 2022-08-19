
library(magrittr)
library(measurements) # https://www.rdocumentation.org/packages/measurements/versions/1.4.0/topics/conv_unit # conv_unit(3, from='m', to='cm')

# test if a vector has any NaN, Inf, or NA. If it does, throw an error and stop program
finiteTest <- function(numeric_vector, label){
  if(any(!is.finite(numeric_vector))) sprintf('Non-finite error in %s', label) %>% stop
}


logger <- function(msg, file = 'log.txt', console = TRUE){
	log_msg <- "[%s] - %s" %>% sprintf(Sys.time(), msg)
	log_msg %>% cat(file = file, append = TRUE)
	if(console) log_msg %>% cat()
}


