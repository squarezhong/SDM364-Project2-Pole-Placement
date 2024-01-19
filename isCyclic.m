% isCyclic - Check if a matrix is cyclic
%
%   This function checks if a given matrix is cyclic. A matrix is considered
%   cyclic if its characteristic polynomial is equal to its minimal polynomial.
%
% Syntax: 
%   [is_cyclic] = isCyclic(A)
%
% Inputs:
%   A - Input matrix
%
% Outputs:
%   is_cyclic - Boolean value indicating if the matrix is cyclic (true) or not (false)
%
% Example:
%   A = [1 2; 3 4];
%   is_cyclic = isCyclic(A);
%
%   The output is:
%   is_cyclic = false
%
%   because the characteristic polynomial of A is not equal to its minimal polynomial.
%
% Author: Square Zhong
function [is_cyclic] = isCyclic(A)
    char_poly = charpoly(A);
    min_poly = minpoly(A);

    if (isequal(char_poly,min_poly))
        is_cyclic = true;
    else
        is_cyclic = false;
    end
end

