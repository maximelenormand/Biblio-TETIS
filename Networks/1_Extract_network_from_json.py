# https://github.com/tanodino/biblioLabo/tree/main

# Import modules
import sys
import os
import json
from unidecode import unidecode
import pandas as pd
import numpy as np
import itertools

# Source
source = sys.argv[1]
#source = "GG"
#source = "HAL"

# Import Permanents_TETIS
df = pd.read_csv("Permanents_TETIS.csv")               # Import file
    
fir = df.iloc[:, 1].to_numpy()                         # First name
fir2 = [unidecode(el).lower().strip() for el in fir]    
fam = df.iloc[:, 0].to_numpy()                         # Family name
fam = [el.split(" ")[-1] for el in fam]
fam2 = [unidecode(el).lower().strip() for el in fam]           
ist = df.iloc[:,2].to_numpy()                          # Institute
ist = [el.strip() for el in ist]
tea = df.iloc[:,3].to_numpy()                          # Team
tea = [el.strip() for el in tea]
grp = df.iloc[:,4].to_numpy()                          # Group
grp = [el.strip() for el in grp]
ing = df.iloc[:,5].to_numpy()                          # Engineering
ing = [el.strip() for el in ing]

# User ID
user_id = [ "%s"%(unidecode(n).lower().strip()) for n in fam2]

# User dictionary
user = {}
for i in range(len(user_id)):
    user[user_id[i]] = [fir[i],fam[i],fir2[i],fam2[i],ist[i],tea[i],grp[i],ing[i]]

# Loop over json files
jsonf = os.listdir(source + "/Publications")
output = {}
for k in range(0,len(jsonf)):
    if source == "GG":                                                                 # Open file
        f = open(source + "/Publications/pub_"  + str(k) +  ".json")
    else:
        f = open(source + "/Publications/"  + str(k) +  "_pub.json")          
    publik = json.load(f)                                                              # Extract publi
    if 'conference' in publik['bib'].keys() or 'journal' in publik['bib'].keys():      # Only if Journal or Conference article
        auth = publik['bib']['author']           # Authors 
        year = int(publik['bib']['pub_year'])    # Year
        if source == "GG":                       # Number of citations
            ncit = publik['num_citations']
        else:
            ncit = 0
        
        # Extract authors list
        auth_list = auth.split(" and ")
        auth_list = [unidecode(el).lower().strip() for el in auth_list]            
        auth_list = [el.split()[-1] for el in auth_list if el != '']
        
        # Extract pairs
        inter = np.intersect1d(auth_list, user_id)
        nbext = len(auth_list) - len(inter)
        
        if len(inter) == 0:
            continue
        
        if len(inter)==1 and len(auth_list)==1:     # If one TETIS only
            pairs = [(inter[0],'zzself')]
                
        if len(inter)==1 and len(auth_list)>1:      # If one TETIS + external 
            pairs = [(inter[0],'zzext')]
                
        if len(inter)>1:                            
            pairs = list(itertools.combinations(inter, 2))
        
        # Loop over the pairs
        for p in pairs:
            new_p = list(p)
            new_p.sort()
            key_pair = '%s_%s_%s'%(k, new_p[0], new_p[1])
            output[key_pair] = (year, ncit, len(inter), nbext)
                
    f.close()

# Export nodes
nodes = open(source + '/nodes.csv', 'w')
nodes.write('ID')
nodes.write(';')
nodes.write('Nom')
nodes.write(';')
nodes.write('Institut')
nodes.write(';')
nodes.write('Equipe')
nodes.write(';')
nodes.write('Groupe')
nodes.write(';')
nodes.write('Ingénierie')
nodes.write('\n')

for k in user:
        
    nodes.write(str(user[k][3]))
    nodes.write(';')
    nodes.write(str(user[k][0]) + " " + str(user[k][1]))
    nodes.write(';')
    nodes.write(str(user[k][4]))
    nodes.write(';')
    nodes.write(str(user[k][5]))
    nodes.write(';')
    nodes.write(str(user[k][6]))
    nodes.write(';')
    nodes.write(str(user[k][7]))
    nodes.write('\n')

nodes.close()

# Export edges
edges = open(source + '/edges.csv', 'w')
edges.write('Nom1')
edges.write(';')
edges.write('Nom2')
edges.write(';')
edges.write('Year')
edges.write(';')
edges.write('#Citations')
edges.write(';')
edges.write('Publication_ID')
edges.write(';')
edges.write('#TETIS')
edges.write(';')
edges.write('#Exterieur')
edges.write('\n')

for k in output:
    
    el1, el2, el3 = k.split("_")
    
    edges.write(str(el2))
    edges.write(';')
    edges.write(str(el3))
    edges.write(';')
    edges.write(str(output[k][0]))
    edges.write(';')
    edges.write(str(output[k][1]))
    edges.write(';')
    edges.write(str(el1))
    edges.write(';')
    edges.write(str(output[k][2]))
    edges.write(';')
    edges.write(str(output[k][3]))
    edges.write('\n')

edges.close()



