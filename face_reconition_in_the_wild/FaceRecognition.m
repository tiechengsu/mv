%% Intialization
close all; clc; clear
%% Load image data
faceDatabase = imageSet('E:/2016Spring/MV/Project/LabeledFacesintheWild','recursive');
% More data
clc
n = 1;
faceData = imageSet;
for i=1:size(faceDatabase,2)
    if faceDatabase(i).Count>11
        faceData(n) = faceDatabase(i);
        n = n+1;
    end
end

% Split Database into Training & Test Sets
[training,test] = partition(faceData,[0.8 0.2]);
% Detect Faces
trainingfaces=FaceDetection(training);
testfaces=FaceDetection(test);
%%
figure;
montage(faceData(6).ImageLocation);
%%
% [hogFeature, visualization]=extractHOGFeatures(trainingfaces{1}{1});
% figure;
% subplot(2,1,1);imshow(trainingfaces{1}{1});title('Input Face');
% subplot(2,1,2);plot(visualization);title('HoG Feature');
%% Extract HOG Features for training set
clc;
faceNum = 0;
for i=1:3%size(trainingfaces,2)
    faceNum = faceNum + size(trainingfaces{i},2);
end
trainingFeatures = zeros(faceNum,10404,'single');
featureCount = 1;
for i=1:3%size(trainingfaces,2)
    for j=1:size(trainingfaces{i},2)
        trainingFeatures(featureCount,:)=extractHOGFeatures(trainingfaces{i}{j});
        trainingLabels{featureCount}=training(i).Description;
        featureCount = featureCount + 1;
    end
    personIndex{i}=training(i).Description;
end
% Create class classifier using fitcecoc
faceClassifier = fitcecoc(trainingFeatures,trainingLabels);
% Test first 10 people from test set
close all
figureNum = 1;
for i=1:3
    figure
    for j=1:size(testfaces{i},2)
        queryImage = testfaces{i}{j};
        queryFeatures = extractHOGFeatures(testfaces{i}{j});
        personLabel = predict(faceClassifier, queryFeatures);
        % Map back to training set to find identity
        booleanIndex = strcmp(personLabel, personIndex);
        integerIndex = find(booleanIndex);
        subplot(size(testfaces{i},2),2,figureNum);imshow(queryImage);title('Query Face');
        subplot(size(testfaces{i},2),2,figureNum+1);imshow(trainingfaces{integerIndex}{1});title('Matched Class');
        figureNum = figureNum+2;
    end
    figureNum = 1;
end
%% Perform Fisher Vector Feature Extraction
clc;
run('D:/Program/matlabR2015b/vlfeat/vlfeat-0.9.20/toolbox/vl_setup');
%%
discriptors = [];
features = [];
locations = [];
binSize = 12;
range = 1:10;
for i=range%size(trainingfaces,2)
    for j=1:size(trainingfaces{i},2)
        %SIFT density 2, 24*24 pixels patches
        [location ,feature] = vl_dsift(single(rgb2gray(trainingfaces{i}{j})),'step',2,'size',binSize);
        features = [features,feature];
        locations = [locations,location];
    end
end
[z,pcaCoeff] = PCA(features); %PCA-sift
discriptors = single([z; locations./150-0.5]);%spatial information
%% KMeans to pre-cluster the data
numClusters = 256;%256
[initMeans, assignments] = vl_kmeans(discriptors, numClusters,...
    'Algorithm','Lloyd');
