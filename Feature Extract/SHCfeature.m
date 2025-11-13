% 设置包含.mat文件的文件夹的路径
clear all;
load('SCHdata.mat');
% 初始化特征矩阵
C = FO;
numMatrices = size(C, 1) ; % 矩阵的数量numel(C)
channel = size(C, 2);
feature = [];
fs = 128;
nodeIndices = [2,4,8,16,15];
numNodes = numel(nodeIndices);

% ===== 关键修改：使用parfor并行样本循环 =====
feature = cell(numMatrices, channel);  % 预分配特征cell数组

% 启动并行池
if isempty(gcp('nocreate'))
    parpool; 
end

parfor i = 1:numMatrices  % 并行样本循环
    feature_i = cell(1, channel);  % 当前样本的特征存储
    
    for j = 1:channel
        % 获取当前矩阵
        currentMatrix = C{i,j};
        
        % 小波包分解
        coeffs = wpdec(currentMatrix, 4, 'db4');
        
        % 预分配节点系数
        Coeffs = cell(1, numNodes);
        totalEnergy = zeros(1, numNodes);
        
        % 计算系数 (避免重复计算)
        for k = 1:numNodes
            idx = nodeIndices(k);
            Coeffs{k} = wpcoef(coeffs, idx);
            totalEnergy(k) = TotalEnergy2(coeffs,idx);
        end
        
        % 特征矩阵预分配
        FT = zeros(numNodes, 4);
        
        % 计算特征
        for k = 1:numel(Coeffs)
            FT(k,1) = feat_ApproximateEntropy(Coeffs{k});
            FT(k,2) = RER(Coeffs{k},totalEnergy(k));
            FT(k,3) = C_zero(Coeffs{k});
            FT(k,4) = ZCR(Coeffs{k});
        end
        feature_i{j} = FT;
    end
    
    % 存储当前样本所有通道结果
    feature(i, :) = feature_i;
end