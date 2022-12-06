bar_data <- components %>% filter(Type == "Steel")

bar_data_1 <- bar_data %>% count(Type, CS) %>% group_by(Type) %>% mutate(prob = (n/sum(n)*100))
bar_plot_1<- plot_ly(bar_data_1, x = ~Type, y = ~prob , color = ~CS ,type = "bar")  %>%
  layout( barmode = "stack")
bar_plot_1


bar_data_2 <- bar_data %>% count(Type, CS) %>% group_by(Type) %>% mutate(prob = (n/sum(n)*100))
bar_plot_2<- plot_ly(bar_data_2, x = ~Type, y = ~prob , color = ~CS ,type = "bar",
                     text = ~prob %>% round() ) %>% layout(yaxis = list(ticksuffix = "%") ) 
bar_data_2
# bar_data_2 <- components %>% count(Type, CS)
# bar_data_2 <- components %>% plot_ly( x = ~Type, y = ~n , color = ~CS ,type = "bar")
# bar_data_2
