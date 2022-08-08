library(reader)

#read url from github
bookings_url = "https://raw.githubusercontent.com/SalesLoft/data-analyst-exercise/master/bonus_challenge/data/Bookings_Data.csv"
bookings_df <- read_csv(url(bookings_url))


## explore Sales Segment 

#won dataframe
sales_seg_df_won <- bookings_df %>% 
  filter(`Stage Name`=='Closed Won') %>% 
  group_by(`Sales Segment`) %>% 
  mutate(n = n()) %>% 
  ungroup() %>% 
  distinct(`Sales Segment`, n) %>% 
  arrange(`Sales Segment`)

#all dataframe
sales_seg_df_all <- bookings_df %>% 
  group_by(`Sales Segment`) %>% 
  mutate(n = n()) %>% 
  ungroup() %>% 
  distinct(`Sales Segment`, n) %>% 
  arrange(`Sales Segment`)

#compute close rate
sales_seg_info <- sales_seg_df_won
sales_seg_info$c_rate <- (sales_seg_df_won$n/sales_seg_df_all$n)*100

#make visualization
seg_plot <- ggplot(data = sales_seg_info, aes(x=reorder(`Sales Segment`,-c_rate), y = c_rate)) +
  geom_bar(stat = 'identity', fill = 'steelblue') +
  geom_text(aes(label=(round(c_rate,2))), vjust=1.6, color="white", size=3.5)+
  ggtitle('Close Rate by Sales Segment') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Close Rate (%)') +
  xlab('Sales Segment')

seg_plot


## explore Source
source_df_won <- bookings_df %>%
  drop_na(Source) %>% 
  filter(`Stage Name`=='Closed Won') %>% 
  group_by(Source) %>% 
  mutate(n_won = n()) %>% 
  ungroup() %>% 
  distinct(Source, n_won) %>% 
  arrange(Source)

source_df_all <- bookings_df %>% 
  drop_na(Source) %>% 
  group_by(Source) %>% 
  mutate(n_all = n()) %>% 
  ungroup() %>% 
  distinct(Source, n_all) %>% 
  arrange(Source)

#compute close rate
source_info <- source_df_all %>% filter(Source %in% source_df_won$Source)
source_info$c_rate <- (source_df_won$n_won/source_info$n_all)*100

#only take the top 5 
source_info <- source_info %>% arrange(c_rate) %>% slice(1:5)

#visualize data
source_plot <- ggplot(data = source_info, aes(x=reorder(Source,-c_rate), y = c_rate)) +
  geom_bar(stat = 'identity', fill = 'steelblue') +
  geom_text(aes(label=(round(c_rate,2))), vjust=1.6, color="white", size=3.5)+
  ggtitle('Close Rate by Source') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Close Rate (%)') +
  xlab('Source')

source_plot




## explore global region
region_df_won <- bookings_df %>%
  drop_na(`Global Region`) %>% 
  filter(`Stage Name`=='Closed Won') %>% 
  group_by(`Global Region`) %>% 
  mutate(n_won = n()) %>% 
  ungroup() %>% 
  distinct(`Global Region`, n_won) %>% 
  arrange(`Global Region`)

region_df_all <- bookings_df %>% 
  drop_na(`Global Region`) %>% 
  group_by(`Global Region`) %>% 
  mutate(n_all = n()) %>% 
  ungroup() %>% 
  distinct(`Global Region`, n_all) %>% 
  arrange(`Global Region`)

#calculate close rate
region_info <- region_df_all %>% filter(`Global Region` %in% region_df_won$`Global Region`)
region_info$c_rate <- (region_df_won$n_won/region_info$n_all)*100

#visualize data
region_plot <- ggplot(data = region_info, aes(x=`Global Region`, y = c_rate)) +
  geom_bar(stat = 'identity', fill = 'steelblue') +
  geom_text(aes(label=(round(c_rate,2))), vjust=1.6, color="white", size=3.5)+
  ggtitle('Close Rate by Global Region') +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab('Close Rate (%)')

region_plot

  