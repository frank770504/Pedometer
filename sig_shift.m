function [ y ] = sig_shift( x, sh )
%SIG_SHIFT Summary of this function goes here
%   Detailed explanation goes here

x(1:sh,:) = [];
for i=1:sh,
    y = [x;x(end,:)];
end


end

