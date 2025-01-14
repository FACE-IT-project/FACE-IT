# code/fjord_light.R
# Code for exploring the data from Bernard's FjordLight package


# Setup -------------------------------------------------------------------

source("code/functions.R")
library(FjordLight) # NB: Installed directly from .tar.gz


# Get fjord data ----------------------------------------------------------

# Set name
fjord <- "kong"

# Download
fl_DownloadFjord(fjord, dirdata = "data/PAR")

# Load
fjorddata <- fl_LoadFjord(fjord, dirdata = "data/PAR")
str(fjorddata)

## Extract bathymetry
# all depths (what = "s" ; s for Sea), as raster
bathy_rast <- flget_bathymetry(fjorddata, what = "s", mode = "raster", PLOT = TRUE)
bathy_df <- flget_bathymetry(fjorddata, what = "s", mode = "3col", PLOT = TRUE)
# coastal zone [0-200m] (what = "c" ; c for Coastal), as raster
# as 3 columns data frame (mode = "3col" : longitude, latitude, depth)
coast_df <- flget_bathymetry(fjorddata, what = "c", mode = "3col", PLOT = FALSE) |> 
  dplyr::rename(lon = longitude, lat = latitude)
sea_df <- flget_bathymetry(fjorddata, what = "s", mode = "3col", PLOT = FALSE) |> 
  dplyr::rename(lon = longitude, lat = latitude)


# Get pixel sizes ---------------------------------------------------------

# Calculate surface area for a single pixel
grid_size_one <- function(df, lon_half, lat_half){
  # Distance for longitude
  lon_dist <- distm(c(df$lon-lon_half, df$lat), c(df$lon+lon_half, df$lat), fun = distHaversine)/1000
  # Distance for latitude
  lat_dist <- distm(c(df$lon, df$lat+lat_half), c(df$lon, df$lat-lat_half), fun = distHaversine)/1000
  # Total area
  sq_area <- data.frame(sq_area = lon_dist*lat_dist)
  # Combine and exit
  res <- cbind(df, sq_area)
  return(res)
}

# Calculate the square kilometre surface area of each pixel
# This function assumes a lon lat column on a 0.08333333 degree grid
# NB: requires a 'lon' and 'lat' column on a full even grid
grid_size <- function(df){
  
  # Find average size of pixels
  unique_lon <- arrange(distinct(df[1]), lon) |> 
    mutate(diff = lon - lag(lon, default = first(lon))) |> 
    filter(diff != 0) # Get rid of first value
  unique_lat <- arrange(distinct(df[2]), lat) %>% 
    mutate(diff = lat - lag(lat, default = first(lat))) |> 
    filter(diff != 0)
  
  # Check for grid regularity
  if(length(unique(round(unique_lon$diff, 6))) != 1) stop("Data are not on an even grid")
  if(length(unique(round(unique_lat$diff, 6))) != 1) stop("Data are not on an even grid")
  
  # Get half pixel lengths
  lon_half <- unique(round(unique_lon$diff, 6))/2
  lat_half <- unique(round(unique_lat$diff, 6))/2
  
  # Get all sizes
  res <- plyr::ddply(mutate(df, plyr_idx = 1:n()), c("plyr_idx"), grid_size_one, .parallel = T,
                     lon_half = lon_half, lat_half = lat_half) |> 
    dplyr::select(-plyr_idx)
  return(res)
  # rm(df, unique_lon, unique_lat, lon_half, lat_half, lon_dist, lat_dist, sq_area, res)
}

# Get size in square kilometres per pixel
# kong_res <- grid_size(sea_df)
load("metadata/kong_surface.RData")


# Compare surface areas ---------------------------------------------------

# PAR as 3 columns data frame
P02012 <- flget_optics(fjorddata, "PAR0m", "Yearly", year = 2012, mode = "3col")
P0June <- flget_optics(fjorddata, optics = "PAR0m", period = "Monthly", month = 6, mode = "3col")
PBJune <- flget_optics(fjorddata, optics = "PARbottom", period = "Monthly", month = 6, mode = "3col")
PB2012 <- flget_optics(fjorddata, "PARbottom", "Yearly", year = 2012, mode = "3col")
P0global <- flget_optics(fjorddata, "PAR0m", "Global", mode = "3col")
PBglobal <- flget_optics(fjorddata, "PARbottom", "Global", mode = "3col")
kdglobal <- flget_optics(fjorddata, "kdpar", "Global", mode = "3col")

# Equation
# NB: Still needs work
# PAR_Bottom = PAR0 x exp(−KdPAR × bottom_depth )
bkdPAR <- left_join(kong_res, P0global)

# Get surface areas from FjordLight package
# as a function
fG <- flget_Pfunction(fjorddata, "Global", plot = FALSE)
# then you can use it; for instance :
irradiance_levels <- c(0.1, 1, 10)
fG(irradiance_levels)

# Internal code
with(fjorddata, {
  g <- fjorddata[["GlobalPfunction"]]
  ret <- data.frame(irradianceLevel, g)
  # names(ret) <- c("irradianceLevel", layername)
  return(ret)
})

