function totalEnergy = TotalEnergy2(coeffs,kmax)
    if kmax == 0 
        error('kmax错误!');
    end
    totalEnergy = 0;
    totalTerminalEnergy = 0;
    L = floor(log2(kmax+1));          % 分解层数
    L1 = 2^L-1;
    L2 = 2^(L+1)-2;
    for k = L1:L2 
        nodeCoeffs = wpcoef(coeffs, k);
        nodeEnergy = sum(nodeCoeffs.^2);
        totalTerminalEnergy = totalTerminalEnergy + nodeEnergy;
    end
    totalEnergy = totalTerminalEnergy;
end