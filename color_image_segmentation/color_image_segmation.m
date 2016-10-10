%% Initialization
close all; clc; clear
%% Get rid of the specular highlights by threshold
I = double(imread('E:\2016Spring\MV\HW3\PeppersRGB.tif'));
I_flat = I;
I_flat(I>180)=180;
figure;
subplot(1,2,1);
imagesc(I/255);
subplot(1,2,2);
imagesc(I_flat/255);
%% RGB feature vector
max_iterations = 30;
k_values = 2:5;
[I_segmentation,I_segmentation_class] = k_means(I_flat,k_values,max_iterations);
%%
[I_segmentation,I_segmentation_class] = k_means(I_flat,4,max_iterations);
figure;
subplot(3,3,1)
imagesc(I_segmentation/255);
subplot(3,3,2)
imagesc(I_segmentation_class(:,:,:,1)/255);
subplot(3,3,3)
imagesc(I_segmentation_class(:,:,:,2)/255);
subplot(3,3,4)
imagesc(I_segmentation_class(:,:,:,3)/255);
subplot(3,3,5)
imagesc(I_segmentation_class(:,:,:,4)/255);
%% LST as the feature vector
LST = zeros(size(I));
LST(:,:,1) = (I(:,:,1)+I(:,:,2)+I(:,:,3))./3;
LST(:,:,2) = (I(:,:,1)-I(:,:,3))./2;
LST(:,:,3) = (2*I(:,:,2)-I(:,:,1)-I(:,:,3))./4;
[LST_segmentation,LST_segmentation_class] = k_means(LST,k_values,max_iterations);
%%
[LST_segmentation,LST_segmentation_class] = k_means(LST,3,max_iterations);
figure;
subplot(2,2,1)
imagesc(LST_segmentation/255);
subplot(2,2,2)
imagesc(LST_segmentation_class(:,:,:,1)/255);
subplot(2,2,3)
imagesc(LST_segmentation_class(:,:,:,2)/255);
subplot(2,2,4)
imagesc(LST_segmentation_class(:,:,:,3)/255);
%% HSV as the feature vector
HSV = rgb2hsv(I);
[HSV_segmentation,HSV_segmentation_class] = k_means(HSV,k_values,max_iterations);
%%
[HSV_segmentation,HSV_segmentation_class] = k_means(HSV,2,max_iterations);
figure;
subplot(2,2,1)
imagesc(HSV_segmentation/255);
subplot(2,2,2)
imagesc(HSV_segmentation_class(:,:,:,1)/255);
subplot(2,2,3)
imagesc(HSV_segmentation_class(:,:,:,2)/255);


