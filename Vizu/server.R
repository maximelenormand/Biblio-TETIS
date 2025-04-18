# Import packages
library(RColorBrewer)

# Load data
load("Data.Rdata")

# Inputs
colotut = brewer.pal(7, "Accent")
colotut[4:5] = colotut[5:4]
coloteam = brewer.pal(3, "Set3")
cologrp = brewer.pal(7, "Pastel1")
coloing = brewer.pal(3, "Pastel2")
coloa1 =  c("#4682B4","#7DA7CA", "#448C3A", "#6DB966")
coloa2 =  c("#448C3A", "#6DB966","#CCE7C9")

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

# Server
shinyServer(function(input, output) {
  
  # Network GG #################################################################
  
  # Update end years
  observe({
    
      years <- years_gg
      start <- as.numeric(input$startgg)
      end <- as.numeric(input$endgg)
      
      updateSelectInput(session = getDefaultReactiveDomain(),
                        "startgg",
                        choices = years[1:as.numeric(which(years==end))],
                        selected = start)
      
      updateSelectInput(session = getDefaultReactiveDomain(),
                        "endgg",
                        choices = years[
                          as.numeric(which(years==start)):length(years)],
                        selected = end)
  })

  # Reactive to format the base network
  reacnetgg <- reactive({
    
    # Original inputs
    org_edges <- edges_gg
    org_nodes <- nodes_gg
    
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
  output$networkgg <- renderVisNetwork({
    visNetwork(reacnetgg()$nodes, reacnetgg()$edges) %>%
      visGroups(groupname = "Aucun", color = "#7DA7CA")
  })

  # Update network
  observe({
    
    # Proxy
    proxy <- visNetworkProxy("networkgg")
    
    # Inputs
    start <- as.numeric(input$startgg)
    end <- as.numeric(input$endgg)
    org_edges <- edges_gg
    org_nodes <- nodes_gg
    indexcit <- (as.numeric(input$cit)+1) 
    
    # Temporary nodes & edges
    ntemp <- reacnetgg()$nodes
    etemp <- reacnetgg()$edges[,-4]
    
    if(start==end){
      etemp$value <- org_edges[[indexcit]][,start]
    }else{
      etemp$value <- apply(org_edges[[indexcit]]
                           [,start:end],
                           1,sum)
    }

    # Update proxy
    visUpdateNodes(proxy, ntemp)
    visUpdateEdges(proxy, etemp)

    # Edge & Node to remove
    erem <- etemp$id[etemp$value < as.numeric(input$wgg)]
    etemp <- etemp[etemp$value >= as.numeric(input$wgg), ]

    nid <- c(etemp[, 2], etemp[, 3])
    nid <- nid[!duplicated(nid)]
    nrem <- setdiff(ntemp$id, nid)

    if (length(nrem) > 0) {
      visRemoveNodes(proxy, nrem)
    }
    visRemoveEdges(proxy, erem)

    # Aucun
    if (input$typgg == "Aucun") {
      
      ntemp$group <- rep("Aucun", dim(ntemp)[1])
      if (input$namegg) {
        ntemp$label <- reacnetgg()$name
      } else {
        ntemp$label <- ""
      }
      ntemp <- ntemp[match(nid, ntemp$id), ]

      visUpdateNodes(proxy, ntemp)

      proxy %>%
        visGroups(groupname = "Aucun", color = "#7DA7CA")
    }

    # Tutelle
    if (input$typgg == "Tutelle") {
      
      ntemp$group <- reacnetgg()$inst
      if (input$namegg) {
        ntemp$label <- reacnetgg()$name
      } else {
        ntemp$label <- ""
      }
      ntemp <- ntemp[match(nid, ntemp$id), ]

      visUpdateNodes(proxy, ntemp)

      proxy %>%
        visGroups(groupname = "APT", color = colotut[1]) %>%
        visGroups(groupname = "CIRAD", color = colotut[2]) %>%
        visGroups(groupname = "CIHEAM", color = colotut[3]) %>%
        visGroups(groupname = "CNRS", color = colotut[4]) %>%
        visGroups(groupname = "INRAE", color = colotut[5]) %>%
        visGroups(groupname = "INRIA", color = colotut[6]) %>%
        visGroups(groupname = "UPV", color = colotut[7]) 
    }
    
    # Equipe
    if (input$typgg == "Equipe") {
      
      ntemp$group <- reacnetgg()$team
      if (input$namegg) {
        ntemp$label <- reacnetgg()$name
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
    if (input$typgg == "Ad Hoc") {
      
      ntemp$group <- reacnetgg()$grp
      if (input$namegg) {
        ntemp$label <- reacnetgg()$name
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
    if (input$typgg == "Ingénierie") {
      
      ntemp$group <- reacnetgg()$ing
      if (input$namegg) {
        ntemp$label <- reacnetgg()$name
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
  output$legtutgg <- renderPlot({
    
      par(mar = c(0, 0, 0, 0))
      plot(1, type = "n", axes=FALSE, xlab="",ylab="n")
      legend("topleft", inset=c(0,0), 
             pch=16,
             pt.cex=3,
             col=colotut,
             legend=c("APT","CIRAD","CIHEAM","CNRS","INRAE","INRIA","UPV"), 
             bty="n", 
             cex=1.5, 
             xpd=TRUE)
    
  })

  output$legteamgg <- renderPlot({

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
  
  output$leggrpgg <- renderPlot({
    
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
  
  output$leginggg <- renderPlot({
    
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
  
  # Network HAL ################################################################
  
  # Update end years
  observe({
    
    years <- years_gg
    start <- as.numeric(input$startgg)
    end <- as.numeric(input$endgg)
    
    updateSelectInput(session = getDefaultReactiveDomain(),
                      "startgg",
                      choices = years[1:as.numeric(which(years==end))],
                      selected = start)
    
    updateSelectInput(session = getDefaultReactiveDomain(),
                      "endgg",
                      choices = years[
                        as.numeric(which(years==start)):length(years)],
                      selected = end)
  })
  
  # Reactive to format the base network
  reacnethal <- reactive({
    
    # Original inputs
    org_edges <- edges_hal
    org_nodes <- nodes_hal
    
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
  output$networkhal <- renderVisNetwork({
    visNetwork(reacnethal()$nodes, reacnethal()$edges) %>%
      visGroups(groupname = "Aucun", color = "#7DA7CA")
  })
  
  # Update network
  observe({
    
    # Proxy
    proxy <- visNetworkProxy("networkhal")
    
    # Inputs
    start <- as.numeric(input$starthal)
    end <- as.numeric(input$endhal)
    org_edges <- edges_hal
    org_nodes <- nodes_hal
    indexcit <- 1
    
    # Temporary nodes & edges
    ntemp <- reacnethal()$nodes
    etemp <- reacnethal()$edges[,-4]
    
    if(start==end){
      etemp$value <- org_edges[[indexcit]][,start]
    }else{
      etemp$value <- apply(org_edges[[indexcit]]
                           [,start:end],
                           1,sum)
    }
    
    # Update proxy
    visUpdateNodes(proxy, ntemp)
    visUpdateEdges(proxy, etemp)
    
    # Edge & Node to remove
    erem <- etemp$id[etemp$value < as.numeric(input$whal)]
    etemp <- etemp[etemp$value >= as.numeric(input$whal), ]
    
    nid <- c(etemp[, 2], etemp[, 3])
    nid <- nid[!duplicated(nid)]
    nrem <- setdiff(ntemp$id, nid)
    
    if (length(nrem) > 0) {
      visRemoveNodes(proxy, nrem)
    }
    visRemoveEdges(proxy, erem)
    
    # Aucun
    if (input$typhal == "Aucun") {
      
      ntemp$group <- rep("Aucun", dim(ntemp)[1])
      if (input$namehal) {
        ntemp$label <- reacnethal()$name
      } else {
        ntemp$label <- ""
      }
      ntemp <- ntemp[match(nid, ntemp$id), ]
      
      visUpdateNodes(proxy, ntemp)
      
      proxy %>%
        visGroups(groupname = "Aucun", color = "#7DA7CA")
    }
    
    # Tutelle
    if (input$typhal == "Tutelle") {
      
      ntemp$group <- reacnethal()$inst
      if (input$namehal) {
        ntemp$label <- reacnethal()$name
      } else {
        ntemp$label <- ""
      }
      ntemp <- ntemp[match(nid, ntemp$id), ]
      
      visUpdateNodes(proxy, ntemp)
      
      proxy %>%
        visGroups(groupname = "APT", color = colotut[1]) %>%
        visGroups(groupname = "CIRAD", color = colotut[2]) %>%
        visGroups(groupname = "CIHEAM", color = colotut[3]) %>%
        visGroups(groupname = "CNRS", color = colotut[4]) %>%
        visGroups(groupname = "INRAE", color = colotut[5]) %>%
        visGroups(groupname = "INRIA", color = colotut[6]) %>%
        visGroups(groupname = "UPV", color = colotut[7]) 
    }
    
    # Equipe
    if (input$typhal == "Equipe") {
      
      ntemp$group <- reacnethal()$team
      if (input$namehal) {
        ntemp$label <- reacnethal()$name
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
    if (input$typhal == "Ad Hoc") {
      
      ntemp$group <- reacnethal()$grp
      if (input$namehal) {
        ntemp$label <- reacnethal()$name
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
    if (input$typhal == "Ingénierie") {
      
      ntemp$group <- reacnethal()$ing
      if (input$namehal) {
        ntemp$label <- reacnethal()$name
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
  output$legtuthal <- renderPlot({
    
    par(mar = c(0, 0, 0, 0))
    plot(1, type = "n", axes=FALSE, xlab="",ylab="n")
    legend("topleft", inset=c(0,0), 
           pch=16,
           pt.cex=3,
           col=colotut,
           legend=c("APT","CIRAD","CIHEAM","CNRS","INRAE","INRIA","UPV"), 
           bty="n", 
           cex=1.5, 
           xpd=TRUE)
    
  })
  
  output$legteamhal <- renderPlot({
    
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
  
  output$leggrphal <- renderPlot({
    
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
  
  output$leginghal <- renderPlot({
    
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
      
      if(input$data1 =="GG"){
        
        a1 <- a1_gg
        
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
      
      if(input$data1 =="HAL"){
        
        a1 <- a1_hal
        
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
                cex.names = 1.25, names.arg = 2019:2024)
        axis(2, at=seq(0,160,20), las = 1, cex.axis = 1.25)
        mtext("Année", 1, line = 4, cex = 2.25)
        mtext(mtext2, 2, line = 4, cex = 2.25)
        
      }
    
  }
    
    # Analysis 2
    if(as.numeric(input$analysis) == 2){
      
      beside=input$a2beside
      
      if(input$data2 =="GG"){
        
        a2 <- a2_gg
        
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
      
      if(input$data2 =="HAL"){
        
        a2 <- a2_hal
        
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
                cex.names = 1.25, names.arg = 2019:2024)
        axis(2, at=seq(0,160,20), las = 1, cex.axis = 1.25)
        mtext("Année", 1, line = 4, cex = 2.25)
        mtext(mtext2, 2, line = 4, cex = 2.25)
        
      } 
      
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
