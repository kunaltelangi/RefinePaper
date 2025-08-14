% Paths
folder = 'latex-teaching/figures/';

% LaTeX Defaults
setlatex();

%% Single Parity Plot
paperfigure();

% Data setup
ytrue = (0.01:0.0001:1).';
ypred = normrnd(ytrue, 0.02);

% Plot & Save
parityplot(ytrue, ypred);
savefigpng(folder, 'single-parity');

% Caption
rmse_single = get_errmetrics(ypred, ytrue, 'rmse');
caption_str = sprintf('Parity plot with \\gls{rmse} of \\SI{%.5d}{\\J\\per\\square\\m}', rmse_single);
savefigstr(caption_str, 'multi-parity', folder);

%% Multiple Parity Plots
% Predictions with different noise levels
noise_levels = [0.02, 0.05, 0.1, 0.15];
Slist = cell(1, numel(noise_levels));

for idx = 1:numel(noise_levels)
    Slist{idx} = struct( ...
        'ytrue', ytrue, ...
        'ypred', normrnd(ytrue, noise_levels(idx)) ...
    );
end

% Plot & Save
multiparity(Slist, 'ht', 14);
savefigpng(folder, 'multi-parity');

% RMSE calculation
rmse_vals = zeros(numel(Slist), 1);
for idx = 1:numel(Slist)
    rmse_vals(idx) = get_errmetrics(Slist{idx}.ypred, ytrue, 'rmse');
end
writematrix(rmse_vals, fullfile(folder, 'parity-test-rmse.csv'));

% Caption
caption_list = get_captionlist(rmse_vals);
caption_str = sprintf('Parity plots with \\glspl{rmse} of %s \\SI{}{\\J\\per\\square\\m}.', caption_list);
savefigstr(caption_str, 'multi-parity', folder);