initCovariances = zeros(66,numClusters,'single');
initPriors = zeros(numClusters,1,'single');
for i = 1:numClusters
    data_k = discriptors(:,assignments==i);
    initPriors(i) = size(data_k,2)/numClusters;
    
    if size(data_k,1)==0 || size(data_k,2)==0
        initCovariances(:,i) = diag(cov(discriptors'));
    else
        initCovariances(:,i) = diag(cov(data_k'));
    end
end
%% Single Image test
[locations ,features] = vl_dsift(single(rgb2gray(testfaces{1}{1})));
[z] = PCA(features);
discriptor = [z; locations./150-0.5];%spatial information
encoding = vl_fisher(single(discriptor),means,covariances,priors,'normalized','squareroot');%dimensionality 2Kd
%% GMM
[means, covariances, priors] = vl_gmm(discriptors, numClusters,...
    'initialization','custom',...
    'InitMeans',initMeans,...
    'InitCovariances',initCovariances,...
    'InitPriors',initPriors);
%%
%
trainingLabels = {};
faceNum = 0;
for i=range%size(trainingfaces,2)
    faceNum = faceNum + size(trainingfaces{i},2);
end
trainingFeatures = zeros(faceNum,2*numClusters*66,'single');%dimensionality 2Kd
featureCount = 1;
n = 1;
for i=range%size(trainingfaces,2)
    for j=1:size(trainingfaces{i},2)
        discriptor = discriptors(:,(n-1)*size(feature,2)+1:n*size(feature,2));
        n = n+1;
        trainingFeatures(featureCount,:) = (vl_fisher(discriptor,means,...
            covariances,priors,'normalized','squareroot'))';
        trainingLabels{featureCount}=training(i).Description;
        featureCount = featureCount + 1;
    end
    personIndex{i}=training(i).Description;%label for all people
end
%%

% Create class classifier using fitcecoc
faceClassifier = fitcecoc(trainingFeatures,trainingLabels);

% Test first 10 people from test set
close all;clc
figureNum = 1;
for i=range
    figure
    for j=1:size(testfaces{i},2)
        queryImage = testfaces{i}{j};
        [location ,feature] = vl_dsift(single(rgb2gray(queryImage)),'step',2,'size',binSize);
        z = pcaCoeff*double(feature);
        discriptor = [z; location./150-0.5];
        %discriptor = PCAwhite(discriptor);
        queryFeatures = vl_fisher(single(discriptor),means,...
            covariances, priors,'normalized','squareroot');
        personLabel = predict(faceClassifier, queryFeatures');
        % Map back to training set to find identity
        booleanIndex = strcmp(personLabel, personIndex);
        integerIndex = find(booleanIndex);
        subplot(size(testfaces{i},2),2,figureNum);imshow(queryImage);title('Query Face');
        subplot(size(testfaces{i},2),2,figureNum+1);imshow(trainingfaces{integerIndex}{1});title('Matched Class');
        figureNum = figureNum+2;
    end
    figureNum = 1;
end
%%
save('E:/2016Spring/MV/Project/Fishervectorfacesinthewild/training_512.mat',...
    'means','covariances', 'personIndex','priors','trainingFeatures','trainingLabels');
%%
load('E:/2016Spring/MV/Project/Fishervectorfacesinthewild/training.mat');
%% Initialize the W
[coeff,score,latent] = pca(trainingFeatures);
%% Compress a high-dimensional FV
%
clc
b = 92;%learnt threshold
%(92 7,accuarcy 0.83 for 256GMM)
%(97 7,accuarcy 0.83 for 512GMM)
p = 128;
W = diag(1./sqrt(latent(1:p)+0.001))*coeff(:,1:p)';%white
gamma = 0.2;%study rate
%
%find the releation between people and fisher
face_people = zeros(size(range));
face_people(1) = size(trainingfaces{1},2);
for i = 2:size(range,2)
    face_people(i) = size(trainingfaces{i},2)+face_people(i-1);
end
%%
%sampling with equal frequency positive and negative labels y
for iteration = 1:8
    for i = randperm(size(trainingFeatures,1))
        num = find(face_people>i,1);
        temp = rand(1);
        if (temp<=0.5) & (num>1)
            j = datasample(face_people(num-1)+1:face_people(num),1);
        elseif (temp<=0.5) & (num==1)
            j = datasample(1:face_people(num),1);
        elseif (temp>0.5) & (num==1)
            j = datasample(face_people(num):size(trainingFeatures,1),1);
        elseif (temp>0.5) & (num>1)
            j = datasample([1:face_people(num-1),face_people(num)+1:size(trainingFeatures,1)],1);
        elseif (temp>0.5)
            j = datasample(1:face_people(end),1);
        else
            j = datasample(face_people(end):size(trainingFeatures,1),1);
        end
        y = strcmp(trainingLabels(i),trainingLabels(j))*2-1;
        %euclidean distance
        d = (trainingFeatures(i,:)-trainingFeatures(j,:))*W'*W*(trainingFeatures(i,:)-trainingFeatures(j,:))';
        if y*(b-d)<=1
            W = W - gamma*y*W*(trainingFeatures(i,:)-trainingFeatures(j,:))'*...
                (trainingFeatures(i,:)-trainingFeatures(j,:));
        end
    end
end

%%
trainingFeatures_compress = trainingFeatures*W';
%
% Create class classifier using fitcecoc
faceClassifier = fitcecoc(trainingFeatures_compress,trainingLabels);

% Test first 5 people from test set
close all;clc
figureNum = 1;
count = 0;%count the number of test set
for i=range
    figure
    for j=1:size(testfaces{i},2)
        count = count+1;
        queryImage = testfaces{i}{j};
        [location ,feature] = vl_dsift(single(rgb2gray(queryImage)),'step',2,'size',binSize);
        z = pcaCoeff*double(feature);
        discriptor = [z; location./150-0.5];
        %discriptor = PCAwhite(discriptor);
        queryFeatures = vl_fisher(single(discriptor),means,...
            covariances, priors,'normalized','squareroot');
        queryFeatures_compress = queryFeatures'*W';
        personLabel = predict(faceClassifier, queryFeatures_compress);
        % Map back to training set to find identity
        booleanIndex = strcmp(personLabel, personIndex);
        integerIndex = find(booleanIndex);
        subplot(size(testfaces{i},2),2,figureNum);imshow(queryImage);title('Query Face');
        subplot(size(testfaces{i},2),2,figureNum+1);imshow(trainingfaces{integerIndex}{1});title('Matched Class');
        figureNum = figureNum+2;
    end
    figureNum = 1;
end

