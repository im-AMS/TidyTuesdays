# Libraries
library(tidyverse)
library(geofacet)
library(ggnewscale)
library(showtext)
library(ggridges)
library(janitor)
library(tidycensus)
library(lubridate)
library(gganimate)
library(cartography)
library(ggtext)


#drought <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-06-14/drought.csv')
drought_fips <-
  readr::read_csv(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-06-14/drought-fips.csv'
  )



states_map <- map_data("state") %>%
  select(lat, long, region, group) %>%
  distinct()


cleaned_df <- drought_fips %>%
  mutate(region = tolower(state.name[match(drought_fips$State, state.abb)])) %>%
  select(region, date, DSCI) %>%
  mutate(date = format(as.Date(date), "%Y-%m")) %>%
  group_by(region, date) %>%
  summarise(DSCI_mean = mean(DSCI)) %>%
  left_join(states_map, by = "region")





plot <- cleaned_df %>%
  filter(date >= '2010-01') %>%
  ggplot(aes(long, lat, group = group)) +
  geom_polygon(aes(fill = DSCI_mean), color = "grey40", size = 0.08) +
  coord_map() +
  transition_manual(date) +
  scale_fill_gradientn(
    limits = c(0, 500),
    #colors=c("#e4f1e1","#b4d9cc","#89c0b6","#63a6a0","#448c8a","#287274","#0d585f"),
    colors = c(
      "#fbe6c5",
      "#f5ba98",
      "#ee8a82",
      "#dc7176",
      "#c8586c",
      "#9c3f5d",
      "#70284a"
    ),
    guide = guide_colourbar(
      direction = "horizontal",
      barwidth = 15,
      barheight = 0.3,
      ticks = FALSE,
      title.position = "top"
    ),
  ) +
  theme(
    text = element_text(family = "Inter"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    panel.background = element_rect(fill = 'white', colour = 'white'),
    plot.background = element_rect(fill = 'white', colour = 'white'),
    legend.background = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "bottom",
    legend.title.align = 0.5,
    plot.caption = element_markdown(size = rel(0.6),),
    plot.title = element_markdown(),
    plot.subtitle = element_markdown(),
    # plot.margin = margin(
    #   t = 2,
    #   r = 1,
    #   b = 2,
    #   l = 1
    # ),
    
    
  )+
  labs(
    title = "**Drought Scores of US**",
    subtitle = "**Year:** {current_frame}",
    fill = "Average DSCI",
    caption = "**#TidyTuesday** week 24 | **Data:** National Integrated Drought Information System | Viz by **Aditya MS**"
  )

animate(
  plot,
  height = 3000,
  width = 5000,
  fps = 30,
  duration = 10,
  start_pause = 4,
  end_pause = 4,
  res = 700,
)


library(rstudioapi)

# Getting the path of your current open file
current_path = rstudioapi::getActiveDocumentContext()$path
setwd(dirname(current_path))

anim_save("../../../Plots/2022/W24/W24.mp4")
anim_save("../../../Plots/2022/W24/W24.gif")
