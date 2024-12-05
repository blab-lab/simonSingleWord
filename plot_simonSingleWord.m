function plot_simonSingleWord(dataPaths)

% Analysis function for simonSingleWord experiment, which ran in May/June
% 2021.
%
% 2021-08 BP init.

dbstop if error

if nargin < 1 || isempty(dataPaths)
    dataPaths = get_dataPaths_simonSingleWord;
end

%% set up parameters

set(0, 'DefaultFigureRenderer', 'painters');

nSubs = length(dataPaths);
filenamePlotData = sprintf('plotData_%ds_simonSinglewordAnalysis',nSubs);
load(fullfile(get_acoustLoadPath('simonSingleWord'),strcat(filenamePlotData,'.mat')));

phases = fieldnames(ix);
nPhases = length(phases)-1; %don't draw a line after the first block of the washout phase

nSubs = size(fdata_proj{1},1);
nBins = size(fdata_proj{1},2);
V1color = [.9 0 0];
V2color = [0 0 .9];
F2scaleFact = .7;
figpos = [1 1 19.7556 14.8167];
plotParams.TileSpacing = 'compact';
lineWidth = 2;

%% plot sign-corrected data for F1 and F2
h1(1) = figure('Units','centimeters','Position',figpos); hold on;
errorbar(1:nBins,mean(fdata_norm_flip.f1{1}),ste(fdata_norm_flip.f1{1}),'o-','Color',V1color,'MarkerFaceColor',V1color);
errorbar(1:nBins,mean(fdata_norm_flip.f1{2}),ste(fdata_norm_flip.f1{2}),'o-','Color',V2color,'MarkerFaceColor',V2color);
hline(0,'k',':');
for p = 1:nPhases
    vline(ix.(phases{p})+0.5,'k','-');
end
xlabel('bin (10 trials)');
ylabel('F1 (mels)');
title('Within-trial average F1 values in first vs second vowel');
legend({'V1','V2'},'Location','northwest');
makeFig4Screen


h1(2) = figure; hold on;
errorbar(1:nBins,mean(fdata_norm_flip.f2{1}),ste(fdata_norm_flip.f2{1}),'o-','Color',F2scaleFact.*V1color,'MarkerFaceColor',F2scaleFact.*V1color);
errorbar(1:nBins,mean(fdata_norm_flip.f2{2}),ste(fdata_norm_flip.f2{2}),'o-','Color',F2scaleFact.*V2color,'MarkerFaceColor',F2scaleFact.*V2color);
hline(0,'k',':');
for p = 1:nPhases
    vline(ix.(phases{p})+0.5,'k','-');
end
xlabel('bin (10 trials)');
ylabel('F2 (mels)');
title('Within-trial average F2 values in first vs second vowel');
legend({'V1','V2'},'Location','northwest');
makeFig4Screen

h_all(1) = figure('Units','centimeters','Position',figpos); hold on;
copy_fig2tiledlayout(h1,h_all(1),2,1,[],[],1,plotParams)

%% plot projection onto perturbation direction
h2(1) = figure; hold on;
errorbar(1:nBins,mean(fdata_proj{1}),ste(fdata_proj{1}),'o-','Color',V1color,'MarkerFaceColor',V1color,'LineWidth',lineWidth);
errorbar(1:nBins,mean(fdata_proj{2}),ste(fdata_proj{2}),'o-','Color',V2color,'MarkerFaceColor',V2color,'LineWidth',lineWidth);
ylim([-10 40])
hline(0,'k',':');
for p = 1:nPhases
    vline(ix.(phases{p})+0.5,'k','--');
end
% xlabel('bin (10 trials)');
ylabel('Adaptation (mels)');
set(gca,'XTick', [ix.baseline/2 + .5, ix.baseline + (ix.ramp-ix.baseline)/2 + .5, ix.ramp + (ix.adapt-ix.ramp)/2+.5, ix.adapt + (nBins - ix.adapt)/2  + .5],...
    'XTickLabel', phases)
% title('Adaptation magnitude in first vs second vowel');
% legend({'V1','V2'},'Location','northwest');
makeFig4Screen

h2(2) = figure; hold on;
rampVals = linspace(0,-125,7);
plot([0:ix.baseline ix.baseline+0.5 ix.baseline+1:ix.ramp ix.ramp+0.5 ix.ramp+1:ix.adapt ix.adapt+0.5 ix.adapt+0.5 ix.adapt+1:nBins+1]...
    ,[zeros(1,4) rampVals([1 2 4 6 7]) repmat(-125, 1, ix.adapt-ix.ramp+1) zeros(1,nBins - ix.adapt + 2)],'-','Color','k','LineWidth',lineWidth);
ylim([-125 0])
hline(0,'k',':');
for p = 1:nPhases
    vline(ix.(phases{p})+0.5,'k','--');
end
set(gca, 'YTick', [-125 0],'XTick',[])
makeFig4Screen

