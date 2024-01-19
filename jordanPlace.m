% FILEPATH: /c:/Users/square/OneDrive/Code/MATLAB/Modern_Control/Project2/jordanPlace.m
%
% jordanPlace is a function that calculates the controller gain matrix K
% using the Jordan placement method. 
% This method treats repeated eigenvalues as Jordan blocks rather than
% separate eigenvalues. The function returns a 3D matrix K which contains
% the controller gain matrices for each combination of repeated eigenvalues
%
% Inputs:
%   - A: System matrix A
%   - B: System matrix B
%   - poles: Desired poles for the closed-loop system
%   - seed (optional): Seed value for random number generation
%
% Output:
%   - K: Controller gain matrix
%
% Example usage:
%   A3 = [0 1 0 0;
%       0 0 0 0;
%       0 0 0 1;
%       0 0 0 0];
%   B3 = [0 0; 1 0; 0 0; 0 1];
%   poles3 = [-1 -1 -1 -1];
%   K3 = sdimPlace(A3,B3,poles3,2)
%   K3_3 = K3(:,:,3);
%   eig(A3 - B3 * K3_3)
%
% Author: Square Zhong
function [K] = jordanPlace(A,B,poles,seed)
arguments
    A
    B
    poles (1,:) {mustBeNumeric}
    seed = 0
end

rng(seed);

n = size(A,1);
m = size(B,2);

K = NaN;

% by default n > m
if n <= m
    disp("not supported yet.");
    return
end

% number and index of desired poles
n_repeat = 1;
i_repeat = 1;
[~,ia,~] = unique(poles,'stable');

if length(poles) ~= 1 && length(ia) ==1
    n_repeat = length(poles);
    i_repeat = 1;
else
    for index = 1:length(ia)-1
        tmp = ia(index+1) - ia(index);
        if tmp > 1
            n_repeat = tmp;
            i_repeat = index;
            break
        end
    end
end

disp('repeat number of eigenvalues')
disp(n_repeat);

I = eye(n);
Omega = randi([-5,5],m,n);
V = zeros(n);

counts = idivide(n_repeat,int32(2));
disp(counts);
arrange = zeros(counts,4);

for index = 1:counts
    arrange(index,:) = [1,index,index+1,n_repeat];
end

disp('arrange:')
disp(arrange);

K = zeros(m,n,counts+1);

% condition1: treat repeated eigenvalues as one jordan block    
for index = 1:n
    if (index > i_repeat) && (index < i_repeat+n_repeat)
        V(:,index) = (A - poles(index)*I)^(-1) * (B * Omega(:,index) + V(:,index-1));
    else
        V(:,index) = (A - poles(index)*I)^(-1) * B * Omega(:,index);
    end
end

% Omega/V is faster and more accurate than Omega*inv(V) in MATLAB
K(:,:,1) = Omega / V;

for cnt = 1:counts
    % for each combination
    for index = 1:n
        split = arrange(cnt,3);
        interval1 = (index > i_repeat) && (index < split);
        interval2 = (index > split) && (index < i_repeat+n_repeat);
        if interval1 || interval2
            V(:,index) = (A - poles(index)*I)^(-1) * (B * Omega(:,index) + V(:,index-1));
        else
            V(:,index) = (A - poles(index)*I)^(-1) * B * Omega(:,index);
        end
    end

    % calculate K for each combination
    K(:,:,cnt+1) = Omega / V;
end

end