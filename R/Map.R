#' Module to display Earth Engine (EE) spatial objects
#'
#' Create interactive visualizations of spatial EE objects
#' (ee$Geometry, ee$Image, ee$Feature, and ee$FeatureCollection)
#' using \code{mapview}.
#' @format An object of class environment with the
#' following functions:
#' \itemize{
#'   \item  \strong{addLayer(eeObject, visParams, name = NULL, shown = TRUE,
#'   opacity = 1)}: Adds a given EE object to the map as a layer. \cr
#'   \itemize{
#'     \item \strong{eeObject:} The object to add to mapview.\cr
#'     \item \strong{visParams:} List of parameters for visualization.
#'     See details.\cr
#'     \item \strong{name:} The name of the layer.\cr
#'     \item \strong{shown:} A flag indicating whether the
#'     layer should be on by default. \cr
#'     \item \strong{opacity:} The layer's opacity represented as a number
#'      between 0 and 1. Defaults to 1. \cr
#'   }
#'   \item \strong{setCenter(lon = 0, lat = 0, zoom = NULL)}: Centers the map
#'   view at the given coordinates with the given zoom level. If no zoom level
#'   is provided, it uses 1 by default.
#'   \itemize{
#'     \item \strong{lon:} The longitude of the center, in degrees.\cr
#'     \item \strong{lat:} The latitude of the center, in degrees.\cr
#'     \item \strong{zoom:} The zoom level, from 1 to 24.
#'   }
#'   \item \strong{setZoom(zoom = NULL)}: Sets the zoom level of the map.
#'   \itemize{
#'     \item \strong{zoom:} The zoom level, from 1 to 24.
#'   }
#'   \item \strong{centerObject(eeObject, zoom = NULL,
#'    maxError = ee$ErrorMargin(1))}: Centers the
#'   map view on a given object. If no zoom level is provided, it will
#'   be predicted according to the bounds of the Earth Engine object specified.
#'   \itemize{
#'     \item \strong{eeObject:} EE object.\cr
#'     \item \strong{zoom:} The zoom level, from 1 to 24.
#'     \item \strong{maxError:} 	Max error when input
#'     image must be reprojected to an explicitly
#'     requested result projection or geodesic state.
#'   }
#' }
#'
#' @details
#' `Map` use the Earth Engine method
#' \href{https://developers.google.com/earth-engine/api_docs#ee.data.getmapid}{
#' getMapId} to fetch and return an ID dictionary being used to create
#' layers in a \code{mapview} object. Users can specify visualization
#' parameters to Map\$addLayer by using the visParams argument. Each Earth
#' Engine spatial object has a specific format. For
#' \code{ee$Image}, the
#' \href{https://developers.google.com/earth-engine/image_visualization}{
#' parameters} available are:
#'
#' \tabular{lll}{
#' \strong{Parameter}\tab \strong{Description}  \tab \strong{Type}\cr
#' \strong{bands}    \tab  Comma-delimited list of three band names to be
#' mapped to RGB     \tab  list \cr
#' \strong{min}      \tab  Value(s) to map to 0 \tab  number or list of three
#' numbers, one for each band \cr
#' \strong{max}      \tab  Value(s) to map to 1 \tab  number or list of three
#' numbers, one for each band \cr
#' \strong{gain}     \tab  Value(s) by which to multiply each pixel value \tab
#' number or list of three numbers, one for each band \cr
#' \strong{bias}     \tab  Value(s) to add to each Digital Number (DN)
#' value \tab number or list of three numbers, one for each band \cr
#' \strong{gamma}    \tab  Gamma correction factor(s) \tab  number or list of
#' three numbers, one for each band \cr
#' \strong{palette}  \tab  List of CSS-style color strings
#' (single-band images only) \tab  comma-separated list of hex strings \cr
#' \strong{opacity}   \tab  The opacity of the layer (0.0 is fully transparent
#' and 1.0 is fully opaque) \tab  number \cr
#' }
#'
#' If you add an \code{ee$Image} to the map without any additional parameters,
#' by default `Map$addLayer()` assigns the first three bands to red,
#' green, and blue bands, respectively. The default stretch is based on the
#' min-max range. By the other hand, for \code{ee$Geometry}, \code{ee$Feature},
#' and \code{ee$FeatureCollection} the available parameters are:
#'
#' \itemize{
#'  \item \strong{color}: A hex string in the format RRGGBB specifying the
#'  color to use for drawing the features. By default #000000.
#'  \item \strong{pointRadius}: The radius of the point markers. By default 3.
#'  \item \strong{strokeWidth}: The width of lines and polygon borders. By
#'  default 3.
#' }
#' @examples
#' \dontrun{
#' library(rgee)
#' ee_Initialize()
#'
#' # Case 1: Geometry*
#' geom <- ee$Geometry$Point(list(-73.53, -15.75))
#' Map$centerObject(geom, zoom = 13)
#' m1 <- Map$addLayer(
#'   eeObject = geom,
#'   visParams = list(
#'     pointRadius = 10,
#'     color = "FF0000"
#'   ),
#'   name = "Geometry-Arequipa"
#' )
#'
#' # Case 2: Feature
#' eeobject_fc <- ee$FeatureCollection("users/csaybar/DLdemos/train_set")$
#'   first()
#' m2 <- Map$addLayer(
#'   eeObject = ee$Feature(eeobject_fc),
#'   name = "Feature-Arequipa"
#' )
#' m2 + m1
#'
#' # Case 3: FeatureCollection
#' eeobject_fc <- ee$FeatureCollection("users/csaybar/DLdemos/train_set")
#' Map$centerObject(eeobject_fc)
#' m3 <- Map$addLayer(eeObject = eeobject_fc, name = "FeatureCollection")
#' m3 + m2 + m1
#'
#' # Case 4: Image
#' image <- ee$Image("LANDSAT/LC08/C01/T1/LC08_044034_20140318")
#' Map$centerObject(image)
#' m4 <- Map$addLayer(
#'   eeObject = image,
#'   visParams = list(
#'     bands = c("B4", "B3", "B2"),
#'     max = 10000
#'   ),
#'   name = "SF"
#' )
#' m4
#' }
#' @export
Map <- function() {
  Map <- new.env(parent = emptyenv())
}

