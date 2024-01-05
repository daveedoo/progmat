function iterationsCountFigure(A, b, p, e)
    n = width(A);
    [~, exitflag_qua, ~] = callQuadprog(A, b, p, false);
    if exitflag_qua <= 0
        disp("System randomized with 'seed' parameter needs to have a solution.");
        return;
    end

    optimalityTols=[1e-14, 1e-13, 1e-12, 1e-11, 1e-10, 1e-9, 1e-8, 1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1];
    stepTols=[1e-18, 1e-17, 1e-16, 1e-15, 1e-14, 1e-13, 1e-12, 1e-11, 1e-10, 1e-9, 1e-8, 1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2];
    optTolLen = 14;
    stepTolLen = 17;
    
    iterCounts = zeros(stepTolLen, optTolLen);
    for x=1:optTolLen
        for y=1:stepTolLen
            [~, ~, it_zfk] = ZFK(A, b, p, zeros(n, 1), e, optimalityTols(x), stepTols(y));
            iterCounts(y, x) = it_zfk;
        end
    end

    surf(optimalityTols, stepTols, iterCounts);
    colorbar;
    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');
    % set(gca, 'ZScale', 'log');
    xlabel('Optimality Tolerance');
    ylabel('Step Tolerance');
    zlabel('No. of iterations');
end