function [drivers_red, drivers_syn, mi_red, mi_syn, r_n, s_n] = hifi_syn_red(x, i, j, funct, str_hifi)
% i,j: % i is the target (response or dependent variable) 

    R = funct(x(:,i), x(:,j));
    mi = var(x(:,i)) - var(R);

    if str_hifi.runPerms == false
        nperm = [];
    else
        nperm.nsurr = str_hifi.nsurr;
        nperm.alpha = str_hifi.alpha;
    end

    max_ndrivers = str_hifi.maxNdrivers;

    [drivers_red, mi_red, r_n] = calculateHOI(x, i, j, mi, funct, 1, nperm, max_ndrivers);
    [drivers_syn, mi_syn, s_n] = calculateHOI(x, i, j, mi, funct, 0, nperm, max_ndrivers);
end

%% internal function
function [drivers, mi, n_drivers] = calculateHOI(x, i, j, mi_ij, funct, is_red, nperm, max_ndrivers)

    if is_red
        funct_hoi = @min;
        funct_surr = @lt; % negative values
    else
        funct_hoi = @max;
        funct_surr = @gt;
    end
    
    [n,p] = size(x);

    pmin = min([p,max_ndrivers]);

    mi = zeros(pmin-1,1);
    mi(1) = mi_ij;

    drivers = zeros(1,pmin);
    drivers(1:2) = [i j];

    ind = setdiff(1:p, [i j]);
    m = length(ind);
    icont = 1;
    ifcont = true;
    while m > 0 & ifcont & icont<max_ndrivers   
        deltas = zeros(1,m);
        for h = 1:m
            dt = [drivers(1:icont+1) ind(h)];
            deltas(h) = hifi(x(:,i), x(:,j), x(:,dt(3:end)), funct);
        end
        icont = icont+1;
        [mi(icont), ii] = funct_hoi(deltas);
        drivers(icont+1) = ind(ii); 
        ind = setdiff(ind,ind(ii)); m = length(ind);
        n_drivers = icont;

        % surrogate data
        if ~isempty(nperm)
            nsurr = nperm.nsurr;
            alpha = nperm.alpha; % alpha, or bonf alpha
            xx = x(:,drivers(1:icont+1));
            mi_surr = zeros(nsurr,1);
            for k = 1:nsurr
                xx(:,end) = xx(randperm(n),end);
                mi_surr(k) = hifi(xx(:,1), xx(:,2), xx(:,3:end), funct);
            end
            pval = sum(funct_surr(mi_surr, mi(icont)))/(nsurr+1);
            if pval>=alpha
                ifcont = false;

                n_drivers = icont-1;
                mi(icont) = 0;
                drivers(icont+1) = 0;
            end
        end
    end
end

