# Libraries ---------------------------------------------------------------

library(tidyverse)
library(janitor)
library(lubridate)
library(ggtext)
library(ggrepel)
library(ggstream)
library(patchwork)

DPI <- 800

# showtext_opts(dpi = DPI)
# showtext_auto(enable = TRUE)

# showtext_auto()
library(rstudioapi)

# Getting the path of your current open file
current_path = rstudioapi::getActiveDocumentContext()$path
setwd(dirname(current_path))

# import data -------------------------------------------------------------

df <- read.csv("./chip_dataset.csv" ) %>%
  clean_names() %>%
  filter(release_date != 'NaT') %>%
  # na.omit() %>%
  mutate(year = year(release_date))


# plot 1 ------------------------------------------------------------------

df %>%
  ggplot(aes(x=tdp_w, y = die_size_mm_2)) +
  geom_point(aes(color = factor(type)))


# Plot 2 ------------------------------------------------------------------

df %>%
  filter(type == 'CPU') %>%
  ggplot(aes(x=tdp_w, y = transistors_million/die_size_mm_2),) +
  # geom_point(aes(color = factor(type)))+
  geom_point(aes(color = factor(vendor)))+
  scale_y_continuous(trans='log10')


# Plot 2 ------------------------------------------------------------------

df %>%
  ggplot(aes(x=tdp_w, y= freq_m_hz))+
  geom_point(aes(color = factor(type)))


# Plot 3 ------------------------------------------------------------------

df %>%
  filter(type == 'CPU') %>%
  ggplot(aes(x=release_date, y = transistors_million/die_size_mm_2),) +
  # geom_point(aes(color = factor(type)))+
  geom_point(aes(color = factor(vendor)))+
  scale_y_continuous(trans='log10')
