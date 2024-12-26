function R = reg_lin(y,X)
    [~,~,R] = regress(y,X);
end