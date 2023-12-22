function [x, fval, it, err_h_inv] = DFP(fun, x0, e, alpha_fun)
% DFP   Solves the unconstrained minimization problem using the
%   quasi-newtonian DFP algorithm.
%   
%   fun - examined function; [val, grad, hessian] = fun(x).
%   x0 - starting point.
%   e - epsilon defining the STOP condition; computation accuracy.
%   alpha_fun - function returning the step of the directional minimization.
%       alpha = alpha_fun(x, d)
%
%   x - optimal solution found by the algorithm.
%   fval - value of 'fun' at point 'x'.
%   it - number of iterations executed.

    n = length(x0);
    x = x0;
    H = eye(n);
    
    it = 0;
    [fval, grad, hes] = fun(x);
    grad_norm_values = [norm(grad)];
    while grad_norm_values(end) > e
        d = -H*grad;
        alpha_min = alpha_fun(x, d);
        x_next = x + alpha_min * d;
    
        [fval, grad_next, hes_next] = fun(x_next);
        grad_norm_values = [grad_norm_values, norm(grad_next)];
    
        s = x_next - x;
        r = grad_next - grad;
        dH = (s * s')/(s' * r) - (H * (r * r') * H)/(r' * H * r);
        H = H + dH;

        x = x_next;
        grad = grad_next;
        it = it + 1;
    end

    err_h_inv = norm(H - inv(hes_next), "fro");

    semilogy(0:it, grad_norm_values, '-*');
    xlabel('Iteration');
    ylabel('norm(grad)');
end
