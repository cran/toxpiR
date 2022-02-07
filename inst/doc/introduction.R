## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- eval = FALSE------------------------------------------------------------
#  install.packages("toxpiR")

## ---- eval = FALSE------------------------------------------------------------
#  remotes::install_github("ToxPi/toxpiR")

## ----packages, warning=FALSE--------------------------------------------------
library(toxpiR)

## -----------------------------------------------------------------------------
data(txp_example_input, package = "toxpiR")
head(txp_example_input)

## -----------------------------------------------------------------------------

## Goal - Create two slices with transformation functions 
# Slice 1: Metric 1, No transformation 
# Slice 2: Metric 2 (square) and Metric 3 (no transformation)

slice2.trans <- TxpTransFuncList(func1 = function(x) x^2, func2 = NULL)

f.slices <- TxpSliceList(Slice1 = TxpSlice("metric1"), 
                         Slice2 = TxpSlice(c("metric2", "metric3"), 
                                           txpTransFuncs = slice2.trans ))


## -----------------------------------------------------------------------------

## Goal - Create ToxPi model.
# Slice 1, weight = 2
# Slice 2, weight = 1, apply log transform to final value. 

# Object storing list of transformation functions.
final.trans <- TxpTransFuncList(f1 = NULL, f2 = function(x) log10(x)) 

f.model <- TxpModel(txpSlices = f.slices, 
                    txpWeights = c(2,1),
                    txpTransFuncs = final.trans)


## -----------------------------------------------------------------------------
f.results <- txpCalculateScores(model = f.model, 
                                input = txp_example_input,
                                id.var = 'name' ) 

txpSliceScores(f.results) #ToxPi scores
txpWeights(f.results) #Print weights

## ----fig.width=7, fig.height=3------------------------------------------------
library(grid) # Load library
plot(f.results) # ToxPi visuals
# grid.ls() #List grid info

# Highlight one figure using its label
grid.edit("pie-1", fills = c("red", "black"))

# Or just one slice in a figure
grid.edit("pie-10::slice1", gp = gpar(fill = "#7DBC3D"))

## ----fig.width=5, fig.height=4------------------------------------------------
# Rank plot
plot(f.results, y = txpRanks(f.results), labels = 1:10)

# Hierarchical Clustering

f.hc <- hclust(dist(txpSliceScores(f.results)))

plot(f.hc, hang = -1, labels = txpIDs(f.results), xlab = '', sub = '')

