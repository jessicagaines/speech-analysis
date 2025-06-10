function [all_f0, all_amp, upshift_f0,downshift_f0,stacked_f0,stacked_upshift,stacked_downshift,cond_values,shifts,names,excluded_names] = exclude_ppts(all_f0, all_amp, upshift_f0,downshift_f0,stacked_f0,stacked_upshift,stacked_downshift,cond_values,shifts,names)
    variance = var(all_f0,0,2,"omitmissing");
    mean_var = mean(variance);
    std_dev_var = std(variance);
    figure;
    hold on;
    histogram(variance)
    upper_bound = mean_var + 2*std_dev_var;
    lower_bound = mean_var - 2*std_dev_var;
    xline(upper_bound)
    xline(lower_bound)
    condition = variance > lower_bound & variance < upper_bound;
    idx = find(condition);
    all_f0 = all_f0(idx,:);
    all_amp = all_amp(idx,:);
    upshift_f0 = upshift_f0(idx,:);
    downshift_f0 = downshift_f0(idx,:);
    stacked_f0 = stacked_f0(idx,:,:);
    stacked_upshift = stacked_upshift(idx,:,:);
    stacked_downshift = stacked_downshift(idx,:,:);
    shifts = shifts(idx);
    excluded_idx = find(not(condition));
    excluded_names = names(excluded_idx);
    names = names(idx);
end