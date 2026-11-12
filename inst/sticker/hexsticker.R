# Starter script for the waveform package hex sticker.
# Run from the package root after installing hexSticker.
# Customize the artwork, colors, typography, and sticker layout as desired.

dir.create("man/figures", recursive = TRUE, showWarnings = FALSE)

hexSticker::sticker(
  # hexSticker uses this SVG file as the sticker image.
  subplot = "inst/sticker/waveform_wave.svg",
  package = "waveform",
  p_size = 18,
  p_color = "#17324D",
  p_x = 1,
  p_y = 0.12,
  s_x = 1,
  s_y = 1.58,
  s_width = 0.15,
  asp = 764 / 160,
  h_fill = "white",
  h_color = "#17324D",
  h_size = 1.5,
  filename = "man/figures/waveform-hex.png",
  dpi = 600
)
