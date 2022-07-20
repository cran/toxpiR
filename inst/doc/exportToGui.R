## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(toxpiR)

# Load example model from "Import ToxPi GUI Files" vignette
data_format_C <- tempfile()
download.file(
  url = "https://raw.githubusercontent.com/ToxPi/ToxPi-example-files/main/format_C.csv",
  destfile = data_format_C,
  quiet = TRUE
)
gui1 <- txpImportGui(data_format_C)

## -----------------------------------------------------------------------------
# Export back into GUI format
data_exported <- tempfile()
txpExportGui(
  fileName = data_exported,
  input = gui1$input,
  model = gui1$model,
  id.var = 'Name',
  fills = gui1$fills
)

## ----echo=FALSE---------------------------------------------------------------
knitr::kable(read.csv(data_format_C, header = FALSE, stringsAsFactors = FALSE))

## ----echo=FALSE---------------------------------------------------------------
df <- read.csv(data_exported, header = FALSE, stringsAsFactors = FALSE)
df[6:nrow(df), 2:ncol(df)] <- format(as.numeric(as.matrix(df[6:nrow(df), 2:ncol(df)])), digits = 4)
knitr::kable(df)

## -----------------------------------------------------------------------------
gui2 <- txpImportGui(data_exported)

res1 <- txpCalculateScores(gui1$model, gui1$input)
res2 <- txpCalculateScores(gui2$model, gui2$input)

all.equal(
  txpScores(res1),
  txpScores(res2)
)

all.equal(
  txpSliceScores(res1),
  txpSliceScores(res2)
)

