function [featureVector]=training()
featurevector=[];
directory = uigetdir;
images=directory;
jpgfiles=dir(fullfile(images,'\*.jpg*'));
pngfiles=dir(fullfile(images,'\*.png*'));
jpegfiles=dir(fullfile(images,'\*.jpeg*'));
allfiles=[jpgfiles;pngfiles;jpegfiles];
for i1=1:length(allfiles)
I=imread(fullfile(images,allfiles(i1).name));
   [m,n,o]=size(I);

if o==3
    G=rgb2gray(I);
else 
    G=I;
end
adj=imadjust(G);
bi=adj<180;

can=edge(bi,'canny');
sob=edge(bi,'sobel');
comb=or(can,sob);
bif=imfill(bi,'holes');
[kp,kpl,kpori,kpmag,kpd]=SIFT(comb);

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
kp=double(kpmag(1:50));
i=[ kp' featureout];
featurevector=[featurevector;i];

end

[r1 ,c1]=size(featurevector);
for i=1:r1
    for j=1:c1
        featureVector(i,j)=featurevector(i,j);
    end
end

end
