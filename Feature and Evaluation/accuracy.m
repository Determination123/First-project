function ACC = accuracy(TP,TN,FP,FN)
    ACC = (TP + TN) / (TP + TN + FP + FN);
end