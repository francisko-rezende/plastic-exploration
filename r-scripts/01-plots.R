
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

## per capita plastic waste generation
ggplot2::ggplot(capita, aes(x = factor_country, y = `Per capita plastic waste (kilograms per person per day)`, fill = group)) +
  geom_col() +
  coord_flip() +
  theme(axis.text.y = element_blank())
  

