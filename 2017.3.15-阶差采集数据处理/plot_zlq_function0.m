function higher=plot_zlq_function0(path,file,step)%path为文件路径，file为文件名，step为距离圆边界的步长
    Landscape=0;%横向
    Portrait=1;%纵向
    zlq=load([path,'/',file]);
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
% 测定边界
    mean_clmn = mean((clmn(2:end-1)))*ones(1,l2);%均值
    clmn(end)=0;
    sort_clmn = 1:l2;
    sc = sort_clmn(clmn>mean_clmn);
    result_clmn = [sc(1),sc(end)];
    mean_row = mean((row(2:end-1)))*ones(1,l1);
    row(end)=0;
    sort_row = 1:l1;
    sr = sort_row(row>mean_row);
    result_row = [sr(1),sr(end)];
% 标记内点值
    inner_point = [floor((result_row(1)+result_row(2))/2),result_clmn(1)+step;floor((result_row(1)+result_row(2))/2),result_clmn(2)-step;...
        result_row(1)+step,floor((result_clmn(1)+result_clmn(2))/2);result_row(2)-step,floor((result_clmn(1)+result_clmn(2))/2)];
    inner=[Y(inner_point(1,2),inner_point(1,1)),Y(inner_point(2,2),inner_point(2,1)),...
        Y(inner_point(3,2),inner_point(3,1)),Y(inner_point(4,2),inner_point(4,1))];
    inner0 = mean(inner);

% 曲面拟合
% 
%     X = [ones(size(x1)) x1.*x1 x1 x2.*x2 x2 x1.*x2];  
%     b = regress(y,X);
%     [X1,X2] = meshgrid(x11,x22);
%     YFIT = b(1) + b(2)*X1.*X1+b(3)*X1 + b(4)*X2.*X2 + b(5)*X2 + b(6)*X1.*X2; 
% 
    X = [ones(size(x1)) x1 x2];  
    b = regress(y,X);
    [X1,X2] = meshgrid(x11,x22);
    YFIT = b(1) + b(2)*X1 + b(3)*X2; 
    
    outer=[YFIT(inner_point(1,2),inner_point(1,1)),YFIT(inner_point(2,2),inner_point(2,1)),...
        YFIT(inner_point(3,2),inner_point(3,1)),YFIT(inner_point(4,2),inner_point(4,1))];

    higher=abs(mean(inner)-mean(outer));

    f1=figure;
    set(f1,'Position',[200 10 l1+300 l2+300])
    a=subplot(311);
    plot((clmn(2:end-2)),2:l2-2)
    hold on
    plot(mean_clmn,1:l2,'r')
    hold on
    b=subplot(312);
    plot(2:l1-2,(row(2:end-2)))
    hold on
    plot(1:l1,mean_row,'r')
    c=subplot(313);
    imagesc(1:l1,1:l2,Y)
    hold on
    plot([1:l1],result_clmn(1)*ones(1,l1),'r');plot([1:l1],result_clmn(2)*ones(1,l1),'r')
    plot(result_row(1)*ones(1,l2),[1:l2],'r');plot(result_row(2)*ones(1,l2),[1:l2],'r')
    plot(inner_point(:,1),inner_point(:,2),'r*')
    title([file,'原图'])
    grid minor;
    set(a,'YDir','reverse','YLim',[1 l2],'YMinorGrid','on','position',[50/(l1+300) 250/(l2+300) 200/(l1+300) l2/(l2+300)])
    set(b,'XLim',[1 l1],'XMinorGrid','on','position',[250/(l1+300) 50/(l2+300) l1/(l1+300) 200/(l2+300)])
    set(c,'XTicklabel',[],'YTicklabel',[],'position',[250/(l1+300) 250/(l2+300) l1/(l1+300) l2/(l2+300)])
    f2=figure;
    title('差分图')
    set(f2,'Position',[800-l1 100 l1+100 l2+100])
    d=subplot(1,1,1);
    imagesc(1:l1,1:l2,D);
    set(d,'position',[50/(l1+100) 50/(l2+100) l1/(l1+100) l2/(l2+100)])
    f3=figure;
    set(f3,'Position',[800-l1 100 l1+100 l2+100])
    e=subplot(1,1,1);
    imagesc(1:l1,1:l2,YFIT);
    title('拟合后图')
    set(e,'position',[50/(l1+100) 50/(l2+100) l1/(l1+100) l2/(l2+100)])
    fprintf('高度为%f\n',higher)
