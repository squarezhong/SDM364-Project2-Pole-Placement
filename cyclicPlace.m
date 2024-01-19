% CYCLICPLACE - Computes the controller gain matrix using cyclic placement method.
%
%   [K] = CYCLICPLACE(A, B, poles, seed) computes the controller gain matrix K
%   for a given system represented by state matrix A and input matrix B, using
%   the cyclic placement method. The desired closed-loop pole locations are
%   specified by the vector 'poles'. The optional input 'seed' is used to
%   initialize the random number generator for reproducibility.
%
%   Inputs:
%       - A: State matrix of the system.
%       - B: Input matrix of the system.
%       - poles: Vector of desired closed-loop pole locations.
%       - seed: (Optional) Seed value for random number generator.
%
%   Output:
%       - K: Controller gain matrix.
%
%   Example:
%       A2 = [0 1 1; -6 -8 2; 0 0 3];
%       B2 = [0 1; 1 0; 0 1];
%       poles2 = [-4 -5 -6];
%       K2_1 = sdimPlace(A2,B2,poles2,1)
%
%   See also PLACE.
function [K] = cyclicPlace(A,B,poles, seed)
arguments
    A
    B
    poles (1,:) {mustBeNumeric}
    seed = 0
end

rng(seed);
p = size(B,2);

V = randi([-5,5],p,1);
BV = B * V;

while(rank(ctrb(A,BV)) ~= length(A))
    disp('selected random seed is discarded');
    seed = seed + 1;
    rng(seed);
    disp('current seed:');
    disp(seed);
    V = randi([-5,5],p,1);
    BV = B * V;
end

K_init = place(A,BV,poles);
K = V * K_init;
end

