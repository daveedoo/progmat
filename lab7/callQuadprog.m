function [x, exitflag, it, lambda] = callQuadprog(A, b, p, displayOutput)
    if displayOutput
        options = optimoptions("quadprog", Display="iter-detailed");
    else
        options = optimoptions("quadprog", Display="none");
    end

    n = width(A);
    [x, ~, exitflag, output, lambda] = quadprog(eye(n), -p, [], [], A, b, zeros(n, 1), Inf(n, 1), [], options);
    it = output.iterations;
end