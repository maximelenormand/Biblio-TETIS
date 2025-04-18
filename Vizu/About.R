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
          de l&#39;UMR TETIS à partir de deux sources de données (Google Scholar  
          et HAL/Agritrop). 
        </p>
      </div>   
      
      <div style="max-width:1000px; word-wrap:break-word;">
        <p style="font-size:120%;text-align:justify">
          Les données Google Scholar consistent en une liste de publications  
          (tag &#39;conference&#39; et &#39;journal&#39;) cosignées par au moins un  
          permanent de TETIS sur la période 2016-2023. Elles ont été  
          <a href="https://github.com/tanodino/biblioLabo/tree/main" target=_blank>moissonnées et nettoyées</a>  
          par Dino Ienco.  
        </p>
      </div>   
      
      <div style="max-width:1000px; word-wrap:break-word;">
        <p style="font-size:120%;text-align:justify">
          Les données HAL/Agritrop consistent en une liste de publications  
          (tag &#39;Article de revue&#39; et &#39;Communication dans un congrès&#39;)  
          cosignées par au moins un permanent de TETIS sur la période 2019-2024.  
          Elles ont été moissonnées par Isabelle Nault (HAL) et Sylvie Blin
          (Agritrop), nettoyées par Agnès Bégué et mises en forme par Dino Ienco.  
        </p>
      </div>   

      <div style="max-width:1000px; word-wrap:break-word;">
        <p style="font-size:120%;text-align:justify">
         Les deux premiers onglets permettent de visualiser le réseau de copublications 
         de l&#39;UMR 
         TETIS durant une certaine période d&#39;activité (en années) en 
         fonction de la source de données, des tutelles, équipes et groupes ad hoc. 
        </p>
      </div>   
      
      <div style="max-width:1000px; word-wrap:break-word;">
        <p style="font-size:120%;text-align:justify">
         Le troisième onglet propose différentes analyses permettant de visualiser 
         des statistiques concernant le nombre de publications par année selon 
         différents critères.
        </p>
      </div>   

      <hr width="1000", align="left" style="height:0.5px;border:none;color:#A0A5A8;background-color:#A0A5A8;" />

		  <span style="color:#64645F;font-weight: bold;font-size:12pt;">Développeur</span>
		  <div style="max-width:1000px; word-wrap:break-word;">
		     <p style="text-align:justify">
		        <a href="https://www.maximelenormand.com" target=_blank>Maxime Lenormand</a> <br>
		     </p>
		  </div>  

		  <span style="color:#64645F;font-weight:bold;font-size:12pt;">Code & Données</span>
		  <div style="max-width:1000px; word-wrap:break-word;">
		     <p style="text-align:justify;">
		        Disponible <a href="https://github.com/maximelenormand/biblio-tetis" target=_blank>ici</a>
		     </p>
		  </div> 

		  <span style="color:#64645F;font-weight:bold;font-size:12pt;">Licence</span>
		  <div style="max-width:1000px; word-wrap:break-word;">
		     <p style="text-align:justify;">
		        GPLv3
		     </p>
		  </div> 
		  
		  <hr>
		
		  <span style="font-size:12px;">Powered by <a href="https://sk8.inrae.fr" target="_blank">SK8</a> since 2021 - </span>
      <a href="https://sk8.inrae.fr" target="_blank">
          <img style="vertical-align:middle;height:25px;" src="SK8.png"/>
      </a>
		  
		'),
           value = "about"
  )
}
