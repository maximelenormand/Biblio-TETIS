# Bibliometric analysis of the TETIS laboratory

## Description

This interactive web application provides a bibliographic analysis of the 
publications (journal articles and conference papers) of the UMR TETIS based on 
two data sources (Google Scholar and HAL/Agritrop). 

The Google Scholar data 
consist of a list of publications (tagged as 'conference' and 'journal') 
co-authored by at least one permanent member of TETIS during the 2016–2023
period. They were 
[harvested and cleaned](https://github.com/tanodino/biblioLabo/tree/main){:target="_blank"} 
by Dino Ienco.

The HAL/Agritrop data consist of a list of publications (tagged as 'Journal 
article' and 'Conference presentation') co-authored by at least one permanent 
member of TETIS during the 2019–2024 period. They were harvested by Isabelle 
Nault (HAL) and Sylvie Blin (Agritrop), cleaned by Agnès Bégué, and formatted 
by Dino Ienco.

The first two tabs allow for the visualization of the co-publication network of 
the UMR TETIS over a given period of activity (in years), based on the data 
source, supervising institutions, teams, and ad hoc groups. 
The third tab offers various analyses to visualize statistics on the number of 
publications per year according to different criteria.

## Data & analysis

This repository contains two folders: **Networks** and **Vizu**. The first folder 
contains the raw data in `.json` format for both data sources 
(the **GG/Publications** and **HAL/Publications** folders). The Python script 
can be used to extract the co-publication networks from the raw data:

**python3 1_Extract_network_from_json.py GG**  
**python3 1_Extract_network_from_json.py HAL**

The R script can then be used to extract and format the data for Shiny.

The second folder contains all the materials (R scripts, `.Rdata` file, and the 
`www` data folder) needed to run [the app](https://biblio-tetis.sk8.inrae.fr).

## Contributors

- [Maxime Lenormand](https://www.maximelenormand.com/)
- [Dino Ienco](https://github.com/tanodino)

If you need help, find a bug, want to give me advice or feedback, please 
contact me!  

## Repository mirrors

This repository is mirrored on both GitLab and GitHub. You can access it via the following links:

- **GitLab**: [https://gitlab.com/maximelenormand/biblio-tetis](https://gitlab.com/maximelenormand/biblio-tetis)  
- **GitHub**: [https://github.com/maximelenormand/Biblio-TETIS](https://github.com/maximelenormand/Biblio-TETIS)  

The repository is archived in Software Heritage:

[![SWH](https://archive.softwareheritage.org/badge/origin/https://github.com/maximelenormand/biblio-tetis/)](https://archive.softwareheritage.org/browse/origin/?origin_url=https://github.com/maximelenormand/biblio-tetis)
