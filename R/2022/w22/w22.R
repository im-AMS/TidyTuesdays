library(tidyverse)
library(ggsci)
library(ggtext)
library("scales")

library(rstudioapi)

# Getting the path of your current open file
current_path = rstudioapi::getActiveDocumentContext()$path
setwd(dirname(current_path))
print(getwd())

df <-
  readr::read_csv(
    "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-05-31/reputation.csv"
  )


theme_custom <-
  function (base_size = 8,
            display_font = "Playfair Display",
            text_font = "Inter") {
    half_line <- base_size / 2
    black <- "#222831"
    gray <- "#7F8487"
    lgray <- "#d2d2d2"
    dgray <- "#595959"
    axis_tick <- "#222831"
    axis_legend <- "#040506"
    tick_thickness <- 0.15
    
    theme(
      line = element_line(
        color = black,
        size = .5,
        linetype = 1,
        lineend = "butt"
      ),
      
      
      
      rect = element_rect(
        fill = "white",
        color = black,
        size = .5,
        linetype = 1
      ),
      
      text = element_text(
        family = text_font,
        face = "plain",
        color = black,
        size = base_size * 1,
        lineheight = .9,
        hjust = .5,
        vjust = .5,
        angle = 0,
        margin = margin(),
        debug = FALSE
      ),
      
      axis.line = element_blank(),
      axis.line.x = NULL,
      axis.line.y = NULL,
      axis.text = element_text(size = base_size * 0.9, color = axis_tick),
      
      
      
      
      axis.text.x = element_text(margin = margin(t = .8 * half_line / 2),
                                 vjust = 1),
      axis.text.x.top = element_text(margin = margin(b = .8 * half_line /
                                                       2),
                                     vjust = 0),
      axis.text.y = element_text(margin = margin(r = .8 * half_line / 2),
                                 hjust = 1),
      axis.text.y.right = element_text(margin = margin(l = .8 * half_line /
                                                         2),
                                       hjust = 0),
      axis.ticks = element_line(color = gray, size = tick_thickness),
      
      
      
      
      axis.ticks.length = unit(half_line / 1.5, "pt"),
      axis.ticks.length.x = NULL,
      axis.ticks.length.x.top = NULL,
      axis.ticks.length.x.bottom = NULL,
      axis.ticks.length.y = NULL,
      axis.ticks.length.y.left = NULL,
      axis.ticks.length.y.right = NULL,
      
      
      
      axis.title.x = element_text(
        margin = margin(t = half_line),
        vjust = 1,
        size = base_size * 1.3,
        face = "plain",
        color = axis_legend
      ),
      
      
      
      axis.title.x.top = element_text(margin = margin(b = half_line),
                                      vjust = 0),
      axis.title.y = element_text(
        angle = 0,
        vjust = 1,
        margin = margin(r = half_line),
        size = base_size * 1.3,
        color = axis_legend
      ),
      
      
      
      axis.title.y.right = element_text(
        angle = -90,
        vjust = 0,
        margin = margin(l = half_line)
      ),
      # legend.background = element_rect(color = NA),
      legend.background = element_blank(),
      
      
      
      legend.spacing = unit(.4, "cm"),
      legend.spacing.x = NULL,
      legend.spacing.y = NULL,
      legend.margin = margin(.2, .2, .2, .2, "cm"),
      legend.key = element_rect(fill = "gray95", color = "white"),
      legend.key.size = unit(1.2, "lines"),
      legend.key.height = NULL,
      legend.key.width = NULL,
      legend.text = element_text(size = rel(.8)),
      legend.text.align = NULL,
      legend.title = element_text(hjust = 0),
      legend.title.align = NULL,
      legend.position = "right",
      legend.direction = NULL,
      legend.justification = "center",
      legend.box = NULL,
      legend.box.margin = margin(0, 0, 0, 0, "cm"),
      legend.box.background = element_blank(),
      legend.box.spacing = unit(.4, "cm"),
      
      
      panel.background = element_rect(fill = NA, color = NA),
      panel.border = element_rect(fill = NA, color = NA),
      
      
      
      panel.grid.major = element_line(color = lgray, size = tick_thickness),
      
      panel.grid.minor = element_blank(),
      
      
      
      panel.spacing = unit(base_size, "pt"),
      panel.spacing.x = NULL,
      panel.spacing.y = NULL,
      panel.ontop = FALSE,
      strip.background = element_rect(fill = "white", color = "gray30"),
      strip.text = element_text(color = black, size = base_size),
      strip.text.x = element_text(margin = margin(t = half_line,
                                                  b = half_line)),
      strip.text.y = element_text(
        angle = -90,
        margin = margin(l = half_line,
                        r = half_line)
      ),
      strip.text.y.left = element_text(angle = 90),
      strip.placement = "inside",
      strip.placement.x = NULL,
      strip.placement.y = NULL,
      strip.switch.pad.grid = unit(0.1, "cm"),
      strip.switch.pad.wrap = unit(0.1, "cm"),
      
      
      plot.background = element_rect(fill = "#FBF8F1", color = "#FBF8F1"),
      
      
      
      plot.title = element_text(
        family = display_font ,
        size = base_size * 2.2,
        hjust = .5,
        vjust = 1,
        face = "bold",
        margin = margin(b = half_line * 1.2)
      ),
      plot.title.position = "panel",
      plot.subtitle = element_text(
        size = base_size * 1.2,
        hjust = .5,
        vjust = 1,
        margin = margin(b = half_line * 2.5)
      ),
      plot.caption = element_text(
        size = rel(0.9),
        hjust = 1,
        vjust = 1,
        margin = margin(t = half_line * .9)
      ),
      plot.caption.position = "panel",
      plot.tag = element_text(
        size = rel(1.2),
        hjust = .5,
        vjust = .5
      ),
      plot.tag.position = "topleft",
      plot.margin = margin(base_size, base_size, base_size, base_size),
      complete = TRUE
    )
  }