# As a 2 column data.frame
f2012 <- flget_Pfunction(fjorddata, "Yearly", year = 2012, mode = "2col")
fglobal <- flget_Pfunction(fjorddata, "Global", mode = "2col")

# Plot
flget_Pfunction(fjorddata, "Global", PLOT = TRUE, lty = 1, col = 1, lwd = 2, Main = paste(fjord, "P-functions"), ylim = c(0, 50))

# Manual calculation
kong_surf_total <- sum(kong_res$sq_area)
kong_surf_sea <- kong_res |> 
  filter(depth <= 0) |> 
  summarise(sq_area = sum(sq_area, na.rm = T))
kong_surf_sea
kong_surf_coast <- kong_res |> 
  filter(depth >= -200, depth <= 0) |> 
  summarise(sq_area = sum(sq_area, na.rm = T))
kong_surf_coast

# Manual proportions of surface > 10 PAR
kong_global_coast_PAR10 <- PBglobal |> 
  dplyr::rename(lon = longitude, lat = latitude) |> 
  left_join(kong_res) |> 
  filter(depth >= -200, depth <= 0) |> 
  filter(PARbottom_Global >= 10) |>
  summarise(sq_area = sum(sq_area, na.rm = T))
kong_global_coast_PAR10/kong_surf_coast

# Manual proportions of surface > 0.1 PAR
kong_global_coast_PAR0.1 <- PBglobal |> 
  dplyr::rename(lon = longitude, lat = latitude) |> 
  left_join(kong_res) |> 
  filter(depth >= -200, depth <= 0) |> 
  filter(PARbottom_Global >= 0.1) |> 
  summarise(sq_area = sum(sq_area, na.rm = T))
kong_global_coast_PAR0.1/kong_surf_coast


# Get pixels in regions ---------------------------------------------------

# Subset high-res coastline
if(!exists("coastline_full")) load("metadata/coastline_full_df.RData")
coastline_kong_wide <- coastline_full_df %>% 
  filter(x >= bbox_kong[1]-1, x <= bbox_kong[2]+1,
         y >= bbox_kong[3]-1, y <= bbox_kong[4]+1) %>% 
  dplyr::select(x, y, polygon_id) %>% 
  dplyr::rename(lon = x, lat = y)
coastline_kong <- coastline_full_df %>% 
  filter(x >= bbox_kong[1], x <= bbox_kong[2],
         y >= bbox_kong[3], y <= bbox_kong[4]) %>% 
  dplyr::select(x, y) %>% 
  dplyr::rename(lon = x, lat = y)

# Manually create regions
kong_inner <- coastline_kong[270,] %>% 
  rbind(data.frame(lon = c(12.36, 12.65, 12.65), lat = c(78.86, 78.86, 79.01958))) %>% 
  rbind(coastline_kong[c(560:570, 536, 420),]) %>% 
  rbind(data.frame(lon = 12.36003, lat = 78.945)) %>% mutate(region = "inner")
kong_trans <- coastline_kong[c(157:270),] %>% 
  rbind(data.frame(lon = 12.36003, lat = 78.945)) %>% 
  rbind(coastline_kong[c(420, 536, 570:589, 500:470),]) %>% mutate(region = "transition")
kong_middle <- coastline_kong[c(76:157, 470:500, 589:666),] %>% mutate(region = "middle")
kong_outer <- coastline_kong[c(76, 666),] %>% rbind(data.frame(lon = 11.178, lat = 79.115)) %>% mutate(region = "outer")
kong_shelf <- coastline_kong[1:76,] %>% 
  rbind(data.frame(lon = c(11.178, 11.178, 11, 11, 11.72653), lat = c(79.115, 79.2, 79.2, 78.85, 78.85))) %>%  mutate(region = "shelf")
kong_regions <- rbind(kong_inner, kong_trans, kong_middle, kong_outer, kong_shelf) %>% 
  mutate(region = factor(region, levels = c("inner", "transition", "middle", "outer", "shelf")))

# Find regions for hi-res pixels
kong_hires_region <- plyr::ldply(unique(kong_regions$region), points_in_region, .parallel = F, 
                                 bbox_df = kong_regions, data_df = sea_df)

# Merge and get averages
PBglobal_regions <- PBglobal |> 
  dplyr::rename(lon = longitude, lat = latitude) |> 
  left_join(kong_hires_region, by = c("lon", "lat")) |> 
  filter(!is.na(region)) |> 
  summarise(PARbottom_Global = mean(PARbottom_Global, na.rm = T), .by = region)

# Merge and plot
kong_regions |> 
  left_join(PBglobal_regions, by = c("region")) |> 
  ggplot(aes(x = lon, y = lat)) +
  geom_polygon(aes(group = region, colour = region, fill = PARbottom_Global)) +
  geom_polygon(data = coastline_kong_wide, aes(group = polygon_id), colour = "grey20") +
  coord_quickmap(expand = F,
                 xlim = c(bbox_kong[1]-0.3, bbox_kong[2]+0.3), 
                 ylim = c(bbox_kong[3]-0.05, bbox_kong[4]+0.05))

