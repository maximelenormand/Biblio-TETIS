# Import packages
library(DescTools)

# Working directory
#setwd()

# Load data
org_edges_gg <- read.csv2("Networks/GG/edges.csv")
org_edges_gg <- org_edges_gg[org_edges_gg$Year > 2015 &
                             org_edges_gg$Year < 2024,]
org_edges_hal <- read.csv2("Networks/HAL/edges.csv")
org_nodes <- read.csv2("Networks/GG/nodes.csv")

# Extract GG publication matrix
org_edges <- org_edges_gg
id <- paste(org_edges[,5],
            org_edges[,3],
            org_edges[,4],
            org_edges[,6],
            org_edges[,7],
            sep="_")
from <- org_edges[,1]
to <- org_edges[,2]
from_ist <- org_nodes[match(from,org_nodes[,1]),3]
to_ist <- org_nodes[match(to,org_nodes[,1]),3]
to_ist[is.na(to_ist)] <- to[is.na(to_ist)]
from_tea <- org_nodes[match(from,org_nodes[,1]),4]
to_tea <- org_nodes[match(to,org_nodes[,1]),4]
to_tea[is.na(to_tea)] <- to[is.na(to_tea)]

mat <- rbind(cbind(id,from_ist),
             cbind(id,to_ist),
             cbind(id,from_tea),
             cbind(id,from_tea))
mat <- aggregate(mat[,1], list(mat[,1],mat[,2]), length)
colnames(mat) <- c("ID","Type","W")
mat <- as.matrix.xtabs(xtabs(W ~ ID + Type, mat))
mat[mat>0] <- 1
mat <- data.frame(do.call(rbind,strsplit(rownames(mat), "_")),
                  mat[,c(1,3,4,5,6,7,9,2,8,10)])
rownames(mat) <- 1:dim(mat)[1]
colnames(mat)[1:5] <- c("ID","Years","NbCits","NbTETIS","NbExt")
for(k in 1:dim(mat)[2]){
  mat[,k] <- as.numeric(mat[,k])
}
mat <- mat[order(mat[,1]),]

dupl_gg <- mat[,1][duplicated(apply(mat[,-1], 1, paste, collapse = "_"))] # Identify duplicated publications
mat_gg <- mat[!duplicated(apply(mat[,-1], 1, paste, collapse = "_")),] # Remove duplicated publications

# Extract HAL publication matrix
org_edges <- org_edges_hal
id <- paste(org_edges[,5],
            org_edges[,3],
            org_edges[,4],
            org_edges[,6],
            org_edges[,7],
            sep="_")
from <- org_edges[,1]
to <- org_edges[,2]
from_ist <- org_nodes[match(from,org_nodes[,1]),3]
to_ist <- org_nodes[match(to,org_nodes[,1]),3]
to_ist[is.na(to_ist)] <- to[is.na(to_ist)]
from_tea <- org_nodes[match(from,org_nodes[,1]),4]
to_tea <- org_nodes[match(to,org_nodes[,1]),4]
to_tea[is.na(to_tea)] <- to[is.na(to_tea)]

mat <- rbind(cbind(id,from_ist),
             cbind(id,to_ist),
             cbind(id,from_tea),
             cbind(id,from_tea))
mat <- aggregate(mat[,1], list(mat[,1],mat[,2]), length)
colnames(mat) <- c("ID","Type","W")
mat <- as.matrix.xtabs(xtabs(W ~ ID + Type, mat))
mat[mat>0] <- 1
mat <- data.frame(do.call(rbind,strsplit(rownames(mat), "_")),
                  mat[,c(1,3,4,5,6,7,9,2,8,10)])
rownames(mat) <- 1:dim(mat)[1]
colnames(mat)[1:5] <- c("ID","Years","NbCits","NbTETIS","NbExt")
for(k in 1:dim(mat)[2]){
  mat[,k] <- as.numeric(mat[,k])
}
mat_hal <- mat[order(mat[,1]),]

# Extract stats for Analysis 1
mat <- mat_gg
cond1 = mat$NbTETIS==1 & mat$NbExt==0
cond2 = mat$NbTETIS==1 & mat$NbExt>0
cond3 = mat$NbTETIS>1 & mat$NbExt==0
cond4 = mat$NbTETIS>1 & mat$NbExt>0

