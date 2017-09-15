close all
clear all
% path='数据';
% file='hits-3.txt';
path='.';
file='半圆-1.txt';
%  higher=plot_zlq_function1(path,file,50,'PinMian');
% point_num=10;
% higher=plot_zlq_function3(path,file,'PinMian');
% higher=plot_zlq_function3(path,file,'ErCiQuMian');
accuracy = 1e-3;
step = 0.2;
threshold = 2e-4;
% diff_mode为差分方式'Landscape'为横向差分,'Portrait'为纵向差分
higher=plot_zlq_function4(path,file,'PinMian',step, 'Landscape', accuracy, threshold);