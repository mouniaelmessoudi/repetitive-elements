library(ggplot2)

setwd("/Users/mouniaelmessaoudi/Xenopus")

df <- read.csv(file = 'result.csv')
bp <- barplot(t(df[,]), col = c("black","blue", "red", "green", "orange", "gold"), names.arg=c("X.Tropicalis","X.Mellotropicalis"), ylab = ("% of repeats"), legend.text=TRUE, beside=TRUE, main = "barplot comparing repeated sequences of two Xenopus species")
bp <- barplot(t(df[,]), col = c("black","blue", "red", "green", "orange", "gold"), names.arg=c("X.Tropicalis","X.Mellotropicalis"), ylab = ("% of repeats"), legend.text=TRUE, main = "stacked barplot comparing repeated sequences of two Xenopus species")

par(mfrow=c(1,2)) 
pie(t(df[1,]), labels = colnames(df),main = "X.Tropicalis",col = c("black","blue", "red", "green", "orange", "gold"),radius = 1)
pie(t(df[2,]), labels = colnames(df),main = "X.Mellotropicalis",col = c("black","blue", "red", "green", "orange", "gold"),radius = 1)
