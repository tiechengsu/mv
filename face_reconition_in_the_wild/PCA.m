function  [z,pcaCoeff] = PCA(features)
% Apply PCA to SIFT
features = double(features);
% avg = mean(features,2);
% features = features - repmat(avg,1,size(features,2));%mean normalization
avg = mean(features,1);
features = features - repmat(avg,size(features,1),1);%mean normalization
sigma = features*features'/size(features,2);%convariance matrix
[u,s,v] = svd(sigma);%singular value decomposition
z = u(:,1:64)'* features;
pcaCoeff = u(:,1:64)';
end