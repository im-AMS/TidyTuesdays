# Libraries ---------------------------------------------------------------

library(tidyverse)
library(janitor)
library(lubridate)
library(ggtext)
library(ggrepel)
library(patchwork)
library(fable)
library(fabletools)
library(tsibble)
library(ggstream)



# Set working directory ---------------------------------------------------

library(rstudioapi)

# Getting the path of your current open file
current_path = rstudioapi::getActiveDocumentContext()$path
setwd(dirname(current_path))



# import data -------------------------------------------------------------

data <- readr::read_csv("flights.csv") %>%
  clean_names()


# wrangle -----------------------------------------------------------------


# top_airports
top_apt <- data %>%
  mutate(date = floor_date(ymd(flt_date), unit = "day")) %>%
  select(date,apt_name, state_name,flt_dep_1) %>%
  group_by(apt_name) %>%
  summarise(sum = sum(flt_dep_1)) %>%
  arrange(desc(sum)) %>%
  select(apt_name) %>%
  head(5)


# copy paste --------------------------------------------------------------


df_base <- data %>%
  mutate(flt_date = floor_date(ymd(flt_date), unit = "month")) %>%
  group_by(year, month_mon, flt_date) %>%
  summarise(
    dep = sum(flt_dep_1),
    # arr = sum(flt_arr_1)
  ) %>%
  mutate(yr_mth = yearmonth(paste(year, month_mon)))

# fit time series model
mod <- df_base %>%
  filter(flt_date < ymd("2020-02-01")) %>%
  as_tsibble(index = yr_mth) %>%
  model(ARIMA(dep))

# set new data
new_data <- df_base %>%
  filter(flt_date >= ymd("2020-02-01")) %>%
  as_tsibble(index = yr_mth)

# forecast
fcst <- mod %>%
  forecast(new_data = new_data)

# plot forecast
# fcst %>%
#   autoplot(as_tsibble(df_base, index = yr_mth))

fcst_actual <- new_data %>%
  inner_join(fcst, by = c("year", "month_mon", "flt_date", "yr_mth"))



# wrangle: dedicated airports  --------------------------------------------


# Weekly data -------------------------------------------------------------


# weekly_data <- data %>%
#   # mutate(week = sprintf("%02d",week(flt_date))) %>%
#   # mutate(week = paste(year,'-', week)) %>%
#   mutate(week = yearweek(flt_date)) %>%
#   group_by(year,week,apt_name) %>%
#   summarise(dep = sum(flt_dep_1)) %>%
#   arrange(apt_name, week)
#
# weekly_data %>%
#   filter(apt_name == 'paris- Schiphol') %>%
#   ggplot(aes(x=week,y=dep))+
#   geom_line()+
#   geom_smooth(method = 'gam', se=F, formula = y ~poly(x,20))



# Monthly data ------------------------------------------------------------

#
# monthly_data <- data %>%
#   mutate(yr_mth = yearmonth(flt_date)) %>%
#   group_by(year, yr_mth, apt_name) %>%
#   summarise(dep = sum(flt_dep_1)) %>%
#   arrange(apt_name, yr_mth)

monthly_data <- data %>%
  mutate(flt_date = floor_date(ymd(flt_date), unit = "month")) %>%
  group_by(year, month_mon, flt_date, apt_name) %>%
  summarise(dep = sum(flt_dep_1)) %>%
  # ungroup() %>%
  mutate(yr_mth = yearmonth(paste(year, month_mon))) %>%
  arrange(apt_name, flt_date)




# Montly data for Amsterdam - Schiphol -------------------------------------


mod <- monthly_data %>%
  filter(apt_name == 'Amsterdam - Schiphol', flt_date < ymd('2020-02-01')) %>%
  as_tsibble(index = yr_mth) %>%
  model(ARIMA(dep))


tmp <- monthly_data %>%
  filter(apt_name == 'Amsterdam - Schiphol', flt_date >= ymd('2020-02-01')) %>%
 as_tsibble(index = yr_mth)

