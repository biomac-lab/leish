function [count,data,species] = mammals_dataset(names,coordinates)
%function mammals_dataset counts the number of mammal species and assign them a
%consecutive number. names and coordinates were created by reading the names 
%from an excel file and a txt file. This files should be sorted alphabetically 
%and cleaned for extra characters.
%The following commands show how to read the files.
%num = xlsread('all_mammals'); coordinates = num(2:end,:);
%names = importdata('mammals_names.txt');
%and to sort them: [B,IX] = sort(names); nc = coordinates(IX,:); names + B;
%coordinates = nc; save('mammals','names', 'coordinates')
%mammals contains a coordinates variable with long lat (2 columns) and
%names a cell array with all the name son the first column. Same order as
%coordinates
%
%INPUT names: species names 
%      coordinates: latitude longitud for each observation
%
%OUTPUT count: number of species in the data set
%       data: a matrix with species number on the first column and
%            coordinates on second and third row
%
n1 = names{1};
count = 1;
data = zeros(length(coordinates),3);
data(1,:) = [1 coordinates(1,:)];
species{1} = n1;
for i = 2:length(coordinates)
    n2 = names{i};
    if strcmp(n1,n2)
        data(i,:) = [count coordinates(i,:)];
        continue
    end
    count = count + 1;
    species{count} = n2;
    data(i,:) = [count coordinates(i,:)];
    n1 = n2;
end
species=species';


