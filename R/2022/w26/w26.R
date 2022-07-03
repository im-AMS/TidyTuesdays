# Libraries ---------------------------------------------------------------

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
library(ggrepel)
library(ggstream)
library(streamgraph)
library(patchwork)

DPI <- 800

showtext_opts(dpi = DPI)
showtext_auto(enable = TRUE)

showtext_auto()
library(rstudioapi)

# Getting the path of your current open file
current_path = rstudioapi::getActiveDocumentContext()$path
setwd(dirname(current_path))

# import data -------------------------------------------------------------


df <-
  # read_csv("paygap.csv") %>%
  read_csv(
    "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-06-28/paygap.csv"
  ) %>%
  select(employer_id, date_submitted, post_code, employer_size, 7:20, ) %>%
  mutate(employer_size = factor(
    employer_size,
    levels = c(
      "Less than 250",
      "250 to 499",
      "500 to 999",
      "1000 to 4999",
      "5000 to 19,999",
      "20,000 or more",
      "Not Provided"
    )
  ))

str(df)



# Wrangle data ------------------------------------------------------------



lower_quartile <- df %>%
  select(date_submitted,
         employer_size,
         male_lower_quartile,
         female_lower_quartile) %>%
  na.omit %>%
  mutate(year = year(date_submitted)) %>%
  filter(!grepl('Not Provided', employer_size)) %>%
  group_by(year, employer_size) %>%
  summarise(male = median(male_lower_quartile),
            female = median(female_lower_quartile)) %>%
  pivot_longer(
    cols = c("male", "female"),
    values_to = "median_lower_quartile",
    names_to = "Gender"
  ) %>%
  arrange(year, employer_size)



top_quartile <- df %>%
  select(date_submitted,
         employer_size,
         male_top_quartile,
         female_top_quartile) %>%
  na.omit %>%
  mutate(year = year(date_submitted)) %>%
  filter(!grepl('Not Provided', employer_size)) %>%
  group_by(year, employer_size) %>%
  summarise(male = median(male_top_quartile),
            female = median(female_top_quartile)) %>%
  pivot_longer(
    cols = c("male", "female"),
    values_to = "median_top_quartile",
    names_to = "Gender"
  ) %>%
  arrange(year, employer_size)


top_lower_quartile <-
  full_join(lower_quartile, top_quartile,)


top_lower_quartile


# Plot 1: Ribbon Plot -----------------------------------------------------


top_lower_quartile %>%
  mutate(label = if_else(year == 2022, Gender, NULL)) %>%
  mutate(label = recode(label, `male` = "M", `female` = "F")) %>%
  ggplot(aes(x = year, color = Gender, )) +
  geom_ribbon(aes(ymin = median_lower_quartile, ymax = median_top_quartile,
                  fill = Gender),
              alpha = 0.4) +
  facet_wrap( ~ employer_size, ncol = 1, strip.position = "right") +
  geom_text_repel(
    aes(label = label, y = median_top_quartile),
    nudge_x = 5,
    na.rm = TRUE,
    size = 3.5,
    fontface = "bold"
  ) +
  
  theme_minimal(base_size = 12) +
  theme(
    panel.spacing = unit(0, "cm"),
    panel.grid.minor = element_blank(),
    legend.position = "none"
  )



# Plot 2: Smooth line plot ------------------------------------------------


top_lower_quartile %>%
  mutate(label = if_else(year == 2022, Gender, NULL)) %>%
  mutate(label = recode(label, `male` = "M", `female` = "F")) %>%
  ggplot(aes(x = year, color = Gender, )) +
  # geom_smooth(aes(y=median_lower_quartile), size=0.5)+
  geom_smooth(aes(y = median_top_quartile), size = 0.5) +
  facet_wrap(
    ~ employer_size,
    ncol = 1,
    # strip.position = "right") +
    scale_y_continuous(limits = c(30, 70), breaks = c(30, 50, 70)) +
      geom_text_repel(
        aes(label = label, y = median_top_quartile),
        nudge_x = 5,
        na.rm = TRUE,
        size = 3.5,
        fontface = "bold"
      ) +
      
      theme_minimal(base_size = 12) +
      theme(
        panel.spacing = unit(0, "cm"),
        panel.grid.minor = element_blank(),
        legend.position = "none"
      )
  )


# Plot 3: Stream Plot -----------------------------------------------------

top_lower_quartile %>%
  group_by(year, Gender) %>%
  summarise(median_top_quartile = sum(median_top_quartile)) %>%
  ggplot(aes(x = year, y = median_top_quartile, fill = Gender)) +
  geom_stream()


# Plot 4: Percent Stacked Bar chart ---------------------------------------

df_pivot <- df %>%
  mutate(year = year(date_submitted)) %>%
  select(-c(1:10), employer_size) %>%
  filter(!grepl('Not Provided', employer_size)) %>%
  group_by(year, employer_size) %>%
  summarise(across(everything(), median, na.rm = TRUE)) %>%
  pivot_longer(!c(year, employer_size),
               names_to = "kind",
               values_to = "earning") %>%
  # rowwise() %>%
  mutate(Gender = case_when(grepl("female", kind) ~ "F",
                            grepl("male", kind) ~ "M", )) %>%
  mutate(kind = factor(
    kind,
    levels = c(
      "male_top_quartile",
      "male_upper_middle_quartile",
      "male_lower_middle_quartile",
      "male_lower_quartile",
      "female_top_quartile",
      "female_upper_middle_quartile",
      "female_lower_middle_quartile",
      "female_lower_quartile"
    )
  ))


