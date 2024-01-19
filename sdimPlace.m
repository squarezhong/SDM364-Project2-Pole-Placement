%SDIMPLACE Places the state-feedback gain matrix K for a given linear system.
%
%   K = SDIMPLACE(A, B, poles) computes the state-feedback gain matrix K
%   such that the closed-loop system has the desired poles. A is the system
%   matrix, B is the input matrix, and poles is a vector of desired poles.
%
%   K = SDIMPLACE(A, B, poles, seed) additionally specifies a seed value for
%   the random number generator used in the cyclic placement algorithm.
%
%   Example:
%       A2 = [0 1 1; -6 -8 2; 0 0 3];
%       B2 = [0 1; 1 0; 0 1];
%       poles2 = [-4 -5 -6];
%       K2_1 = sdimPlace(A2,B2,poles2,1)
%       eig(A2 - B2 * K2_1)
%
%   See also PLACE, CYCLICPLACE, JORDANPLACE.
function [K] = sdimPlace(A,B,poles,seed)
arguments
    A
    B {mustBeControllable(A,B)}
    poles (1,:) {mustBeNumeric}
    seed = 0
end

p = size(B,2);
is_cyclic = isCyclic(A);

poles = sort(poles,'descend');

if (p == 1)
    K = place(A,B,poles);
elseif (p > 1)
    if (is_cyclic)
        K = cyclicPlace(A,B,poles,seed);
    else
        K = jordanPlace(A,B,poles,seed);
    end
else
    disp('invalid input size');
    K = NaN;
end

end