a1 <- cbind(aggregate(mat$Years, list(mat$Years), length),
            aggregate(mat$Years[cond1], list(mat$Years[cond1]), length),
            aggregate(mat$Years[cond2], list(mat$Years[cond2]), length),
            aggregate(mat$Years[cond3], list(mat$Years[cond3]), length),
            aggregate(mat$Years[cond4], list(mat$Years[cond4]), length))
a1 <- a1[,-c(3,5,7,9)]
colnames(a1) <- c("Year","All","1woE","1wE","2+woE","2+wE")
a1_gg <- a1

mat <- mat_hal
cond1 = mat$NbTETIS==1 & mat$NbExt==0
cond2 = mat$NbTETIS==1 & mat$NbExt>0
cond3 = mat$NbTETIS>1 & mat$NbExt==0
cond4 = mat$NbTETIS>1 & mat$NbExt>0

a1 <- cbind(aggregate(mat$Years, list(mat$Years), length),
            aggregate(mat$Years[cond1], list(mat$Years[cond1]), length),
            aggregate(mat$Years[cond2], list(mat$Years[cond2]), length),
            aggregate(mat$Years[cond3], list(mat$Years[cond3]), length),
            aggregate(mat$Years[cond4], list(mat$Years[cond4]), length))
a1 <- a1[,-c(3,5,7,9)]
colnames(a1) <- c("Year","All","1woE","1wE","2+woE","2+wE")
a1_hal <- a1

# Extract stats for Analysis 2
mat <- mat_gg
cond1 = mat$NbTETIS>1 & apply(mat[,13:15],1,sum)==1
cond2 = mat$NbTETIS>1 & apply(mat[,13:15],1,sum)==2
cond3 = mat$NbTETIS>1 & apply(mat[,13:15],1,sum)==3
cond4 = mat$NbTETIS>1 & apply(mat[,6:12],1,sum)==1
cond5 = mat$NbTETIS>1 & apply(mat[,6:12],1,sum)==2
cond6 = mat$NbTETIS>1 & apply(mat[,6:12],1,sum)>=3

a2 = merge(aggregate(mat$Years[cond1], list(mat$Years[cond1]), length),
           aggregate(mat$Years[cond2], list(mat$Years[cond2]), length),
           by="Group.1",all=TRUE)
a2 = merge(a2,
           aggregate(mat$Years[cond3], list(mat$Years[cond3]), length),
           by="Group.1",all=TRUE)
a2 = merge(a2,
           aggregate(mat$Years[cond4], list(mat$Years[cond4]), length),
           by="Group.1",all=TRUE)
a2 = merge(a2,
           aggregate(mat$Years[cond5], list(mat$Years[cond5]), length),
           by="Group.1",all=TRUE)
a2 = merge(a2,
           aggregate(mat$Years[cond6], list(mat$Years[cond6]), length),
           by="Group.1",all=TRUE)
a2[is.na(a2)]=0
colnames(a2) <- c("Year","E1","E2","E3","T1","T2","T3+")
a2_gg <- a2

mat <- mat_hal
cond1 = mat$NbTETIS>1 & apply(mat[,13:15],1,sum)==1
cond2 = mat$NbTETIS>1 & apply(mat[,13:15],1,sum)==2
cond3 = mat$NbTETIS>1 & apply(mat[,13:15],1,sum)==3
cond4 = mat$NbTETIS>1 & apply(mat[,6:12],1,sum)==1
cond5 = mat$NbTETIS>1 & apply(mat[,6:12],1,sum)==2
cond6 = mat$NbTETIS>1 & apply(mat[,6:12],1,sum)>=3

a2 = merge(aggregate(mat$Years[cond1], list(mat$Years[cond1]), length),
           aggregate(mat$Years[cond2], list(mat$Years[cond2]), length),
           by="Group.1",all=TRUE)
a2 = merge(a2,
           aggregate(mat$Years[cond3], list(mat$Years[cond3]), length),
           by="Group.1",all=TRUE)
a2 = merge(a2,
           aggregate(mat$Years[cond4], list(mat$Years[cond4]), length),
           by="Group.1",all=TRUE)
a2 = merge(a2,
           aggregate(mat$Years[cond5], list(mat$Years[cond5]), length),
           by="Group.1",all=TRUE)
