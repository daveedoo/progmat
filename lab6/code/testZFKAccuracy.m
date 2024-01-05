function meanNorm = testZFKAccuracy(N, n, m, e, optimalityTolerance, stepTolerance, showWaitbar)
% N - number of tests (positive)
% n - number of variables
% m - number of equation constraints
    meanNorm = 0.0;
    i = 0;

    if showWaitbar
        f = waitbar(0, sprintf('Computing iteration %i/%i (n = %i, m = %i,\ne=%.1d,\noptimalityTol=%.1d,\nstepTol=%.1d)', 0, N, n, m, e, optimalityTolerance, stepTolerance));
    end

    while i < N
        [A, b, p] = getRandomSystem(n, m, -5, 5, -5, 5, []);
        [x_qua, exitflag_qua, it_qua] = callQuadprog(A, b, p, false);
        if exitflag_qua > 0
            [x_zfk, ~, it_zfk] = ZFK(A, b, p, zeros(n, 1), e, optimalityTolerance, stepTolerance);
            % norm(x_zfk - x_qua)
            meanNorm = meanNorm + norm(x_zfk - x_qua);
            i = i + 1;

            if showWaitbar
                waitbar(i/N, f, sprintf('Computing iteration %i/%i (n = %i, m = %i,\ne=%.1d,\noptimalityTol=%.1d,\nstepTol=%.1d)', i, N, n, m, e, optimalityTolerance, stepTolerance));
            end
        end
    end
    if showWaitbar
        close(f);
    end
    
    meanNorm = meanNorm / N;
end