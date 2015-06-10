function [ y ] = moving_avg( x, n )
%MOVING_AVG Summary of this function goes here
%   Detailed explanation goes here
%   n is the number of tabs
%   x is the data array
    a = 1;
    b = ones(1,n)./n;
    %b = (n:-1:1)./sum(n:-1:1);
    y = filter(b,a,x);
end

