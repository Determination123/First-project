function [TP,TN,FP,FN] = evaluation(classification, label)
    TP = 0;TN = 0;FP = 0;FN = 0;
    for i = 1:size(classification,1)
        if classification(i) == label(i)
            if classification(i) == 1
                TP = TP + 1;
            else
                TN = TN + 1;
            end
        else 
            if classification(i) == 1
                FP = FP + 1;
            else
                FN = FN + 1;
            end
        end
    end    
end