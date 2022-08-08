###this script is used to create the data visualizations for questions 3, 4, and 5 from the SQL exercise

######## QUESTION 3 VISUALIZATION########

# I did not successfully create the final product for question three, so I will be using artificial data to
# represent how I would visualize the output

## A pie chart would be best to convey the percentages of GDP contribution by continent

q3_output <- data.frame(North_America = 27, Europe = 21, Rest_of_World = 52)

##make a pie chart
slices <- c(q3_output$North_America, q3_output$Europe, q3_output$Rest_of_World)
label_group <- c('North America', "Europe", "Rest of the World") #main text
pct <- round(slices/sum(slices)*100) #get percentages
lbls <- paste(label_group, pct) # add percents to labels
lbls <- paste(lbls,"%",sep="") #create final labels
pie(slices, labels = lbls, col=rainbow(length(lbls)),
      main="Percent of Annual Total GDP Per Capita")

#plot manually exported in Rstudio

######## QUESTION 4 VISUALIZATION########

## A multi-line plot made the most sense to portray GDP trends over time for multiple continents

# read in calculated output exported from postgres
q4_output <- read_csv('q4_results.csv')

#fix column names
names(q4_output) <- c('Year','Continent','avg_gdp')

## Fix North America values (R read in 'NA' as a missing value)
q4_output$Continent <- ifelse(is.na(q4_output$Continent),'NA',q4_output$Continent)

gdp_plot_q4 <- ggplot(q4_output,            
                   aes(x = Year,
                       y = avg_gdp,
                       color = Continent)) +  geom_line()
  
## final formatting 
gdp_plot_q4 +
  scale_color_manual(values = c("black","blue","green",'red','orange','purple')) +
  ggtitle('Average GDP Per Capita (2004-2012)') +
  ylab('Average GDP Per Capita ($)') +
  xlab('Year') +
  theme(plot.title = element_text(hjust = 0.5))
  
#plot manually exported in Rstudio



######## QUESTION 5 VISUALIZATION ########

### Due to similarities between question 4 and 5, I used the same method for the data visualization

# read in calculated output exported from postgres
q5_output <- read_csv('q5_results.csv')

#fix column names
names(q5_output) <- c('Year','Continent','median_gdp')

## Fix North America values (R read in 'NA' as a missing value)
q5_output$Continent <- ifelse(is.na(q5_output$Continent),'NA',q5_output$Continent)

gdp_plot_q5 <- ggplot(q5_output,            
                   aes(x = Year,
                       y = median_gdp,
                       color = Continent)) +  geom_line()

## final formatting 
gdp_plot_q5 +
  scale_color_manual(values = c("black","blue","green",'red','orange','purple')) +
  ggtitle('Median GDP Per Capita (2004-2012)') +
  ylab('Median GDP Per Capita ($)') +
  xlab('Year') +
  theme(plot.title = element_text(hjust = 0.5))

#plot manually exported in Rstudio
