%% Exercise 1 - Synthetic Dataset
% Implemented by Lorenzo Belone, Victor Morini

% cleaning procedure:knnClassify2dTest
clear all
close all
clc

% load data set
load synthetic
testSet = knnClassify2dTrain;
% begin:

% set variables
k = 10;
allClasses = zeros(size(testSet, 1), 1);

for j=1:size(testSet)
    dummy = testSet(j,1:end-1);

    x = knnClassify2dTrain(:, 1);
    y = knnClassify2dTrain(:, 2);
    class = knnClassify2dTrain(:, 3);

    testSet_XY = [x, y];
    dummyVector_XY = meshgrid(dummy, ones(size(testSet, 1),1));

    euclidianDistance = sqrt(sum((power(testSet_XY - dummyVector_XY, 2)), 2));

    sortDist = sortrows(euclidianDistance, 'ascend');

    importantDistances = sortDist(1:k, 1);

    importantIndexes = zeros(1, length(importantDistances));
    for i=1:length(importantDistances)
        importantIndexes(i) = find(importantDistances(i) == euclidianDistance);
    end

    classes = class(importantIndexes);

    % finding the probability
    if(nnz(classes == 1) > nnz(classes == 2))
        percentage = (nnz(classes == 1)/k) * 100;
        class = 1;
        allClasses(j) = 1;
    else
        percentage = (nnz(classes == 2)/k )* 100;
        class = 2;
        allClasses(j) = 2;
    end
    fprintf('The percentage of belonging to class %d is %.2f \n',class, percentage )
end
fprintf('The accuracy is %.2f \n',(nnz(allClasses == testSet(:, 3))/length(allClasses)) * 100)


