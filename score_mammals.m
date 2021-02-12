function [SM,SIM] = score_mammals(CG,V,data,count)
%function score_mammals computes mammal scores. Species observations have  
%to be located and a radius of motion has to be assigned.
%to locate observations (lat, long) on the map we use assumed that
%pixel size is 0.0083 and the coordinates at the lower left corner are:
%14.53 (lat) and -118.4(long).
%
%INPUT CG: colombian grid a raster with colombian geography
%      V: vector grid
%      count: number of species in the data set
%      data: matrix with species number on the first column and
%            coordinates on second and third row
%
%OUTPUT SM: Score mammals
%       SMI: Score mammals index
%
%initialize scores
[nrg, ncg] = size(CG);
SM = zeros(nrg,ncg);
SIM = zeros(count,1);
h = waitbar(0,'computing mammal scores');
for i = 1:count
    M = CG;
    MM = data(data(:,1) == i,:);
    [nr, ~] = size(MM);
    %check if the resolution of CG for fixed pixel or radius.
    if nrg == 1669 %radius
        radius = 10; %define the radius
        for j=1:nr
            c= round((MM(j,3) + 79.0472)/0.01);
            r= 1669 - round((MM(j,2) + 4.2267)/0.01);
            %keep the point inside the area of study
            if r > 1669; r = 1669;end
            if r < 1 ; r = 1;end
            if c > 1217; c = 1217;end
            if c < 1 ; c = 1;end
            if r-radius < 1 ||  r+radius > 1669 || c-radius< 1 || c+radius > 1217
                radius = 0;
            end
            M(r-radius:r+radius,c-radius:c+radius) = 2;
        end
    else %fixed pixel
        for j=1:nr
            c= round((MM(j,3) + 79.0472)/(12.17/ncg));
            r= nrg - round((MM(j,2) + 4.2267)/(16.69/nrg));
            %keep the point inside the area of study
            if r > nrg; r = nrg;end
            if r < 1 ; r = 1;end
            if c > ncg; c = ncg;end
            if c < 1 ; c = 1;end
            M(r,c) = 2;
        end
    end
    %get 
    %the number of pixels where M == 2 and V == 2 (both present) 
    %the number of pixels where V == 2 and M == 1 (vector present mammal
    %abscent)
    %the number of cells where the vector is present
    BP = (M == 2 & V == 2);%both present
    VP = (V == 2);%vector present 
    MPVA = (M == 2 & V == 1);%mammal present vector absent
    VA = (V == 1);%vector absent
    bp = sum(sum(BP));
    vp = sum(sum(VP));
    mpva = sum(sum(MPVA));
    va = sum(sum(VA));
    if bp == 0 || vp==0 || mpva == 0 || va == 0
        score = 0;
    else
        score = log((bp/vp)/(mpva/va));
    end
    SM = SM + (M==2)*score;
    SIM(i) = score;
    waitbar(i/count)
end
close(h)

 
