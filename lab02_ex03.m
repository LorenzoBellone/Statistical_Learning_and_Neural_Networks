%% Exercise 3 - Model fitting for continuous distributions
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

py = sum(ytrain == 1) / length(ytrain); % py is the prior probability of each class
py = horzcat(py, sum(ytrain == 2) / length(ytrain));


% x train is 900x600, 900 samples (campioni in italian)(documents) and 600 features (words).
% Let's count for each word, how many times it appears in each document belonging to a certain class.
% teta_jc_hat = Njc (the sum) 

class_1 = xtrain(1:size(xtrain,1)*0.5,:);
class_2 = xtrain((size(xtrain,1)*0.5)+1:end,:);

teta_j1 = sum(class_1)/(size(xtrain,1)*0.5); % teta is the conditional probability of each feature

teta_j2 = sum(class_2)/(size(xtrain,1)*0.5);

x1 = (1:600)';
y1 = full(teta_j1)';

x2 = (1:600)';
y2 = full(teta_j2)';

indexes_informative = x1(~(abs(y1*100-y2*100) <= mean(vertcat(y1*100, y2*100)*1))); % this removes the unimportant features

%%
teta_j1 %(~indexes_informative) = 0; %this substitutes with 0 the unimportant features
% 
teta_j2%(~indexes_informative) = 0; %this substitutes with 0 the unimportant features

%%
complement_teta_j1 = 1-teta_j1;
complement_xtest = ~xtest;
complement_xtest = complement_xtest .* complement_teta_j1;
likelihood_cj1 = xtest .* teta_j1;
likelihood_cj1 = complement_xtest + likelihood_cj1;


complement_teta_j2 = 1-teta_j2;
complement_xtest = ~xtest;
complement_xtest = complement_xtest .* complement_teta_j2;
likelihood_cj2 = xtest .* teta_j2;
likelihood_cj2 = complement_xtest + likelihood_cj2;


%%

log_likelihood_cj1 = log(likelihood_cj1);
sum_log_likelihood_cj1 = sum(log_likelihood_cj1, 2);

log_likelihood_cj2 = log(likelihood_cj2);
sum_log_likelihood_cj2 = sum(log_likelihood_cj2, 2);

y_hat = zeros(size(sum_log_likelihood_cj1));
y_hat(sum_log_likelihood_cj1 > sum_log_likelihood_cj2) = 1;
y_hat(~ (sum_log_likelihood_cj1 > sum_log_likelihood_cj2)) = 2;

x = y_hat == ytest
sum_x = sum(x)
len = length(x)
prob = (sum_x / len )*100


%%
complement_teta_j1 = 1-teta_j1;
complement_xtrain = ~xtrain;
complement_xtrain = complement_xtrain .* complement_teta_j1;
likelihood_cj1_tr = xtrain .* teta_j1;
likelihood_cj1_tr = complement_xtrain + likelihood_cj1_tr;


complement_teta_j2 = 1-teta_j2;
complement_xtrain = ~xtrain;
complement_xtrain = complement_xtrain .* complement_teta_j2;
likelihood_cj2_tr = xtrain .* teta_j2;
likelihood_cj2_tr = complement_xtrain + likelihood_cj2_tr;


%%

log_likelihood_cj1_tr = log(likelihood_cj1_tr);
sum_log_likelihood_cj1_tr= sum(log_likelihood_cj1_tr, 2);

log_likelihood_cj2_tr = log(likelihood_cj2_tr);
sum_log_likelihood_cj2_tr = sum(log_likelihood_cj2_tr, 2);

y_hat_tr = zeros(size(sum_log_likelihood_cj1_tr));
y_hat_tr(sum_log_likelihood_cj1_tr > sum_log_likelihood_cj2_tr) = 1;
y_hat_tr(~ (sum_log_likelihood_cj1_tr > sum_log_likelihood_cj2_tr)) = 2;

x_tr = y_hat_tr == ytrain;
sum_x_tr = sum(x_tr);
len = length(x_tr);
prob_tr = (sum_x_tr / len )*100

