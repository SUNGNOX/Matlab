%% 平移搜索圆平面
% path为文件路径，file为文件名
% FitMethod为拟合方法有'PinMian'平面拟合和'ErCiQuMian'二次曲面拟合
% step为搜索初值，diff_mode为差分方式'Landscape'为横向差分,'Portrait'为纵向差分
% accuracy为值的精度，threshold为标定圆边界的门限
%2017-8-20
function higher=plot_zlq_function4(path,file,FitMethod,step, diff_mode, accuracy,threshold)
    clmn_threshold=threshold;%列门限
    row_threshold=threshold;%行门限
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
% 得到差分图D
    switch diff_mode
        case 'Portrait'
            for g=2:l1
                for s=2:l2
                    D(s,g)=Y(s,g)-Y(s,g-1);
                end
            end
        case 'Landscape'
            for s=2:l2
                for g=2:l1
                    D(s,g)=Y(s,g)-Y(s-1,g);
                end
            end
        otherwise 
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

% 曲面拟合
        
    MY(sc(1):sc(end), sr(1):sr(end))=0;
    for t1=1:l2
        ft((1+(t1-1)*l1):(l1+(t1-1)*l1))=MY(t1,:);
    end
    ft(ft==0)=[];
    fx1=x1(ft); fx2=x2(ft); fy=y(ft);
    [X1,X2] = meshgrid(x11,x22);
%     平面拟合
    switch FitMethod
        case 'PinMian'
            X = [ones(length(ft),1) fx1 fx2];  
            b = regress(fy,X); 
            b(4:6)=0;
%     二次曲面拟合
        case 'ErCiQuMian'
            X = [ones(length(ft),1) fx1 fx2 fx1.*fx1 fx2.*fx2 fx1.*fx2];  
            b = regress(fy,X);
        otherwise
            fprintf('error in fitmethod!!\n');
    end
    YFIT = b(1) + b(2)*X1  + b(3)*X2 + b(5)*X2.*X2 + b(4)*X1.*X1 + b(6)*X1.*X2;
    % 圆面所在区域的原图和平台拟合面
    YD=Y(sc(1):sc(end), sr(1):sr(end));
    YDFIT=YFIT(sc(1):sc(end), sr(1):sr(end));
    D0=YD-YDFIT;
    [b0,b1]=find(D0>0);
	xx0 = b0;
	xx1 = b1; 
    for k=1:length(xx0)
        fdy(k) = YDFIT(xx0(k), xx1(k));
        fd(k) = YD(xx0(k), xx1(k));
    end
    %% 按步长搜索（使得fd与yfd的差值在精度范围之内为止）
    n=1;
    ydf = fdy;% ydf与平台拟合面平行
    while (1)
        if mean(fd - ydf)>0
            constant = n*step;
            ydf0 = ydf;
            ydf = constant + ydf;
        elseif abs(mean(fd - ydf))<accuracy
            break
        elseif mean(fd - ydf)<0
            n = n/2;
            ydf = n*step + ydf0;
            if n==0
                break
            end
        end
    end
    % 得到高
    higher=abs(mean(fdy-ydf));
    %% 画图
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
    imagesc(1:l1,1:l2,D)
    hold on
    plot([1:l1],result_clmn(1)*ones(1,l1),'r');plot([1:l1],result_clmn(2)*ones(1,l1),'r')
    plot(result_row(1)*ones(1,l2),[1:l2],'r');plot(result_row(2)*ones(1,l2),[1:l2],'r')
    title([file,'利用差分图标记圆面范围'])
    grid minor;
    set(a,'YDir','reverse','YLim',[1 l2],'YMinorGrid','on','position',[50/(l1+300) 250/(l2+300) 200/(l1+300) l2/(l2+300)])
    set(b,'XLim',[1 l1],'XMinorGrid','on','position',[250/(l1+300) 50/(l2+300) l1/(l1+300) 200/(l2+300)])
    set(c,'XTicklabel',[],'YTicklabel',[],'position',[250/(l1+300) 250/(l2+300) l1/(l1+300) l2/(l2+300)])
    
    figure
    plot3(xx1+sr(1)-1,xx0+sc(1)-1,ydf,'.')
    hold on
    plot3(xx1+sr(1)-1,xx0+sc(1)-1,fdy,'.')
    mesh(Y)
    title('圆内面拟合、平台面拟合、原图')
    fprintf('高度为%f\n',higher)
