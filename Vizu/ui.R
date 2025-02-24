# Import packages
library(shinyWidgets)

# Source text for the "About" panel
tabPanelAbout <- source("About.R")$value

# Inputs
years=list(
  "2016" = 5, 
  "2017" = 6, 
  "2018" = 7, 
  "2019" = 8, 
  "2020" = 9, 
  "2021" = 10, 
  "2022" = 11, 
  "2023" = 12, 
  "2024" = 13
)

# UI
shinyUI(navbarPage(
  title = HTML('<span style="font-size:120%;color:white;font-weight:bold;">Bibliométrie TETIS &nbsp;&nbsp;</span></a>'),
  windowTitle = "Biblio TETIS",

  # Network ####################################################################
  tabPanel(
    HTML('<span style="font-size:100%;color:white;font-weight:bold;">Réseaux de copublications</span></a>'),
    div(
      class = "outer",

      # Include custom CSS & logo
      tags$head(
        includeCSS("styles.css"), tags$link(rel = "icon", type = "image/png", href = "logo.png")
      ),

      # Network
      visNetworkOutput("network", width = "100%", height = "100%"),

      absolutePanel( 
        id = "control", class = "panel panel-default", fixed = TRUE,
        draggable = FALSE, top = 80, left = "auto", right = 20, bottom = "auto",
        width = 350, height = "auto",
        h2("Explorateur"),
        
        selectInput(
          inputId = "start",
          label = strong("Année de début (incluse)"),
          choices = years,
          selected = 5
        ),
        
        selectInput(
          inputId = "end",
          label = strong("Année de fin (incluse)"),
          choices = years,
          selected = 13
        ),
        
        selectInput(
          inputId = "typ",
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
          condition = "input.typ == 'Tutelle'",
          HTML('<div style="font-weight:bold;"align="justified">Légende</div>'),
          plotOutput("legtut", height = 169)
        ),
        
        conditionalPanel(  
          condition = "input.typ == 'Equipe'",
          HTML('<div style="font-weight:bold;"align="justified">Légende</div>'),
          plotOutput("legteam", height = 108)
        ),
        
        conditionalPanel(  
          condition = "input.typ == 'Ad Hoc'",
          HTML('<div style="font-weight:bold;"align="justified">Légende</div>'),
          plotOutput("leggrp", height = 180)
        ),
        
        conditionalPanel(  
          condition = "input.typ == 'Ingénierie'",
          HTML('<div style="font-weight:bold;"align="justified">Légende</div>'),
          plotOutput("leging", height = 70)
        ),
        
        chooseSliderSkin("Flat", "#4682B4"),
        sliderInput(inputId="w", 
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
        
        checkboxInput("name", "Afficher les noms", value=FALSE)
        
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
