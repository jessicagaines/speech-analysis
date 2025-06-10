function [f0_cents, f0, amp_pct, cond_array, goodfiles, shift] = pitch_adapt_one_subj(subdir,baseline_size,timeframe,detrend)
    cd(subdir);
    D = dir;
    cd(D(3).name)
    load('dataVals');
    load('expt');
    load('goodfiles');
    
    shift = expt.shift.F0;
    cond_array = expt.condValues.F0;
    cond_values = get_cond_change_values(cond_array);
    
    baseline_start = find(goodfiles >= cond_values(2)-(baseline_size-1),1);
    baseline_end = find(goodfiles > cond_values(2),1)-1;

    [f0_temp,amp] = get_f0(dataVals,timeframe);
    
    if detrend
        f0_mdl = fitlm(goodfiles,f0_temp);
        f0_slope = f0_mdl.Coefficients.Estimate(2);
        f0 = f0_temp - f0_slope*goodfiles;
    else
        f0 = f0_temp;
    end
    f0_cents = get_f0_cents(f0, baseline_start:baseline_end);
    amp_pct = get_amp_pct(amp,baseline_start:baseline_end);

    f0_mdl = fitlm(goodfiles,f0_cents);
    f0_intercept = f0_mdl.Coefficients.Estimate(1);
    f0_slope = f0_mdl.Coefficients.Estimate(2);
    amp_mdl = fitlm(goodfiles,amp_pct);
    amp_intercept = amp_mdl.Coefficients.Estimate(1);
    amp_slope = amp_mdl.Coefficients.Estimate(2);

    fig = figure;
    hold on
    path = split(cd,'\');
    subdir = path{end-1};
    shade_hold_phase(cond_values,min(f0_cents)-50,max(f0_cents)+50);
    scatter(goodfiles,f0_cents,'k');
    scatter(goodfiles,amp_pct,'r');
    plot(goodfiles,f0_intercept+f0_slope*goodfiles,'k')
    plot(goodfiles,amp_intercept+amp_slope*goodfiles,'r')
    xlabel('Trial');
    ylabel('Pitch (cents)');
    title(strcat(subdir,' ',num2str(shift),' cents shift'));
    saveas(fig,strcat(subdir,'_',num2str(shift),'_adapt.fig'));
end

function [amp_pct] = get_amp_pct(amp,baseline_trials)
    baseline = mean(amp(baseline_trials),"omitmissing");
    amp_pct = ((amp-baseline)/baseline)*100;
end