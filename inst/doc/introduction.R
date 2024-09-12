## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.retina = 6
)

## ----eval = FALSE-------------------------------------------------------------
#  install.packages("toxpiR")

## ----eval = FALSE-------------------------------------------------------------
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
f.model <- txp_example_model #Load a more complex 4 slice model
f.results <- txpCalculateScores(model = f.model,
                                input = txp_example_input,
                                id.var = 'name' ) 

txpSliceScores(f.results) #ToxPi scores
txpWeights(f.results) #Print weights
txpMissing(f.results) #Proportion of missing data within each slice

## ----eval=FALSE---------------------------------------------------------------
#  library("ggplot2")
#  
#  # Default plot
#  plot(f.results, package = "gg") # Using ggplot package

## ----fig.show='hold', fig.width=4, fig.height=4, echo=FALSE-------------------
library("ggplot2")

# Default plot
plot(f.results, package = "gg") # Using ggplot package

## ----fig.show = "hide"--------------------------------------------------------
## Optional code to make smoother lines

# Plot before updating coord_munch
plot(f.results["chem01"], package = "gg") 

# Save the original version of coord_munch
coord_munch_orig <- ggplot2:::coord_munch

# Make a wrapper function that has a different default for segment_length
if (length(formals(coord_munch_orig)) == 5) {
  coord_munch_new <- function(coord, data, range, segment_length = 1/1000,
                              is_closed = FALSE) {
    coord_munch_orig(coord, data, range, segment_length, is_closed)
  }
} else {
  coord_munch_new <- function(coord, data, range, segment_length = 1/1000) {
    coord_munch_orig(coord, data, range, segment_length)
  }
}

# The environment may need to be set
#environment(coord_munch_new) <- environment(coord_munch_orig)

# Replace ggplot2:::coord_munch with coord_munch_new
assignInNamespace("coord_munch", coord_munch_new, ns = "ggplot2")

# Plot after updating coord_munch
plot(f.results["chem01"], package = "gg") 

# Revert to original coord_munch ater plotting if desired 
#assignInNamespace("coord_munch", coord_munch_orig, ns = "ggplot2")

## ----eval=FALSE---------------------------------------------------------------
#  # Changing the slice colors
#  colors <- c("orange", "green", "magenta", "lightblue")
#  plot(f.results["chem02"], package = "gg", fills = colors)
#  plot(f.results["chem02"], package = "gg", fills = NULL)

## ----fig.show="hold", echo=FALSE----------------------------------------------
# Changing the slice colors
colors <- c("orange", "green", "magenta", "lightblue")
plot(f.results["chem02"], package = "gg", fills = colors)
plot(f.results["chem02"], package = "gg", fills = NULL)

## ----eval=FALSE---------------------------------------------------------------
#  # Changing the background color
#  plot(f.results["chem02"], package = "gg", bgColor = "lightskyblue")
#  plot(f.results["chem02"], package = "gg", bgColor = NULL)

## ----fig.show="hold", echo=FALSE----------------------------------------------
# Changing the background color
plot(f.results["chem02"], package = "gg", bgColor = "lightskyblue")
plot(f.results["chem02"], package = "gg", bgColor = NULL)

## ----eval=FALSE---------------------------------------------------------------
#  # Changing the max radius ring color
#  plot(f.results["chem02"], package = "gg", borderColor = "black")
#  plot(f.results["chem02"], package = "gg", borderColor = NULL)

## ----fig.show="hold", echo=FALSE----------------------------------------------
# Changing the max radius ring color
plot(f.results["chem02"], package = "gg", borderColor = "black")
plot(f.results["chem02"], package = "gg", borderColor = NULL)

## ----eval=FALSE---------------------------------------------------------------
#  # Changing the slice border color
#  plot(f.results["chem02"], package = "gg", sliceBorderColor = "magenta")
#  plot(f.results["chem02"], package = "gg", sliceBorderColor = NULL)

## ----fig.show="hold", echo=FALSE----------------------------------------------
# Changing the slice border color
plot(f.results["chem02"], package = "gg", sliceBorderColor = "magenta")
plot(f.results["chem02"], package = "gg", sliceBorderColor = NULL)

## ----eval=FALSE---------------------------------------------------------------
#  # Adding slice guidelines
#  plot(f.results["chem02"], package = "gg", sliceLineColor = "red")
#  plot(f.results["chem02"], package = "gg", sliceLineColor = NULL)

