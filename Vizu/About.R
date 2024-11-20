function(){
  tabPanel(HTML('<span style="font-size:100%;color:white;font-weight:bold;">A propos</span></a>'),
           HTML('
      <div style="display:inline;float:right;margin:0px 0px 5px 20px">
        <img src="logo2.png" border="0" width="300" style="margin:0px">
      </div>

      <div style="max-width:1000px; word-wrap:break-word;">
        <p style="font-size:120%;text-align:justify">
         Cette application web interactive propose une analyse bibliographique 
         des publications (articles dans des revues et articles de conférence) 
         de l&#39;UMR TETIS entre 2016 et 2024. Les données ont été moissonnées 
         sur Google Scholar. Cette application contient deux onglets. 
        </p>
      </div>   

      <div style="max-width:1000px; word-wrap:break-word;">
        <p style="font-size:120%;text-align:justify">
         Le premier onglet permet de visualiser le réseau de copublications 
         de l&#39;UMR 
         TETIS durant une certaine période d&#39;activité (en années) en 
         fonction des tutelles, équipes et groupes ad hoc. 
        </p>
      </div>   
      
      <div style="max-width:1000px; word-wrap:break-word;">
        <p style="font-size:120%;text-align:justify">
         Le second onglet 
         propose différentes analyses permettant de visualiser des statistiques
         concernant le nombre de publications par année selon différents critères.
        </p>
      </div>   

      <hr width="1000", align="left" style="height:0.5px;border:none;color:#A0A5A8;background-color:#A0A5A8;" />

		  <span style="color:#64645F;font-weight: bold;font-size:12pt;">Contributeur·rice·s</span>
		  <div style="max-width:1000px; word-wrap:break-word;">
		     <p style="text-align:justify">
		        <a href="https://scholar.google.com/citations?user=k-E3aCAAAAAJ&hl=fr" target=_blank>Rémy Decoupes</a> <br>
		        <a href="https://www.researchgate.net/profile/Pascal-Degenne" target=_blank>Pascal Degenne</a> <br>
		        <a href="https://scholar.google.it/citations?user=C8zfH3kAAAAJ&hl=fr" target=_blank>Dino Ienco</a> <br>
		        <a href="https://scholar.google.fr/citations?user=GWACYGoAAAAJ&hl" target=_blank>Roberto Interdonato</a> <br> 
		        <a href="https://scholar.google.fr/citations?hl=fr&user=nIJPPHMAAAAJ" target=_blank>Camille Jahel</a> <br>
		        <a href="https://www.maximelenormand.com" target=_blank>Maxime Lenormand</a> <br>
		        <a href="https://scholar.google.fr/citations?hl=fr&user=9Hy7dPoAAAAJ" target=_blank>Renaud Marti</a> 
		        
		     </p>
		  </div>  


		  <span style="color:#64645F;font-weight:bold;font-size:12pt;">Code & Données</span>
		  <div style="max-width:1000px; word-wrap:break-word;">
		     <p style="text-align:justify;">
		        Disponible <a href="https://gitlab.com/maximelenormand/biblio-tetis" target=_blank>ici</a>
		     </p>
		  </div> 

		  <span style="color:#64645F;font-weight:bold;font-size:12pt;">Licence</span>
		  <div style="max-width:1000px; word-wrap:break-word;">
		     <p style="text-align:justify;">
		        GPLv3
		     </p>
		  </div> 
		'),
           value = "about"
  )
}
