server=shinyServer(function(input, output){
  
  
  observeEvent (input$city_dropdown,{
    if(input$city_dropdown=="All"){
      output$city_bike_map=renderLeaflet ({
        leaflet() %>% 
          addTiles() %>% 
          addMarkers(
            label=cities_today_status$CITY_ASCII, lng=cities_today_status$LNG, 
            lat=cities_today_status$LAT, popup=cities_today_status$LABEL,
            options = popupOptions(closeButton = FALSE)) %>% 
          addCircleMarkers(lng=cities_today_status$LNG,
                           lat=cities_today_status$LAT,color=cities_today_status$COLOR, 
                           radius=cities_today_status$CIRCLE )
      })
    }else{
      selected_city=reactive({ 
        cities_today_status %>% 
          filter(CITY_ASCII==input$city_dropdown) 
        })
      
      selected_city_5_day=reactive({
        city_weather_bike_df %>% 
          filter(CITY_ASCII==input$city_dropdown)
        })
      
      output$city_bike_map=renderLeaflet ({
        leaflet() %>% 
          addTiles() %>% 
          setView(lng=selected_city()$LNG, lat=selected_city()$LAT, zoom=15) %>% 
          addMarkers(lng=selected_city()$LNG, lat=selected_city()$LAT, 
                     popup=selected_city()$DETAILED_LABEL)
        })
      output$temp_line=renderPlot({
        ggplot(selected_city_5_day(),aes(x=FORECASTDATETIME,y=TEMPERATURE)) +
          geom_line(color="yellow") +
          geom_text(aes(label=TEMPERATURE),size=3) +
          labs(title=("Temperature Chart"))+ xlab('Time (3hrs ahead)') +
          ylab("Temperature")
        })
      
      output$bike_prediction=renderPlot({
        ggplot(selected_city_5_day(),aes(x=FORECASTDATETIME,y=BIKE_PREDICTION)) + 
          geom_line(color="blue", lty="dashed") +
          geom_text(aes(label=BIKE_PREDICTION),size=3) +
          xlab('Time (3hrs ahead)') + ylab("Predicted Bike Count")
        })
      
      output$bike_date_output=renderText({
        paste("Time=", as_datetime(input$plot_click$x), 
              "\nBikeCountPred=", as.integer(input$plot_click$y)) 
        })
      
      output$humidity_pred_chart=renderPlot({
        ggplot(selected_city_5_day(),aes(x=HUMIDITY,y=BIKE_PREDICTION))+
          geom_smooth(method=lm,formula=y~poly(x,4),color="red")+
          geom_point()+
          xlab('Humidity')+ ylab("Bike Prediction")
        })
      }
    })
  })
