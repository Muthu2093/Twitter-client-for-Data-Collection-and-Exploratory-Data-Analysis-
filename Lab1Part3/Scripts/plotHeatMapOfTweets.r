##### PLOT HEATMAP OF TWEETS GATHERED #######

library(ggplot2)
library(maps)
library(fiftystater)
library(maps)

## Read the dataset collected and stored from reverse.r
data <- read.csv("../data_collected/statesFrequency")
data<- subset(data, select = -c(X)) #removing column named X
setwd("../Scripts")
alpha = sort(table(data), decreasing = TRUE)
data("fifty_states")

checker <- data.frame(state.name)
colnames(checker) <- c("state")
rownames <- rownames(alpha)
rownames(alpha) <- NULL
alpha <- data.frame(cbind(rownames,alpha))
colnames(alpha) <- c("state", "count")

pointer = 1
## Code to filter and keep only the 50 - us states(48 continental + Hawaii + Alaska)
## Discards all non-us locations
for (i in 1:nrow(alpha))
{
  for (j in 1:nrow(checker))
  {
    if (as.character(alpha$state[i])==as.character(checker$state[j]))
    {
      if (pointer == 1)
      {
        temp = alpha[i,]
        pointer = 2
        next
        
      }
      if (pointer == 2)
      {
        temp = rbind(temp,alpha[i,])
      }
    }
  }
}


## Plotting HEATMAP
temp$count<-as.numeric(levels(temp$count))[temp$count]
temp$state <- unlist(as.list(tolower(temp$state)))

p <- ggplot(temp, aes(map_id = state)) + 
  geom_map(aes(fill = count), map = fifty_states, color = "black") + 
  expand_limits(x = fifty_states$long, y = fifty_states$lat) +
  coord_map() +
  scale_fill_gradient2(low="green", mid="yellow", high="red3", midpoint = mean(temp$count), guides(fill = "Number of Tweets"), limits=c(0,max(temp$count)+100), breaks=c(0,50,100,150,200,250,300,350,400,450,500,550,600,650,700,750,800,850,900,950,1000)) +
  guides(fill = guide_colorbar(barwidth = 1.5, barheight = 25)) +
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) +
  labs(x = "", y = "") +
  ggtitle("2017-18 Influenza Season Week 4 ending Jan 27, 2018") +
  theme(legend.position = "right",
        plot.title = element_text(family = "Helvetica Neue", color="#666666", face="bold", size=12, hjust=0))

print(p + ggtitle("HeatMap of Tweets on Influenza in USA"))

# add border boxes to AK/HI
p + fifty_states_inset_boxes()

