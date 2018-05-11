% warning('off')
% clc;
% clear all;
% close all;
% featureVector=training();
% SVMModel=svmconstruct(featureVector);
%reading input image %
[filename,pathname] = uigetfile({'*.jpg';'*.png';'*.tif';'*.gif'});
I = imread([pathname,filename]);
figure,imshow(I);
title('Input image');
impixelinfo;
[m,n,o]=size(I);

%convert to gray scale%

if o==3
    G=rgb2gray(I);
else 
    G=I;
end

%adjust the pixel intensity%
adj=imadjust(G);
figure,imshow(adj);
title('Intensity Adjusted Image');

%Binarise the Image%
bi=adj<180;
figure,imshow(bi);
title('Binary Image');

%Canny Edge Detection%
can=edge(bi,'canny');
figure,imshow(can);
title('Canny');

%Sobel Edge Detection%
sob=edge(bi,'sobel');
figure,imshow(sob);
title('Sobel');

%Combine the Edge detectors%
comb=or(can,sob);
figure,imshow(comb);
title('Combined edge image');

%Draw the Object Boundary% 
[B,L] = bwboundaries(comb);
figure,imshow(adj,[]);
title('object detection')
hold on
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end

%Extract the Shape from the image%
bif=imfill(bi,'holes');
figure,imshow(bif);
title('Shape Extracted Image');
%% SIFT Feature %%
[kp,kpl,kpori,kpmag,kpd,fig]=SIFT(comb);
figure,imshow(fig);
title('SIFT Features');

%% shape feature extraction %%
g=regionprops(bif,'all');
g1=extractfield(g,'Area');
[g11,index1]=max(g1);
ar=round(g11);

g2=extractfield(g,'MajorAxisLength');
[g22,index2]=max(g2);
maj=round(g22);

g3=extractfield(g,'MinorAxisLength');
[g33,index3]=max(g3);
min=round(g33);

g4=extractfield(g,'Perimeter');
[g44,index4]=max(g4);
per=round(g44);

featureout=[ar,maj,min,per];
featuretest=[];
kp=kpmag(1:50);


%% Construct the Feature Vector%%
featuretest=[featuretest;[ kp' featureout]];
TestSet1=featuretest;
[label,score] = predict(SVMModel,TestSet1);
if label==1
    msgbox('Circle');
elseif label==2
    msgbox('Star');
else
        msgbox('NOT RECOGNISED');
end