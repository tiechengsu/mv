%%Initialization
close all; clc; clear;
%% Select a single threshold to segment the given image
close all;
I = imread('E:\2016Spring\MV\HW2\Shapes-blurred.png');
figure
imhist(I);
%Create a binary map in which all major objects are segmented
S = I;
threshold = 60;
%Assign all the object pixels a value of 255 and the background a value of
%0
S(I > threshold) = 255;
S(I <= threshold) = 0;

imshow(I);
figure()
imagesc(S);
figure()
himage = imshow(S);
hfigure = figure;
hpanel = impixelregionpanel(hfigure, himage);
%% Label connected components
%first pass
close all; clc
linked = {};
[rows,cols]=size(S);
S_pad = zeros(rows+2,cols+2);
S_pad(2:1+rows,2:1+cols) = S;
[r,c]=size(S_pad);
B = zeros(r,c);
label = 1;
for i = 2:r-1
    for j = 2:c-1
        if S_pad(i,j)==255
            if S_pad(i,j-1)==0&&S_pad(i-1,j-1)==0&&S_pad(i-1,j)==0&&S_pad(i-1,j+1)==0
                linked{label} = label;
                B(i,j)= label;
                label = label + 1;
            else
                neighbors = [B(i,j-1);B(i-1,j-1);B(i-1,j);B(i-1,j+1);B(i,j+1)];
                L = min(neighbors(neighbors>0));
                B(i,j)=L;
                for ii = 1:5
                    if neighbors(ii)>0;
                        linked{neighbors(ii)} = union(linked{neighbors(ii)},(neighbors(neighbors>0))');
                    end
                end
            end
        end
    end
end
figure()
imagesc(B);
figure()
himage = imshow(B);
hfigure = figure;
hpanel = impixelregionpanel(hfigure, himage);
%% second pass
clc;close all
%uniquely labeled
length = size(linked,2);
ID = [];
ID1 = [];
for i=1:length
    ID(i) = min(linked{i});
end
%consecutive label
temp = unique(ID(:));
for ii=1:size(temp,1)
    ID1(ID==temp(ii))=ii;
end

C = zeros(r,c);
for i=1:length
    C(B==i)=ID1(i);
end
s = regionprops(C, 'Centroid');
imagesc(C);
hold on
for k = 1:numel(s)
    m = s(k).Centroid;
    text(m(1), m(2), sprintf('%d', k),'Color','w','FontSize',14,...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
end
hold off
%% Perform region Selection
%Remove all regions having areas smaller than 10 pixels
clc;
C1 = C(2:r-1,2:c-1);
temp = unique(ID1(:));
for i = 1:size(temp,1)
     if sum(C1(:)==temp(i))< 10
        C1(C1(:)==temp(i)) = 0;
     end
end
imshow(C1);
hold on
for k = 1:numel(s)
    m = s(k).Centroid;
    text(m(1), m(2), sprintf('%d', k),'FontSize',14,...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
hold off

%% Remove all skinny regions having aspect ratio over 3:1
temp = unique(C1(C1>0));
for i = 1:size(temp,1)
    [row,col] = find(C1 == temp(i));
    row_diff = peak2peak(row);
    col_diff = peak2peak(col);
    if(max(row_diff,col_diff)/min(row_diff,col_diff)<3)
        C1(C1(:)==temp(i)) = 0;
    end
end
imshow(C1);
imwrite(C1,'Shapes_blurred_removed.png','png');
hold on
for k = 1:numel(s)
    m = s(k).Centroid;
    text(m(1), m(2), sprintf('%d', k),'FontSize',14,...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
hold off
%% Dectect the heart shape(Valentine's Day bonus)
clc;
temp = unique(C1(C1>0));
for i = 1:size(temp,1)
    [row,col] = find(C1 == temp(i));
    row_diff = peak2peak(row);
    col_diff = peak2peak(col);
     if int8(max(row_diff,col_diff)/min(row_diff,col_diff))~=1;
        C1(C1(:)==temp(i)) = 0;
     end
end
imshow(C1);
hold on
for k = 1:numel(s)
    m = s(k).Centroid;
    text(m(1), m(2), sprintf('%d', k),'FontSize',14,...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
hold off








