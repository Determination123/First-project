function F1 = F1score(TP,FP,FN)
    F1 = (2 * TP) / (2 * TP + FP + FN);
end