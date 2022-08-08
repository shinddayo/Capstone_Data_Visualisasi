

shinyServer(function(input, output) {

  v <- reactiveValues(data = "Bank Sampah")
  
  observeEvent(input$BS, {
    v$data <- "Bank Sampah"
  })
  
  observeEvent(input$SE, {
    v$data <- "Sumber Energi"
  })  
  
  observeEvent(input$TPS, {
    v$data <- "TPS3R/PDU/ITF"
  })  
  
  observeEvent(input$KOM, {
    v$data <- "Komposting"
  })  
  
  observeEvent(input$TPA, {
    v$data <- "TPA"
  })  
  
  observeEvent(input$SI, {
    v$data <- "Sektor Internal"
  })  
  output$JenisPlot <- renderEcharts4r({
    komposisi_jenis %>% 
      filter(Tahun==input$slider) %>% 
      arrange(Perc) %>% 
      e_charts(x = Jenis) %>% 
      e_bar(
        Perc, 
        name = "Timbulan Sampah", 
        symbol = "none"
      ) %>% 
      e_grid(containLabel = T) %>% 
      e_title(text = "Komposisi Sampah Berdasarkan Jenisnya",
              left = "center",
              top = "0") %>% 
      e_legend(F) %>%
      e_y_axis(axisLabel = list(
        interval = 0L
      )) %>% 
      e_format_y_axis(suffix = "%")%>% 
      e_flip_coords() %>%
      e_tooltip(formatter = htmlwidgets::JS("
                                        
                                        function(params)
                                        {
                                            return `<strong>Sampah ${params.value[1]}</strong>
                                                     <br/>${parseFloat(params.value[0]).toFixed(2)}% dari Total Timbulan Sampah`
                                        }
                                        ")) %>% 
      e_color(c("#2b9348","#80b918"))
  })
  
  output$sumberPlot <- renderEcharts4r({
    komposisi_sumber %>% 
      mutate(
        Perc=Perc*100
      ) %>% 
      filter(Tahun==input$slider) %>% 
      arrange(Perc) %>% 
      e_charts(x = Sumber) %>% 
      e_bar(
        Perc, 
        name = "Timbulan Sampah", 
        symbol = "none",
        bind = Weight,
        fill="green"
      ) %>% 
      e_grid(containLabel = T) %>% 
      e_title(text = "Komposisi Sampah Berdasarkan Sumbernya",
              left = "center",
              top = "0") %>% 
      e_legend(F) %>%
      e_format_y_axis(suffix = "%")%>% 
      e_flip_coords() %>%
      e_tooltip(formatter = htmlwidgets::JS("
                                        
                                        function(params)
                                        {
                                            return `<strong>Sampah ${params.value[1]}</strong>
                                                      <br/>Timbulan: ${echarts.format.addCommas(params.name)} Ton/Tahun
                                                    <br/>${parseFloat(params.value[0]).toFixed(2)}% dari Total Timbulan Sampah`
                                        }
                                        ")) %>% 
      e_color(c("#2b9348","#aad576"))
    
  })

  output$petaFasilitas <- renderLeaflet({
    
      tag.map.title <- tags$style(HTML("
    .leaflet-control.map-title { 
      transform: translate(-50%,20%);
      position: fixed !important;
      left: 23%;
      text-align: center;
      padding-left: 10px; 
      padding-right: 10px; 
      background: rgba(255,255,255,0.75);
      font-weight: bold;
      font-size: 28px;
    }
  "))
      
      title <- tags$div(
        tag.map.title, HTML(v$data)
      )  
      
    pop<-  paste0("Kota: ", pengolah_lat$KabupatenKota, "<br>",pengolah_lat$Jumlah_Fasilitas," ", pengolah_lat$Fasilitas_Group) 
       
    icons <- awesomeIcons(icon = "street-view",
                          iconColor = "pink",
                          markerColor = "black",
                          library = "fa")
    
    map1 <- leaflet() %>% 
      addTiles()  %>% 
      addControl(title, position = "topleft", className="map-title") %>% 
      addMarkers(data = pengolah_lat[pengolah_lat$Tahun==input$slider & pengolah_lat$Fasilitas_Group==v$data,], icon=icons, popup = pop ,clusterOptions = markerClusterOptions())
    
    map1
    
  })
  
  output$VaueTimbulan<-renderUI({
    scales::comma(sampah_Tahunan$Timbulan_Sampah[sampah_Tahunan$Tahun==input$slider])
  })
  
  output$VaueTerkelola<-renderUI({
    scales::comma(sampah_Tahunan$Sampah_Terkelola[sampah_Tahunan$Tahun==input$slider])
  })
  
  output$VaueRecycle<-renderUI({
    scales::comma(sampah_Tahunan$Recycling[sampah_Tahunan$Tahun==input$slider])
  })
  
  output$VaueTimbulanHarian<-renderUI({
    scales::comma(sampah_Tahunan$Timbulan_Harian_Ton[sampah_Tahunan$Tahun==input$slider])
  })
  
  output$VaueFasilitas<-renderUI({
    scales::comma(pengolah_Tahunan$Jumlah_Fasilitas[pengolah_Tahunan$Tahun==input$slider])
  })
  
  output$VaueBankS<-renderUI({
    scales::comma(Bank_sampah_Tahunan$Jumlah_Fasilitas[Bank_sampah_Tahunan$Tahun==input$slider])
  })
  
  output$provinsiSampah<-renderEcharts4r(
    
    sampah %>% group_by(Tahun, Provinsi) %>% 
      summarise(
        Timbulan_Sampah_Tahunan=sum(Timbulan_Sampah_Tahunan),
        Penanganan_Sampah_Tahunan=sum(Penanganan_Sampah_Tahunan),
        Recycle=sum(Recycling_Tahunan),
        tidak_ditangani=sum(Timbulan_Sampah_Tahunan)-sum(Penanganan_Sampah_Tahunan),
        tidak_Recycle=sum(Penanganan_Sampah_Tahunan)-sum(Recycling_Tahunan)
      ) %>% 
      ungroup() %>% 
      #pivot_longer(cols = c("tidak_ditangani", "tidak_Recycle","Recycle"), names_to = "Penanganan",values_to="Timbulan") %>%
      mutate(
        label1 = glue("Timbulan Sampah : {scales::comma(Timbulan_Sampah_Tahunan)} Ton/Tahun <br/>
                    Sampah tidak ditangani : {scales::comma(tidak_ditangani)} Ton/Tahun <br/>
                    {round(tidak_ditangani/Timbulan_Sampah_Tahunan*100,2)}%"),
        label2 = glue("Penanganan Sampah : {scales::comma(Penanganan_Sampah_Tahunan)} Ton/Tahun <br/>
                                    {round(Penanganan_Sampah_Tahunan/Timbulan_Sampah_Tahunan*100,2)}% <br/>
                    Tidak di recycle : {scales::comma(tidak_Recycle)} Ton/Tahun <br/>
                                    {round(tidak_Recycle/Penanganan_Sampah_Tahunan*100,2)}%"),
        label3 = glue("Recycle Sampah : {scales::comma(Recycle)} Ton/Tahun <br/>
                                    {round(Recycle/Timbulan_Sampah_Tahunan*100,2)}%"),
        tidak_Recycle=ifelse(tidak_Recycle < 0, 0, tidak_Recycle)
        
      ) %>% 
      filter(Tahun==input$slider) %>% 
      arrange(Timbulan_Sampah_Tahunan) %>% 
      e_charts(x = Provinsi) %>% 
      e_bar(
        Recycle, 
        name = "Recycled", 
        symbol = "none",
        stack="stack",
        bind=label3
      ) %>% 
      e_bar(
        tidak_Recycle, 
        name = "Penanganan Sampah", 
        symbol = "none",
        stack="stack",
        bind=label2
      ) %>% 
      e_bar(
        tidak_ditangani, 
        name = "Timbulan Sampah", 
        symbol = "none",
        stack="stack",
        bind=label1
      ) %>% 
      e_grid(containLabel = T) %>% 
      e_title(text = "Provinsi Penghasil Sampah Terbanyak",
              left = "center",
              top = "0") %>% 
      e_legend(F) %>%
      e_y_axis(axisLabel = list(
        interval = 0L
      )) %>% 
      e_flip_coords() %>%
      e_tooltip(formatter = htmlwidgets::JS("
                                        
                                        function(params)
                                        {
                                            return `<strong>Provinsi ${params.value[1]}</strong>
                                                     <br/>${echarts.format.addCommas(params.name)} `
                                        }
                                        ")) %>% 
      e_axis_labels(x = "(Ton/Tahun)")
    
  )
  
  output$table <- renderDataTable({
    datatable(pengolah_lat[pengolah_lat$Tahun==input$slider & pengolah_lat$Fasilitas_Group==v$data,c("Provinsi","KabupatenKota","Jumlah_Fasilitas","Sampahmasuk_TonThn", "Sampahterkelola_TonThn")],
              options = list(scrollX=T,
                             scrollY=T)
    )
    
  })
  
})
