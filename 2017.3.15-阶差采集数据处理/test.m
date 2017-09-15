clc; clear all; close all;
x = 1:60;
y = 5*x + 10;
y = y + 10*rand(1, size(x, 2));
data = [y' x']; % 60*2µÄ¾ØÕó
b = regress(data(:, 1), [data(:, 2) ones(size(data, 1), 1)]);figure; hold on; box on;
plot(x, y, 'r+');
xt = linspace(min(x), max(x));
yt = b(1)*xt + b(2);
plot(xt, yt, 'b-');
funstr = sprintf('y = %.3f*x + %.3f', b(1), b(2));
title([funstr ' By lyqmath'], 'FontWeight', 'Bold', 'Color', 'r');