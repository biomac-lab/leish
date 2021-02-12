# leish

This repository contains the data and MATLAB code for our paper:

> Marla López, Diana Erazo, Juliana Hoyos, Cielo León, Patricia Fuya, Ligia Lugo, Juan Manuel Cordovez, Camila González *Measuring spatial co-occurrences of species >potentially involved in Leishmania transmission cycles through a predictive and fieldwork approach*
 
 
### How to download or install

You can download the compendium as a zip from from this URL:
<https://github.com/biomac-lab/leish/archive/master.zip>

## Analysis, figures and tables

Run analysis, figures and tables from main_script.m

Put all the following files in the same folder:

MAIN SCRIPT: main_script.m

DATA: colombian grid (colgrid.mat) - Colombian grid and its borders (stored in CG 0 water, 1 land)        
      mammal data (mammals.mat) - mammal species coordinates 
      vector data (vectors.mat) - vector species coordinates  

FUNCTIONS: mammals_dataset.m 
           score_mammals.m 
           score_map.m
           vector_dataset.m
           

