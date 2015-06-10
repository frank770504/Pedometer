function [ y ] = ssq_prop( x, x_prop )
%SSQ_PROP Summary of this function goes here
%   Detailed explanation goes here

    x = x.^2;
    y = x.*x_prop;
    y = sum(y,2);

end

