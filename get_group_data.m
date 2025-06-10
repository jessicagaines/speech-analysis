function[all_f0, all_amp, upshift_f0,downshift_f0,stacked_f0,stacked_upshift,stacked_downshift,cond_values,shifts,names] = get_group_data(total_trials,cwd,baseline_size,adapt_size,washout_size,detrend)
    D = dir;
    currD = D(3).name;
    [f0_cents, f0, amp_pct, cond_array, goodfiles, shift] = pitch_adapt_one_subj(currD,baseline_size,[0.05,0.15],detrend);
    cd(cwd)
    cond_values = get_cond_change_values(cond_array);
    n_hold = length(cond_values)/2-1;
    all_f0 = NaN(length(D)-2,total_trials);
    all_amp = NaN(length(D)-2,total_trials);
    upshift_f0 = NaN(length(D)-2,total_trials);
    downshift_f0 = NaN(length(D)-2,total_trials);
    stacked_f0 = NaN(length(D)-2,cond_values(4),n_hold);
    stacked_upshift = NaN(length(D)-2,cond_values(4),n_hold);
    stacked_downshift = NaN(length(D)-2,cond_values(4),n_hold);
    shifts = NaN(length(D)-2,1);
    names = strings(length(D)-2,1);
    methods_figure(cond_array,baseline_size,adapt_size,washout_size,n_hold)
    for k = 3:length(D)
        currD = D(k).name;
        names(k-2) = D(k).name;
        [f0_cents, f0, amp_pct, cond_array, goodfiles, shift] = pitch_adapt_one_subj(currD,baseline_size,[0.05,0.15],detrend);
        shifts(k-2) = shift;
        all_f0(k-2,goodfiles) = -sign(shift)*f0_cents; % flip upshift so all are equivalent to response to downshift
        all_amp(k-2,goodfiles) = amp_pct;
        % separate upshift and downshift
        if sign(shift) > 0
            upshift_f0(k-2,goodfiles) = f0_cents;
        else
            downshift_f0(k-2,goodfiles) = f0_cents;
        end
        % Rebaseline for each hold phase
        temp = NaN(total_trials,1);
        temp(goodfiles) = f0;
        amp_temp = NaN(total_trials,1);
        amp_temp(goodfiles) = amp_pct;
        for i = 1:n_hold
            cond1 = cond_values(i*2-1)+1;
            cond2 = cond_values((i+1)*2);
            f0_block_cents = get_f0_cents(temp(cond1:cond2),cond_values(2)-(baseline_size-1):cond_values(2));
            stacked_f0(k-2,:,i) = -sign(shift)*f0_block_cents;
            if sign(shift) > 0
                stacked_upshift(k-2,:,i) = f0_block_cents;
            else
                stacked_downshift(k-2,:,i) = f0_block_cents;
            end
        end
        cd(cwd)
    end
end