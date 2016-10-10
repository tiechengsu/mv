%% Initialization
close all; clear; clc
%% Removing small regions and regions with aspect ratio less than 3
I = imread('E:\2016Spring\MV\HW4\Shapes_blurred_removed.png');
I = flipud(I);
%Since y is counting from the bottom up, we better flip the image before we
%manipulate it.
%extracting boundary points
B = bwboundaries(I,'noholes');
I_b = zeros(size(I));
for k = 1:length(B)
   boundary = B{k};
   for i=1:size(boundary,1)
       I_b(boundary(i,1),boundary(i,2))=1;
   end
end
figure;
imshow(flipud(I_b));
%% Use polar representation
close all
thetafrequency = 0.01;
[rows,cols] = size(I);
rho_limit = norm([rows cols]);
%quantize angle and offset
rho = -rho_limit:0.4:rho_limit;
theta = 0:thetafrequency:pi;
houghspace = zeros(numel(rho),numel(theta));
%pre-compute the sin and cos values
cosine = (0:cols-1)'*cos(theta);
sine = (0:rows-1)'*sin(theta);
[y_index,x_index] = find(I_b);
accumulator = zeros(numel(y_index),numel(theta));
accumulator(1:numel(y_index),:) = cosine(x_index,:) + sine(y_index,:);
for i=1:numel(theta)
    houghspace(:,i) = hist(accumulator(:,i),rho);
end
figure;
pcolor(theta,rho,houghspace);
shading flat;
hold on
peaks = houghpeaks(houghspace,4);
title('Hough Transform');
xlabel('theta(radians)');
ylabel('rho(pixels)');
plot(theta(peaks(:,2)),rho(peaks(:,1)),'s','color','white')
hold off
fprintf('The corresponding thetas are: \n');
fprintf('%.2f\n',theta(peaks(:,2))*180/pi);
fprintf('The corresponding rhos are:\n');
fprintf('%.2f\n',rho(peaks(:,1)));
%The length of each line should be the peaks values
fprintf('The corresponding lengths are:\n')
for i=1:4
    length = houghspace(peaks(i,1),peaks(i,2));
    fprintf('%d\n',length(1));
end
%The correspondence of peaks
figure;
imshow(I_b);
hold on
for i=1:2
    line([0 rho(peaks(i,1))*cos(theta(peaks(i,2)))],...
    [20*i rho(peaks(i,1))*sin(theta(peaks(i,2)))+20*i],'Color','r','LineWidth',3);
    text(2,20*i,num2str(i),'Color','w','Fontsize',15,'Fontweight','bold');
end
for i=3:4
    line([i*5 rho(peaks(i,1))*cos(theta(peaks(i,2)))+i*5],...
    [0 rho(peaks(i,1))*sin(theta(peaks(i,2)))],'Color','y','LineWidth',3);
    text(i*5,2,num2str(i),'Color','w','Fontsize',15,'Fontweight','bold');
end
