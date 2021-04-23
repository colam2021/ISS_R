# References: 
# Glur, C. (2020). Introduction to data.tree. 
#     https://cran.r-project.org/web/packages/data.tree/vignettes/data.tree.html
# Glur, C. (2020). Convert a complex JSON to an R data.frame. 
#     https://gist.github.com/gluc/5f780246d57897b57c6b
# The data.tree package creator shows how ot use the package to handle a complex JSON. 
 

library(easypackages)
libraries("data.tree", "jsonlite", "magrittr", "plotly", "httr")

# pull the data directly from the remote Open-Notify JSON file
# result is a list
space <- fromJSON("http://api.open-notify.org/iss-now.json", simplifyDataFrame = FALSE)

# Take a look at the "space" file
space0 <- httr::GET("http://api.open-notify.org/iss-now.json")
httr::content(space0, "text")

# The "space" file is a nested json file
# We can create the tree to see the hierarchy

space1 <- Node$new("space")
  iss_position <- space1$AddChild("iss_position")
      latitude <- iss_position$AddChild("latitude")
      longitude <- iss_position$AddChild("longitude")
  timestamp <- space1$AddChild("timestamp")
  message <- space1$AddChild("message")

print(space1)

# To go into the "iss_position" level
space2 <- as.Node(space )
print (space2, "latitude", "longitude")

#convert this to a data.frame
space_df <- space2%>%ToDataFrameTable( "latitude"  , "longitude", 
                                   message = function(x) x$parent$message,
                                   timestamp = function(x) x$parent$timestamp)
space_df

##
# The next step is to plot the ISS current location in the map
# It is done by plotly

space_df$poph <- paste('latitude=' ,  space_df$latitude, 'longitude=', space_df$longitude)

fig = plot_geo(space_df, lat = space_df$latitude, lon = space_df$longitude,  text = ~poph , 
  mode = 'markers', symbol = 'circle',
  color = 'rgba(255, 182, 193, .9)', marker = list( size = 20 ), hoverinfo = "text")%>% 
  layout(title = 'Current ISS Location')
fig
 
 
