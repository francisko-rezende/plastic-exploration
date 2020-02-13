
# loading packages --------------------------------------------------------

library(tidyverse)
library(here)


# loading data ------------------------------------------------------------

fate <- readr::read_csv(here::here("data", "raw", "global-plastic-fate.csv"))

prod <- readr::read_csv(here::here("data", "raw", "global-plastics-production.csv"))

capita <- readr::read_csv(here::here("data", "raw", "plastic-waste-per-capita.csv")) %>% 
  dplyr::mutate(group = dplyr::if_else(Entity == "Finland", "Suomi", "Muut"),
                factor_country = factor(Entity),
                factor_country = forcats::fct_reorder(Entity, `Per capita plastic waste (kilograms per person per day)`))


# plotting ----------------------------------------------------------------

## plastic fate
ggplot2::ggplot(fate, aes(x = Year, y = `Estimated historic plastic fate (%)`, fill = Entity)) +
  geom_area() +
  labs(x = "Vuosi",
       y = "Arvioitu muovin kohtalo (%)")

## plastic production
ggplot2::ggplot(prod, aes(x = Year, y = `Global plastics production (million tonnes) (tonnes)`)) +
  geom_line()+
  geom_point()


# finding countries with pop size similar to fin --------------------------

europe <- gapminder::gapminder %>% 
  mutate(fin = if_else(country == "Finland", "Finland", "Other"),
         country = fct_reorder(country, pop)) %>% 
  filter(year == 2007) %>% 
  filter(continent == "Europe") %>% 
  select(country)

europe <-  as.character(europe$country)

## per capita plastic waste generation

capita %>% 
  filter(Entity %in% europe) %>% 
  ggplot2::ggplot(aes(x = factor_country, y = `Per capita plastic waste (kilograms per person per day)`, fill = group)) +
  geom_col() +
  coord_flip()

# pop_2010 <- read_csv("data/raw/population-figures-by-country-csv_csv.csv") %>% 
#   pivot_longer(cols = c(-1, -2), names_to = "year", values_to = "pop") %>% 
#   separate(year, into = c(NA, "year")) %>% 
#   filter(year == 2010,
#          pop > 3000000,
#          pop < 7000000) %>% 
#   mutate(year = as.numeric(year),
#          Country = factor(Country),
#          Country = fct_reorder(Country,  pop),
#          fin = if_else(Country == "Finland", "Finland", "Other"))
#   
#   ggplot(pop_2010, aes(Country, pop, fill = fin)) +
#   geom_col() +
#   coord_flip() +
#   scale_y_continuous(labels = scales::comma)
# 
#   