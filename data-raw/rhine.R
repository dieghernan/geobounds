## code to prepare `rhine` dataset goes here

library(sf)
library(ggplot2)

rhine <- read_sf("data-raw/rhine.geojson")
rhine2 <- rhine |>
  select(name_en = `name:en`) |>
  st_cast("LINESTRING") |>
  group_by(name_en) |>
  summarise(n = n()) |>
  select(-n) |>
  st_make_valid()
ggplot(rhine2) +
  geom_sf()


st_write(rhine2, "inst/extdata/rhine.gpkg")

st_geometry_type(rhine)

usethis::use_data(rhine, overwrite = TRUE)
