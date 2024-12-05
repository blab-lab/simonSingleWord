%CD to the acoustic folder

cd("\\wcs-cifs\wc\smng\experiments\simonSingleWord\acousticdata");

% List all participants
Participants = ["sp322" "sp352" "sp353" "sp354" "sp355" "sp356" "sp358" ...
    "sp359" "sp360" "sp363" "sp364" "sp365" "sp366" "sp367" "sp368" ...
    "sp369" "sp371" "sp372" "sp373" "sp375"];

% Set up looping variable for participants
nParticipants = width(Participants);

ParticipantIndex = 1;

% Set up looping variable for trials
nTrial = 1;

% Set up looping frame

% Select the first person

Participant = Participants(ParticipantIndex);

load(fullfile('.', Participant, 'dataVals.mat'));
load(fullfile('.', Participant, 'expt.mat'));

%Find the location of the vowels

[row, Indx1] = find(dataVals(nTrial).segment == "v1Start"); % Vowel location
[row, Indx2] = find(dataVals(nTrial).segment == "v2Start"); % Vowel location

% Read data of the first trial

%First syllable
f0 = dataVals(nTrial).f0{1, Indx1}; %f0
Int = dataVals(nTrial).int{1, Indx1}; %Int
Trial = repelem(nTrial, height(f0))'; %Trial number
Position = (1:height(f0))'; %Position within a measurement window
%%Word = repelem(expt.listWords(nTrial), height(f0))'; %Word
Syllable = repelem("bed", height(f0))'; %Syllable
Speaker = repelem(Participant, height(f0))'; %Speaker



% Create tables with headers
data = table(f0, Int, Trial, Position, Syllable, Speaker);

% Retain only the table headers

data(1:height(data),:) = [];

% Zoom into individual participants and collect data

while ParticipantIndex <= nParticipants

    % Zoom into one participant & Load data
    Participant = Participants(ParticipantIndex);

    load(fullfile('.', Participant, 'dataVals.mat'));
    load(fullfile('.', Participant, 'expt.mat'));

    % Retain only the table headers

    data(1:height(data),:) = [];

    % Zoom into individual trials

    nRow = width(dataVals);

    % Set up looping variable for trial

    nTrial = 1;

    % Obtain info
    while nTrial <= nRow

        %Check if this row is empty
        if isempty(dataVals(nTrial).segment)
            nTrial = nTrial + 1
            continue
        end

        %Find the location of the vowels

        [row, Indx1] = find(dataVals(nTrial).segment == "v1Start"); % Vowel location
        [row, Indx2] = find(dataVals(nTrial).segment == "v2Start"); % Vowel location

        if isempty(Indx1)
            nTrial = nTrial + 1
            continue
        end

        %% Access the first syllable
        f0 = dataVals(nTrial).f0{1, Indx1}; %f0

        % Skip the current trial if the f0 values are missing
        if isempty(f0)
            nTrial = nTrial + 1
            continue
        end

        Int = dataVals(nTrial).int{1, Indx1}; %Int
        Trial = repelem(nTrial, height(f0))'; %Trial number
        Position = (1:height(f0))'; %Position within a measurement window
        %%Word = repelem(expt.listWords(nTrial), height(f0))'; %Word
        Syllable = repelem("bed", height(f0))'; %Syllable
        Speaker = repelem(Participant, height(f0))'; %Speaker
      
        % Create a temporary table with headers
        temp = table(f0, Int, Trial, Position, Syllable, Speaker);

        % Join the temporary table with the master table
        data = [data; temp];

        % The second sylllable

        if isempty(Indx2)
            nTrial = nTrial + 1
            continue
        end

        f0 = dataVals(nTrial).f0{1, Indx2}; %f0

        % Skip the current trial if the f0 values are missing
        if isempty(f0)
            nTrial = nTrial + 1
            continue
        end

        Int = dataVals(nTrial).int{1, Indx2}; %Int
        Trial = repelem(nTrial, height(f0))'; %Trial number
        Position = (1:height(f0))'; %Position within a measurement window
        %%Word = repelem(expt.listWords(nTrial), height(f0))'; %Word
        Syllable = repelem("head", height(f0))'; %Syllable
        Speaker = repelem(Participant, height(f0))'; %Speaker
       

        % Create a temporary table with headers
        temp = table(f0, Int, Trial, Position, Syllable, Speaker);

        % Join the temporary table with the master table
        data = [data; temp];

        % Go to the next trial
        nTrial = nTrial + 1;
    end

    % Write one person's data to disk

    writetable(data, strcat(Participant, '_Prosody.csv'));

    % Go to the next participant
    ParticipantIndex = ParticipantIndex + 1;

end