function expt = run_simonSingleWord_v2_expt(expt, bTestMode)
% RUN_SIMONSINGLEWORD_EXPT_v2    This is an Audapter formant perturbation,
%  adaptation experiment designed in 2022 in SMAC Lab. It is part of a
%  broader group of experiments called "SimOn" -- simultaneous adaptation.
%  In this study, participants hear opposing perturbations on each syllable
%  of the word "bedhead", to see if they can learn these opposing
%  perturbations, despite /E/ being perturbed in both cases.
%
%  The experiment is counterbalanced between people receiving a
%  F1 perturbation up on the first syllable and F1 down on the
%  second syllable, and vice versa. For all participants, the amount of
%  perturbation scales based on phase, with the typical baseline, ramp,
%  hold, and washout phases.
%
%  There are also "transfer" blocks before the baseline phase and after the
%  washout phase. These blocks use other 2-syllable stimulus words with /E/
%  to assess if adaptation on that vowel transferred to non-training words.

% 2021-01 v1. Adapted from run_modelExpt_expt. Programmed by Mackenzie
%   Bugg & Kathleen Zarnott, and Chris Naber.
% 2022-11 v2. Adapted from run_simonSingleWord_expt. Programmed by Yuyu
% Zeng and Chris Naber. 

% Default Arguments
if nargin < 1, expt = []; end
if nargin < 2 || isempty(bTestMode), bTestMode = 0; end

%% Experiment Setup/Establish Folder and Group
expt.name = 'simonSingleWord_v2';
if ~isfield(expt,'snum'), expt.snum = get_snum; end
expt.dataPath = get_acoustSavePath(expt.name, expt.snum);

if ~exist(expt.dataPath,'dir')
    mkdir(expt.dataPath)
end

%Added line
%rng('shuffle');

% Load in existing expt.mat, if there is one
if isfile(fullfile(expt.dataPath, 'expt.mat'))
    bOverwrite = input('This participant already exists. Load in existing expt? (y/n): ', 's');
    if strcmp(bOverwrite,'y')
        load(fullfile(expt.dataPath, 'expt.mat'), 'expt')
    end
end

if ~isfield(expt,'gender'), expt.gender = get_height; end

%% Finish setting up expt file
expt.shiftMag = 125;
expt.shiftNames = {'noShift', 'Shift'};

expt.timing.stimdur = 1.8; %longer than normal, for a 2-syllable word
expt.timing.stimdurTrns = 1.8;          % time transfer stim on screen
expt.timing.interstimdur = 1.25;
expt.timing.interstimjitter = .25;

%% Use exptpre to set up formant shifts with formantmeans from run_measureformants_audapter
exptpre = expt;
exptpre.dataPath = fullfile(expt.dataPath,'pre');

%Switch to bid/bad/bed for collection of formantmeans
exptpre.words = {'bid' 'bat' 'bed'};
nwordspre = length(exptpre.words);

% Set to use default single-syllable, one word Audapter OST file
exptpre.trackingFileLoc = 'experiment_helpers';
exptpre.trackingFileName = 'measureFormants';

%Where nblocks is the number of repetitions for each word.
if bTestMode
    exptpre.nblocks = 1;
else
    exptpre.nblocks = 10;
end

exptpre.ntrials = exptpre.nblocks * nwordspre; % testMode = 3, live = 30;
exptpre.breakFrequency = exptpre.ntrials;
exptpre.breakTrials = exptpre.ntrials;
exptpre.conds = {'noShift'};
exptpre = set_exptDefaults(exptpre); % set missing expt fields to defaults

%% Stimuli setup
expt.words = {'bedhead' 'bed' 'head' ...
    'redhead' 'bedspread' 'headrest' 'deathbed' ...
    'breastfed'};


nwords = 1; % beadhead
nwordsTrns = 8; % all the other words

expt.conds = {'transfer1' 'baseline' 'ramp' 'hold' 'transfer2' 'washout'};

if bTestMode
    testModeReps = 1;
    testModeRepsTransfer = 1; 
    
    nTransfer1 =          testModeRepsTransfer * nwordsTrns;
    nBaseline =           testModeReps * nwords;
    nRamp =               testModeReps * nwords;
    nHold =               testModeReps * nwords * 2;
    nTransfer2 =          testModeRepsTransfer * nwordsTrns;
    nWashout =            testModeReps * nwords;
    expt.breakFrequency = 99;
else
    nTransfer1 =    10 * nwordsTrns
    nBaseline =     20 * nwords;
    nRamp =         30 * nwords;
    nHold =         200 * nwords;
    nTransfer2 =    10 * nwordsTrns
    nWashout =      10 * nwords;
    expt.breakFrequency = 30;
