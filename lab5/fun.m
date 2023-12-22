function [val, grad, hes] = fun(x, A, b)
    AA = (A' * A);
    Ab = (A' * b);

    val = 0.5 * x' * AA * x - Ab' * x;
    grad = AA * x - Ab;
    hes = AA;
end
