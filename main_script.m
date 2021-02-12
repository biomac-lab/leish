%Script to work with Leishmania database.

%put all the following files in the same folder

%INPUTS: colombian grid (colgrid.mat) - Colombian grid and its borders 
%                                       (stored in CG 0 water, 1 land)
%        mammal data (mammals.mat) - mammal species coordinates 
%        vector data (vectors.mat) - vector species coordinates  

%FUNCTIONS: mammals_dataset.m 
%           score_mammals.m 
%           score_map.m
%           vector_dataset.m

%% The script is divided in four sections:
%
%The first loads the map for Colombia and generates a discrete map for 
%vectors based on geographical coordinates (latitude,longitude). 
%
%The second part loads vector information and generates a 
%distribution for each species over the same colombian grid. 
%
%The third part loads mammal information and generates a 
%distribution for each species over the same colombian grid. 
%This section also computes the score associated with each mammal species.  
%
%The fourth section generates the graphical output.

% load the grid that defines Colombia and its borders 
%(stored in CG 0 water, 1 land)
load colgrid

CG = round(imresize(colgrid,1)); % redefine colgrid for fixed pixel size 
%1 means same size as CG

%load a vector data set
load vectors
%load mamals data set
load mammals
p = 0;
for i=1:5 %number of ecoregions
   ix = vectors_ecoregion == i;
   vect = vectors_coordinates(ix,:);
   ixx = mammals_ecoregion == i;
   nam = {};
   [row,col] = find(ixx);
   for k=1:sum(ixx)
            nam{k} = mammals_names{row(k)};
   end
   mamcoor = mammals_coordinates(ixx,:);
   for j=1:20 %number of vector species
        p = p+1;
        ixv = vectors_names(ix) == j;
        if sum(ixv) == 0
            SM{p} = [];
            SIM{p} = [];
            species{p} = [];
            continue
        end
        % generate a distribution for each vector species over the same grid
        V = vector_dataset(vect(ixv,:),CG);
        % generate a distribution for each mammal species over the same grid
        [count,data,species{p}] = mammals_dataset(nam,mamcoor);
        % compute the score associated of each vector species to each mammal species
        [SM{p},SIM{p}] = score_mammals(CG,V,data,count);
    end
end

 
%generate distribution map
score_map(SM)


%% Present score results in a table per ecoregion

% Each pair of columns (mammals species and associated score) represents
% the score between a vector species and the corresponding mammal 

% Example shows ecoregion 1 (i = 1:20) Dry forest
% for other ecoregions use: ecoregion 2 (i = 21:40) Moist forest
%                           ecoregion 3 (i = 41:60) Montane forest
%                           ecoregion 4 (i = 61:80) Lowlands
%                           ecoregion 5 (i = 81:100) Xeric shrublands
%                           and change filename
pos = {'A1', 'C1', 'E1', 'G1', 'I1', 'K1', 'M1', 'O1', 'Q1', 'S1', 'U1', 'W1', 'Y1', 'AA1', 'AC1', 'AE1', 'AG1', 'AI1', 'AK1', 'AM1'};
filename = 'ecoregion1.xls'; %change depending on ecoregion, see above
k=0;
for i = 1:20 %change depending on ecoregion, see above
    ix = SIM{i} > 0;
    mammals_with_score = species{i}(ix);
    [sc, ixs] = sort(SIM{i}(ix));
    mws = mammals_with_score(ixs);
    %construct data
    dat = cell(length(sc),2);
    for i=1:length(sc)
        dat{i,1} = mws{i};
    end
    for i=1:length(sc)
        dat{i,2} = sc(i);
    end
    f = figure('Position',[500 500 400 500],'Name','species and score');
    cnames = {'Species name','Score'};
    t = uitable('Units','normalized','Position',[0.1 0.1 0.9 0.9],'Data',dat,'ColumnName',cnames,'Parent',f,...
        'ColumnWidth',{200 60});
    T = table(dat);
    k=k+1;
    writetable(T,filename,'Sheet',1,'Range',pos{k})
end


