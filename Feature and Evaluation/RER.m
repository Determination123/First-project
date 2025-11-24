function rer = RER(coeffs,totalEnergy)
    coeffs = coeffs(:)';
    energy = sum(coeffs.^2);    
    rer = energy / totalEnergy;
end