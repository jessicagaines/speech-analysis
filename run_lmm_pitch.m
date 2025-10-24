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

    fprintf("Full Model with Shift")
    cat_lme = fitlme(tbl,"pitch ~ 1 + phase + cat_cycle + shift + phase*cat_cycle + shift*phase + shift*cat_cycle + shift*phase*cat_cycle + (1|participant)","DummyVarCoding","reference")
    p = coefTest(cat_lme)
    anova(cat_lme)

    % posthocs

    posthoc(tbl,tbl.cat_cycle,tbl.phase,"pitch ~ 1 + phase + (1|participant)","Cycle ",[-45,27],"",'multiple_pitch_adapt_figures/posthocs_cycle')
    posthoc(tbl,tbl.phase,tbl.cat_cycle,"pitch ~ 1 + cat_cycle + (1|participant)","",[-45,27],"Cycle",'multiple_pitch_adapt_figures/posthocs_phase')

    end

