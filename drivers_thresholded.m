function [r_n, s_n] = drivers_thresholded(p, alpha, nsurr, mi_red, mi_syn, mi_red_surr, mi_syn_surr)

    r_n = drivers_thresholded_(p, alpha, mi_red, mi_red_surr, nsurr, 0);
    s_n = drivers_thresholded_(p, alpha, mi_syn, mi_syn_surr, nsurr, 1);
end

function n_drivers = drivers_thresholded_(p, alpha, hoi_meas, hoi_surr, nsurr, pos)
    
    n_drivers = zeros(1,p-1); 
    for i = 1:p-1
        surri = hoi_surr{i};
        hoi_measi = hoi_meas{i}(2:end);

        bsig = true;
        cont = 1;
        while bsig & cont<=p-2
            if pos
                pval = sum(surri(:,cont)>hoi_measi(cont))/(nsurr+1);
            else
                pval = sum(surri(:,cont)<hoi_measi(cont))/(nsurr+1);
            end
            if pval<alpha
                cont = cont+1;
            else
                bsig = false;
            end
        end
        n_drivers(i) = cont;
    end
end