h_all(2) = figure('Units','centimeters','Position',[figpos(1:3) figpos(4)*.7]); hold on;
copy_fig2tiledlayout(h2,h_all(2),4,1,[1 4],[{[3 1]} {[1 1]}],1,plotParams)

%% plot F1 and F2 difference between V1 and V2
h3(1) = figure; hold on;
% dat = abs(fdata_norm.f1{1}-fdata_norm.f1{2});
dat = abs(fdata.f1{1}-fdata.f1{2});
errorbar(1:nBins,mean(dat),ste(dat),'o-','Color','k','MarkerFaceColor','k','LineWidth',lineWidth);
ylim([0 60])
hline(mean(mean([abs(fdata.f1{1}(:,1:3)-fdata.f1{2}(:,1:3))],2)),'k',':')
for p = 1:nPhases
    vline(ix.(phases{p})+0.5,'k','-');
end
set(gca,'XTick', [ix.baseline/2 + .5, ix.baseline + (ix.ramp-ix.baseline)/2 + .5, ix.ramp + (ix.adapt-ix.ramp)/2+.5, ix.adapt + (nBins - ix.adapt)/2  + .5],...
    'XTickLabel', phases)
ylabel('F1 dist. (mels)');
title('Distance between F1 values in first and second vowel');
makeFig4Screen

h3(2) = figure; hold on;
% dat = abs(fdata_norm.f2{1}-fdata_norm.f2{2});
dat = abs(fdata.f2{1}-fdata.f2{2});
errorbar(1:nBins,mean(dat),ste(dat),'o-','Color','k','MarkerFaceColor','k','LineWidth',lineWidth);
ylim([0 60])
set(gca,'XTick', [ix.baseline/2 + .5, ix.baseline + (ix.ramp-ix.baseline)/2 + .5, ix.ramp + (ix.adapt-ix.ramp)/2+.5, ix.adapt + (nBins - ix.adapt)/2  + .5],...
    'XTickLabel', phases)
ylabel('F2 dist. (mels)');
hline(mean(mean(abs([fdata.f2{1}(:,1:3)-fdata.f2{2}(:,1:3)]),2)),'k',':')
for p = 1:nPhases
    vline(ix.(phases{p})+0.5,'k','-');
end
title('Distance between F2 values in first and second vowel');
makeFig4Screen

h_all(3) = figure('Units','centimeters','Position',figpos);
copy_fig2tiledlayout(h3,h_all(3),2,1,[],[],1,plotParams)

%     DOES NOT ACCOUNT FOR SHIFT ORDER
%     h4(1) = plot_pairedData(fdata_phase.f1.adapt,[V1color;V2color]);
%     hline(0,'k',':');
%     title('F1 values at end of hold');
%     ylabel('F1 (mels)');
%     makeFig4Screen
%
%     h4(2) = plot_pairedData(fdata_phase.f1.washout,[V1color;V2color]);
%     hline(0,'k',':');
%     title('F1 values in washout');
%     ylabel('F1 (mels)');
%     makeFig4Screen
%
%     h4(3) = plot_pairedData(fdata_phase.f2.adapt,F2scaleFact.*[V1color;V2color]);
%     hline(0,'k',':');
%     title('F2 values at end of hold');
%     ylabel('F2 (mels)');
%     makeFig4Screen
%
%     h4(4) = plot_pairedData(fdata_phase.f2.washout,F2scaleFact.*[V1color;V2color]);
%     hline(0,'k',':');
%     title('F2 values in washout');
%     ylabel('F2 (mels)');
%     makeFig4Screen
%
%     ylims.f1(1,1:2) = get(h4(1).Children(1),'ylim');
%     ylims.f1(2,1:2) = get(h4(2).Children(1),'ylim');
%     ylims.f2(1,1:2) = get(h4(3).Children(1),'ylim');
%     ylims.f2(2,1:2) = get(h4(4).Children(1),'ylim');
%     set(h4(1).Children(1),'ylim',[min(ylims.f1(:,1)) max(ylims.f1(:,2))]);
%     set(h4(2).Children(1),'ylim',[min(ylims.f1(:,1)) max(ylims.f1(:,2))]);
%     set(h4(3).Children(1),'ylim',[min(ylims.f2(:,1)) max(ylims.f2(:,2))]);
%     set(h4(4).Children(1),'ylim',[min(ylims.f2(:,1)) max(ylims.f2(:,2))]);

%     h_all(4) = figure('Units','centimeters','Position',figpos);
%     copy_fig2tiledlayout(h4,h_all(4),2,2,[],[],1)
%     makeFig4Screen


%% plot individual data as projection onto perturbation by vowel and phase
params.MarkerSize = 100;
h5(1) = plot_pairedData(fdata_proj_phase,[V1color;V2color;V1color;V2color],params);
ylabel('Adaptation (mels)');
hline(0,'k',':');
set(gca,'XTick',[1.5 3.5],'XTickLabel',{'Adaptation' 'Washout'});
makeFig4Screen

h_all(5) = figure('Units','centimeters','Position',figpos);

copy_fig2tiledlayout(h5,h_all(5),1,1,[],[],1,plotParams)


