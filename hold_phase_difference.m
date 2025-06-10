function[] = hold_phase_difference(stacked_f0,cond_values,baseline_size,adapt_size,washout_size)
    trial_diff = NaN(size(stacked_f0,1),size(stacked_f0,2),size(stacked_f0,3)-1);
    tick_labels = strings(1,size(trial_diff,2));
    i_vec = 1:size(trial_diff,3);
    for i = i_vec
        tick_labels(i) = strcat(num2str(i+1), " - ", num2str(i));
        trial_diff(:,:,i) = stacked_f0(:,:,i+1) - stacked_f0(:,:,i);
    end

    baseline_trials = reshape(trial_diff(:,cond_values(2)-baseline_size+1:cond_values(2),:),[],size(trial_diff,3));
    adapt_trials = reshape(trial_diff(:,cond_values(3)-adapt_size+1:cond_values(3),:),[],size(trial_diff,3));
    early_washout_trials = reshape(trial_diff(:,cond_values(3)+1:cond_values(3)+washout_size,:),[],size(trial_diff,3));
    late_washout_trials = reshape(trial_diff(:,cond_values(4)-washout_size+1:cond_values(4),:),[],size(trial_diff,3));

    fig = figure;
    tiledlayout(2,2);
    
    nexttile;
    hold on;
    title("Baseline")
    plot_diff(i_vec,baseline_trials)
    plot_extras(i_vec,tick_labels)
    
    nexttile;
    hold on;
    title("Holds")
    plot_diff(i_vec,adapt_trials)
    plot_extras(i_vec,tick_labels)

    nexttile;
    hold on;
    title("Early Washout")
    plot_diff(i_vec,early_washout_trials)
    plot_extras(i_vec,tick_labels)

    nexttile;
    hold on;
    title("Late Washout")
    plot_diff(i_vec,late_washout_trials);
    plot_extras(i_vec,tick_labels);

    saveas(fig,'multiple_pitch_adapt_figures/hold_phase_difference','fig');
    saveas(fig,'multiple_pitch_adapt_figures/hold_phase_difference','epsc');
end

function [] = plot_diff(i_vec,trial_diff)
    means = mean(trial_diff,1,"omitmissing");
    bar(i_vec, means,0.3,FaceColor="#7E2F8E")
    [H, P, CI] = ttest(trial_diff);
    for i = i_vec
        plot([i,i],[CI(1,i),CI(2,i)],'k-_')
        if P(i) < 0.05
            text(i-0.1,15,"*",FontSize=15);
        end
    end
end

function [] = plot_extras(i_vec,tick_labels)
    xticks(i_vec)
    xticklabels(tick_labels)
    xlabel("Hold Phase")
    ylabel("Adaptation Difference (cents)")
    ylim([-55,20]);
end