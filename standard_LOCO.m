% standard loco
function dLOC = standard_LOCO(y,x,funct) 
R = funct(y,x);
p = size(x,2);
dLOC = zeros(p,1);
for k = 1:p
    ind = setdiff(1:p,k);
    R1 = funct(y,x(:,ind));
    dLOC(k) = var(R1)-var(R);
end
