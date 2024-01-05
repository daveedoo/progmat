clear;
clc;
n = 10; % number of variables
m = 5;  % number of equation constraints
e = 1e-10;

%%
% seed = [];
% [A, b, p] = getRandomSystem(n, m, -5, 5, -5, 5, seed);
% 
% [x_q, exitflag_q, it_q, lambda_q] = callQuadprog(A, b, p, true);
% if exitflag_q > 0
%     disp('x_quadprog:'); disp(x_q');
%     disp('lambda_q:'); disp(lambda_q.eqlin');
%     KTFulfilled = checkKTConditions(A, b, p, x_q, lambda_q.eqlin);
%     if KTFulfilled
%         disp('KT conditions fulfilled.');
%     end
% end
% 
% [x_zfk, exitflag_zfk, it_zfk, lambda_zfk] = ZFK(A, b, p, zeros(n, 1), e);
% if exitflag_zfk > 0
%     disp('x_zfk:'); disp(x_zfk');
%     disp('lambda_zfk:'); disp(lambda_zfk');
%     KTFulfilled = checkKTConditions(A, b, p, x_zfk, lambda_zfk);
%     if KTFulfilled
%         disp('KT conditions fulfilled.');
%     end
% end

%%
sameResults = 0;
differentResults = 0;
for i=1:10000
    seed = [];
    [A, b, p] = getRandomSystem(n, m, -5, 5, -5, 5, seed);

    [x_q, exitflag_q, it_q, lambda_q] = callQuadprog(A, b, p, false);
    [x_zfk, exitflag_zfk, it_zfk, lambda_zfk] = ZFK(A, b, p, zeros(n, 1), e);

    if exitflag_q < 0 && exitflag_zfk < 0
        sameResults = sameResults + 1;
    elseif exitflag_q > 0 && exitflag_zfk > 0 && norm(x_q - x_zfk) < 3
        sameResults = sameResults + 1;
    else
        differentResults = differentResults + 1;
    end
end
disp('sameResults:'); disp(sameResults);
disp('differentResults:'); disp(differentResults);
%% Tabela 1
% getSolutionExistenceDistribution(10, [3, 5, 7], 10)

%% FIGURE 1
% N = 1;
% meanNormFigure(N, n, m, e);

%% FIGURE 2
% A = [2	-2	-1	1	2	5	-1	-2	-5	-4;
%     -3	5	-5	-2	2	-2	4	-5	2	-1;
%     -1	5	1	-3	-3	3	-3	3	-5	0];
% b = [4; 3;  -5];
% p = [0; 0; 3; -2; 3; 1; 1; -1; 5; -1];

% A = [-5	-1	-1	5	-5	-5	5	4	-1	-2;
%     1	-1	-5	2	-2	0	2	0	-5	-3;
%     -3	-5	5	0	-3	-1	5	-2	-2	-3];
% b = [-2;0;1];
% p = [1;4;5;2;1;2;5;-5;-1;-3];
% 
% iterationsCountFigure(A, b, p, e);
