# Other than the current location of ISS, 
# the Open Notify data also includes the number of crew and their names.
# Here, we would like to find out the crew in the ISS now.

library(easypackages)
libraries("data.tree", "jsonlite", "magrittr", "plotly", "httr")



# pull the data directly from the remote Open-Notify JSON file
astros <- fromJSON("http://api.open-notify.org/astros.json", simplifyDataFrame = FALSE)

# Take a look at the "astros" file
astros0 <- httr::GET("http://api.open-notify.org/astros.json")
httr::content(astros0, "text")

# Like the "space" JSON file, the "astros" is a nested JSON file too.
# We can use the data.tree pkg to see the hierarchy
astros1 <- Node$new("astros")
    people <- astros1$AddChild("people")
        craft <- people$AddChild("craft")
        astro_name <- people$AddChild("astro_name")
    number <- astros1$AddChild("number")
    message <- astros1$AddChild("message")

print(astros1)

# To see the names of the crew
astros_1 <- as.Node(astros)
print (astros_1, "craft")

#convert this to a data.frame
astros_df <- astros_1%>%ToDataFrameTable( "craft"  , "name", 
                                        message = function(x) x$parent$message,
                                        number = function(x) x$parent$number)
astros_df