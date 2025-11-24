function zcr = ZCR(signal)
    signal = signal(:)'; 
    signChanges = diff(sign(signal)); % 计算符号差分
    crossCount = sum(abs(signChanges) ~= 0); 
    zcr = crossCount / (length(signal) - 1);
end