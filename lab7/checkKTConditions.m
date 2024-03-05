function isFulfilled = checkKTConditions(A, b, p, x, lambda)
% Checks Kuhn-Tucker conditions
    n = width(A);
    EPS = 1e-5;

    gradL_x = x - p + A' * lambda;
    kt1 = all(gradL_x >= -EPS);
    kt2 = all(abs(A*x - b) < EPS);
    kt3 = (all(x >= 0));
    kt4 = abs(x' * gradL_x) < n*EPS;

    if ~kt1
        disp('KT1 not met!');
    end
    if ~kt2
        disp('KT2 not met!');
    end
    if ~kt3
        disp('KT3 not met!');
    end
    if ~kt4
        disp('KT4 not met!');
    end
    isFulfilled = kt1 && kt2 && kt3 && kt4;
end
