clear
clc
close all
for k=5%1:31
try
Landscape=0;%横向
Portrait=1;%纵向
zlq=load(['沈飞阶差采集/',num2str(k),'.txt']);
%% 预处理(去掉NAN)
%-防止第一组值为nan
if isnan(sum(abs(zlq(1,:))))
    for i = 2:length(zlq(:,1))
        if isnan(sum(abs(zlq(i,:)))) == 0
            zlq(1,:)=zlq(i,:);
        end
    end
end
%-令nan组的值等于前一组
for i = 2:length(zlq(:,1))
    if isnan(sum(abs(zlq(i,:))))
        zlq(i,:) = zlq(i-1,:);
    end
end

%% 得到原图像的矩阵形式
x1 = zlq(:,1); x11 = sort(x1);x11 = unique(x11);
x2 = zlq(:,2); x22 = sort(x2);x22 = unique(x22);
y=zlq(:,3); c = length(y);
l1=length(x11);
l2=length(x22);
Y=zeros(l2,l1);
Y2=zeros(l2,l1);
% Y2(1,:)=Y(1,:);
% Y2(end,:)=Y(end,:);
% Y2(:,1)=Y(:,1);
% Y2(:,end)=Y(:,end);
for i = 1:c
    a1 = find(x11 == x1(i));
    a2 = find(x22 == x2(i));
    Y(a2,a1) = y(i);
end

% for s=2:l2-1
%     for g=2:l1-1
%         m=Y(s-1:s+1,g-1:g+1);
%         m2=[m(1,:),m(2,:),m(3,:)];
%         m3=sort(m2);
%         Y2(s,g)=m3(5);
%     end
% end
if Portrait==1
    for g=2:l1
        for s=2:l2
            D(s,g)=Y(s,g)-Y(s,g-1);
        end
    end
elseif Landscape==1
 	for s=2:l2
        for g=2:l1
            D(s,g)=Y(s,g)-Y(s,g-1);
        end
	end
else 
    fprintf('Error in difference mode!');
end
D=abs(abs(D));
for s=3:l2
    clmn(s)=abs(sum((D(s,:)-D(s-1,:)).^3));
end
for g=3:l1
    row(g)=abs(sum((D(:,g)-D(:,g-1)).^3));
end
f1=figure(2*k-1);
set(f1,'Position',[800 100 l1+300 l2+300])
a=subplot(311);
plot((clmn(2:end-2)),2:l2-2)
hold on
plot(mean((clmn(2:end-1)))*ones(1,l2),1:l2,'r')
% title([num2str(k),'.txt'])
hold on
b=subplot(312);
plot(2:l1-2,(row(2:end-2)))
hold on
plot(1:l1,mean((row(2:end-1)))*ones(1,l1),'r')
c=subplot(313);
imagesc(1:l1,1:l2,Y)
title([num2str(k),'.txt原图'])
grid minor;
set(a,'YDir','reverse','YLim',[1 l2],'YMinorGrid','on','position',[50/(l1+300) 250/(l2+300) 200/(l1+300) l2/(l2+300)])
set(b,'XLim',[1 l1],'XMinorGrid','on','position',[250/(l1+300) 50/(l2+300) l1/(l1+300) 200/(l2+300)])
set(c,'XTicklabel',[],'YTicklabel',[],'position',[250/(l1+300) 250/(l2+300) l1/(l1+300) l2/(l2+300)])
f2=figure(2*k);
set(f2,'Position',[800-l1 100 l1+100 l2+100])
d=subplot(1,1,1);
imagesc(1:l1,1:l2,D);
set(d,'position',[50/(l1+100) 50/(l2+100) l1/(l1+100) l2/(l2+100)])
if ~exist('.\原图')
    mkdir('原图')
end
if ~exist('.\横向差分图')
    mkdir('横向差分图')
end
% saveas(f1,['./原图/',num2str(k),'.txt原图.jpg'])
% saveas(f2,['./横向差分图/',num2str(k),'.txt横向差分图.jpg'])
% figure
% imagesc(D)
% figure
% imagesc(Y)
% figure
% imagesc(D2)
catch
    fprintf([num2str(k),'.txt错误\n']);
end
% figure
% mesh(Y)
% hold on
% mesh(Y2(2:end-1,2:end-1))
clear
% close all
end