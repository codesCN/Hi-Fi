function mi = hifi(y, x, z, funct)
% y is the target variable (response variable in regression)
    R1 = funct(y,[x z]);
    R2 = funct(y,z);
    mi = var(R2)-var(R1);
end
        