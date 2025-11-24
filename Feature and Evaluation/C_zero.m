function c = C_zero(x1)%文献中r一般取值建议5-10，x1为一维数组序列
    r = 5;
    x1 = x1(:)';
    N = size(x1,2);
    X1 = fft(x1);%离散傅里叶变换
    gn = r*sum(abs(X1).*abs(X1))/N;%计算判断条件
    for i=1:N
        if abs(X1(i))^2> gn
            X2(i)=X1(i);
        else
            X2(i)=0;
        end
    end
    x2 =ifft(X2);%反傅里叶变换
    x3 = x1-x2;
    c = sum(abs(x3).*abs(x3))/sum(abs(x1).*abs(x1));%计算了C0复杂度
end