palette <- c(
  "male_lower_quartile" = "#00b4d8",
  "male_lower_middle_quartile" = "#0096c7",
  "male_upper_middle_quartile" = "#0077b6",
  "male_top_quartile" = "#023e8a",
  
  "female_lower_quartile" = "#ff9ebb",
  "female_lower_middle_quartile" = "#ff7aa2",
  "female_upper_middle_quartile" = "#e05780",
  "female_top_quartile" = "#b9375e"
)

library(showtext)
font_add_google("Hepta Slab")
font_add_google("Prata")
font_add_google("Crimson Pro")
font_add_google("Inter")

final_plot <- df_pivot %>%
  group_by(year, employer_size) %>%
  mutate(percent = earning / sum(earning)) %>%
  
  ggplot(aes(x = year, y = earning, fill = kind)) +
  geom_bar(position = "fill",
           stat = "identity",
           width = 0.8,) +
  geom_text(
    aes(label = scales::percent(percent, accuracy = 0.1)),
    position = position_fill(vjust = 0.5),
    size = 2.2,
    family = "Hepta Slab",
    color = "white",
  ) +
  scale_x_continuous(
    labels = c(
      "2017" = "'17",
      "2018" = "'18",
      "2019" = "'19",
      "2020" = "'20",
      "2021" = "'21",
      "2022" = "'22"
    ),
    breaks = c(2017, 2018, 2019, 2020, 2021, 2022)
  ) +
  scale_fill_manual(values = palette) +
  geom_hline(
    yintercept = 0.5,
    color = 'gray45',
    alpha = 0.75,
    size = 0.3
  ) +
  coord_cartesian(clip = "off") +
  theme_classic() +
  theme(
    legend.title = element_blank(),
    text = element_text(family = "Hepta Slab", size = 9),
    plot.title = element_markdown(
      family = "Prata",
      size = 22,
      color = "#2c353a"
    ),
    plot.subtitle = element_markdown(
      family = "Crimson Pro",
      size = 10,
      color = "#596a73",
      lineheight = 1.1
    ),
    plot.caption = element_markdown(family = "Inter", size = 7),
    plot.background = element_rect(fill = "#fef8f1"),
    strip.background.x = element_rect(fill = NULL),
    strip.background.y = element_rect(fill = NULL),
    legend.background = element_blank(),
    panel.background = element_blank(),
    axis.text.y = element_blank(),
    axis.title.y = element_markdown(),
    axis.title.x = element_markdown(),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.margin = unit(c(
      t = 0.5,
      b = 0.5,
      l = 1,
      r = 1
    ), "cm"),
    axis.line = element_line(size = 0.3),
    axis.ticks = element_line(size = 0.3),
    strip.background = element_rect(size = 0.5)
  ) +
  facet_wrap(~ employer_size, ncol = 3) +
  labs(
    title = "**Gender Pay Gap in UK**",
    subtitle =
      "This is a plot of Gender wage gap in UK from 2017 to 2022 of various quartiles of Men and Women, faceted by employee size.
  The grey line represents 50% mark.<br>
  Although there is no sufficient granularity in terms of sector of companies (one of highly correlated factors) among others,<br>
  we can observe that there has constantly been nearly no median salary difference in companies with 1000 to 5000 employees.
  <br>",
  caption = "**#TidyTuesday** week 26 | Source: **gender-pay-gap.service.gov.uk** | Viz by **Aditya MS**",
  ) +
  ylab("Median Earning %") +
  xlab("Year")



plot(final_plot)

ggsave(
  filename = "../../../Plots/2022/W26/W26.png",
  plot = final_plot,
  #scale = 1,
  width = 12,
  height = 7,
  units = "in",
  dpi = DPI
)




theme_update(panel.spacing = unit(0, "pt"),
             legend.position = "none")

df_pivot_filter <- df_pivot %>%
  filter(employer_size == "20,000 or more")

p1 <- df_pivot_filter %>%
  filter(year == 2017) %>%
  ggplot(aes(x = year, y = earning, fill = kind)) +
  geom_bar(stat = "identity") +
  # geom_bar()+
  # facet_wrap(~year)+
  facet_wrap( ~ Gender)

p2 <- df_pivot_filter %>%
  filter(year == 2018) %>%
  ggplot(aes(x = year, y = earning, fill = kind)) +
  geom_bar(stat = "identity") +
  # geom_bar()+
  # facet_wrap(~year)+
  facet_wrap( ~ Gender)

p3 <- df_pivot_filter %>%
  filter(year == 2019) %>%
  ggplot(aes(x = year, y = earning, fill = kind)) +
  geom_bar(stat = "identity") +
  # geom_bar()+
  # facet_wrap(~year)+
  facet_wrap( ~ Gender)

p4 <- df_pivot_filter %>%
  filter(year == 2020) %>%
  ggplot(aes(x = year, y = earning, fill = kind)) +
  geom_bar(stat = "identity") +
  # geom_bar()+
  # facet_wrap(~year)+
  facet_wrap( ~ Gender)

p1 + p2 + p3 + p4
