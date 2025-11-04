## code to prepare `logo` dataset goes here

# To replace with package functions when available
library(hexSticker)
library(sysfonts)
ff <- font_families_google()

font_add()
df <- data.frame(fam = ff)
font_add_google("Open Sans", "opensans")
library(ggplot2)
p <- ggplot(aes(x = mpg, y = wt), data = mtcars) +
  geom_point()
p <- p + theme_void() + theme_transparent()
outfile <- "./data-raw/logo.png"
sticker(p,
  package = "tidygeoboundaries", filename = outfile,
  p_family = "opensans", p_fontface = "bold"
)
