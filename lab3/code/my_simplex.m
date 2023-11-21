function [opt_x, opt_val, opt_x2, opt_val2, err_code] = my_simplex(c_, A, b, u, fileID)
    % err_code 0 - Success
    % err_code 1 - No finite solution found
    % err_code 2 - Solution not found in MAX_STEPS steps;
    MAX_STEPS = 100;
    EPS = 0.00001;
    n = width(A);
    m = height(A);
    opt_x = zeros(n, 1);
    opt_val = 0;
    opt_x2 = double.empty;
    opt_val2 = 0;
    err_code = 0;

    c = [c_; zeros(m + n, 1)];
    z = zeros(2*n + m, 1);
    z_c = z - c;
    basis = (n+1):(2*n + m);

    A_ext = [A, eye(m), zeros(m, n), b; ...
            eye(n), zeros(n, m), eye(n), u];

    step = 0;
    print_table(fileID, c, A_ext, basis, z, z_c, step);
    while any(z_c < 0)
        step = step + 1;
        % find pivot value...
        [~, in_idx] = min(z_c);
        in_col = A_ext(:, in_idx);
        if all(in_col <= 0)
            err_code = 1;
            fprintf(fileID, "No finite solution found.");
            return;
        end
    
        positive_indexes = find(in_col > 0);
        [~, out_idx_temp] = min(A_ext(positive_indexes, width(A_ext)) ./ in_col(positive_indexes));
        out_idx = positive_indexes(out_idx_temp);
    
        pivot_value = A_ext(out_idx, in_idx);
    
    
        % gaussing...
        for j=1:height(A_ext)
            if j ~= out_idx
                A_ext(j,:) = A_ext(j,:) - (A_ext(j, in_idx) / pivot_value) * A_ext(out_idx, :);
            end
        end
        A_ext(out_idx, :) = A_ext(out_idx, :) / pivot_value;
    
        basis(out_idx) = in_idx;
        z = A_ext(:, (1:end-1))' * c(basis);
        z_c = z - c;
    
        print_table(fileID, c, A_ext, basis, z, z_c, step);

        if step > MAX_STEPS
            err_code = 2;
            return;
        end
    end

    opt_x_temp = zeros(2*n + m, 1);
    opt_x_temp(basis) = A_ext(:, end);
    opt_x = opt_x_temp(1:n);
    opt_val = c_' * opt_x;

    fprintf(fileID, ['Optimal solution:\n\t', repmat('%f ', 1, n), '\n'], opt_x);
    fprintf(fileID, 'Optimal value: %f\n', opt_val);

    % ======= CHECK FOR ANOTHER SOLUTION =======
    nonbasis_indexes = setdiff(1:n, basis);
    potential_in_idxs = find(abs(z_c(nonbasis_indexes )) < EPS);  % indexes of the vectors that could be inserted to the result
    all_checked = isempty(potential_in_idxs);

    if all_checked
        fprintf(fileID, 'Solution is unique.\n');
        return;
    end
    
    % we can check as many indexes as there is elements in 'potential_in_idxs' array
    for i=1:length(potential_in_idxs)
    % for i=1:1
        if i > 1
            disp("bbb!");
        end
        in_idx = nonbasis_indexes(potential_in_idxs(i));
        in_col = A_ext(:, in_idx);

        % important: we check also if b ~= 0. If b was equal 0, the solution would be exactly the same despite different basis.
        positive_indexes = intersect(find(in_col > EPS), find(abs(A_ext(:, end)) > EPS));
        if isempty(positive_indexes)
            % if there is no out_index meeting both conditions we check for
            % another potential_in_idx
            continue;
        end
        [~, out_idx_temp] = min(A_ext(positive_indexes, width(A_ext)) ./ in_col(positive_indexes));
        out_idx = positive_indexes(out_idx_temp);
    
        pivot_value = A_ext(out_idx, in_idx);

        % gaussing...
        for j=1:height(A_ext)
            if j ~= out_idx
                A_ext(j,:) = A_ext(j,:) - (A_ext(j, in_idx) / pivot_value) * A_ext(out_idx, :);
            end
        end
        A_ext(out_idx, :) = A_ext(out_idx, :) / pivot_value;
    
        basis(out_idx) = in_idx;
        z = A_ext(:, (1:end-1))' * c(basis);
        z_c = z - c;
    
        opt_x_temp2 = zeros(2*n + m, 1);
        opt_x_temp2(basis) = A_ext(:, end);
        opt_x2 = opt_x_temp2(1:n);
        opt_val2 = c_' * opt_x2;
        fprintf(fileID, ['Optimal solution 2:\n\t', repmat('%f ', 1, n), '\n'], opt_x2);
        fprintf(fileID, 'Optimal value 2: %f\n', opt_val2);

        if all(opt_x == opt_x2)
            disp("aaa!");
        end

        % if c(in_idx) ~= 0
        %     disp("ccc");
        % end
        print_table(fileID, c, A_ext, basis, z, z_c, step + 1);
        break;
    end
end

function print_table(fileID, c, A_ext, basis, z, z_c, i)
    L = length(c);

    fprintf(fileID, 'STEP %d\n', i);
    fprintf(fileID, ['  c  |   ', repmat('%-7d ', 1, L), '\n'], c);
    fprintf(fileID, ['base |   ', repmat('x%-7d', 1, L), 'b\n'], 1:length(c));
    fprintf(fileID, '%s\n', repelem('-', 8*L + 12));
    fprintf(fileID, [' x%-2d |', repmat('%7.3f ', 1, width(A_ext) - 1), '| %5.3f\n'], [basis', A_ext]');
    fprintf(fileID, '%s\n', repelem('-', 8*L + 12));
    fprintf(fileID, ['  z  |', repmat('%7.3f ', 1, L), '|\n'], z);
    fprintf(fileID, [' z-c |', repmat('%7.3f ', 1, L), '|\n'], z_c);
    fprintf(fileID, '%s\n\n', repelem('=', 8*L + 12));
end