%% plot correlation of individual data as projection onto perturbation in hold phase
h6(1) = figure;
plot(fdata_proj_phase.V1Adapt,fdata_proj_phase.V2Adapt,'o',...
    'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',8);
ylabel('V2 Adaptation (mels)');
xlabel('V1 Adaptation (mels)');
axis square
hline(0,'k',':');
vline(0,'k',':');
set(gca,'xcolor',V1color,'ycolor',V2color)
makeFig4Screen

h_all(6) = figure('Units','centimeters','Position',figpos);

copy_fig2tiledlayout(h6,h_all(6),1,1,[],[],1,plotParams)

%% plot perturbation example
subjInd = 1;
load(fullfile(dataPaths{subjInd},'pre','expt.mat'))
fmtMeans = calc_vowelMeans(fullfile(dataPaths{subjInd},'pre'));
plotColors = {V1color V2color}; 
[~,expt] = calc_formantShifts(fmtMeans, expt.shiftMag, 'eh', {'ih' 'ae'}, 1, expt);
h7(1) = plot_perturbs(fmtMeans, expt.shifts.mels,'eh',[0 1],plotColors);
set(gca,'Xlim',[500 850],'Ylim', [1250 1500],'YTick', 1300:100:1500);
set(gca,'XTick',[],'XLabel',[])
makeFig4Screen

plotColors = {V2color V1color}; 
h7(2) = plot_perturbs(fmtMeans, expt.shifts.mels,'eh',[0 1],plotColors);
set(gca,'Xlim',[500 850],'Ylim', [1250 1500],'YTick', 1300:100:1500);
makeFig4Screen

h_all(7) = figure('Units','centimeters','Position',[figpos(1:2) figpos(3)*.5 figpos(4)*.75]);

copy_fig2tiledlayout(h7,h_all(7),2,1,[],[],1,plotParams)

%% plot F1 adaptation by perturbation group
group{1} = strcmp(shiftCat,'AE-IH');
group{2} = ~group{1};

for g = 1:2
    h8(g) = figure; hold on;
    V1 = fdata_norm.f1{1}(group{g},:);
    V2 = fdata_norm.f1{2}(group{g},:);
    errorbar(1:nBins,mean(V1),ste(V1),'o-','Color',V1color,'MarkerFaceColor',V1color,'LineWidth',lineWidth);
    errorbar(1:nBins,mean(V2),ste(V2),'o-','Color',V2color,'MarkerFaceColor',V2color,'LineWidth',lineWidth);
    ylim([-40 40])
    hline(0,'k',':');
    for p = 1:nPhases
        vline(ix.(phases{p})+0.5,'k','--');
    end
    % xlabel('bin (10 trials)');
    ylabel('F1 change (mels)');
    if g ==2
        set(gca,'XTick', [ix.baseline/2 + .5, ix.baseline + (ix.ramp-ix.baseline)/2 + .5, ix.ramp + (ix.adapt-ix.ramp)/2+.5, ix.adapt + (nBins - ix.adapt)/2  + .5],...
            'XTickLabel', phases)
        xlabel(' ')
    else
        set(gca,'XTick', [],...
            'XTickLabel', [])
        
    end
    % title('Adaptation magnitude in first vs second vowel');
    % legend({'V1','V2'},'Location','northwest');
    makeFig4Screen
end

h_all(8) = figure('Units','centimeters','Position',[figpos(1:2) figpos(3) figpos(4)*.75]); hold on;
copy_fig2tiledlayout(h8,h_all(8),2,1,[],[],1,plotParams)

end %EOF

function h_fig = plot_perturbs(fmtMeans,shifts,vowel2shift,bMel,pertColors)
%get vowels to plot
vowels = fieldnames(fmtMeans);
nVow = length(vowels);

h_fig = figure;
hold on

%plot the vowels
for v = 1:nVow
    vow = vowels{v};
    if ~bMel(1)
        fmtMeans.(vow)(1) = hz2mel(fmtMeans.(vow)(1));
        fmtMeans.(vow)(2) = hz2mel(fmtMeans.(vow)(2));
    end
    plot(fmtMeans.(vow)(1),fmtMeans.(vow)(2),'o','MarkerSize',10,...
        'MarkerFaceColor','w','MarkerEdgeColor','w');
    text(fmtMeans.(vow)(1),fmtMeans.(vow)(2),vow,...,
        'FontSize',20,'FontWeight','bold',...
        'HorizontalAlignment','center');
end

%plot the perturbations
center = fmtMeans.(vowel2shift);
nPerts = length(shifts);
for p = 1:nPerts
    if ~bMel
        shift = hz2mel(shifts{p});
    else
        shift = shifts{p};
    end
    if any(abs(shift)>0)
        quiver(center(1),center(2),shift(1),shift(2),0,...
            'Color',pertColors{p},'LineWidth',3,'MaxHeadSize',.8);
    end
end

xlabel('F1 (mels)')
ylabel('F2 (mels)')
axis equal
makeFig4Screen
end