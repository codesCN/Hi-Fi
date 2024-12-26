function R = reg_lin_2k(y,X)
    X = prepare(X);
    [~,~,R] = regress(y,X);
end

function Y = prepare(X)
    [N, p] = size(X);
    Y = zeros(N,p^2+1);
    icont = 0;
    for k = 1:p
        for h = k:p
            icont = icont+1;
            Y(:,icont) = X(:,k).*X(:,h);
        end
    end
    icont = icont+1;
    Y(:,icont) = ones(N,1);
    Y = Y(:,1:icont);
    Y = [Y X]; 
end