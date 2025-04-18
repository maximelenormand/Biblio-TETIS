# Import packages
library(shinyWidgets)

# Source text for the "About" panel
tabPanelAbout <- source("About.R")$value

# Inputs
years_gg <- list(
  "2016" = 4, 
  "2017" = 5, 
  "2018" = 6, 
  "2019" = 7, 
  "2020" = 8, 
  "2021" = 9, 
  "2022" = 10, 
  "2023" = 11
)

years_hal <- list(
  "2019" = 4, 
  "2020" = 5, 
  "2021" = 6, 
  "2022" = 7, 
  "2023" = 8,
  "2024" = 9
)

# UI
shinyUI(navbarPage(
  title = HTML('<span style="font-size:120%;color:white;font-weight:bold;">Bibliométrie TETIS &nbsp;&nbsp;</span></a>'),
  windowTitle = "Biblio TETIS",

  # Network GG #################################################################
  tabPanel(
    HTML('<span style="font-size:100%;color:white;font-weight:bold;">Réseaux de copublications (Google Scholar)</span></a>'),
    div(
      class = "outer",

      # Include custom CSS & logo
      tags$head(
        includeCSS("styles.css"), tags$link(rel = "icon", type = "image/png", href = "logo.png")
      ),

      # Network
      visNetworkOutput("networkgg", width = "100%", height = "100%"),

      absolutePanel( 
        id = "control", class = "panel panel-default", fixed = TRUE,
        draggable = FALSE, top = 80, left = "auto", right = 20, bottom = "auto",
        width = 350, height = "auto",
        h2("Explorateur"),
        
        selectInput(
            inputId = "startgg",
            label = strong("Année de début (incluse)"),
            choices = years_gg,
            selected = 4
        ),
        
        selectInput(
          inputId = "endgg",
          label = strong("Année de fin (incluse)"),
          choices = years_gg,
          selected = 11
        ),
        
        selectInput(
          inputId = "typgg",
          label = strong("Groupe"),
          choices = list(
            "Aucun" = "Aucun", 
            "Tutelle" = "Tutelle", 
            "Equipe" = "Equipe", 
            "Ad Hoc" = "Ad Hoc",
            "Ingénierie" = "Ingénierie"
          ),
          selected = "Aucun"
        ),
        
        conditionalPanel(  
          condition = "input.typgg == 'Tutelle'",
          HTML('<div style="font-weight:bold;"align="justified">Légende</div>'),
          plotOutput("legtutgg", height = 173)
        ),
        
        conditionalPanel(  
          condition = "input.typgg == 'Equipe'",
          HTML('<div style="font-weight:bold;"align="justified">Légende</div>'),
          plotOutput("legteamgg", height = 108)
        ),
        
        conditionalPanel(  
          condition = "input.typgg == 'Ad Hoc'",
          HTML('<div style="font-weight:bold;"align="justified">Légende</div>'),
          plotOutput("leggrpgg", height = 180)
        ),
        
        conditionalPanel(  
          condition = "input.typgg == 'Ingénierie'",
          HTML('<div style="font-weight:bold;"align="justified">Légende</div>'),
          plotOutput("leginggg", height = 70)
        ),
        
        chooseSliderSkin("Flat", "#4682B4"),
        sliderInput(inputId="wgg", 
                    label="Nombre minimal de publications", 
                    value=1, 
                    min = 1, 
                    max = 10, 
                    step = 1),
        
        chooseSliderSkin("Flat", "#4682B4"),  
        sliderInput(inputId="cit", 
                    label="Nombre minimal de citations", 
                    value=0, 
                    min = 0, 
                    max = 10, 
                    step = 1),
        
        checkboxInput("namegg", "Afficher les noms", value=FALSE)
        
      ),
      
    ),
    
    # SK8 footer
    div(
      class="footer",
      includeHTML("footer.html")
    )
  ),

  # Network GG #################################################################
  tabPanel(
    HTML('<span style="font-size:100%;color:white;font-weight:bold;">Réseaux de copublications (Hal/Agritrop)</span></a>'),
    div(
      class = "outer",
      
      # Include custom CSS & logo
      tags$head(
        includeCSS("styles.css"), tags$link(rel = "icon", type = "image/png", href = "logo.png")
      ),
      
      # Network
      visNetworkOutput("networkhal", width = "100%", height = "100%"),
      
      absolutePanel( 
        id = "control", class = "panel panel-default", fixed = TRUE,
        draggable = FALSE, top = 80, left = "auto", right = 20, bottom = "auto",
        width = 350, height = "auto",
        h2("Explorateur"),
        
        selectInput(
          inputId = "starthal",
          label = strong("Année de début (incluse)"),
          choices = years_hal,
          selected = 4
        ),
        
        selectInput(
          inputId = "endhal",
          label = strong("Année de fin (incluse)"),
          choices = years_hal,
          selected = 9
        ),
        
        selectInput(
          inputId = "typhal",
          label = strong("Groupe"),
          choices = list(
            "Aucun" = "Aucun", 
            "Tutelle" = "Tutelle", 
            "Equipe" = "Equipe", 
            "Ad Hoc" = "Ad Hoc",
            "Ingénierie" = "Ingénierie"
          ),
          selected = "Aucun"
        ),
        
        conditionalPanel(  
          condition = "input.typhal == 'Tutelle'",
          HTML('<div style="font-weight:bold;"align="justified">Légende</div>'),
          plotOutput("legtuthal", height = 173)
        ),
        
        conditionalPanel(  
          condition = "input.typhal == 'Equipe'",
          HTML('<div style="font-weight:bold;"align="justified">Légende</div>'),
          plotOutput("legteamhal", height = 108)
        ),
        
        conditionalPanel(  
          condition = "input.typhal == 'Ad Hoc'",
          HTML('<div style="font-weight:bold;"align="justified">Légende</div>'),
          plotOutput("leggrphal", height = 180)
        ),
        
        conditionalPanel(  
          condition = "input.typhal == 'Ingénierie'",
          HTML('<div style="font-weight:bold;"align="justified">Légende</div>'),
          plotOutput("leginghal", height = 70)
        ),
        
        chooseSliderSkin("Flat", "#4682B4"),
        sliderInput(inputId="whal", 
                    label="Nombre minimal de publications", 
                    value=1, 
                    min = 1, 
                    max = 10, 
                    step = 1),
        
        checkboxInput("namehal", "Afficher les noms", value=FALSE)
        
      ),
      
    ),
    
    # SK8 footer
    div(
      class="footer",
      includeHTML("footer.html")
    )
  ),
  
  # Analysis ###################################################################
  tabPanel(
    HTML('<span style="font-size:100%;color:white;font-weight:bold;">Analyses</span></a>'),
    div(
      class = "outer",
      
      # Include custom CSS & logo
      tags$head(
        includeCSS("styles.css"), tags$link(rel = "icon", type = "image/png", href = "logo.png")
      ),
      
      # Analysis
      plotOutput("plotanalysis", width = "1200px", height = "600px"),
      
      absolutePanel( 
        id = "control", class = "panel panel-default", fixed = TRUE,
        draggable = FALSE, top = 80, left = "auto", right = 20, bottom = "auto",
        width = 350, height = "auto",
        h2("Explorateur"),
        
        selectInput(
          inputId = "analysis",
          label = strong("Analyse"),
          choices=list("Analyse 1" = 1,
                       "Analyse 2" = 2),
          selected = 1
        ),
        
        # Analysis 1
        conditionalPanel(
          condition = "input.analysis == 1",
          selectInput(
            inputId = "data1",
            label = strong("Source de données"),
            choices=list("Google Scholar" = "GG",
                         "Hal/Agritrop" = "HAL"),
            selected = 1
          ),
          strong("Options"),
          checkboxInput("a1beside", "Bars côte-à-côte", value=FALSE),
          checkboxInput("a1prop", "Pourcentage", value=FALSE),
          uiOutput("legplot1"),
          uiOutput("leganalysis1")
        ),
        
        # Analysis 2
        conditionalPanel(
          condition = "input.analysis == 2",
          selectInput(
            inputId = "data2",
            label = strong("Source de données"),
            choices=list("Google Scholar" = "GG",
                         "Hal/Agritrop" = "HAL"),
            selected = 1
          ),
          selectInput(
            inputId = "a2type",
            label = strong("Options"),
            choices=list("Equipe" = 1,
                         "Tutelle" = 2),
            selected = 1
          ),
          checkboxInput("a2beside", "Bars côte-à-côte", value=FALSE),
          checkboxInput("a2prop", "Pourcentage", value=FALSE),
          uiOutput("legplot2"),
          uiOutput("leganalysis2"),
          conditionalPanel(
            condition = "input.a2type == 1",
            uiOutput("legplot21")
          ),
          
          conditionalPanel(
            condition = "input.a2type == 2",
            uiOutput("legplot22")
          )   
        ),
        
     
      ),
      
    ),
    
    # SK8 footer
    div(
      class="footer",
      includeHTML("footer.html")
    )
  ),
  
  ## About ----------------------------------------------------------------------
  tabPanelAbout()
  
))
