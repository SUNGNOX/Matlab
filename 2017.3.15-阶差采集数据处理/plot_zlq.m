clear
clc
close all
for k=1:31
    figure
try
zlq=load(['��ɽײ�ɼ�/',num2str(k),'.txt']);
%% Ԥ����(ȥ��NAN)
%-��ֹ��һ��ֵΪnan
if isnan(sum(abs(zlq(1,:))))
    for i = 2:length(zlq(:,1))
        if isnan(sum(abs(zlq(i,:)))) == 0
            zlq(1,:)=zlq(i,:);
        end
    end
end  
%-��nan���ֵ����ǰһ��
for i = 2:length(zlq(:,1))
    if isnan(sum(abs(zlq(i,:))))
        zlq(i,:) = zlq(i-1,:);
    end
end

%% �õ�ԭͼ��ľ�����ʽ
x1 = zlq(:,1); x11 = sort(x1);x11 = unique(x11);
x2 = zlq(:,2); x22 = sort(x2);x22 = unique(x22);
y=zlq(:,3); c = length(y);
for i = 1:c
    a1 = find(x11 == x1(i));
    a2 = find(x22 == x2(i));
    Y(a2,a1) = y(i);
end

%% ���Իع����Ԫ���ζ���ʽ���ϵ��
X = [ones(size(x1)) x1.*x2.*x2 x1.*x1.*x2 x1.*x1.*x1 x1.*x1 x1.*x2 x2.*x2 x1 x2];  
b = regress(y,X);
[X1,X2] = meshgrid(x11,x22);
YFIT = b(1) + b(2)*X1.*X2.*X2+b(3)*X1.*X1.*X2 + b(4)*X1.*X1.*X1 + b(5)*X1.*X1 + b(6)*X1.*X2 + b(7)*X2.*X2 + b(8)*X1 + b(9)*X2;  

%% ���
D=YFIT-Y;
%% ��ͼ
mesh(X1,X2,Y)%ԭͼ
hold on
mesh(X1,X2,YFIT)%��Ϻ�
mesh(X1,X2,D)%���
%% ��������
D0 = sum(D);
D1 = sum(D');
% �Ƴ��߽�����
while (1)
    [a1,a2] = find(D0 == max(D0));
    jx1 = a2 - 50; jx2 = a2 + 50;
    if jx1 < 1 || jx2 > length(D0)
        D0(a2) = 0;
    else
        break
    end
end
while (1)
    [b1,b2] = find(D1 == max(D1));
    jy1 = b2 - 50; jy2 = b2 + 50;
    if jy1 < 1 || jy2 > length(D1)
        D1(b2) = 0;
    else
        break
    end
end

%% ���Իع����Ԫ���ζ���ʽ���ϵ��
dx1=zeros(length(y),1);
dx2=zeros(length(y),1);
dy=zeros(length(y),1);
for m=1:length(x22)
    for n=1:length(x11)
        dx1((m-1)*length(X1)+n)=X1(m,n);
        dx2((m-1)*length(X1)+n)=X2(m,n);
        dy((m-1)*length(X1)+n)=D(m,n);
    end
end
X = [ones(size(dx1)) dx1.*dx1 dx1 dx2.*dx2 dx2 dx1.*dx2];  
b = regress(dy,X);
[X1,X2] = meshgrid(x11,x22);
DFIT = b(1) + b(2)*X1.*X1+b(3)*X1 + b(4)*X2.*X2 + b(5)*X2 + b(6)*X1.*X2; 
mesh(X1,X2,DFIT)
%%
high = max(max(D(jy1:jy2,jx1:jx2)));%�õ���ֵ
[q1, q2] = find(D == high);
catch
    fprintf([num2str(k),'.txt��ȡ����\n']);
end
clear
end
%% �Ѿ���洢Ϊԭ��ʽtxt�ı�
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