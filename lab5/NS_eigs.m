function [x, fval, it] = NS_eigs(fun, x0, e, lambda)
% NS_eigs   Solves the unconstrained minimization problem using the
%   gradient descent method.
%   
%   fun - examined function; [val, grad, hessian] = fun(x).
%   x0 - starting point.
%   e - epsilon defining the STOP condition; computation accuracy.
%   lambda - vector of eigenvalues used to determine the optimal step size
%       of iteration

    x = x0;
    it = 0;
    [fval, grad, hes] = fun(x);
    lambda = sort(unique(lambda), 'descend');

    while norm(grad) > e
        d = -grad;
        idx = mod(it, length(lambda)) + 1;
        alpha = 1/lambda(idx);
        x = x + alpha*d;

        [fval, grad, hes] = fun(x);

        it = it + 1;
    end
end