fcst_amsterdam<- mod %>%
  forecast(new_data = tmp)


fcst_amsterdam<- tmp %>%
  inner_join(fcst_amsterdam, by = c("year", "month_mon", "flt_date", "yr_mth")) %>%
  select("year","month_mon", "flt_date","yr_mth", "apt_name.x", "dep.x", ".mean") %>%
  clean_names() %>%
  rename(apt_name = apt_name_x, dep_actual = dep_x, dep_predicted = mean)


a1 <- monthly_data %>%
filter(apt_name == 'Amsterdam - Schiphol') %>%
  ggplot()+
  geom_line(aes(x=flt_date,y=dep),alpha=0.8)+
  geom_line(aes(x=flt_date, y = dep_predicted),fcst_amsterdam, lty=2)
  # geom_smooth(method = 'gam', se=F, formula = y ~poly(x,20), alpha=0.8)

a2 <- fcst_amsterdam%>%
  ggplot() +
  geom_line(aes(x=flt_date,y=dep_predicted - dep_actual))+
  geom_point(aes(x=flt_date,y=dep_predicted - dep_actual))+
  # geom_smooth(aes(x=flt_date,y=dep_predicted - dep_actual), method = "gam",se=F,formula = y ~ poly(x,15))+
  geom_area(aes(x=flt_date,y=dep_predicted - dep_actual), fill='grey80', alpha=0.5)+
  coord_cartesian(xlim = c(ymd('2016-01-01'), NA))

a1/a2


# p2/a2



# Monthly wrangle: Paris-Charles-de-Gaulle --------------------------------



mod <- monthly_data %>%
  filter(apt_name == 'Paris-Charles-de-Gaulle', flt_date < ymd('2020-02-01')) %>%
  as_tsibble(index = yr_mth) %>%
  model(ARIMA(dep))


tmp <- monthly_data %>%
  filter(apt_name == 'Paris-Charles-de-Gaulle', flt_date >= ymd('2020-02-01')) %>%
  as_tsibble(index = yr_mth)

fcst_paris <- mod %>%
  forecast(new_data = tmp)


fcst_paris<- tmp %>%
  inner_join(fcst_paris, by = c("year", "month_mon", "flt_date", "yr_mth")) %>%
  select("year","month_mon", "flt_date","yr_mth", "apt_name.x", "dep.x", ".mean") %>%
  clean_names() %>%
  rename(apt_name = apt_name_x, dep_actual = dep_x, dep_predicted = mean)



paris1 <- monthly_data %>%
  filter(apt_name == 'Paris-Charles-de-Gaulle') %>%
  ggplot()+
  geom_line(aes(x=flt_date,y=dep),alpha=0.8)+
  geom_line(aes(x=flt_date, y = dep_predicted),fcst_paris, lty=2)
# geom_smooth(method = 'gam', se=F, formula = y ~poly(x,20), alpha=0.8)

paris2 <- fcst_paris%>%
  ggplot() +
  geom_line(aes(x=flt_date,y=dep_predicted - dep_actual))+
  geom_point(aes(x=flt_date,y=dep_predicted - dep_actual))+
  # geom_smooth(aes(x=flt_date,y=dep_predicted - dep_actual), method = "gam",se=F,formula = y ~ poly(x,15))+
  geom_area(aes(x=flt_date,y=dep_predicted - dep_actual), fill='grey80', alpha=0.5)+
  coord_cartesian(xlim = c(ymd('2016-01-01'), NA))

paris1/paris2


# p2/paris2



# Wrangle for: Frankfurt --------------------------------------------------



mod <- monthly_data %>%
  filter(apt_name == 'Frankfurt', flt_date < ymd('2020-02-01')) %>%
  as_tsibble(index = yr_mth) %>%
  model(ARIMA(dep))


tmp <- monthly_data %>%
  filter(apt_name == 'Frankfurt', flt_date >= ymd('2020-02-01')) %>%
  as_tsibble(index = yr_mth)

