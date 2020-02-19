% cleaning procedure
clear
close all 
clc

%load data
load Indian_Pines_Dataset

% choosing Class2 and Class14
class2=zeros(1428,220);
n=0;
for i=1:size(indian_pines,1)
    for j=1:size(indian_pines,2)
        if indian_pines_gt(i,j)== 2 % class index
            n=n+1;
            class2(n,:)= indian_pines(i,j,:);
        end
    end
end
class2_mean = mean(class2);
class2_test = class2 - class2_mean;

class14=zeros(1265,220);
n=0;
for i=1:size(indian_pines,1)
    for j=1:size(indian_pines,2)
        if indian_pines_gt(i,j)== 14 % class index
            n=n+1;
            class14(n,:)= indian_pines(i,j,:);
        end
    end
end
class14_mean = mean(class14);
class14_test = class14 - class14_mean;

x = [class2_test; class14_test];
sample_cov = (x')*(x);
sample_cov = sample_cov/length(x);
[eig_vect, eig_val] = eig(sample_cov);
res = []
for K=1:219
    W = eig_vect(:, end-K:end);
    Z = (W')*(x');
    x_hat = W * Z;
    J = (norm(x-x_hat'))^2
    J = J/length(x);
    res = horzcat(res,J);
end
plot(res)