## ----fig.show="hold", echo=FALSE----------------------------------------------
# Adding slice guidelines 
plot(f.results["chem02"], package = "gg", sliceLineColor = "red")
plot(f.results["chem02"], package = "gg", sliceLineColor = NULL) 

## ----eval=FALSE---------------------------------------------------------------
#  # Adding visible slice scores
#  plot(f.results["chem02"], package = "gg", sliceValueColor = "brown")
#  plot(f.results["chem02"], package = "gg", sliceValueColor = NULL)

## ----fig.show="hold", echo=FALSE----------------------------------------------
# Adding visible slice scores
plot(f.results["chem02"], package = "gg", sliceValueColor = "brown")
plot(f.results["chem02"], package = "gg", sliceValueColor = NULL)

## ----eval=FALSE---------------------------------------------------------------
#  # Hiding inner circle
#  plot(f.results["chem02"], package = "gg", showCenter = TRUE)
#  plot(f.results["chem02"], package = "gg", showCenter = FALSE)

## ----fig.show="hold", echo=FALSE----------------------------------------------
# Hiding inner circle
plot(f.results["chem02"], package = "gg", showCenter = TRUE)
plot(f.results["chem02"], package = "gg", showCenter = FALSE)

## ----eval=FALSE---------------------------------------------------------------
#  # Hiding missing data information (pure white inner circle)
#  plot(f.results["chem02"], package = "gg", showMissing = TRUE)
#  plot(f.results["chem02"], package = "gg", showMissing = FALSE)

## ----fig.show="hold", echo=FALSE----------------------------------------------
# Hiding missing data information (pure white inner circle)
plot(f.results["chem02"], package = "gg", showMissing = TRUE)
plot(f.results["chem02"], package = "gg", showMissing = FALSE)

## ----eval=FALSE---------------------------------------------------------------
#  # Hiding the overall profile scores
#  plot(f.results["chem02"], package = "gg", showScore = TRUE)
#  plot(f.results["chem02"], package = "gg", showScore = FALSE)

## ----fig.show="hold", echo=FALSE----------------------------------------------
# Hiding the overall profile scores
plot(f.results["chem02"], package = "gg", showScore = TRUE)
plot(f.results["chem02"], package = "gg", showScore = FALSE) 

## ----fig.width = 7, fig.align='center'----------------------------------------
# Specifying the number of columns in the plot
plot(f.results, package = "gg", ncol = 5) 

## ----eval=FALSE---------------------------------------------------------------
#  # Moving the legend using ggplot built in theme functions
#  plot(f.results, package = "gg", ncol = 5) + theme(legend.position = "bottom")
#  plot(f.results, package = "gg", ncol = 2) + theme(legend.position = "left")

## ----fig.show="hold", fig.height=5, echo=FALSE--------------------------------
# Moving the legend using ggplot built in theme functions
plot(f.results, package = "gg", ncol = 5) + theme(legend.position = "bottom") 
plot(f.results, package = "gg", ncol = 2) + theme(legend.position = "left")

## ----fig.align='center'-------------------------------------------------------
# Removing plot margins
plot(f.results, package = "gg") + theme(plot.margin = margin(0, 0, 0, 0, "cm"))
# Removing spacing between panels
plot(f.results, package = "gg") + theme(panel.spacing = unit(0, "lines"))
# Removing text labels
plot(f.results, package = "gg") + theme(strip.text.x = element_blank())
# A combination of the above for a rank ordered plot
plot(f.results[order(txpRanks(f.results)[1:9])], package = "gg") +
  theme(
    plot.margin = margin(0, 0, 0, 0, "cm"),
    panel.spacing = unit(0, "lines"),
    strip.text.x = element_blank(),
    legend.position = "none"
  )

## ----fig.align='center'-------------------------------------------------------
## Creating an example with more variable missing data amounts
f.input <- txp_example_input

# Add more missing data to slice 2 via metric3 in the raw data
f.input[3:10, "metric3"] <- NA

# Modify transformation function for slice 4
txpSlices(f.model)[[4]] <- TxpSlice("metric8", c(fn = \(x) sqrt(x - 30)))

# Calculate new ToxPi results
f.results_missing <- txpCalculateScores(f.model, f.input, id.var = "name")