a2 = merge(a2,
           aggregate(mat$Years[cond6], list(mat$Years[cond6]), length),
           by="Group.1",all=TRUE)
a2[is.na(a2)]=0
colnames(a2) <- c("Year","E1","E2","E3","T1","T2","T3+")
a2_hal <- a2

# Extract nodes & edges GG
org_edges <- org_edges_gg
org_edges <- org_edges[is.na(match(org_edges$Publication_ID, dupl_gg)),]

edges <- list()
length(edges) <- length(table(org_edges$Year))
minyear <- min(org_edges$Year)
maxyear <- max(org_edges$Year)

temp <- org_edges[org_edges[,2]!="zzext" & org_edges[,2]!="zzself",c(1,2,3)]
temp <- aggregate(temp[,3], list(temp[,1],temp[,2],temp[,3]), length)
colnames(temp) <- c("Nom1","Nom2","Year","NbPub")
id <- paste0(temp[,1], "_", temp[,2])
year <- temp[,3]
npub <- temp[,4]
tab <- as.matrix.xtabs(xtabs(npub ~ id + year))
id <- do.call(rbind,strsplit(rownames(tab), "_"))
tab <- data.frame(id=1:dim(tab)[1], 
                  from=id[,1],
                  to=id[,2],
                  tab)
rownames(tab) <- 1:dim(tab)[1]
colnames(tab)[-c(1,2,3)] <- seq(minyear,maxyear,1)
edges[[1]] <- tab
temp[,4] <- 0

for(k in 1:10){
  
  tempk <- org_edges[org_edges[,2]!="zzext" & org_edges[,2]!="zzself",c(1,2,3,4)]
  tempk <- tempk[tempk[,4]>=k, c(1,2,3)]
  tempk <- aggregate(tempk[,3], list(tempk[,1],tempk[,2],tempk[,3]), length)
  colnames(tempk) <- c("Nom1","Nom2","Year","NbPub")
  tempk <- rbind(tempk,temp)
  id <- paste0(tempk[,1], "_", tempk[,2])
  year <- tempk[,3]
  npub <- tempk[,4]
  tab <- as.matrix.xtabs(xtabs(npub ~ id + year))
  id <- do.call(rbind,strsplit(rownames(tab), "_"))
  tab <- data.frame(id=1:dim(tab)[1], 
                    from=id[,1],
                    to=id[,2],tab)
  rownames(tab) <- 1:dim(tab)[1]
  colnames(tab)[-c(1,2,3)] <- seq(minyear,maxyear,1)
  edges[[(k+1)]] <- tab
  
}

edges_gg <- edges

nodes <- c(temp[, 1], temp[, 2])
nodes <- sort(nodes[!duplicated(nodes)])
nodes <- org_nodes[match(nodes, org_nodes[, 1]),]
nodes_gg <- nodes

# Extract nodes & edges HAL
org_edges <- org_edges_hal

minyear <- min(org_edges$Year)
maxyear <- max(org_edges$Year)

temp <- org_edges[org_edges[,2]!="zzext" & org_edges[,2]!="zzself",c(1,2,3)]
temp <- aggregate(temp[,3], list(temp[,1],temp[,2],temp[,3]), length)
colnames(temp) <- c("Nom1","Nom2","Year","NbPub")
id <- paste0(temp[,1], "_", temp[,2])
year <- temp[,3]
npub <- temp[,4]
tab <- as.matrix.xtabs(xtabs(npub ~ id + year))
id <- do.call(rbind,strsplit(rownames(tab), "_"))
tab <- data.frame(id=1:dim(tab)[1], 
                  from=id[,1],
                  to=id[,2],
                  tab)
rownames(tab) <- 1:dim(tab)[1]
colnames(tab)[-c(1,2,3)] <- seq(minyear,maxyear,1)

edges_hal <- list()
edges_hal[[1]] <- tab

nodes <- c(temp[, 1], temp[, 2])
nodes <- sort(nodes[!duplicated(nodes)])
nodes <- org_nodes[match(nodes, org_nodes[, 1]),]
nodes_hal <- nodes

# Export data
save(edges_gg, 
     nodes_gg, 
     edges_hal,
     nodes_hal,
     a1_gg, 
     a1_hal,
     a2_gg,
     a2_hal, 
     file = "Vizu/Data.Rdata")


