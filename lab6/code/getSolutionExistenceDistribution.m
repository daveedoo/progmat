function solutionFoundPercent = getSolutionExistenceDistribution(N, ms, n)
    solutionFoundPercent = dictionary(ms, zeros(1, length(ms)));
    for i=ms
        fprintf("m = %i\n", i);

        tic
        dict = getSolutionExistence(N, i, n);
        foundSolutions = dict(2) + dict(1);
        solutionFoundPercent(i) = (foundSolutions / N * 100);
        toc
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
        [A, b, p] = getRandomSystem(n, m, -5, 5, -5, 5, []);
        [~, exitflag, ~] = callQuadprog(A, b, p, false);
        % [~, exitflag] = doRandomQuadprogTest(m, n, false);

        waitbar(i/N, f, sprintf('Computing iteration %i/%i (n = %i, m = %i)', i, N, n, m));
        dict(exitflag) = dict(exitflag) + 1;
    end
    close(f);
end