theme_set(theme_custom())

tmp <- df %>%
  select(industry, score) %>%
  group_by(industry) %>%
  summarise(avg_score = mean(score),
            sd = sd(score, na.rm = TRUE)) %>%
  arrange(desc(avg_score)) %>%
  head(10)


tmp$industry <- factor(tmp$industry) %>%
  fct_reorder(tmp$avg_score)



p1 <- ggplot(tmp, aes(x = avg_score, y = industry)) +
  geom_col(fill = "#54BAB9",
           color = "#54BAB9",
           alpha = 1) +
  geom_errorbar(aes(xmin = avg_score - sd, xmax = avg_score + sd),
                width = 0.2,
                color = "#595959") +
  labs(
    y = element_blank(),
    x = "Average Score",
    title = "Top 10 Industries overall",
    subtitle = "Average score of all paramerters for all industries. Only Top 10 shown.",
    caption = "#TidyTuesday - W22 | Data:Axios Harris Poll 100 | Visualisation by Aditya MS"
  ) +
  coord_cartesian(expand = FALSE, clip = "off") +
  theme(
    plot.margin = margin(
      t = 10,
      r = 40,
      b = 10,
      l = 7
    ),
    axis.text.y = element_text(size = 8, color = "black"),
    plot.caption = element_text(hjust = 1, face = "italic"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.y = element_blank(),
    
  )


ggsave(
  "../../../Plots/2022/W22/W22-p1.png",
  plot = p1,
  scale = 8,
  width = 666,
  height = 445,
  units = "px",
  dpi = 800
)
plot(p1)

tmp <- df %>%
  select(-score) %>%
  group_by(company) %>%
  summarise(score = sum(1 / rank), across()) %>%
  distinct(company, .keep_all = T) %>%
  select(-name, -rank) %>%
  arrange(desc(score))

tmp$score <- tmp$score / max(tmp$score)

tmp <- head(tmp, 10)


tmp$company <- factor(tmp$company) %>%
  fct_reorder(tmp$score)


theme_set(theme_custom())

p2 <- ggplot(data = tmp, aes(x = score, y = company)) +
  geom_col(aes(fill = industry)) +
  scale_color_manual(values = c(
    "#798777",
    "#716F81",
    "#316B83",
    "#9AD0EC",
    "#D68060",
    "#FFAAA5",
    "#54BAB9"
  )) +
  scale_fill_manual(values = c(
    "#798777",
    "#716F81",
    "#316B83",
    "#9AD0EC",
    "#D68060",
    "#FFAAA5",
    "#54BAB9"
  )) +
  labs(
    subtitle = "score is calculated by taking sum(1/rank) for each metric, for all companies.",
    title = "Best Overall Company",
    y = element_blank(),
    caption = "#TidyTuesday - W22 | Data:Axios Harris Poll 100 | Visualisation by Aditya MS"
  ) +
  theme(
    axis.text.y = element_text(size = 8, color = "black"),
    plot.caption = element_text(hjust = 1, face = "italic"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks = element_blank(),
    axis.text.x = element_blank(),
    plot.subtitle = element_text(size = 8 * 0.8,)
    
  )

ggsave(
  "../../../Plots/2022/W22/W22-p2.png",
  plot = p2,
  scale = 8,
  width = 666,
  height = 444,
  units = "px",
  dpi = 800
)
plot(p2)
