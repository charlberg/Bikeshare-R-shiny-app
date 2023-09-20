ui=shinyUI(
  fluidPage(padding=5,
            titlePanel("Bike-sharing demand prediction app"), 
            # Create a side-bar layout
            sidebarLayout(
              # Create a main panel to show cities on a leaflet map
              mainPanel(
                leafletOutput("city_bike_map", height=1000)
              ),
              sidebarPanel(selectInput("city_dropdown","Cities",
                                       choices=c("All",city_weather_bike_df$CITY_ASCII)),
                           plotOutput("temp_line", height=200),
                           plotOutput("bike_prediction",
                                      height=200,click = "plot_click"),
                           verbatimTextOutput("bike_date_output"),
                           plotOutput("humidity_pred_chart", height=200)
              )
            )
  ))
