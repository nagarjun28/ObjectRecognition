%% Important Variables
% a     : Input image
% kpmag : keypoints magnitude
% kpori : keypoints orientation
% kpd   : key point descriptors
% kp    : keypoints
% kpl   : keypoint locations

function [KP,KPL,KPORI,KPMAG,KPD,Fig] = SIFT(a)

%a=imread('triangle.jpg');
% figure,imshow(a);
% title('Selected image');
[m,n,plane]=size(a);
if plane==3
a=rgb2gray(a);
end
a=im2double(a);
original=a;
store1=[];
store2=[];
store3=[];
tic
%% 1st octave generation
k2=0; 
a(m:m+6,n:n+6)=0;
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*1.6;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=a(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store1=[store1 c];
end
clear a;
a=imresize(original,1/((k2+1)*2));

%% 2nd Octave generation
k2=1;
[m,n]=size(a);
a(m:m+6,n:n+6)=0;
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*1.6;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=a(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store2=[store2 c];
end
clear a;
a=imresize(original,1/((k2+1)*2));

%% 3rd octave generation
k2=2;
[m,n]=size(a);
a(m:m+6,n:n+6)=0;
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*1.6;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=a(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store3=[store3 c];          % c(64x64) value
end
[m,n]=size(original);
fprintf('\nTime taken for Pyramid level generation is :%f\n',toc);

%% Obtaining key point from the image
i1=store1(1:m,1:n)-store1(1:m,n+1:2*n);
i2=store1(1:m,n+1:2*n)-store1(1:m,2*n+1:3*n);
i3=store1(1:m,2*n+1:3*n)-store1(1:m,3*n+1:4*n);
[m,n]=size(i2);
kp=[];
kpl=[];
tic
for i=2:m-1
    for j=2:n-1
        x=i1(i-1:i+1,j-1:j+1);
        y=i2(i-1:i+1,j-1:j+1);
        z=i3(i-1:i+1,j-1:j+1);
        y(1:4)=y(1:4);
        y(5:8)=y(6:9);
        mx=max(max(x));
        mz=max(max(z));
        mix=min(min(x));
        miz=min(min(z));
        my=max(max(y));
        miy=min(min(y));
        if (i2(i,j)>my && i2(i,j)>mz) || (i2(i,j)<miy && i2(i,j)<miz && i2(i,j)<mix)
            kp=[kp i2(i,j)];
            kpl=[kpl i j];
        end
    end
end
fprintf('\nTime taken for finding the key points is :%f\n',toc);

%% Key points plotting on to the image
for i=1:2:length(kpl);
    k1=kpl(i);
    j1=kpl(i+1);
    i2(k1,j1)=1;
end
Fig=i2;
% figure, imshow(i2);
% title('Image with key points mapped onto it');

%%Komal write comment :)
for i=1:m-1
    for j=1:n-1
         mag(i,j)=sqrt(((i2(i+1,j)-i2(i,j))^2)+((i2(i,j+1)-i2(i,j))^2));
         oric(i,j)=atan2(((i2(i+1,j)-i2(i,j))),(i2(i,j+1)-i2(i,j)))*(180/pi);
    end
end

%% Forming key point neighbourhooods 5x5
kpmag=[];
kpori=[];
kplo=[];
kpn=[];
addkp=0;
for x1=1:2:length(kpl)
    k1=kpl(x1);
    j1=kpl(x1+1);
    addkp=addkp+1;
    if k1 > 2 && j1 > 2 && k1 < m-2 && j1 < n-2
    p1=mag(k1-2:k1+2,j1-2:j1+2);
    q1=oric(k1-2:k1+2,j1-2:j1+2);
    else
        continue;
    end
    %% Finding orientation and magnitude for the key point
[m1,n1]=size(p1);
magcounts=[];
for x=0:10:359   % 0 to 359 degree values for sepating into 36 bins
    magcount=0;
for i=1:m1
    for j=1:n1
        ch1=-180+x;
        ch2=-171+x;
        if ch1<0  ||  ch2<0
        if abs(q1(i,j))<abs(ch1) && abs(q1(i,j))>=abs(ch2)
            ori(i,j)=(ch1+ch2+1)/2;
            magcount=magcount+p1(i,j);
        end
        else
        if abs(q1(i,j))>abs(ch1) && abs(q1(i,j))<=abs(ch2)
            ori(i,j)=(ch1+ch2+1)/2;
            magcount=magcount+p1(i,j);
        end
        end
    end
end
magcounts=[magcounts magcount];
end
[maxvm maxvp]=max(magcounts);
kmag=maxvm;
kori=(((maxvp*10)+((maxvp-1)*10))/2)-180;
kpmag=[kpmag kmag];
kpori=[kpori kori];
kplo=[kplo k1 j1];
kpn=[kpn kp(addkp)];
% maxstore=[];
% for i=1:length(magcounts)
%     if magcounts(i)>=0.8*maxvm
%         maxstore=[maxstore magcounts(i) i];
%     end
% end
% 
% if maxstore > 2
%     kmag=maxstore(1:2:length(maxstore));
%     maxvp1=maxstore(2:2:length(maxstore));
%     temp=(countl((2*maxvp1)-1)+countl(2*maxvp1)+1)/2;
%     kori=temp;
% end
end
fprintf('\nTime taken for magnitude and orientation assignment is :%f\n',toc);


%% Forming key point Descriptors
KPD=[];
KPL=[];
KP=[];
KPORI=[];
KPMAG=[];
newcnt=0;
for x1=1:2:length(kplo)
    kk1=kplo(x1);
    jj1=kplo(x1+1);
    newcnt=newcnt+1;    
    if kk1 > 7 && jj1 > 7 && kk1 < m-8 && jj1 < n-8
    p2=mag(kk1-7:kk1+8,jj1-7:jj1+8);
    q2=oric(kk1-7:kk1+8,jj1-7:jj1+8);           %16x16 matrices
    else
        continue;
    end
    kpmagd=[];
    kporid=[];
%% Dividing into 4x4 blocks
    for k1=1:4
        for j1=1:4
            p1=p2(1+(k1-1)*4:k1*4,1+(j1-1)*4:j1*4);
            q1=q2(1+(k1-1)*4:k1*4,1+(j1-1)*4:j1*4);  
            [m1,n1]=size(p1);
            magcounts=[];
            for x=0:45:359
                magcount=0;
            for i=1:m1
                for j=1:n1
                    ch1=-180+x;
                    ch2=-180+45+x;
                    if ch1<0  ||  ch2<0
                    if abs(q1(i,j))<abs(ch1) && abs(q1(i,j))>=abs(ch2)
                        ori(i,j)=(ch1+ch2+1)/2;
                        magcount=magcount+p1(i,j);
                    end
                    else
                    if abs(q1(i,j))>abs(ch1) && abs(q1(i,j))<=abs(ch2)
                        ori(i,j)=(ch1+ch2+1)/2;
                        magcount=magcount+p1(i,j);
                    end
                    
                    end
                end
            end
            magcounts=[magcounts magcount];
            end
            kpmagd=[kpmagd magcounts];
        end
    end
    KPD=[KPD; kpmagd];
    KPL=[KPL; kk1 jj1];
    KP=[KP; kpn(newcnt)];
    KPORI=[KPORI; kpori(newcnt)];
    KPMAG=[KPMAG; kpmag(newcnt)];
    
end
fprintf('\nTime taken for finding key point desctiptors is :%f\n',toc);
end
