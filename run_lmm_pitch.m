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
    
    % full model
    fprintf("Full Model\n")
    phases = ["Baseline", "Holds", "Early Washout", "Late Washout"];
    cycles = ["1","2","3"];
    phase = repmat([repmat(phases(1),size(baseline,1)*size(baseline,2),1); repmat(phases(2),size(holds,1)*size(holds,2),1); repmat(phases(3),size(early_washout,1)*size(early_washout,2),1); repmat(phases(4),size(late_washout,1)*size(late_washout,2),1)],size(stacked_f0,3),1);
    cycle = [zeros(size(all,1)*size(all,2),1); ones(size(all,1)*size(all,2),1); repmat(2,size(all,1)*size(all,2),1)];
    cat_cycle = [repmat(cycles(1),size(all,1)*size(all,2),1); repmat(cycles(2),size(all,1)*size(all,2),1); repmat(cycles(3),size(all,1)*size(all,2),1)];
    
    participant = repmat(transpose(1:size(all,1)),size(all,2)*size(all,3),1);
    tbl = [array2table(pitch) array2table(phase) array2table(cycle) array2table(cat_cycle) array2table(participant)];% array2table(shift)];
    tbl=tbl(~any(ismissing(tbl),2),:);
    writetable(tbl,"pitch.csv")
    %lme = fitlme(tbl,"pitch ~ 1 + phase + cycle + phase*cycle + (1|participant)","DummyVarCoding","reference")
    %p = coefTest(lme)
    %anova(lme)

    fprintf("Full Model Cat")
    cat_lme = fitlme(tbl,"pitch ~ 1 + phase + cat_cycle + phase*cat_cycle + (1|participant)","DummyVarCoding","reference")
    p = coefTest(cat_lme)
    anova(cat_lme)

    % posthocs

    fig = figure('Position',[200,50,1000,400]);
    tiledlayout(1,length(cycles))

    for i=1:length(cycles)
        current_cycle = cycles(i);
        idx = find(tbl.cat_cycle == current_cycle);
        posthoc_tbl = tbl(idx,:);
        fprintf("Cycle = " + current_cycle + "\n")
        posthoc_lme = fitlme(posthoc_tbl,"pitch ~ 1 + phase + (1|participant)","DummyVarCoding","reference")
        p = coefTest(posthoc_lme)

        nexttile;
        hold on;
        title("Cycle " + current_cycle)
        betas = posthoc_lme.Coefficients.Estimate;
        std_errs = posthoc_lme.Coefficients.SE;
        std_devs = std_errs * sqrt(height(posthoc_tbl));
        variances = std_devs.^2;
        intercept_variance = variances(1);
        combined_variances = vertcat(intercept_variance, variances(2:end) + intercept_variance);
        combined_std_devs = sqrt(combined_variances);
        combined_std_errs = combined_std_devs ./ sqrt(height(posthoc_tbl));
        intercept = betas(1);
        total_betas = vertcat(intercept, betas(2:end)+intercept);
        bar(phases,total_betas)
        errorbar(1:length(phases),total_betas,combined_std_errs,LineStyle="none",color='k')
        for j=1:length(phases)
            if posthoc_lme.Coefficients.pValue(j) < 0.05
                text(j-0.1,max(10,total_betas(j) + 10),'*',FontSize=20,color='k')
            end
        end
        ylim([-45,27])
        ylabel("Fixed Effects Coefficient (cents)")

    end

    saveas(fig,'multiple_pitch_adapt_figures/posthocs_cycle','fig');
    saveas(fig,'multiple_pitch_adapt_figures/posthocs_cycle','epsc');

    fig = figure('Position',[200,50,1300,400]);
    tiledlayout(1,length(phases))

    for i=1:length(phases)
        current_phase = phases(i);
        idx = find(tbl.phase == current_phase);
        posthoc_tbl = tbl(idx,:);
        fprintf("Phase = " + current_phase + "\n")
        posthoc_lme = fitlme(posthoc_tbl,"pitch ~ 1 + cat_cycle + (1|participant)","DummyVarCoding","reference")
        p = coefTest(posthoc_lme)
        
        nexttile;
        hold on;
        title(current_phase)
        betas = posthoc_lme.Coefficients.Estimate;
        std_errs = posthoc_lme.Coefficients.SE;
        std_devs = std_errs * sqrt(height(posthoc_tbl));
        variances = std_devs.^2;
        intercept_variance = variances(1);
        combined_variances = vertcat(intercept_variance, variances(2:end) + intercept_variance);
        combined_std_devs = sqrt(combined_variances);
        combined_std_errs = combined_std_devs ./ sqrt(height(posthoc_tbl));
        intercept = betas(1);
        total_betas = vertcat(intercept, betas(2:end)+intercept);
        bar(cycles,total_betas)
        errorbar(1:length(cycles),total_betas,combined_std_errs,LineStyle="none",color='k')
        for j=1:length(cycles)
            if posthoc_lme.Coefficients.pValue(j) < 0.05
                text(j-0.1,max(10,total_betas(j) + 10),'*',FontSize=20,color='k')
            end
        end
        ylim([-45,27])
        xlabel("Cycle")
        ylabel("Fixed Effects Coefficient (cents)")

    end

    saveas(fig,'multiple_pitch_adapt_figures/posthocs_phase','fig');
    saveas(fig,'multiple_pitch_adapt_figures/posthocs_phase','epsc');