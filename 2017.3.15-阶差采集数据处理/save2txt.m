function back = save2txt( file_Name, matrix ) %�Ѿ���matrix�����txt�ļ���
Ma=round(matrix.*10^6)*10^-6;
fop = fopen( file_Name, 'wt' );
[M,N] = size(Ma);
for m = 1:M
for n = 1:N
fprintf( fop,'%s\t',mat2str(Ma(m,n)));
end
fprintf(fop,'\n');
end
back=fclose(fop);