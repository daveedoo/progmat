function [A, b, p] = getRandomSystem(n, m, Ab_min, Ab_max, p_min, p_max, seed)
    if ~isempty(seed)
        rng(seed);
    end

    A = randi([Ab_min, Ab_max], [m, n]);
    b = randi([Ab_min, Ab_max], [m, 1]);
    p = randi([p_min, p_max], [n, 1]);
end