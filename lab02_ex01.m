%% Exercise 1 - Model fitting for continuous distributions
% Implemented by Lorenzo Belone, Victor Morini

% load data
load heightWeight.mat

% giving that male is 1

male_idx = find(heightWeightData(:, 1) == 1);
male = heightWeightData(male_idx, :);

% giving that male is 2

female_idx = find(heightWeightData(:, 1) == 2);
female = heightWeightData(female_idx, :);

%% Plot the data using the scatter function
% 
% h = PlotScatterFilled(male(:, 2), male(:, 3), male(:, 1));
% h = PlotScatterFilled(female(:, 2), female(:, 3), female(:, 1), 2);
% set(h, 'MarkerFaceColor',[0 .7 .7])
% xlabel('height [cm]')
% ylabel('weight [kg]')
% legend({'male','female'})
% hold off
%%
figure()
subplot(2,2,1)
h1 = histogram(male(:, 2));
title('Male Height')
xlabel('height [cm]')
ylabel('occurences')
male_max_x = max(h1.BinEdges);
male_min_x = min(h1.BinEdges);
male_max_y = max(h1.Values);
male_min_y = min(h1.Values);

subplot(2,2,3)
h2 = histogram(female(:, 2));
title('Female Height')
xlabel('height [cm]')
ylabel('occurences')
female_max_x = max(h2.BinEdges);
female_min_x = min(h2.BinEdges);
female_max_y = max(h2.Values);
female_min_y = min(h2.Values);
%setting the x size
if male_max_x > female_max_x
    max_x = male_max_x;
else
    max_x = female_max_x;
end

if male_min_x < female_min_x
    min_x = male_min_x;
else
    min_x = female_min_x;
end
h1.BinLimits = [min_x, max_x];
h2.BinLimits = [min_x, max_x];

%setting the y size
% if male_max_y > female_max_y
%     max_y = male_max_y;
% else
%     max_y = female_max_y;
% end
% 
% if male_min_y < female_min_y
%     min_y = male_min_y;
% else
%     min_y = female_min_y;
% end
% h1.BinCounth = [min_y:5: max_y];
% h2.Values = [min_y:5:max_y];



subplot(2,2,2)
h1 = histogram(male(:, 3));
title('Male Weight')
xlabel('weight [kg]')
ylabel('occurences')
male_max_x = max(h1.BinEdges);
male_min_x = min(h1.BinEdges);

subplot(2,2,4)
h2 = histogram(female(:, 3));
title('Female Weight')
xlabel('weight [kg]')
ylabel('occurences')
female_max_x = max(h2.BinEdges);
female_min_x = min(h2.BinEdges);

if male_max_x > male_max_x
    max_x = male_max_x;
else
    max_x = female_max_x;
end

if male_min_x < male_min_x
    min_x = male_min_x;
else
    min_x = female_min_x;
end
h1.BinLimits = [min_x, max_x];
h2.BinLimits = [min_x, max_x];

%% Covariance Matrix 
mean_male = mean(male(:, 2:end));

mean_female = mean(female(:, 2:end));

covariance_male = cov(male(:, 2:end)); % as the nbr of faeatures are 2, the covariance matrix should be 2x2, if n, nxn, etc

covariance_female = cov(female(:, 2:end));

% cov_male = ((male(:, 2:end)-mean_male)*(male(:, 2:end)-mean_male)')/length(male)
%% Multivariate normal probability density function (pdf)

% mu is the mean
% X is a matrix, with n columns, with n the nbr of features, and x rows,
% with the number of observations
y = mvnpdf(male(:, 2:end), mean_male, covariance_male)
%% Plotting 3D

figure
x1 = min(male(:, 2)):1:max(male(:, 2));
x2 = min(male(:, 3)):1:max(male(:, 3));
[X1,X2] = meshgrid(x1,x2);
F = mvnpdf([X1(:) X2(:)], mean_male, covariance_male);
F = reshape(F, length(x2), length(x1)); 
surf(x1, x2,F); 
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
axis([160 205 50 130 0 max(F(:))]) 
xlabel('weight'); 
ylabel('height'); 
zlabel('Probability Density - males');

hold on

figure
x1 = min(female(:, 2)):1:max(female(:, 2));
x2 = min(female(:, 3)):1:max(female(:, 3));
[X1,X2] = meshgrid(x1,x2);
F = mvnpdf([X1(:) X2(:)], mean_female, covariance_female);
F = reshape(F, length(x2), length(x1)); 
surf(x1, x2,F); 
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
axis([160 205 50 130 0 max(F(:))]) 
xlabel('weight'); 
ylabel('height'); 
zlabel('Probability Density - females');


function h = PlotScatterFilled(varargin)
% begin function initialization
    numvarargs = length(varargin);
    if numvarargs > 5
        error('myfuns:somefun2Alt:TooManyInputs', ...
            'requires at most 5 inputs');
    end
    optargs = {1,1,1,1,1};
    optargs(1:numvarargs) = varargin;
    [x, y, classes_vector, grid_opt, hold_opt] = optargs{:};
% end function initialization
    unique_classes = unique(classes_vector);
    nbr_classes = numel(unique_classes);
    colormap = lines(nbr_classes);
    colormap_all = zeros(length(classes_vector), 3);

    for i=1:nbr_classes
        colormap_all(find(classes_vector == unique_classes(i)), :) = colormap(i);
    end
    h = scatter(x, y, [], colormap_all, 'filled');
    

    if grid_opt == 1
        grid off;
    elseif grid_opt == 2
        grid minor;
    else
        grid on;
    end

    if hold_opt == 1
        hold on;
    else
        hold off;
    end
end