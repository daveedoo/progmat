clear
EPS = 0.00001;
n = 10; % rozmiar rozwiązania (wektor x)
m = 5;  % rozmiar ograniczeń liniowych
filename = 'out.txt';

simple_test(n, m, filename);
% positivity_test(n, m, filename, 10000, EPS);

function [c, A, b, u] = get_random_data(n, m)
    c = randi([-5, 5], [n, 1]);
    A = randi([-5, 5], [m, n]);
    b = randi(5, [m, 1]);
    u = randi(5, [n, 1]);
end

function [opt_x, opt_val, exitflag, output] = simplex_linprog(c, A, b, u)
    options = optimoptions("linprog", "Algorithm", "dual-simplex", "Display", "none");
    [opt_x, val, exitflag, output] = linprog(-c, A, b, [], [], zeros(length(u), 1), u, options);
    opt_val = -val;
end

function positivity_test(n, m, filename, N, EPS)
    positives = 0;
    for i=1:N
        [c, A, b, u] = get_random_data(n, m);

        [linprog_sol, linprog_val, exitflag, output] = simplex_linprog(c, A, b, u);
        fileID = fopen(filename, 'w');
        [my_sol, my_val, ~, ~, err] = my_simplex(c, A, b, u, fileID);
        fclose(fileID);
        
        if err ~= 0
            fprintf("error %d\n", err)
        end

        if abs(linprog_val - my_val) < EPS
            positives = positives + 1;
        else
            fprintf("found case with absolute error: %.10f\n", my_val-linprog_val);
        end
    end

    fprintf("positives ratio: %.2f%%\n", positives / N * 100);
end

function simple_test(n, m, filename)
    [c, A, b, u] = get_random_data(n, m);
    disp("c = ");
    disp(c')
    
    disp("=============LINPROG=============");
    [linprog_sol, linprog_val] = simplex_linprog(c, A, b, u);
    disp(linprog_sol');
    fprintf('Objective function value: %f\n', linprog_val);
    
    disp("=============SIMPLEX=============");
    fileID = fopen(filename, 'w');
    [my_sol, my_val, my_sol2, my_val2, err] = my_simplex(c, A, b, u, fileID);
    fclose(fileID);
    
    if err == 1
        disp("No finite solution found.\n");
    elseif err == 2
        disp("Algorithm run for too long time\n");
    else
        disp("Optimal solution:");
        disp(my_sol');
        fprintf('Objective function value:\n\t%f\n', my_val);

        if ~isempty(my_sol2)
            disp("Optimal solution 2:");
            disp(my_sol2');
            fprintf('Objective function value 2:\n\t%f\n', my_val2);
        else
            disp('Solution is unique.')
        end
    end
end

