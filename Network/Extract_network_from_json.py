# https://github.com/tanodino/biblioLabo/tree/main

# Import modules
import os
import json
from unidecode import unidecode
import pandas as pd
import numpy as np
import itertools

# Define function to replace special cases (example 'j-b feret' in Google Scholar instead of 'jean-baptiste feret')
def replaceSpecialCases(auth_list, special_cases):
    new_list = []
    for el in auth_list:
        if el in special_cases:
            new_list.append(special_cases[el])
        else:
            new_list.append(el)
    return new_list

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
user_id = [ "%s %s"%(unidecode(p).lower().strip(),unidecode(n).lower().strip()) for p,n in zip(fir2,fam2)]

# User dictionary
user = {}
for i in range(len(user_id)):
    user[user_id[i]] = [fir[i],fam[i],fir2[i],fam2[i],ist[i],tea[i],grp[i],ing[i]]

# Define list of special cases
special_cases = {}
for el in user_id:
    p, n = el.split(" ")
    val = "%s %s"%(p[0], n)
    special_cases[val] = el

special_cases["j-b feret"] = "jean-baptiste feret"
special_cases["jb feret"] = "jean-baptiste feret"
special_cases["pm villar"] = "patricio villar"
special_cases["begue agnes"] = "agnes begue"
special_cases["gaetano raffaele"] = "raffaele gaetano"
special_cases["dino lenco"] = "dino ienco"

# Loop over json files
jsonf = os.listdir("Publications")
output = {}
#k=0
#if k==0:
for k in range(0,len(jsonf)):
    f = open("Publications/pub_" + str(k) + ".json")                                   # Open file
    publik = json.load(f)                                                              # Extract publi
    if 'conference' in publik['bib'].keys() or 'journal' in publik['bib'].keys():      # Only if Journal or Conference article
        auth = publik['bib']['author']           # Authors 
        year = int(publik['bib']['pub_year'])    # Year
        ncit = publik['num_citations']           # Number of citations
        
        # Extract authors list
        auth_list = auth.split(" and ")
        auth_list = [unidecode(el).lower().strip() for el in auth_list]    
        auth_list = ["%s %s"%(el.split(" ")[0], el.split(" ")[-1]) for el in auth_list]
        auth_list = replaceSpecialCases(auth_list, special_cases)
        
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
            key_pair = '%s_%s_%s_%s'%(new_p[0], new_p[1], year, ncit)
            output[key_pair] = (k,len(inter),nbext)
        
    f.close()

# Export nodes
nodes = open('nodes.csv', 'w')
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
edges = open('edges.csv', 'w')
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
    
    el1, el2, el3, el4 = k.split("_")
    el1 = el1.split(" ")[-1]
    el2 = el2.split(" ")[-1]
    
    edges.write(str(el1))
    edges.write(';')
    edges.write(str(el2))
    edges.write(';')
    edges.write(str(el3))
    edges.write(';')
    edges.write(str(el4))
    edges.write(';')
    edges.write(str(output[k][0]))
    edges.write(';')
    edges.write(str(output[k][1]))
    edges.write(';')
    edges.write(str(output[k][2]))
    edges.write('\n')

edges.close()



