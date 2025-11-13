clear all;
load('PDfeature.mat');
load('PDlabel.mat');

numMatrices = size(feature,1); 
channel = size(feature,2);

samplesPerSubject = 2;
numSubjects = numMatrices / samplesPerSubject;

if mod(numMatrices, samplesPerSubject) ~= 0
    error('样本数不是每个被试的整数倍，请检查数据。');
end

subjectIDs = repelem(1:numSubjects, samplesPerSubject)';

acc = zeros(1, channel);
sen = zeros(1, channel);
spe = zeros(1, channel);
f1 = zeros(1, channel);

finalPredictions = NaN(numMatrices, channel);

for j = 1:channel
    features = [];
    for i = 1:numMatrices
        current = reshape(feature{i,j}, 1, []);
        features(i,:) = current;
    end
    
    Sfeature = features;
    label = labels; 

    for subj = 1:numSubjects
        testInd = (subjectIDs == subj);
        trainInd = ~testInd;

        trainData = Sfeature(trainInd, :);
        trainLabels = label(trainInd);
        testData = Sfeature(testInd, :);
        testLabels = label(testInd);

        SVMModel = fitcsvm(trainData, trainLabels, ...
            'KernelFunction','polynomial', ...
            'PolynomialOrder',3);

        [predictedLabels, ~] = predict(SVMModel, testData);

        finalPredictions(testInd, j) = predictedLabels;
    end

    if any(isnan(finalPredictions(:,j)))
        error('存在未预测的样本，请检查索引逻辑。');
    end

    [TP,TN,FP,FN] = evaluation(finalPredictions(:,j), label);
    acc(j) = accuracy(TP,TN,FP,FN);
    sen(j) = sensitivity(TP,FN);
    spe(j) = specificity(TN,FP);
    f1(j) = F1score(TP,FP,FN);
end



preclassification = cell(1, channel);
indices = (1:channel)';   
data = [acc(:), f1(:), indices];
sortedData = sortrows(data, [-1 -2]);
Channel = sortedData(:,3)';
for k = 1:numel(Channel)
    preclassification{k}=finalPredictions(:,Channel(k));
end

for j = 1:channel
    TP = 0;TN = 0;FP = 0;FN = 0;
    if j == 1
        finalclassification = preclassification{1};
    else
        currentMax = [];
        currentMax = preclassification{1};
        for i = 1:numMatrices
            count = 0;
            for k = 1:j
                current = [];
                current = preclassification{k};
                if current(i) == 1
                    count = count + 1;
                end
            end
            
            if count == j - count
                finalclassification(i) = currentMax(i);
            elseif count > j-count
                finalclassification(i) = 1;
            else
                finalclassification(i) = 0;
            end
        end
    end
    FC{j} = finalclassification;
    [TP,TN,FP,FN] = evaluation(finalclassification,labels);
    Acc(j) = accuracy(TP,TN,FP,FN);
    Sen(j) = sensitivity(TP,FN);
    Spe(j) = specificity(TN,FP);
    F1(j) = F1score(TP,FP,FN);
end