function [value, gradient] = fun(x, r, A, b, p)
    n = width(A);
    
    fun_val = @(x)(0.5*dot(x, x) - dot(p, x));
    fun_penalty = @(x, r)(r * (sum((A*x - b).^2) + ...
        sum(max(zeros(n, 1), -x).^2)));

    value = fun_val(x) + fun_penalty(x, r);
    gradient = x - p + r*(2 * A' * (A*x - b) + min(zeros(n, 1), 2*x));
end