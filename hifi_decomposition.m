function [dU, dR, dS, dbiv] = hifi_decomposition(mi_red, mi_syn, r_n, s_n)
    p = length(mi_red);
    dU = zeros(p,1);
    dR = zeros(p,1);
    dS = zeros(p,1);
    dbiv = zeros(p,1);
    for k = 1:p
        dU(k) = mi_red{k}(r_n(k));
        dR(k) = mi_red{k}(1)-mi_red{k}(r_n(k));
        dS(k) = -mi_syn{k}(1)+mi_syn{k}(s_n(k));
        dbiv(k) = mi_syn{k}(1);
    end
end