end

% Set Noise
expt.noise = {'none' 'mask' 'speechAndNoise' 'speechshaped'};
expt.allNoise = [2.*ones(1,nTransfer1) 1.*ones(1,nBaseline) ...
    3.*ones(1,(nRamp+nHold)) 2.*ones(1,nTransfer2) ...
    1.*ones(1,nWashout)];
% 4 for speech-shaped noise, 3 for speech + noise, 2 for just masking noise
expt.listNoise = expt.noise(expt.allNoise);
refreshWorkingCopy
%% Set up Main Experiment
expt.ntrials = nTransfer1 + nBaseline + nRamp + nHold + nTransfer2 + nWashout;

expt.breakTrials = expt.breakFrequency:expt.breakFrequency:expt.ntrials;
expt.allConds = [1*ones(1,nTransfer1) 2*ones(1,nBaseline) ...
    3*ones(1,nRamp) 4*ones(1,nHold) ...
    5*ones(1,nTransfer2) 6*ones(1,nWashout)];
expt.trackingFileName = expt.words{1};
expt.trackingFileLoc = expt.name;
refreshWorkingCopy(expt.trackingFileLoc, expt.trackingFileName, 'both');

%% Collect /ih/ /ae/ /eh/ formant means and view perturbation field
LPC_OK = 'no';
while strcmp(LPC_OK, 'no')
    % NOTE: Future functions could use run_checkLPC to simplify this section
    refreshWorkingCopy('experiment_helpers', 'measureFormants', 'both');
    exptpre = run_measureFormants_audapter(exptpre,3);
    
    %check LPC order
    check_audapterLPC(exptpre.dataPath)
    hGui = findobj('Tag','check_LPC');
    waitfor(hGui);
    
    %set lpc order
    load(fullfile(exptpre.dataPath,'nlpc'),'nlpc')
    p.nLPC = nlpc;
    expt.audapterParams = p;
    
    % save expt
    if ~exist(expt.dataPath,'dir')
        mkdir(expt.dataPath)
    end
    exptfile = fullfile(expt.dataPath,'expt.mat');
    bSave = savecheck(exptfile);
    if bSave
        save(exptfile, 'expt')
        fprintf('Saved expt file: %s.\n',exptfile);
    end
    
    %Get vowel formant means from expt
    exptpre.fmtMeans = calc_vowelMeans(exptpre.dataPath);
    
    [shifts, expt] = calc_formantShifts(exptpre.fmtMeans, expt.shiftMag, 'eh', {'ih' 'ae'}, 1, expt);
    
    %check that these values make sense
    h_checkPert = plot_perturbations(exptpre.fmtMeans, expt.shifts.mels, 'eh');
    LPC_OK = askNChoiceQuestion('Is the LPC order OK?', {'yes', 'no'});
    
    try % close the plot_perturbations figure if it's still open
        close(h_checkPert)
    catch
    end
    
end

input('\nRead instructions, then press ENTER to continue to "Pretest phase: OST Check" section', 's');

%% Pretest phase to configure OST
exptost = expt;

if ~bTestMode
    bGoodOSTs = 0;
else
    bRunPretest = input('[Test mode only] Run ost pretest phase (1), or skip it (0)? ');
    bGoodOSTs = ~bRunPretest;
end

if ~bTestMode
    exptost.ntrials = 9;
else
    exptost.ntrials = 3;
end

while ~bGoodOSTs
    exptost.dataPath = fullfile(expt.dataPath, 'ost_check');
    
    exptost.words = {'bedhead'};
    exptost.allWords = ones(1, exptost.ntrials);
    exptost.listWords = exptost.words(exptost.allWords);
    
    exptost.conds = {'ost_check'};
    exptost.allConds = ones(1, exptost.ntrials);
    exptost.listConds = exptost.conds(exptost.allConds);
    
    exptost.allNoise = 3 * ones(1, exptost.ntrials); % speech and noise
    exptost.listNoise = exptost.noise(exptost.allNoise);
    
    exptost.trackingFileName = exptost.words{1};
    exptost.trackingFileLoc = exptost.name;
    refreshWorkingCopy(exptost.trackingFileLoc, exptost.trackingFileName, 'both');
    
    exptost = set_exptDefaults(exptost);
    
    % run ost_check phase
    exptost = run_simonSingleWord_v2_audapter(exptost);
    
    % view ost_check trials in audapter_viewer
    fprintf('Loading ost_check data... ')
    load(fullfile(exptost.dataPath, 'data.mat'), 'data');
    fprintf('Done\n')

    audapter_viewer(data, exptost);
    hGui = findobj('Tag','audapter_viewer');
    waitfor(hGui);
    
    % Decide to redo or move on
    moveOn_resp = askNChoiceQuestion('Redo OST testing phase, or move on?', {'redo', 'move on'});
    if strcmp(moveOn_resp, 'move on')
        % if moving on, save OST settings to expt
        ostList = get_ost(expt.name, exptost.words{1}, 'list');
        for o = 1:length(ostList)
            ostStatus = str2double(ostList{o});
            [heur, param1, param2] = get_ost(expt.name, exptost.words{1}, ostStatus);
            expt.subjOstParams{o} = {ostStatus heur param1 param2};
        end
        bGoodOSTs = 1; % ok to leave while loop
    end
        
