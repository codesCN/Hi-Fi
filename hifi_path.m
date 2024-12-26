function mi_path = hifi_path(mi, drivers, mi_n)
    p = length(drivers);
    mi_path = zeros(p,p);
    for k = 1:p
        pt = drivers{k}(2:end)-1;
        mii = mi{k};
        for j = 2:mi_n(k)
            mi_path(k,pt(j)) = mii(j)-mii(j-1);  
        end
    end
end
