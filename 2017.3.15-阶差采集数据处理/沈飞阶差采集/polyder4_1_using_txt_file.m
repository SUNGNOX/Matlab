% function [high,jx1,jx2,jy1,jy2]=polyder4_1(zlq,step,islinear,ismax)
  clear all
  islinear=1;
  ismax=1;
  step = 50;
  zlq=load('C:\tkx\project\沈飞\沈飞阶差采集\沈飞阶差采集\24.txt');
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
clear All;
for i = 1:c
    a1 = find(x11 == x1(i));
    a2 = find(x22 == x2(i));
    Y(a2,a1) = y(i);
end


if(islinear==0)
    %% 线性回归求二元二次多项式拟合系数
    X = [ones(size(x1)) x1.*x1 x1 x2.*x2 x2 x1.*x2];  
    b = regress(y,X);
    [X1,X2] = meshgrid(x11,x22);
    YFIT = b(1) + b(2)*X1.*X1+b(3)*X1 + b(4)*X2.*X2 + b(5)*X2 + b(6)*X1.*X2;  
else
    %% 线性回归求二元线性多项式拟合系数
     X = [ones(size(x1)) x1 x2];  
     b = regress(y,X);
     [X1,X2] = meshgrid(x11,x22); 
     YFIT =  b(1) +b(2)*X1+b(3)*X2;
end
%% 差分
D=YFIT-Y;
%% 画图
 figure
 mesh(X1,X2,Y)%原图

% figure
% SortY = reshape(Y,[],1);
% SortY = sort(SortY);
% plot(SortY);
% hold on
% figure
% mesh(X1,X2,YFIT)%拟合后
% figure
% mesh(X1,X2,D)%差分

% figure
% SortD = reshape(D, [], 1);
% SortD = sort(SortD);
% plot(SortD);
step = 50;
%% 搜索坑区
D0 = sum(D); %一行元素 748
D1 = sum(D'); %一列元素 640
while (1)
    [a1,a2] = find(D0 == max(D0));
    jx1 = a2 - step; jx2 = a2 + step;
    if jx1 < 1 || jx2 > length(D0)
        D0(a2) = 0;
    else
        break
    end
end
while (1)
    [b1,b2] = find(D1 == max(D1));
    jy1 = b2 - step; jy2 = b2 + step;
    if jy1 < 1 || jy2 > length(D1)
        D1(b2) = 0;
    else
        break
    end
end
if(ismax==1)
    high = max(max(D(jy1:jy2,jx1:jx2)));%得到最值
else
    high = mean(mean(D(jy1:jy2,jx1:jx2)));%得到最值
end
clear zlq;
clear x1;
clear x11;
clear x2;
clear x22;
clear y;
clear Y;
clear D1;
clear X;
clear b;
clear X1;
clear X2;
clear YFIT;
clear D;
clear D0;
clear D1;
%[q1, q2] = find(D == high);
% for i=jx1:jx2
% for j=jy1:jy2
%   index=sub2ind(size(Y),j,i);
% Y(index)=-0.1;  
% end
% end

% figure
% mesh(X1,X2,Y)%差分
end
%% 把矩阵存储为原格式txt文本
% for i = 1:480
%     f(748*(i-1)+1:748*i) = YFIT(i,:);
%     c(748*(i-1)+1:748*i) = D(i,:);
% end
% fit_post(:,1:2)=zlq(:,1:2);
% difference(:,1:2)=zlq(:,1:2);
% fit_post(:,3)=f;
% difference(:,3)=c;
% save2txt('fit_post.txt',fit_post);
% save2txt('difference.txt',difference);