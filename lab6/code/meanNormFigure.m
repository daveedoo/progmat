function meanNormFigure(N, n, m, e)
    optimalityTols=[1e-14, 1e-13, 1e-12, 1e-11, 1e-10, 1e-9, 1e-8, 1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2];
    stepTols=[1e-18, 1e-17, 1e-16, 1e-15, 1e-14, 1e-13, 1e-12, 1e-11, 1e-10, 1e-9, 1e-8, 1e-7, 1e-6, 1e-5, 1e-4, 1e-3];
    optTolLen = 13;
    stepTolLen = 16;
    
    meanNorms = zeros(stepTolLen, optTolLen);
    for x=1:optTolLen
        for y=1:stepTolLen
            meanNorms(y, x) = testZFKAccuracy(N, n, m, e, optimalityTols(x), stepTols(y), true);
        end
    end
    surf(optimalityTols, stepTols, meanNorms)
    colorbar;
    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');
    set(gca, 'ZScale', 'log');
    xlabel('Optimality Tolerance');
    ylabel('Step Tolerance');
    zlabel('Mean norm(x_{zfk} - x_{quadprog})');
end