ee_set_methods <- function() {
  Map$addLayer <- ee_addLayer
  Map$setCenter <- ee_setCenter
  Map$setZoom <- ee_setZoom
  Map$centerObject <- ee_centerObject
  # Map$getBounds <- ee_getBounds
  # Map$getScale <- getScale
  # Map$getCenter <- getCenter
  # Map$getZoom <- getZoom

  # Init environment
  Map$setCenter()
  Map
}

#' Sets the zoom level of the map.
#' @noRd
ee_setZoom <- function(zoom) {
  Map$zoom <- zoom
}

#' Center a mapview
#'
#' Centers the map view at the given coordinates
#' with the given zoom level. If no zoom level is
#' specified, it uses 1.
#'
#' https://developers.google.com/earth-engine/api_docs#map.setcenter
#' @noRd
ee_setCenter <- function(lon = 0, lat = 0, zoom = NULL) {
  Map$lon <- lon
  Map$lat <- lat
  Map$zoom <- zoom
  invisible(Map)
}


#' Center a mapview using an EE object
#'
#' Centers the map view on a given object. If no zoom
#' level is specified, it will be predicted according to the
#' bounds of the specified Earth Engine object.
#'
#' https://developers.google.com/earth-engine/api_docs#map.centerobject
#' @noRd
ee_centerObject <- function(eeObject,
                            zoom = NULL,
                            maxError = ee$ErrorMargin(1)) {
  if (any(class(eeObject) %in% "ee.featurecollection.FeatureCollection")) {
    message("NOTE: Center got from the first element.")
    eeObject <- ee$Feature(eeObject$first())
  }

  if (any(class(eeObject) %in% ee_get_spatial_objects("Nongeom"))) {
    center <- tryCatch(
      expr = eeObject$
        geometry()$
        centroid(maxError)$
        getInfo() %>%
        '[['('coordinates') %>%
        ee_utils_py_to_r(),
      error = function(e) {
        message(
          "The centroid coordinate was not possible",
          " to estimate, assigning: c(0,0)"
        )
        c(0, 0)
      }
    )

    if (is.null(center)) {
      message(
        "The centroid coordinate was not possible",
        " to estimate, assigning: c(0,0)"
      )
      center <- c(0, 0)
    }
  } else if (any(class(eeObject) %in% "ee.geometry.Geometry")) {
    center <- tryCatch(
      expr = eeObject$
        centroid(maxError)$
        coordinates()$
        getInfo() %>%
        ee_utils_py_to_r(),
      error = function(e) {
        message(
          "The centroid coordinate was not possible",
          " to estimate, assigning: c(0,0)"
        )
        c(0, 0)
      }
    )
  } else {
    stop("Spatial Earth Engine Object not supported")
  }

  if (is.null(zoom)) {
    zoom <- ee_getZoom(eeObject, maxError = maxError)
  }
  Map$setCenter(lon = center[1], lat = center[2], zoom = zoom)
}

