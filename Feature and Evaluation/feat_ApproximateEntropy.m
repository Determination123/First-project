function apen = feat_ApproximateEntropy(X)
X = X(:);  
r = 0.2;
r = r*std(X);
N = length(X);  
dim = 2;
phi = zeros(1,2);

for j = 1:2
    m = dim+j-1;        
    C = zeros(1,N-m+1);   
    dataMat = zeros(m,N-m+1);   
    for i = 1:m
        dataMat(i,:) = X(i:N-m+i);
    end

    for i = 1:N-m+1
        tempMat = abs(dataMat - repmat(dataMat(:,i),1,N-m+1));
        boolMat = any( (tempMat > r),1);
        C(i) = sum(~boolMat)/(N-m+1);   
    end

    phi(j) = sum(log(C))/(N-m+1);
end
apen = phi(1)-phi(2);
end
