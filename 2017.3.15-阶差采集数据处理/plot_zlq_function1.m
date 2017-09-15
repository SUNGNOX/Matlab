%% �����߽�����Բ��
%pathΪ�ļ�·����fileΪ�ļ�����stepΪ����Բ�߽�Ĳ���
%FitMethodΪ��Ϸ�����'PinMian'ƽ����Ϻ�'ErCiQuMian'�����������
%2017-8-17
function higher=plot_zlq_function1(path,file,step,FitMethod)
    Landscape=0;%������
    Portrait=1;%������
    clmn_threshold=1e-4;%������
    row_threshold=1e-4;%������
    zlq=load([path,'/',file]);
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
    D=abs(abs(D));
    for s=3:l2
        clmn(s)=abs(sum((D(s,:)-D(s-1,:)).^3));
    end
    for g=3:l1
        row(g)=abs(sum((D(:,g)-D(:,g-1)).^3));
    end
% �ⶨ�߽�
    clmn(end)=0;
    sort_clmn = 1:l2;
    sc = sort_clmn(clmn>clmn_threshold);
    result_clmn = [sc(1),sc(end)];
    row(end)=0;
    sort_row = 1:l1;
    sr = sort_row(row>row_threshold);
    result_row = [sr(1),sr(end)];
%    
    sl=1:l1;
    for z=1:l2
        MY(z,:)=sl+(z-1)*l1;
    end
%     
    bc=sc(end)-sc(1);
    br=sr(end)-sr(1);
    bound=0;
    if sc(1)==3
        bound=1;
        if br/2<bc
            bound=5;
        end
    elseif sc(end)==length(sc)-1
        bound=2;
        if br/2<bc
            bound=5;
        end
    elseif sr(1)==3
        bound=3;
        if bc/2<br
            bound=5;
        end
    elseif sr(end)==length(sr)-1
        bound=4;
        if bc/2<br
            bound=5;
        end
    end
    switch bound
        case 1 
            inner_point = [result_row(1)+step,result_clmn(1);result_row(2)-step,result_clmn(1);...
                floor((result_row(1)+result_row(2))/2),result_clmn(2)];
        case 2
            inner_point = [result_row(1)+step,result_clmn(2);result_row(1)-step,result_clmn(2);...
                floor((result_row(1)+result_row(2))/2),result_clmn(1)];
        case 3
            inner_point = [result_row(2)-step,floor((result_clmn(1)+result_clmn(2))/2);result_row(1),result_clmn(1)+step;...
                result_row(1),result_clmn(2)-step];
        case 4
            inner_point = [result_row(1)-step,floor((result_clmn(1)+result_clmn(2))/2);result_row(2),result_clmn(1)+step;...
                result_row(2),result_clmn(2)-step];
        case 5
            inner_point = [result_row(1)+step,floor((result_clmn(1)+result_clmn(2))/2);floor((result_row(1)+result_row(2))/2),result_clmn(1)+step;...
                floor((result_row(1)+result_row(2))/2),result_clmn(2)-step];   
    end
    
% ����ڵ�ֵ
    inner=[Y(inner_point(1,2),inner_point(1,1)),Y(inner_point(2,2),inner_point(2,1)),...
        Y(inner_point(3,2),inner_point(3,1))];

% �������
        
    MY(sc(1):sc(end), sr(1):sr(end))=0;
    for t1=1:l2
        ft((1+(t1-1)*l1):(l1+(t1-1)*l1))=MY(t1,:);
    end
    ft(ft==0)=[];
    fx1=x1(ft); fx2=x2(ft); fy=y(ft);
    [X1,X2] = meshgrid(x11,x22);
%     ƽ�����
    switch FitMethod
        case 'PinMian'
            X = [ones(length(ft),1) fx1 fx2];  
            b = regress(fy,X);
            YFIT = b(1) + b(2)*X1 + b(3)*X2; 
%     �����������
        case 'ErCiQuMian'
            X = [ones(length(ft),1) fx1.*fx1 fx1 fx2.*fx2 fx2 fx1.*fx2];  
            b = regress(fy,X);
            YFIT = b(1) + b(2)*X1.*X1+b(3)*X1 + b(4)*X2.*X2 + b(5)*X2 + b(6)*X1.*X2; 
        otherwise
            fprintf('error in fitmethod!!\n');
    end
   
    outer=[YFIT(inner_point(1,2),inner_point(1,1)),YFIT(inner_point(2,2),inner_point(2,1)),...
        YFIT(inner_point(3,2),inner_point(3,1))];

    higher=abs(mean(inner)-mean(outer));

    f1=figure;
    set(f1,'Position',[200 10 l1+300 l2+300])
    a=subplot(311);
    plot((clmn(2:end-2)),2:l2-2)
    hold on
    plot(clmn_threshold,1:l2,'r')
    hold on
    b=subplot(312);
    plot(2:l1-2,(row(2:end-2)))
    hold on
    plot(1:l1,row_threshold,'r')
    c=subplot(313);
    imagesc(1:l1,1:l2,Y)
    hold on
    plot([1:l1],result_clmn(1)*ones(1,l1),'r');plot([1:l1],result_clmn(2)*ones(1,l1),'r')
    plot(result_row(1)*ones(1,l2),[1:l2],'r');plot(result_row(2)*ones(1,l2),[1:l2],'r')
    plot(inner_point(:,1),inner_point(:,2),'r*')
    title([file,'ԭͼ'])
    grid minor;
    set(a,'YDir','reverse','YLim',[1 l2],'YMinorGrid','on','position',[50/(l1+300) 250/(l2+300) 200/(l1+300) l2/(l2+300)])
    set(b,'XLim',[1 l1],'XMinorGrid','on','position',[250/(l1+300) 50/(l2+300) l1/(l1+300) 200/(l2+300)])
    set(c,'XTicklabel',[],'YTicklabel',[],'position',[250/(l1+300) 250/(l2+300) l1/(l1+300) l2/(l2+300)])
    f2=figure;
    set(f2,'Position',[800-l1 100 l1+100 l2+100])
    d=subplot(1,1,1);
    imagesc(1:l1,1:l2,D);
    set(d,'position',[50/(l1+100) 50/(l2+100) l1/(l1+100) l2/(l2+100)])
    title([file,'���ͼ'])
    figure
    mesh(YFIT)
    hold on
    mesh(Y)
    fprintf('�߶�Ϊ%f\n',higher)
