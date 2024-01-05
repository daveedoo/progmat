function [xx, exitflag, it, lambda] = ZFK(A, b, p, x0, e, optimalityTol, stepTolerance)
% ZFK   Solves the quadratic minimization problem using the exterior
%   penalty function method.
% 
%   x0 - starting point.
%   e - epsilon defining the STOP condition; computation accuracy.
    m = height(A);
    n = width(A);
    if nargin < 6
        fminuncOptions = optimoptions("fminunc", SpecifyObjectiveGradient=true, Display="none");
    else
        fminuncOptions = optimoptions("fminunc", SpecifyObjectiveGradient=true, OptimalityTolerance=optimalityTol, StepTolerance=stepTolerance, Display="none");
    end

    r0 = 1e-4;
    omega = 10;

    r = r0 / omega;
    xx = x0;
    xx_prev = Inf;

    it = 0;
    while abs(xx_prev - xx) > e
        r = omega*r;

        Fun = @(x)(fun(x, r, A, b, p));
        [x, ~, exitflag_fmu] = fminunc(Fun, xx, fminuncOptions);
        if exitflag_fmu > 0
            xx_prev = xx;
            xx = x;
        else
            exitflag = -1;
            return;
        end

        it = it + 1;
    end

    % check if found solution satisfies KT conditions
    EPS = 1e-4;
    nonzeroIdxs = find(abs(xx) > EPS);
    lambda = linsolve(A(:, nonzeroIdxs)', p(nonzeroIdxs) - xx(nonzeroIdxs));
    if all(A(:, nonzeroIdxs)' * lambda - (p(nonzeroIdxs) - xx(nonzeroIdxs)) < EPS)
        exitflag = 1;
    else
        exitflag = -1;
    end
end