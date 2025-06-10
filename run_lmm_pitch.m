function [] = run_lmm_pitch(stacked_f0, cond_values, baseline_size, adapt_size, washout_size, shifts)
    clc;
    baseline_start = cond_values(2)-(baseline_size-1);
    baseline_end = cond_values(2);
    hold_start = cond_values(3)-(adapt_size-1);
    hold_end = cond_values(3);
    early_washout_start = cond_values(3)+1;
    early_washout_end = cond_values(3) + washout_size;
    late_washout_start = cond_values(4)-(washout_size-1);
    late_washout_end = cond_values(4);
    baseline = stacked_f0(:,baseline_start:baseline_end,:);
    holds = stacked_f0(:,hold_start:hold_end,:);
    early_washout = stacked_f0(:,early_washout_start:early_washout_end,:);
    late_washout = stacked_f0(:,late_washout_start:late_washout_end,:);
    %means = [squeeze(mean(baseline,2,"omitmissing")) squeeze(mean(holds,2,"omitmissing")) squeeze(mean(early_washout,2,"omitmissing")) squeeze(mean(late_washout,2,"omitmissing"))];
    
    all = [baseline holds early_washout late_washout];
    pitch = all(:);
    phase = repmat([repmat("baseline",size(baseline,1)*size(baseline,2),1); repmat("holds",size(holds,1)*size(holds,2),1); repmat("early_washout",size(early_washout,1)*size(early_washout,2),1); repmat("late_washout",size(late_washout,1)*size(late_washout,2),1)],size(stacked_f0,3),1);
    cycle = [zeros(size(all,1)*size(all,2),1); ones(size(all,1)*size(all,2),1); repmat(2,size(all,1)*size(all,2),1)];
    %cycle = [repmat("0",size(all,1)*size(all,2),1); repmat("1", size(all,1)*size(all,2),1); repmat("2",size(all,1)*size(all,2),1)];
    participant = repmat(transpose(1:size(all,1)),size(all,2)*size(all,3),1);
    shift = repmat(shifts,size(all,2)*size(all,3),1);
    tbl = [array2table(pitch) array2table(phase) array2table(cycle) array2table(participant) array2table(shift)];
    tbl=tbl(~any(ismissing(tbl),2),:);
    lme = fitlme(tbl,"pitch ~ 1 + phase + cycle + phase*cycle + (1|participant)");
    lme
    
    
    x = 0:size(stacked_f0,3)-1;

    baseline_cycles = reshape(baseline,[],size(stacked_f0,3));
    hold_cycles = reshape(holds,[],size(stacked_f0,3));
    early_washout_cycles = reshape(early_washout,[],size(stacked_f0,3));
    late_washout_cycles = reshape(late_washout,[],size(stacked_f0,3));

    fig = figure('Position',[200,50,700,700]);
    tiledlayout(2,2)
    names = lme.Coefficients.Name;

    nexttile;
    hold on;
    title("Baseline")
    intercept = lme.Coefficients.Estimate(find(names == "(Intercept)"));
    cycle_slope = lme.Coefficients.Estimate(find(names == "cycle"));
    plot(x,intercept + cycle_slope*x,LineStyle='--',LineWidth=2,color="k")
    plot_data(x,baseline_cycles)
    plot_extras(size(stacked_f0,3))
    if lme.Coefficients.pValue(find(names == "(Intercept)")) < 0.05
        text(1,20,'*',FontSize=30,color='k')
    end

    nexttile;
    hold on;
    title("Holds")
    plot_data(x,hold_cycles)
    plot_extras(size(stacked_f0,3))
    plot_model(x,"phase_holds",lme,intercept,cycle_slope)

    nexttile;
    hold on;
    title("Early Washout")
    plot_data(x,early_washout_cycles)
    plot_extras(size(stacked_f0,3))
    plot_model(x,"phase_early_washout",lme,intercept,cycle_slope)

    nexttile;
    hold on;
    title("Late Washout")
    plot_data(x,late_washout_cycles)
    plot_extras(size(stacked_f0,3))
    plot_model(x,"phase_late_washout",lme,intercept,cycle_slope)
    
    saveas(fig,'multiple_pitch_adapt_figures/phase_by_cycle','fig');
    saveas(fig,'multiple_pitch_adapt_figures/phase_by_cycle','epsc');
end

function[] = plot_extras(n_cycles)
    ylim([-45,25])
    xlabel("Cycle")
    ylabel("Pitch (cents)")
    xticks(0:n_cycles-1)
    xticklabels(1:n_cycles)
    xlim([-0.5,n_cycles-0.5])
end

function[] = plot_data(x,data)
    means = mean(data,1,"omitmissing");
    [H, P, CI] = ttest(data);
    errorbar(x,means,-(CI(1,:)-means),CI(2,:)-means,"MarkerSize",20,"LineStyle","none",color='k',Marker='.')
end

function[] = plot_model(x,phase_name,lme,intercept,cycle_slope)
    names = lme.Coefficients.Name;
    phase_coef = lme.Coefficients.Estimate(find(names == phase_name));
    cycle_interact = lme.Coefficients.Estimate(find(names == strcat(phase_name,":cycle")));
    plot(x,intercept + cycle_slope*x + phase_coef + cycle_interact*x,LineStyle='--',LineWidth=2,color='k')
    if lme.Coefficients.pValue(find(names == strcat(phase_name,":cycle"))) < 0.05
        text(0.93,20,'*',FontSize=20,color='k')
    end
end