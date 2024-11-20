# Packages
library(shiny)
library(visNetwork)
library(RColorBrewer)

# Load data
load("Data.Rdata")
org_edges <- edges
org_nodes <- nodes
a1 <- a1

# Inputs
colotut = brewer.pal(6, "Accent")
coloteam = brewer.pal(3, "Set3")
cologrp = brewer.pal(7, "Pastel1")
coloing = brewer.pal(3, "Pastel2")
coloa1 =  c("#4682B4","#7DA7CA", "#448C3A", "#6DB966")
coloa2 =  c("#448C3A", "#6DB966","#CCE7C9")

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

# Server
shinyServer(function(input, output) {
  
  # Network ####################################################################
  
  # Update end years
  observe({
    
    start <- as.numeric(input$start)
    end <- as.numeric(input$end)
    
    updateSelectInput(session = getDefaultReactiveDomain(),
                      "start", 
                      choices = years[1:as.numeric(which(years==end))],
                      selected = start)
    
    updateSelectInput(session = getDefaultReactiveDomain(),
                      "end", 
                      choices = years[
                        as.numeric(which(years==start)):length(years)],
                      selected = end)
    
  })

  # Reactive to format the base network
  reacnet <- reactive({
    
    # Edges
    edges <- org_edges[[1]][,c(1,2,3)]
    edges$value <- apply(org_edges[[1]][,-c(1,2,3)],1,sum)
    
    # Nodes
    nodes <- org_nodes
    name <- org_nodes[,2]
    inst <- nodes[,3]
    team <- nodes[,4]
    grp <- nodes[,5]
    ing <- nodes[,6]
    nodes <- data.frame(id = nodes[, 1], group = rep("Aucun", dim(nodes)[1]))
    
    # Output
    res <- list(nodes = nodes, 
                edges = edges, 
                name = name,
                inst = inst, 
                team = team, 
                grp = grp,
                ing = ing)

  })

  # Base network
  output$network <- renderVisNetwork({
    visNetwork(reacnet()$nodes, reacnet()$edges) %>%
      visGroups(groupname = "Aucun", color = "#7DA7CA")
  })

  # Update network
  observe({
    
    # Proxy
    proxy <- visNetworkProxy("network")
    
    # Temporal windows
    start <- as.numeric(input$start)
    end <- as.numeric(input$end)
    
    # Temporary nodes & edges
    ntemp <- reacnet()$nodes
    etemp <- reacnet()$edges[,-4]
    if(start==end){
      etemp$value <- org_edges[[(as.numeric(input$cit)+1)]][,start]
    }else{
      etemp$value <- apply(org_edges[[(as.numeric(input$cit)+1)]]
                           [,start:end],
                           1,sum)
    }

    # Update proxy
    visUpdateNodes(proxy, ntemp)
    visUpdateEdges(proxy, etemp)

    # Edge & Node to remove
    erem <- etemp$id[etemp$value < as.numeric(input$w)]
    etemp <- etemp[etemp$value >= as.numeric(input$w), ]

    nid <- c(etemp[, 2], etemp[, 3])
    nid <- nid[!duplicated(nid)]
    nrem <- setdiff(ntemp$id, nid)

    if (length(nrem) > 0) {
      visRemoveNodes(proxy, nrem)
    }
    visRemoveEdges(proxy, erem)

    # Aucun
    if (input$typ == "Aucun") {
      
      ntemp$group <- rep("Aucun", dim(ntemp)[1])
      if (input$name) {
        ntemp$label <- reacnet()$name
      } else {
        ntemp$label <- ""
      }
      ntemp <- ntemp[match(nid, ntemp$id), ]

      visUpdateNodes(proxy, ntemp)

      proxy %>%
        visGroups(groupname = "Aucun", color = "#7DA7CA")
    }

    # Tutelle
    if (input$typ == "Tutelle") {
      
      ntemp$group <- reacnet()$inst
      if (input$name) {
        ntemp$label <- reacnet()$name
      } else {
        ntemp$label <- ""
      }
      ntemp <- ntemp[match(nid, ntemp$id), ]

      visUpdateNodes(proxy, ntemp)

      proxy %>%
        visGroups(groupname = "APT", color = colotut[1]) %>%
        visGroups(groupname = "CIRAD", color = colotut[2]) %>%
        visGroups(groupname = "CNRS", color = colotut[3]) %>%
        visGroups(groupname = "INRAE", color = colotut[4]) %>%
        visGroups(groupname = "INRIA", color = colotut[5]) %>%
        visGroups(groupname = "UPV", color = colotut[6]) 
    }
    
    # Equipe
    if (input$typ == "Equipe") {
      
      ntemp$group <- reacnet()$team
      if (input$name) {
        ntemp$label <- reacnet()$name
      } else {
        ntemp$label <- ""
      }
      ntemp <- ntemp[match(nid, ntemp$id), ]
      
      visUpdateNodes(proxy, ntemp)
      
      proxy %>%
        visGroups(groupname = "ATTOS", color = coloteam[1]) %>%
        visGroups(groupname = "MISCA", color = coloteam[2]) %>%
        visGroups(groupname = "USIG", color = coloteam[3]) 
    }
    
    # Groupe
    if (input$typ == "Ad Hoc") {
      
      ntemp$group <- reacnet()$grp
      if (input$name) {
        ntemp$label <- reacnet()$name
      } else {
        ntemp$label <- ""
      }
      ntemp <- ntemp[match(nid, ntemp$id), ]
      
      visUpdateNodes(proxy, ntemp)
      
      proxy %>%
        visGroups(groupname = "Biodiv", color = cologrp[1]) %>%
        visGroups(groupname = "Données", color = cologrp[2]) %>%
        visGroups(groupname = "Santé", color = cologrp[3]) %>%
        visGroups(groupname = "MDL4EO", color = cologrp[4]) %>%
        visGroups(groupname = "Sécurité", color = cologrp[5]) %>%
        visGroups(groupname = "Territoires", color = cologrp[6]) %>%
        visGroups(groupname = "Autre", color = cologrp[7])
    }
    
    # Ingénierie
    if (input$typ == "Ingénierie") {
      
      ntemp$group <- reacnet()$ing
      if (input$name) {
        ntemp$label <- reacnet()$name
      } else {
        ntemp$label <- ""
      }
      ntemp <- ntemp[match(nid, ntemp$id), ]
      
      visUpdateNodes(proxy, ntemp)
      
      proxy %>%
        visGroups(groupname = "Oui", color = coloing[1]) %>%
        visGroups(groupname = "Non", color = coloing[2]) 
    }
    
  })
  
  # Legend
  output$legtut <- renderPlot({
    
      par(mar = c(0, 0, 0, 0))
      plot(1, type = "n", axes=FALSE, xlab="",ylab="n")
      legend("topleft", inset=c(0,0), 
             pch=16,
             pt.cex=3,
             col=colotut,
             legend=c("APT","CIRAD","CNRS","INRAE","INRIA","UPV"), 
             bty="n", 
             cex=1.5, 
             xpd=TRUE)
    
  })

  output$legteam <- renderPlot({

      par(mar = c(0, 0, 0, 0))
      plot(1, type = "n", axes=FALSE, xlab="",ylab="n")
      legend("topleft", inset=c(0,0),
             pch=16,
             pt.cex=3,
             col=coloteam,
             legend=c("ATTOS","MISCA","USIG"),
             bty="n",
             cex=1.5,
             xpd=TRUE)

  })
  
  output$leggrp <- renderPlot({
    
        par(mar = c(0, 0, 0, 0))
        plot(1, type = "n", axes=FALSE, xlab="",ylab="n")
        legend("topleft", inset=c(0,0),
               pch=16,
               pt.cex=3,
               col=cologrp,
               legend=c("BiodiverSE",
                        "Données Hétérogènes",
                        "Santé",
                        "MDL4OE",
                        "Sécurité Alimentaire",
                        "Territoires",
                        "Autre"),
               bty="n",
               cex=1.5,
               xpd=TRUE)
    
  })
  
  output$leging <- renderPlot({
    
    par(mar = c(0, 0, 0, 0))
    plot(1, type = "n", axes=FALSE, xlab="",ylab="n")
    legend("topleft", inset=c(0,0),
           pch=16,
           pt.cex=3,
           col=coloing,
           legend=c("Oui",
                    "Non"),
           bty="n",
           cex=1.5,
           xpd=TRUE)
    
    
  })
  
  # Analysis ###################################################################
  output$plotanalysis <- renderPlot({
    
    # Analysis 1
    if(as.numeric(input$analysis) == 1){
      
      beside=input$a1beside
      
      maxylim = 160
      tab=t(a1[,-c(1,2)])
      mtext2="#Publications"
      if(input$a1prop){
        maxylim = 100
        tab=100*t(t(tab)/apply(tab,2,sum))
        mtext2="%Publications"
      }
    
      par(mar = c(7, 7, 4, 2))
      barplot(tab, col=coloa1, border=NA, ylim = c(0,maxylim), beside=beside,
              axes=FALSE, xlab = "", ylab = "", las = 1, 
              cex.names = 1.25, names.arg = 2016:2023)
      axis(2, at=seq(0,160,20), las = 1, cex.axis = 1.25)
      mtext("Année", 1, line = 4, cex = 2.25)
      mtext(mtext2, 2, line = 4, cex = 2.25)
      
    }
    
    # Analysis 2
    if(as.numeric(input$analysis) == 2){
      
      beside=input$a2beside
      
      if(as.numeric(input$a2type) == 1){
        tab=t(a2[,2:4])
      }
      if(as.numeric(input$a2type) == 2){
        tab=t(a2[,5:7])
      }
      
      maxylim = 60
      mtext2="#Publications"
      if(input$a2prop){
        maxylim = 100
        tab=100*t(t(tab)/apply(tab,2,sum))
        mtext2="%Publications"
      }
      
      par(mar = c(7, 7, 4, 2))
      barplot(tab, col=coloa2, border=NA, ylim = c(0,maxylim), beside=beside,
              axes=FALSE, xlab = "", ylab = "", las = 1, 
              cex.names = 1.25, names.arg = 2016:2023)
      axis(2, at=seq(0,160,20), las = 1, cex.axis = 1.25)
      mtext("Année", 1, line = 4, cex = 2.25)
      mtext(mtext2, 2, line = 4, cex = 2.25)
      
    }
    
  })
  
  # Legplotanalysis
  output$legplotanalysis1 <- renderPlot({
      
      par(mar = c(0, 0, 0, 0))
      plot(1, type="n", axes= FALSE)
      legend("bottomright",inset=c(-0.0,-0.035),
             legend=c("TETIS = 1 & Externe = 0",
                      "TETIS = 1 & Externe > 0",
                      "TETIS > 1 & Externe = 0",
                      "TETIS > 1 & Externe > 0"),
             fill=coloa1,
             border=NA,
             bty="n",cex=2,xpd=TRUE)  
      
  })
  
  output$legplotanalysis21 <- renderPlot({
    
        par(mar = c(0, 0, 0, 0))
        plot(1, type="n", axes= FALSE)
        legend("bottomright",inset=c(-0.0,-0.035),
               legend=c("1 équipe",
                        "2 équipes",
                        "3 équipes"),
               fill=coloa2,
               border=NA,
               bty="n",cex=2,xpd=TRUE)  
        
  })
  
  output$legplotanalysis22 <- renderPlot({
        
        par(mar = c(0, 0, 0, 0))
        plot(1, type="n", axes= FALSE)
        legend("bottomright",inset=c(-0.0,-0.035),
               legend=c("1 tutelle",
                        "2 tutelles",
                        "3+ tutelles"),
               fill=coloa2,
               border=NA,
               bty="n",cex=2,xpd=TRUE)  
        
    
  })
  
  # Legplot
  output$legplot1 <- renderUI({
    
      absolutePanel( 
        id = "control1", class = "panel panel-default", fixed = TRUE,
        draggable = FALSE, top = "auto", left = 20, right = "auto", bottom = 20,
        width = "auto", height = "auto",
        
        plotOutput("legplotanalysis1", width = "330px", height = "135px"),
        
      )
      
  })
  
  output$legplot21 <- renderUI({
      
      absolutePanel( 
        id = "control1", class = "panel panel-default", fixed = TRUE,
        draggable = FALSE, top = "auto", left = 20, right = "auto", bottom = 20,
        width = "auto", height = "auto",
        
        plotOutput("legplotanalysis21", width = "170px", height = "103px"),
        
      )
    
  })
  
  output$legplot22 <- renderUI({
    
      absolutePanel( 
        id = "control1", class = "panel panel-default", fixed = TRUE,
        draggable = FALSE, top = "auto", left = 20, right = "auto", bottom = 20,
        width = "auto", height = "auto",
        
        plotOutput("legplotanalysis22", width = "175px", height = "103px"),
        
      )
    
  })
  
  # Leganalysis
  output$leganalysis1 <- renderUI({
    
      absolutePanel( 
        id = "control2", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = "auto", left = "auto", right = 20, bottom = 20,
        width = 500, height = 220,
        
        HTML('<div style="font-size:20px;font-style:italic;"align="justified">
           
On observe ici le nombre de publications par année, ventilé en 
fonction du nombre de permanent·e·s TETIS et d&#39;externes ayant cosigné la 
publication. Ce point pourrait être amélioré, mais il est important de 
noter que tous les auteur·rice·s non-permanent·e·s de TETIS sont considéré·e·s 
comme externes, ce qui inclut les doctorant·e·s et les CDDs.
           
           </div>')
        
      )
      
  })
  
  output$leganalysis2 <- renderUI({
    
    absolutePanel( 
      id = "control2", class = "panel panel-default", fixed = TRUE,
      draggable = TRUE, top = "auto", left = "auto", right = 20, bottom = 20,
      width = 500, height = 133,
      
      HTML('<div style="font-size:20px;font-style:italic;"align="justified">
           
On observe ici le nombre de publications par année cosignées par au moins deux 
permanent·e·s TETIS, ventilé en fonction du nombre d&#39;équipes ou de tutelles 
représentées.
           
           </div>')
      
    )
    
  })
  
  
})
