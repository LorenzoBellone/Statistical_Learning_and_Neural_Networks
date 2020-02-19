%% Exercise 1 - Model fitting for continuous distributions
% Implemented by Lorenzo Belone, Victor Morini


% cleaning procedure
clear
close all
clc


% load data
load XwindowsDocData.mat

% calculating pi which is Nc/N, where Nc is the total number of elements in
% class 1 and so on, for all classes. N is the total number of measured
% elements.

py = sum(ytrain == 1) / length(ytrain);
py = horzcat(py, sum(ytrain == 2) / length(ytrain));


% x train is 900x600, 900 samples(documents) and 600 features (words).
% Let's count for each word, how many times it appears in each document belonging to a certain class.
% teta_jc_hat = Njc (the sum) 

class_1 = xtrain(1:size(xtrain,1)*0.5,:);
class_2 = xtrain((size(xtrain,1)*0.5)+1:end,:);

teta_j1 = sum(class_1)/450;

teta_j2 = sum(class_2)/450;

x1 = (1:600)';
y1 = full(teta_j1)';
new = horzcat(y1, x1);
 
h = bar(x1, y1*100, 'LineWidth', 2);
xlabel('features')
ylabel('[%]')
title('class conditional densities \Theta_j_1 - p(xj=1|y=1)')
legend({'\Theta_j_1'})

figure();
x2 = (1:600)';
y2 = full(teta_j2)';
new = horzcat(y2, x2);
 
h = bar(x2, y2*100, 'LineWidth', 2);
xlabel('features')
ylabel('[%]')
title('class conditional densities (\Theta_j_2) - p(xj=1|y=2)')
legend({'\Theta_j_2'})

%% informative features:
indexes_informative = x1(~(abs(y1*100-y2*100) <= 1));
    
