function c = C_zero(x1)
    r = 5;
    x1 = x1(:)';
    N = size(x1,2);
    X1 = fft(x1);
    gn = r*sum(abs(X1).*abs(X1))/N;
    for i=1:N
        if abs(X1(i))^2> gn
            X2(i)=X1(i);
        else
            X2(i)=0;
        end
    end
    
    x2 =ifft(X2);
    x3 = x1-x2;
    c = sum(abs(x3).*abs(x3))/sum(abs(x1).*abs(x1));
end