#' Adds a given EE object to the map as a layer.
#' https://developers.google.com/earth-engine/api_docs#map.addlaye
#' @noRd
ee_addLayer <- function(eeObject,
                        visParams = NULL,
                        name = NULL,
                        shown = TRUE,
                        opacity = 1) {
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("package jsonlite required, please install it first")
  }
  if (!requireNamespace("mapview", quietly = TRUE)) {
    stop("package mapview required, please install it first")
  }
  if (!requireNamespace("leaflet", quietly = TRUE)) {
    stop("package leaflet required, please install it first")
  }

  if (is.null(visParams)) {
    visParams <- list()
  }

  image <- NULL

  # Earth Engine Spatial object
  ee_spatial_object <- ee_get_spatial_objects("Simple")

  if (!any(class(eeObject) %in% ee_spatial_object)) {
    stop(
      "The eeObject argument must be an instance of one",
      " of ee$Image, ee$Geometry, ee$Feature, or ee$FeatureCollection."
    )
  }
  if (any(class(eeObject) %in% ee_get_spatial_objects("Table"))) {
    features <- ee$FeatureCollection(eeObject)

    width <- 2
    if (!is.null(visParams[["width"]])) {
      width <- visParams[["width"]]
    }

    color <- "000000"
    if (!is.null(visParams[["color"]])) {
      color <- visParams[["color"]]
    }

    image_fill <- features$
      style(fillColor = color)$
      updateMask(ee$Image$constant(0.5))

    image_outline <- features$style(
      color = color,
      fillColor = "00000000",
      width = width
    )

    image <- image_fill$blend(image_outline)
  } else {
    image <- do.call(eeObject$visualize, visParams)
  }

  if (is.null(name)) {
    name <- tryCatch(
      expr = jsonlite::parse_json(eeObject$id()$serialize())$
        scope[[1]][[2]][["arguments"]][["id"]],
      error = function(e) "untitled"
    )
    if (is.null(name)) name <- "untitled"
  }
  tile <- get_ee_image_url(image)
  ee_addTile(tile, name = name, shown = shown, opacity = opacity)
}


#' Basic base mapview object
#' @noRd
ee_mapview <- function() {
  if (!requireNamespace("mapview", quietly = TRUE)) {
    stop("package mapview required, please install it first")
  }
  m <- mapview::mapview()
  m@map$x$setView[[1]] <- c(Map$lat, Map$lon)
  m@map$x$setView[[2]] <- if (is.null(Map$zoom)) 1 else Map$zoom
  m
}

#' Add a mapview object based on a tile_fetcher
#' @noRd
ee_addTile <- function(tile, name, shown, opacity) {
  if (!requireNamespace("mapview", quietly = TRUE)) {
    stop("package mapview required, please install it first")
  }
  if (!requireNamespace("leaflet", quietly = TRUE)) {
    stop("package leaflet required, please install it first")
  }
  m <- ee_mapview()
  m@map <- m@map %>%
    leaflet::addTiles(
      urlTemplate = tile,
      group = name,
      options = leaflet::tileOptions(opacity = opacity)
    ) %>%
    ee_mapViewLayersControl(names = name) %>%
    leaflet::hideGroup(if (!shown) name else NULL)
  m@object$tokens <- tile
  m@object$names <- name
  m@object$opacity <- opacity
  m@object$shown <- shown
  m <- new("EarthEngineMap", object = m@object, map = m@map)
  m
}

