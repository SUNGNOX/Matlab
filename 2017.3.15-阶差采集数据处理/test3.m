close all
clear
% path='����';
% file='hits-3.txt';
path='.';
file='��Բ-1.txt';
accuracy = 1e-3;
step = 0.2;
threshold = 1e-4;
higher=plot_zlq_function4(path,file,'PinMian',step, 'Landscape', accuracy, threshold);