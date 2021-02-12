function V = vector_dataset(vectcoor,CG)
%function vector_dataset generaters a vector grid
%
%INPUT vectcoor: variable with longitude and latitude (2 columns) 
%                was created by reading the names from and excel file and 
%                a txt file. This files Should be sorted alphabetically
%                and cleaned for extra characters.
%      CG:      colombian grid a raster with colombian geography
%
%OUTPUT V: vector grid

%generate a vector presence matrix
[nrg,ncg] = size(CG);
[nrv,ncv] = size(vectcoor);
V = CG;

%check if the resolution of CG for fixed pixel or radius.
if nrg == 1669 %radius 
    radius = 5; %define the radius in pixels
    for k=1:nrv
        c= round((vectcoor(k,2) + 79.0472)/0.01);
        r= 1669 - round((vectcoor(k,1) + 4.2267)/0.01);
        %keep the point inside the area of study
        if r-radius < 1 ||  r+radius > 1669 || c-radius< 1 || c+radius > 1217
            radius = 0;
        end
        V(r-radius:r+radius,c-radius:c+radius) = 2;
    end
else %fixed pixel
    for k=1:nrv
        c= round((vectcoor(k,2) + 79.0472)/(12.17/ncg));
        r= nrg - round((vectcoor(k,1) + 4.2267)/(16.69/nrg));
        V(r,c) = 2;
    end
end