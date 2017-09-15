%% ��ͼ�ò��ͼDÿ�е����ֵ�����߽磨���м���Ϊ��׼����ʧ�ܡ�
clear
clc
close all
for k=1:31
% try
Landscape=0;%����
Portrait=1;%����
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
l1=length(x11);
l2=length(x22);
Y=zeros(l2,l1);
Y2=zeros(l2,l1);
for i = 1:c
    a1 = find(x11 == x1(i));
    a2 = find(x22 == x2(i));
    Y(a2,a1) = y(i);
end
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
D0=abs(abs(D));
edge=zeros(l2,l1);
ss0=1:l1;
m0=ss0;
s0=1;
for s=floor(l2/2):-1:2
    s0 = ss0(D0(s,m0) == max(D0(s,m0)))+s0(1)-1;
    if s0(1)-5>=1 && s0(1)+5<=l1
        D0(s,s0(1)-5:s0(1)+5)=0;
        m0=s0(1)-5:s0(1)+5;
    elseif s0(1)-5<1 && s0(1)+5<=l1
        D0(s,s0(1):s0(1)+5)=0;
        m0=1:s0(1)+5;
    elseif s0(1)-5>=1 && s0(1)+5>l1
        D0(s,s0(1)-5:s0(1))=0;
        m0=s0(1)-5:l1;
    end
    edge(s,s0(1))=1;
end

m0=ss0;
s0=1;
for s=floor(l2/2):l2
    s0 = ss0(D0(s,m0) == max(D0(s,m0)))+s0(1)-1;
    if s0(1)-5>=1 && s0(1)+5<=l1
        D0(s,s0(1)-5:s0(1)+5)=0;
        m0=s0(1)-5:s0(1)+5;
    elseif s0(1)-5<1 && s0(1)+5<=l1
        D0(s,s0(1):s0(1)+5)=0;
        m0=1:s0(1)+5;
    elseif s0(1)-5>=1 && s0(1)+5>l1
        D0(s,s0(1)-5:s0(1))=0;
        m0=s0(1)-5:l1;
    end
    edge(s,s0(1))=1;
end

m0=ss0;
for s=2:l2
    aa=0; bb=0; cc=0;
    s0 = ss0(D0(s,m0) == max(D0(s,m0)));
    if s0(1)-5>=1 && s0(1)+5<=l1
        m0=s0(1)-5:s0(1)+5;
    elseif s0(1)-5<1 && s0(1)+5<=l1
        m0=1:s0(1)+5;
    elseif s0(1)-5>=1 && s0(1)+5>l1
        m0=s0(1)-5:l1;
    end
    edge(s,s0(1))=1;
end

figure
imagesc(edge)
% catch
%     fprintf([num2str(k),'.txt����\n']);
% end

clear
% close all
end