# View missing data proportions
txpMissing(f.results_missing)

# View new result profile
plot(f.results_missing["chem02"], package = "gg")

## ----fig.width=7, fig.height=3------------------------------------------------
library(grid) # Load library
plot(f.results) # ToxPi visuals
# grid.ls() #List grid info

# Highlight one figure using its label
grid.edit("pie-1", fills = c("red", "blue", "black", "brown"))

# Or just one slice in a figure
grid.edit("pie-10::slice1", gp = gpar(fill = "#FC0FC0"))

## ----eval=FALSE---------------------------------------------------------------
#  #Single sample
#  plot(f.results["chem02"])
#  plot(f.results["chem02"], package = "gg")

## ----fig.show="hold", echo=FALSE----------------------------------------------
#Single sample
plot(f.results["chem02"])
plot(f.results["chem02"], package = "gg") 

## ----eval=FALSE---------------------------------------------------------------
#  # Subset plots
#  plot(f.results[order(txpRanks(f.results))[1:4]]) #Profiles ranked 1-4
#  plot(f.results[order(txpRanks(f.results))[1:4]], package = "gg") #Profiles ranked 1-4

## ----fig.show="hold", echo=FALSE----------------------------------------------
# Subset plots
plot(f.results[order(txpRanks(f.results))[1:4]]) #Profiles ranked 1-4
plot(f.results[order(txpRanks(f.results))[1:4]], package = "gg") #Profiles ranked 1-4

## ----eval=FALSE---------------------------------------------------------------
#  ## Long sample names for cramped plots
#  
#  #change the first sample name in f.results
#  txpIDs(f.results)[1] <- "I am a long sample name"
#  
#  plot(f.results) #grid plot for all samples
#  plot(f.results, package = "gg") #ggplot for all samples
#  
#  txpIDs(f.results)[1] <- "chem01" # Change the sample name back

## ----fig.show="hold", echo=FALSE----------------------------------------------
## Long sample names for cramped plots

#change the first sample name in f.results
txpIDs(f.results)[1] <- "I am a long sample name"

plot(f.results) #grid plot for all samples
plot(f.results, package = "gg") #ggplot for all samples

txpIDs(f.results)[1] <- "chem01" # Change the sample name back

## ----eval=FALSE---------------------------------------------------------------
#  ## Long slice names for cramped plots
#  
#  #change first slice name in model slot
#  names(f.results@txpModel)[1] <- "long slice name"
#  #change first slice name in scores slot
#  colnames(f.results@txpSliceScores)[1] <- "long slice name"
#  #change first slice name in missing data slot
#  names(f.results@txpMissing)[1] <- "long slice name"
#  
#  #plot results using grid
#  plot(f.results)
#  #plot results using ggplot
#  plot(f.results, package = "gg") + theme(
#    legend.position = "bottom",
#    legend.title = element_text(size = 10),
#    legend.text = element_text(size = 6)
#  )
#  
#  #change slice name back
#  names(f.results@txpModel)[1] <- "s1"
#  colnames(f.results@txpSliceScores)[1] <- "s1"
#  names(f.results@txpMissing)[1] <- "s1"

## ----fig.show="hold", echo=FALSE----------------------------------------------
## Long slice names for cramped plots

#change first slice name in model slot
names(f.results@txpModel)[1] <- "long slice name"
#change first slice name in scores slot
colnames(f.results@txpSliceScores)[1] <- "long slice name"
#change first slice name in missing data slot
names(f.results@txpMissing)[1] <- "long slice name"

#plot results using grid
plot(f.results)
#plot results using ggplot
plot(f.results, package = "gg") + theme(
  legend.position = "bottom",
  legend.title = element_text(size = 10),
  legend.text = element_text(size = 6)
)

#change slice name back
names(f.results@txpModel)[1] <- "s1"
colnames(f.results@txpSliceScores)[1] <- "s1"
names(f.results@txpMissing)[1] <- "s1"

## ----fig.width=5, fig.height=4, fig.align='center'----------------------------
# Rank plot
plot(f.results, y = txpRanks(f.results), labels = 1:10)

# Hierarchical Clustering
f.hc <- hclust(dist(txpSliceScores(f.results)))

plot(f.hc, hang = -1, labels = txpIDs(f.results), xlab = '', sub = '')

