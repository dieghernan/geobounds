## code to prepare `logo` dataset goes here

# To replace with package functions when available
library(tidygeoboundaries)

sri <- get_geobn(
  country = "Sri Lanka",
  boundary_type = "ADM3", simplified = TRUE
)

library(hexSticker)
library(sysfonts)
ff <- font_families_google()

font_add_google("Open Sans", "opensans")
library(ggplot2)

p <- ggplot(sri) +
  geom_sf(fill = NA, linewidth = 0.1, color = "#F0B323") +
  theme_void()
ggsave("data-raw/map.svg", plot = p)
