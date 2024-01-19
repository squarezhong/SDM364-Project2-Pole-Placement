% MUSTBECONTROLLABLE Checks if a system defined by matrices A and B is controllable.
%   mustBeControllable(A, B) checks if the pair (A, B) is controllable by
%   computing the controllability matrix M_c and checking its rank. If the
%   rank is less than the number of states in A, an error is thrown.
%
%   Inputs:
%       - A: State matrix of the system
%       - B: Input matrix of the system
%
%   Example:
%       A = [1 2; 3 4];
%       B = [5; 6];
%       mustBeControllable(A, B)
%
%   See also: ctrb, rank
%
function mustBeControllable(A,B)
M_c = ctrb(A, B);
if rank(M_c) < size(A, 1)
    eid = 'Controllability:Uncontrollable';
    msg = ['pair(A,B) is untrollable, ' ...
        'please do controllability decomposition first'];
    error(eid,msg);
end
