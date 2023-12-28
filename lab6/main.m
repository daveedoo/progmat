clear;
n = 10; % number of variables
m = 7;  % number of equation constraints

[~, ~, ~, lambda] = doRandomQuadprogTest(m, n, true);
% getSolutionExistenceDistribution(100, [3, 5, 7], 10);

function [A, b, p] = getRandomSystem(n, m, Ab_min, Ab_max, p_min, p_max, seed)
    if ~isempty(seed)
        rng(seed);
    end

    A = randi([Ab_min, Ab_max], [m, n]);
    b = randi([Ab_min, Ab_max], [m, 1]);
    p = randi([p_min, p_max], [n, 1]);
end

function [x, fval, exitflag, lambda] = doRandomQuadprogTest(m, n, displayOutput, seed)
    if nargin < 4
        seed = [];
    end

    [A, b, p] = getRandomSystem(n, m, -5, 5, -5, 5, seed);

    if displayOutput
        options = optimoptions("quadprog");
    else
        options = optimoptions("quadprog", "Display", "none");
    end
    [x, fval, exitflag, ~, lambda] = quadprog(eye(n), zeros(n, 1), [], [], A, b-A*p, -p, Inf(n, 1), [], options);

    if exitflag > 0
        x = x + p;  % un-do the substitution
        EPS = 1e-6;

        % Kuhn-Tucker conditions
        gradL_x = (x - p + sum(diag(lambda.eqlin) * A)');
        kt1 = all(gradL_x >= -EPS);
        kt2 = all(abs(A*x - b) < EPS);
        kt3 = (all(x >= 0));
        kt4 = abs(x' * gradL_x) < EPS;
        if ~kt1 || ~kt2 || ~kt3 || ~kt4
            disp('KT conditions not met!');
        end
    end
end

function dict = getSolutionExistence(N, m, n)
% N - number of tests
% m - number of equation constraints
% n - number of variables

    % dictionary of all possible exitflags
    dict = dictionary(2, 0, 1, 0, 0, 0, -2, 0, -3, 0, -6, 0, -8, 0);
    f = waitbar(0, sprintf('Computing iteration %i/%i (n = %i, m = %i)', 0, N, n, m));
    for i=1:N
        [~, ~, exitflag] = doRandomQuadprogTest(m, n, false);
        waitbar(i/N, f, sprintf('Computing iteration %i/%i (n = %i, m = %i)', i, N, n, m));
        dict(exitflag) = dict(exitflag) + 1;
    end
    close(f);
end

function getSolutionExistenceDistribution(N, ms, n)
    for i=ms
        fprintf("m = %i", i);
        tic
        getSolutionExistence(N, i, n)
        toc
    end
end