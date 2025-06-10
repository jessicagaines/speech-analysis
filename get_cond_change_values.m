function cond_values = get_cond_change_values(cond_array)
    cond_values = [0];
    for i = 2:length(cond_array)
        if cond_array(i) ~= cond_array(i-1) || i == length(cond_array)
            if i == length(cond_array)
                    cond_values = [cond_values, i];
                else
                    cond_values = [cond_values, i-1];
            end
        end
    end
end