#' Subset a network keeping the only nodes that intersect a target geometry.
#'
#' If subsetting results in multiple disconnected components, we keep the only
#' largest component.
#'
#' @param network A network object
#' @param target The target geometry
#' @param buffer Optional buffer distance to apply to the target geometry
#'
#' @return A spatial network object
#' @keywords internal
filter_network <- function(network, target, buffer = NULL) {
  # If buffer is given, apply it to the target
  if (!is.null(buffer)) target <- sf::st_buffer(target, buffer)

  network |>
    tidygraph::activate("nodes") |>
    tidygraph::filter(sfnetworks::node_intersects(target)) |>
    # keep only the main connected component of the network
    tidygraph::activate("nodes") |>
    dplyr::filter(tidygraph::group_components() == 1)
}

#' Visualize one or more vector datasets on a base map
#'
#' @param ... [`sf::sf`] objects (or compatible) to display on a map. If the
#'   coordinate reference system is missing, lat/lon coordinates will be assumed
#'   ("EPSG:4326")
#' @param col Color (sequence) to use for the input object(s)
#' @param label Labels to use for the input object(s). If a vector, use its
#'   elements to label the object features. If a string, label
#' @param map Leaflet map object where to plot the geospatial objects
#'
#' @return Leaflet map
visualize <- function(..., col = NULL, label = NULL, map = NULL) {
  # Pack input obhects in a list
  geometries <- list(...)
  ngeoms <- length(geometries)

  # Determine the sequence of colors
  colors <- get_colors(ngeoms, col = col)

  # Initialize map
  if (is.null(map)) map <- leaflet::addTiles(leaflet::leaflet())

  # Loop over objects to plot
  for (n in seq_len(ngeoms)) {
    geometry <- geometries[[n]]
    color <- colors[[n]]

    if (inherits(geometry, "bbox")) {
      # If a bounding box, convert it to polygon
      map <- visualize(sf::st_as_sfc(geometry), col = color, map = map)
    } else if (inherits(geometry, "sfnetwork")) {
      # If a sfnetwork, extract edges and nodes
      edges <- sf::st_as_sf(geometry, "edges")
      labels <- get_edge_labels(edges)
      map <- visualize(edges, col = color, label = labels, map = map)
      nodes <- sf::st_as_sf(geometry, "nodes")
      map <- visualize(nodes, col = color, label = seq_len(nrow(nodes)),
                       map = map)
    } else if (inherits(geometry, "SpatRaster")) {
      map <- leaflet::addRasterImage(map, geometry, opacity = 0.8)
    } else if (inherits(geometry, "sf")) {
      is_column_name <- (
        !is.null(label) && (length(label) == 1) && (label %in% names(geometry))
      )
      if (is_column_name) label <- geometry[[label]]
      map <- visualize(sf::st_geometry(geometry), col = col, label = label,
                       map = map)
    } else if (inherits(geometry, "sfc")) {
      geometry_type <- sf::st_geometry_type(geometry, by_geometry = FALSE)
      data <- as.latlon(geometry)
      if (is.in("linestring", geometry_type)) {
        map <- leaflet::addPolylines(map, data = data, color = color,
                                     label = label)
      } else if (is.in("point", geometry_type)) {
        map <- leaflet::addCircles(map, data = data, color = col,
                                   label = label)
      } else if (is.in("polygon", geometry_type)) {
        map <- leaflet::addPolygons(map, data = data, color = col,
                                    label = label)
      } else {
        stop(sprintf("Cannot plot geometry type: %s", geometry_type))
      }
    } else {
      stop(paste0("Cannot plot data type ", class(geometry)))
    }
  }
  map
}

#' @noRd
get_colors <- function(num_geometries, col = NULL) {
  if (is.null(col)) {
    # If color is NULL, determine colors from a palette
    factpal <- leaflet::colorFactor(topo.colors(num_geometries),
                                    factor(seq_len(num_geometries)))
    col <- sapply(seq_len(num_geometries), factpal)
  } else if (length(col) == 1) {
    # If we got a single color, use it for all geometries
    col <- rep(col, num_geometries)
  }
  # Make sure we have as many colors as geometries
  stopifnot(length(col) == num_geometries)
  col
}

#' @noRd
is.in <- function(x, y) grepl(x, y, ignore.case = TRUE)

#' @noRd
as.latlon <- function(x) {
  crs <- sf::st_crs(x)
  # If no CRS is present, set it to lat/lon
  if (is.na(crs)) sf::st_crs(x) <- sf::st_crs("EPSG:4326")
  sf::st_transform(x, 4326)
}

#' @noRd
get_edge_labels <- function(edges) {
  ids <- seq_len(nrow(edges))
  lapply(sprintf("<strong>%d</strong> %d -> %d", ids, edges$from, edges$to),
         htmltools::HTML)
}
