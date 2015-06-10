function [ y ] = diff_p( x, n )
%DIFF_P Summary of this function goes here
%   Detailed explanation goes here

    a = 1;
    b_pow_t = 0:(n-1);
    b_t = 2.^b_pow_t;
    b = [ wrev(b_t) 0 b_t.*-1 ];
    b = b./sum(abs(b));
    y = filter(b,a,x);

end