if (!isGeneric("+")) {
  setGeneric("+", function(x, y, ...)
    standardGeneric("+"))
}

#' Get the tile_fetcher to display into ee_map
#' @noRd
get_ee_image_url <- function(image) {
  map_id <- ee$data$getMapId(list(image = image))
  url <- map_id[["tile_fetcher"]]$url_format
  url
}


#' Return R classes for Earth Engine Spatial Objects
#' @noRd
ee_get_spatial_objects <- function(type = "all") {
  if (type == "Table") {
    ee_spatial_object <- c(
      "ee.geometry.Geometry",
      "ee.feature.Feature",
      "ee.featurecollection.FeatureCollection"
    )
  }
  if (type == "i+ic") {
    ee_spatial_object <- c(
      "ee.image.Image", "ee.imagecollection.ImageCollection")
  }
  if (type == "Image") {
    ee_spatial_object <- "ee.image.Image"
  }
  if (type == "ImageCollection") {
    ee_spatial_object <- "ee.imagecollection.ImageCollection"
  }
  if (type == "Nongeom") {
    ee_spatial_object <- c(
      "ee.feature.Feature",
      "ee.featurecollection.FeatureCollection",
      "ee.image.Image"
    )
  }
  if (type == "justfeature") {
    ee_spatial_object <- c(
      "ee.feature.Feature",
      "ee.featurecollection.FeatureCollection"
    )
  }
  if (type == "Simple") {
    ee_spatial_object <- c(
      "ee.geometry.Geometry",
      "ee.feature.Feature",
      "ee.featurecollection.FeatureCollection",
      "ee.image.Image"
    )
  }
  if (type == "All") {
    ee_spatial_object <- c(
      "ee.geometry.Geometry",
      "ee.feature.Feature",
      "ee.featurecollection.FeatureCollection",
      "ee.imagecollection.ImageCollection",
      "ee.image.Image"
    )
  }
  return(ee_spatial_object)
}

#' Estimates the zoom level for a given bounds
#' Adapted from Python to R
#' https://github.com/fitoprincipe/ipygee/
#' https://stackoverflow.com/questions/6048975/
#' @noRd
ee_getZoom <- function(eeObject, maxError = ee$ErrorMargin(1)) {
  bounds <- ee_get_boundary(eeObject, maxError)

  WORLD_DIM <- list(height = 256, width = 256)
  ZOOM_MAX <- 18

  latRad <- function(lat) {
    sin <- sin(lat * pi / 180)
    radX2 <- log((1 + sin) / (1 - sin)) / 2
    max(min(radX2, pi), -pi) / 2
  }

  zoom <- function(mapPx, worldPx, fraction) {
    floor(log(mapPx / worldPx / fraction) / log(2))
  }

  latFraction <- (latRad(bounds["ymax"]) - latRad(bounds["ymin"])) / pi
  lngDiff <- bounds["xmax"] - bounds["xmin"]
  lngFraction <- if (lngDiff < 0) lngDiff + 360 else lngDiff
  lngFraction <- lngFraction / 360

  latZoom <- zoom(400, WORLD_DIM[["height"]], latFraction)
  lngZoom <- zoom(970, WORLD_DIM[["width"]], lngFraction)

  min(latZoom, lngZoom, ZOOM_MAX)
}

#' Get boundary of a Earth Engine Object
#' @noRd
ee_get_boundary <- function(eeObject, maxError) {
  if (any(class(eeObject) %in% "ee.geometry.Geometry")) {
    eeObject <- ee$Feature(eeObject)
  }
  eeObject$geometry()$bounds(maxError)$getInfo() %>%
    '[['('coordinates') %>%
    ee_utils_py_to_r() %>%
    unlist() %>%
    matrix(ncol = 2, byrow = TRUE) %>%
    list() %>%
    sf::st_polygon() %>%
    sf::st_bbox()
}

# Create an Map env and set methods
Map <- Map()
ee_set_methods()
