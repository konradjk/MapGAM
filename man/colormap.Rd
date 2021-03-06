\name{colormap}
\alias{colormap}
\title{
Maps Predicted Values and Clusters for modgam Objects
}
\description{
Displays a color image map, including a legend, scale bar, and optional North arrow, showing crude or adjusted odds ratios (or linear predictors) for a grid of points.  Irregular grids are allowed.  Also draws contour lines for regions of signficantly increased or decreased values of the outcome variable ("clusters"), if permutation ranks are provided.  Designed to display \code{modgam} objects but can be used with other model results if the modgamobj list contains the correct elements.      
}
\usage{
colormap(modgamobj, map = NULL, add=F, contours="none", mapmin = NULL, mapmax = NULL, 
         arrow = T, axes = F, ptsize = 0.9, alpha = 0.05)
}
\arguments{
  \item{modgamobj}{
(Required) A list containing at least these two elements:  "grid" (a 2 column data frame with X and Y coordinates) and "fit" (a vector of linear predictors, with length equal to the number of grid points).  If the list contains an element named "OR" (a vector of odds ratios, with length equal to the number of grid points) then "OR" will be used instead of "fit".  If the list contains the element "pointwise" (a vector of percentile ranks generated by permutation test) then those values will be used to generate contours.  The correct list format is provided as output from the modgam function (see examples).   
}
  \item{map}{
Can be used to map predicted values on a base map from the \code{map} function in the \pkg{maps} package, or on a base map produced by the \code{readShapePoly} function in \pkg{maptools} package.  ReadShapePoly reads maps from external files in the ESRI shapefile format.  \code{map=NULL} produces a color image without any base map.
}
  \item{add}{
Use \code{add=T} to add the color map to an existing plot.  This will often result in loss of the legend and scale, which are added outside of the normal
    map boundaries.  \code{add} is ignored when a map is provided using the 
    \code{map} argument.
}
  \item{contours}{
Use \code{contours="response"} to add contour lines for the predicted response, for example to draw isoboles for mixtures of exposures.  Use \code{contours="permrank"} to add contour lines for pointwise p-values computed from the permutation ranks, at alpha/2 and (1-alpha)/2.  The default is "none" which produces no contour lines.
}
  \item{mapmin}{
The minimum value for the color scale legend 
}
  \item{mapmax}{
The maximum value for the color scale legend 
}
  \item{arrow}{
Use arrow=T to add a North arrow to the map.  	
}
  \item{axes}{
Use axes=T to add axes to the map (useful for chemical mixture isoboles).
}
  \item{ptsize}{
The size of the points used to fill in colors on the map.  Increase to remove white space inside the map or decrease to remove color outside the map boundaries.  NOTE: white space can also be eliminated by increasing the grid size in \code{predgrid}, which is often preferable as it results in a higher resolution map.   
}
  \item{alpha}{
The nominal pointwise type I error rate; only used when \code{contours="permrank"}.  
}
}

\value{
Produces an image map showing crude or adjusted linear predictors (or odds ratios).  If the base map is in \code{readShapePoly} format a scale bar is included.  The scale bar assumes that the X and Y coordinates are provided in meters.      
}

\author{
Veronica Vieira, Scott Bartell, and Robin Bliss

Send bug reports to \email{sbartell@uci.edu}.
}

\section{Warning}{Note that the contour lines use a pointwise nominal type I error rate of alpha; the chance of a type I error occurring for \strong{at least} one point on the map is much higher, typically approaching 100\% at alpha=0.05, because a spatial prediction grid generally contains many points.} 

\seealso{
  \code{\link{trimdata}}, 
  \code{\link{predgrid}}, 
  \code{\link{optspan}}, 
  \code{\link{modgam}}.
}

\examples{
\donttest{
### Load readShapePoly base map and data 
data(MAmap)		
data(MAdata) 
# Create a grid on the base map (PBSmapping package recommended)
if(require(PBSmapping)) MAgrid <- predgrid(MAdata, MAmap) else 
	MAgrid <- predgrid(MAdata)		
# fit crude GAM model to the MA data using span size of 50\%
fit1 <- modgam(MAdata, MAgrid, m="crude", sp=0.5)  
# Plot a map showing crude odds ratios
colormap(fit1, MAmap)					

#### A detailed example including map projections and data trimming
# NOTE: this example requires the maps, mapproj, and PBSmapping packages
# Convert base map and beer tweet data locations to US Albers projection 
# projected coords yield better distance estimates than (lat,long)
if(require(maps) & require(mapproj) & require(PBSmapping)) {
	USmap <- map("state",projection="albers",parameters=c(29.5,45.5),
				plot=FALSE,fill=TRUE,col="transparent")
	data(beertweets)
	case <- beertweets$beer
    # Reuse last map projection to convert data coordinates	
	XY <- mapproject(beertweets$longitude,beertweets$latitude)[1:2]  
	beerproj <- data.frame(case, XY[1], XY[2])			 
	# Generate grid on the US map, trimmed to range of beer data
	USgrid <- predgrid(beerproj, USmap)						
    # Fit unadjusted model--geolocation only
	fit2 <- modgam(beerproj, USgrid, m="unadjusted", sp=0.2)	
	dev.new(width=7,height=5)
    colormap(fit2, USmap)
	title(main="Beer Tweet Odds Ratios")	
}
}
}

\keyword{hplot}
\keyword{misc}
\keyword{smooth}
