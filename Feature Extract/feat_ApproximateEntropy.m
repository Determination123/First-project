function apen = feat_ApproximateEntropy(X)
X = X(:);  % 强制转化数据为列方向
r = 0.2;
r = r*std(X);
N = length(X);  % 信号长度，通常在100-5000范围内才能保证会有有效的统计特性和较小的误差
% dim:重构维数，序列长度为100-1000时，推荐dim=2，序列长度为1000-30000时，推荐dim=3
if (100<N) && (N<1000) 
    dim = 2;
else
    dim = 3;
end
phi = zeros(1,2);

for j = 1:2
    m = dim+j-1;        % dim通常设置为2，这样m=2和m=3; dim=3时，m=3和m=4
    C = zeros(1,N-m+1);   % 近似比例
    dataMat = zeros(m,N-m+1);   % 子序列集合，每个子序列的长度是m，共从data中提取N-m+1个子序列
    % setting up data matrix
    for i = 1:m
        dataMat(i,:) = X(i:N-m+i);
    end

    % counting similar patterns using distance calculation
    for i = 1:N-m+1
        tempMat = abs(dataMat - repmat(dataMat(:,i),1,N-m+1));
        boolMat = any( (tempMat > r),1);
        C(i) = sum(~boolMat)/(N-m+1);         % 近似比例
    end

    % summing over the counts
    phi(j) = sum(log(C))/(N-m+1);
end
apen = phi(1)-phi(2);

end
