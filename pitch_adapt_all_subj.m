function[] = pitch_adapt_all_subj()
    clear;
    close all;
    delete *.fig
    delete *.eps
    cwd = cd;
    total_trials = 220;
    pool_n = 5;
    baseline_size = 20;
    adapt_size = 20;
    washout_size = 20;
    set(0, 'DefaultAxesFontSize', 12);
    %set(0, 'DefaultTitleFontSize', 12);
    if ~isfile("multiple_pitch_adapt_data/stacked_f0.mat")
        [all_f0, all_amp, upshift_f0,downshift_f0,stacked_f0,stacked_upshift,stacked_downshift,cond_values,shifts,names] = get_group_data(total_trials,cwd,baseline_size,adapt_size,washout_size,false);
        close all;
        [all_f0, all_amp, upshift_f0,downshift_f0,stacked_f0,stacked_upshift,stacked_downshift,cond_values,shifts,names,excluded_names] = exclude_ppts(all_f0, all_amp, upshift_f0,downshift_f0,stacked_f0,stacked_upshift,stacked_downshift,cond_values,shifts,names);
        save("multiple_pitch_adapt_data/stacked_f0.mat",'stacked_f0')
        save("multiple_pitch_adapt_data/stacked_upshift.mat",'stacked_upshift')
        save("multiple_pitch_adapt_data/stacked_downshift.mat",'stacked_downshift')
        save("multiple_pitch_adapt_data/all_f0.mat",'all_f0')
        save("multiple_pitch_adapt_data/upshift_f0.mat",'upshift_f0')
        save("multiple_pitch_adapt_data/downshift_f0.mat",'downshift_f0')
        save("multiple_pitch_adapt_data/all_amp.mat",'all_amp')
        save("multiple_pitch_adapt_data/cond_values.mat",'cond_values')
        save("multiple_pitch_adapt_data/shifts.mat",'shifts')
    else
        load("multiple_pitch_adapt_data/stacked_f0.mat")
        load("multiple_pitch_adapt_data/stacked_upshift.mat")
        load("multiple_pitch_adapt_data/stacked_downshift.mat")
        load("multiple_pitch_adapt_data/all_f0.mat")
        load("multiple_pitch_adapt_data/upshift_f0.mat")
        load("multiple_pitch_adapt_data/downshift_f0.mat")
        load("multiple_pitch_adapt_data/all_amp.mat")
        load("multiple_pitch_adapt_data/cond_values.mat")
        load("multiple_pitch_adapt_data/shifts.mat")
    end
    
    tick_labels = ["Hold 1", "Hold 2", "Hold 3"];
    plot_indiv_scatter(stacked_f0,cond_values,adapt_size,tick_labels,true,"Adaptation (cents)","multiple_pitch_adapt_figures/indiv_scatter")
    %plot_correlations_old(stacked_f0,cond_values,adapt_size,washout_size,tick_labels)
    adapt_values = squeeze(mean(stacked_f0(:,cond_values(3)-adapt_size+1:cond_values(3),:),2,"omitmissing"));
    plot_correlations(adapt_values,[[2 1];[3 1];[nan nan];[3 2]],[2,2],"Pearson",["Hold 1", "Hold 2", "Hold 3"],[-110,120],"multiple_pitch_adapt_figures/correlations")
    run_lmm_pitch(stacked_f0, cond_values, baseline_size, adapt_size, washout_size, shifts)
    plot_rebaseline_timecourse(stacked_f0,pool_n,cond_values,[size(stacked_f0,3),1],"f0 (cents)",[-60,40],["Cycle 1", "Cycle 2", "Cycle 3"],'multiple_pitch_adapt_figures/rebaseline_timecourse')
    hold_phase_difference(stacked_f0,cond_values,baseline_size,adapt_size,washout_size)
    visualize_variability(stacked_f0,cond_values,baseline_size,adapt_size)
    plot_timecourse(all_f0,upshift_f0,downshift_f0,pool_n,cond_values)
    plot_fatigue(all_amp,all_f0,shifts,pool_n,cond_values)
    %plot_timecourse(all_f0,upshift_f0,downshift_f0,pool_n,cond_values)
end




