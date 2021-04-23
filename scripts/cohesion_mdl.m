function y = cohesion_mdl(x, polynom, sp_point)
    inds = x <= sp_point;
    y = polyval(polynom, x);
    y(inds) = 1;
end