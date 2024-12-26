function [mi_red_surr, mi_syn_surr] = hifi_surr(x, drivers_red, drivers_syn, nsurr, funct)

    %i <- j 
    mi_red_surr = get_surr(x, drivers_red, nsurr, funct);
    mi_syn_surr = get_surr(x, drivers_syn, nsurr, funct);
end

function mi_surr = get_surr(x, drivers, nsurr, funct) 
    [n,p] = size(x);

    mi_surr = zeros(nsurr,p-2);
    for dr = 3:p
        xx = x(:,drivers(1:dr));
        for k = 1:nsurr
            xx(:,dr) = xx(randperm(n),dr);
            mi = hifi(xx(:,1), xx(:,2), xx(:,3:end), funct);
            mi_surr(k,dr-2) = mi;
        end
    end
end
