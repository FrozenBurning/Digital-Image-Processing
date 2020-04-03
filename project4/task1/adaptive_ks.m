function ks = adaptive_ks(I)
%% Adaptive ks calculator
% input:image I
% output: ks
[M,N,Q]=size(I);
gray = rgb2gray(I);
%% compute entropy
E_ent = entropy(gray);
%% compute gray co-ocurrence matrix
glcm = graycomatrix(gray,'NumLevels',8);
% normalize
glcm_norm = glcm/sum(glcm(:));
%% compute energy covirance contrast
energy = sum(sum(glcm_norm.^2));
c_cov = cov(glcm_norm);
c_cov = sum(c_cov(:));

[x,y]=meshgrid(0:size(glcm_norm,1)-1);
c_con = sum(sum(((x-y).^2).*glcm_norm));

%% calculate complexity T
T = E_ent + c_con-energy-c_cov;
ks = ceil((M+N)/T);
end