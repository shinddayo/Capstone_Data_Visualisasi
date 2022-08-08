
dashboardPage(
  skin="green",
  dashboardHeader(
    title="Sampah Di Indonesia"
  ),
  dashboardSidebar(
    sidebarMenu(
      sliderInput("slider", "Tahun:", 2018, 2021, 2021,sep = ""),
      menuItem("Overview", tabName = "overview", icon = icon("house")),
      menuItem("Fasilitas Pengolah Sampah", tabName = "fasilitas", icon = icon("dumpster-fire")),
      menuItem("About", tabName = "about", icon = icon("person"))
    )
    
  ),
  dashboardBody(
    
    tabItems(
      
      tabItem(
        tabName = "overview" ,
        fluidRow(
          
        ),
        fluidRow(
          valueBox("TIMBULAN SAMPAH PER TAHUN (TON)",
                   "maroon",
                  icon = icon("dumpster"), 
                    value = uiOutput(outputId= "VaueTimbulan")),#scales::comma(sampah_Tahunan$Timbulan_Sampah[sampah_Tahunan$Tahun==uiOutput("slider")])),
          valueBox("PENGOLAHAN SAMPAH PER TAHUN (TON)",
                   "yellow",
                  icon = icon("people-roof"), 
                  value= uiOutput(outputId= "VaueTerkelola")),
          valueBox("DAUR ULANG SAMPAH PER TAHUN (TON)",
                   "green",
                  icon = icon("recycle"),
                  value= uiOutput(outputId= "VaueRecycle")),
        ),
        fluidRow(
          valueBox("TIMBULAN SAMPAH PER HARI DALAM SETAHUNN (TON)",
                   "maroon",
                   icon = icon("dumpster"), 
                   value = uiOutput(outputId= "VaueTimbulanHarian")),
          valueBox("JUMLAH FASILITAS PENGELOLAH SAMPAH",
                   "olive",
                   icon = icon("dumpster"), 
                   value= uiOutput(outputId= "VaueFasilitas")),
          valueBox("JUMLAH BANK SAMPAH",
                   "light-blue",
                   icon = icon("bottle-water"),
                   value= uiOutput(outputId= "VaueBankS")),
        ),
        fluidRow(
          box(width=12,echarts4rOutput(outputId = "provinsiSampah"))
        ),
        fluidRow(
          box(width=6,echarts4rOutput(outputId = "JenisPlot")
              ),
          box(width=6,echarts4rOutput(outputId = "sumberPlot")
              )
          )
        )
      ,
      tabItem(
        tabName = "fasilitas" ,
        fluidRow(
          box(width = 12, title = "SEBARAN FASILITAS PENGELOLAAN SAMPAH", 
              HTML("
                   <p>Sebaran Fasilitas Pengelolaan Sampah adalah Sebaran fasilitas pengelolaan sampah untuk mengetahui lokasi TPA, TPS 3R, Bank Sampah, Rumah Kompos, Komposting Skala RTRW, dan lain-lain.
                   </p>
                   <b>Pilih Jenis Fasilitas Pengolah Sampah :</b><br>"), 
              actionButton(inputId = "BS", label="Bank Sampah" ) ,
              actionButton(inputId = "SE", label="Sumber Energi"), 
              actionButton(inputId = "TPS", label="TPS3R/PDU/ITF"), 
              actionButton(inputId = "KOM", label="Komposting"), 
              actionButton(inputId = "SI", label="Sektor Internal"), 
              actionButton(inputId = "TPA", label="TPA"),
              # actionButton(ns("actionbtn_1"), label = "Bank Sampah")
          ),
          box(#title = "Pesebaran Fasilitas Pengolahan Sampah",
            width=12,
            leafletOutput(outputId = "petaFasilitas")
          ),
          box(#title = "Pesebaran Fasilitas Pengolahan Sampah",
            width=12,
            DT::dataTableOutput(outputId = "table")
          )
          
        )
      ),
      tabItem(
        tabName = "about" 
        ,
        fluidPage(
          h1("Visualisasi Pengolahan Sampah Indonesia"),
          h5("By ", a("Shindy Listiani", href = "https://www.linkedin.com/in/shindy-listiani-40b273118/")),
          h2("Dataset"),
          p("Visualisasi ini dibuat dari data Sistem Informasi Pengolahan Sampah Nasional ", 
            a("(SIPSN)", href = "https://sipsn.menlhk.go.id/sipsn/public/data/timbulan")),
          h2("Library"),
          p("Several R library that used to create this visualization are:"),
          p("-  Tidyverse"),
          p("-  Shiny"),
          p("-  Shinydashboard"),
          p("-  Echarts4r"),
          p("-  leaflet"),
          h2("Code"),
          p("Berikut untuk melihat code visualisasi ini ", a("GitHub", href = "https://github.com/shinddayo/Capstone_Data_Visualisasi"))
        )
        
      )
    )
      
      
    )
    
    
  )