end

input('\nRead instructions, then press ENTER to continue to "Practice with stimulus words" phase', 's');

%% get shift permutation
permsPath = '\\wcs-cifs\wc\smng\experiments\simonSingleWord_v2\';
%permsPath = 'W:\experiments\simonSingleWord_v2'; % un-comment when testing locally
fprintf('Trying to access server... ');
if exist(permsPath,'dir')
    fprintf('found it.\n');
    [expt.permIx, expt.shiftsInOrder] = get_cbPermutation(expt.name, permsPath); % get the words and their index
    if ~bTestMode
        set_cbPermutation(expt.name, expt.permIx, permsPath);
    end
else % If the server is down for some reason
    expt.permIx = randi(2);
    % Then use a local copy of the permutations (counts do not
    %  have to be up to date, you just want the order of conditions)
    localPermsPath = 'C:\Users\Public\Documents\experiments\simonSingleWord_v2';
    [~, expt.shiftsInOrder] = get_cbPermutation(expt.name, localPermsPath, [], expt.permIx);
    
    % save warning.txt file with permIx
    warningFile = fullfile(expt.dataPath,'warning.txt');
    fid = fopen(warningFile, 'w');
    warning('Server did not respond. Using randomly generated permutation index (see warning file)');
    fprintf(fid,'Server did not respond. Random permIx generated: %d', expt.permIx);
    fclose(fid);
end

%% set per-trial perturbations in expt.shiftMags
minShiftMag = 0;

expt.shiftMags = [zeros(1,nTransfer1) ...
    zeros(1,nBaseline) ...
    linspace(minShiftMag, expt.shiftMag, nRamp) ...
    expt.shiftMag * ones(1,nHold) ...
    zeros(1, nTransfer2), ...
    zeros(1,nWashout)];

%% get shift permutation
if contains(expt.shiftsInOrder{1},'shiftIH')
    expt.shiftAngles = [shifts.shiftAng(1) shifts.shiftAng(2)];
else
    expt.shiftAngles = [shifts.shiftAng(2) shifts.shiftAng(1)];
end

% Randomize Order of allWords
transfer1AllWords = randomize_wordOrder(nwordsTrns, nTransfer1/nwordsTrns);
baselineAllWords = ones(1, nBaseline);
rampAllWords = ones(1, nRamp);
holdAllWords = ones(1, nHold);
transfer2AllWords = randomize_wordOrder(nwordsTrns, nTransfer2/nwordsTrns);
washoutAllWords = ones(1, nWashout);

expt.allWords = [transfer1AllWords baselineAllWords rampAllWords holdAllWords ...
    transfer2AllWords washoutAllWords];

expt.listWords = expt.words(expt.allWords);

%%Re-assign shift and word assignment based on permutation order
expt.allShiftNames(expt.allConds == 1) = 1; %noShift for words in transfer1
expt.allShiftNames(expt.allConds == 2) = 1; %noShift for words in baseline
expt.allShiftNames(expt.allConds == 5) = 1; %noShift for words in transfer2
expt.allShiftNames(expt.allConds == 6) = 1; %noShift for words in washout
expt.allShiftNames(expt.allShiftNames == 0) = 2; %Set the remaining to be 2

% Set shiftNames fields, which allign 1-1 with shift fields
expt.listShiftNames = expt.shiftNames(expt.allShiftNames);

%% set defaults and save experiment file
expt = set_exptDefaults(expt);

save(exptfile, 'expt')
fprintf('Saved expt file: %s.\n',exptfile);

input('\nRead instructions, then press ENTER to continue to "Main Phase"', 's');

%% run main experiment
expt = run_simonSingleWord_v2_audapter(expt); 

end %EOF
