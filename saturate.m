%====================================================================== 
% SATURATE: Saturates a vector of values to lower/upper bounds
%
%   Syntax:  out = saturate( in, min, max )
%
%   Inputs:  in       a vector (or scalar) of numbers to be saturated
%            min      lower bound. 
%            max      upper bound
%
%   The return value of a vector of the same size as in with all
%   values >=min and <=max. Input values between min and max are
%   left unchanged.
%
%   Version: 2010.11.30
%====================================================================== 

function out = saturate( in, min, max )

out = in;
out(find(in > max)) = max;
out(find(in < min)) = min;

end
