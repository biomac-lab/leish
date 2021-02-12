function score_map(SM)
%function score_map plots map of scores

[~,ncol] = size(SM);
[nr,nc] = size(SM{1});
SC = zeros(nr,nc);
for i = 1:ncol
    SCi = SM{i};
    if isempty(SCi)
        continue
    else
    SC = SC + SCi;
    end
end
imshow(SC,[min(min(SC)) max(max(SC))])
colormap jet



