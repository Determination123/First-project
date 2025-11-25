clear all;
load('SCHdata.mat');
C = FO;
numMatrices = size(C, 1) ; 
channel = size(C, 2);
feature = [];
fs = 128;
nodeIndices = [2,4,8,16,15];
numNodes = numel(nodeIndices);

feature = cell(numMatrices, channel);  

% 启动并行池
if isempty(gcp('nocreate'))
    parpool; 
end

parfor i = 1:numMatrices  
    feature_i = cell(1, channel);  
    
    for j = 1:channel
        currentMatrix = C{i,j};
        
        coeffs = wpdec(currentMatrix, 4, 'db4');
        
        Coeffs = cell(1, numNodes);
        totalEnergy = zeros(1, numNodes);
        
        for k = 1:numNodes
            idx = nodeIndices(k);
            Coeffs{k} = wpcoef(coeffs, idx);
            totalEnergy(k) = TotalEnergy2(coeffs,idx);
        end
        
        FT = zeros(numNodes, 4);
        
        for k = 1:numel(Coeffs)
            FT(k,1) = feat_ApproximateEntropy(Coeffs{k});
            FT(k,2) = RER(Coeffs{k},totalEnergy(k));
            FT(k,3) = C_zero(Coeffs{k});
            FT(k,4) = ZCR(Coeffs{k});
        end
        feature_i{j} = FT;
    end
    feature(i, :) = feature_i;
end
