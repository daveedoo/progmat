clear;
clc;
n = 10; % number of variables
m = 5;  % number of equation constraints
e = 1e-10;

%%
seed = [];
[A, b, p] = getRandomSystem(n, m, -5, 5, -5, 5, seed);

[x_q, exitflag_q, it_q, lambda_q] = callQuadprog(A, b, p, true);
if exitflag_q > 0
    disp('x_quadprog:'); disp(x_q');
    disp('lambda_q:'); disp(lambda_q.eqlin');
    KTFulfilled = checkKTConditions(A, b, p, x_q, lambda_q.eqlin);
    if KTFulfilled
        disp('KT conditions fulfilled.');
    end
end