fcst_frankfurt <- mod %>%
  forecast(new_data = tmp)


fcst_frankfurt<- tmp %>%
  inner_join(fcst_frankfurt, by = c("year", "month_mon", "flt_date", "yr_mth")) %>%
  select("year","month_mon", "flt_date","yr_mth", "apt_name.x", "dep.x", ".mean") %>%
  clean_names() %>%
  rename(apt_name = apt_name_x, dep_actual = dep_x, dep_predicted = mean)



# Wrangle for : London - Heathrow -----------------------------------------


mod <- monthly_data %>%
  filter(apt_name == 'London - Heathrow', flt_date < ymd('2020-02-01')) %>%
  as_tsibble(index = yr_mth) %>%
  model(ARIMA(dep))


tmp <- monthly_data %>%
  filter(apt_name == 'London - Heathrow', flt_date >= ymd('2020-02-01')) %>%
  as_tsibble(index = yr_mth)

fcst_london <- mod %>%
  forecast(new_data = tmp)


fcst_london<- tmp %>%
  inner_join(fcst_london, by = c("year", "month_mon", "flt_date", "yr_mth")) %>%
  select("year","month_mon", "flt_date","yr_mth", "apt_name.x", "dep.x", ".mean") %>%
  clean_names() %>%
  rename(apt_name = apt_name_x, dep_actual = dep_x, dep_predicted = mean)




# wrangle for: Madrid - Barajas -------------------------------------------


mod <- monthly_data %>%
  filter(apt_name == 'Madrid - Barajas', flt_date < ymd('2020-02-01')) %>%
  as_tsibble(index = yr_mth) %>%
  model(ARIMA(dep))


tmp <- monthly_data %>%
  filter(apt_name == 'Madrid - Barajas', flt_date >= ymd('2020-02-01')) %>%
  as_tsibble(index = yr_mth)

fcst_madrid <- mod %>%
  forecast(new_data = tmp)


fcst_madrid<- tmp %>%
  inner_join(fcst_madrid, by = c("year", "month_mon", "flt_date", "yr_mth")) %>%
  select("year","month_mon", "flt_date","yr_mth", "apt_name.x", "dep.x", ".mean") %>%
  clean_names() %>%
  rename(apt_name = apt_name_x, dep_actual = dep_x, dep_predicted = mean)





# Combine top airports ----------------------------------------------------


top_apt_pred <- bind_rows(as_tibble(fcst_amsterdam),
          as_tibble(fcst_paris),
          as_tibble(fcst_frankfurt),
          as_tibble(fcst_london),
          as_tibble(fcst_madrid)
          )


top_apt_pred %>%
  ggplot(aes(x=flt_date, y = dep_predicted - dep_actual))+
  geom_area()+
  facet_wrap(~apt_name)

top_apt_pred %>%
  ggplot(aes(x=flt_date, y = dep_predicted - dep_actual, fill = apt_name))+
  geom_stream()


# Plots -------------------------------------------------------------------



p1 <- df_base %>%
  ggplot() +
  geom_line(aes(x = flt_date, y = dep), size = 0.5) +
  geom_line(aes(x = flt_date, y = .mean), fcst_actual, lty = 2, size = 0.5)

p2 <- fcst_actual %>%
  ggplot() +
  geom_line(aes(x=flt_date,y=.mean-dep.x))+
  geom_point(aes(x=flt_date,y=.mean-dep.x))+
  # geom_smooth(aes(x=flt_date,y=.mean-dep.x), method = "gam",se=F,formula = y ~ poly(x,15))+
  geom_area(aes(x=flt_date,y=.mean-dep.x), fill='grey80', alpha=0.5)+
  coord_cartesian(xlim = c(ymd('2016-01-01'), NA))
# geom_smooth(aes(x=yr_mth,y=.mean-arr), se=F, formula = y~poly(x,20), method = 'glm')

p1/p2
