## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(toxpiR)

## Create a tempfile and download 'format_C.csv'
fmtc <- tempfile()
ghuc <- "https://raw.githubusercontent.com"
fmtcUrl <- file.path(ghuc, "ToxPi", "ToxPi-example-files", "main", "format_C.csv")
download.file(url = fmtcUrl, destfile = fmtc, quiet = TRUE)

## -----------------------------------------------------------------------------
## Import file into R
gui <- txpImportGui(fmtc)


## -----------------------------------------------------------------------------
gui$model
gui$input
gui$fills

## -----------------------------------------------------------------------------
## Calculate ToxPi scores
res <- txpCalculateScores(model = gui$model, input = gui$input, id.var = "Name",negative.value.handling = "missing")

## Overall ToxPi scores
txpScores(res)

## Slice scores
txpSliceScores(res, adjusted = FALSE)

## -----------------------------------------------------------------------------
out <- as.data.frame(res, adjusted = FALSE)
out <- out[order(out$score, decreasing = TRUE), ]
out

## ----fig.width = 7------------------------------------------------------------
plot(sort(res), fills = gui$fills)

## ----fig.width = 7, fig.height = 4--------------------------------------------
plot(res, txpRanks(res))
plot(res, txpRanks(res), labels = 1:10, pch = 16, size = grid::unit(0.75, "char"))

## ----fig.width = 7, fig.height = 5--------------------------------------------
## Hierarchical Clustering
hc <- hclust(dist(txpSliceScores(res)), method = 'complete')
plot(hc, hang = -1, labels = txpIDs(res), xlab = 'Name', sub = '')

## ----fig.width = 7, fig.height = 5--------------------------------------------
## K-Means Clustering, plotted using principal components
nClusters <- 3
km <- kmeans(txpSliceScores(res), nClusters)
pc <- prcomp(txpSliceScores(res))
coord <- predict(pc) * -sum(txpWeights(res))
plot(coord[,1], coord[,2], col = km$cluster, 
     xlab = 'PC1', ylab = 'PC2', pch = 16)

