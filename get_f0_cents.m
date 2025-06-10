function [f0_cents] = get_f0_cents(f0, baseline_trials)
    baseline = mean(f0(baseline_trials),"omitmissing");
    f0_cents = (log2(f0./baseline))*1200;
    mean(f0_cents(baseline_trials),"omitmissing")
end