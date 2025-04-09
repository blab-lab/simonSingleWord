cd("\\wcs-cifs\wc\smng\experiments\simonSingleWord_v2\acousticdata");

% All participants

Participants = ["sp620" "sp624" "sp626" "sp627" "sp628"  "sp629" "sp630" "sp631" ...
    "sp634" "sp637" "sp638" ...
    "sp642" "sp643" "sp644" "sp645" "sp647" "sp648" "sp656" ...
    "sp657" "sp660"];

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

[row, Indx] = find(dataVals(nTrial).segment == "EH"); % Vowel location
if size(Indx) == 2
    Indx1 = Indx(1);
    Indx2 = Indx(2);
else
    Indx1 = Indx(1);
    Indx2 = [];
end

% Read data of the first trial >>>> First syllable
Int = dataVals(nTrial).int{1, Indx1}; %Int
Trial = repelem(nTrial, height(Int))'; %Trial number
Position = (1:height(Int))'; %Position within a measurement window
Word = repelem(expt.listWords(nTrial), height(Int))'; %Word
Syllable = repelem("1", height(Int))'; %Syllable
Speaker = repelem(Participant, height(Int))'; %Speaker
Duration = repelem(dataVals(nTrial).dur{1, Indx1}, height(Int))';
Phase = repelem(expt.listConds(nTrial), height(Int))'; %Phase

% Create tables with headers
data = table(Int, Trial, Position, Word, Syllable, Speaker, Duration, Phase);

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

        %Check if this row is empty. If empty, move on to the next trial
        if isempty(dataVals(nTrial).segment)
            nTrial = nTrial + 1
            continue
        end

        %Check this trial's phase. If not transfer, move on to the next trial

        temp0 = char(expt.listConds(nTrial));
        if ~contains(temp0, 'transfer')
            nTrial = nTrial + 1
            continue
        end

        %Find the location of the vowels

        [row, Indx] = find(dataVals(nTrial).segment == "EH"); % Vowel location

        if width(Indx) == 2
            Indx1 = Indx(1);
            Indx2 = Indx(2);
        else
            Indx1 = Indx(1);
            Indx2 = [];
        end

        
        %% Access the first syllable
        Int = dataVals(nTrial).int{1, Indx1}; %Int

        % Skip the current trial if the Int values are missing
        if isempty(Int)
            nTrial = nTrial + 1
            continue
        end

        Int = dataVals(nTrial).int{1, Indx1}; %Int
        Trial = repelem(nTrial, height(Int))'; %Trial number
        Position = (1:height(Int))'; %Position within a measurement window
        Word = repelem(expt.listWords(nTrial), height(Int))'; %Word
        Syllable = repelem("A", height(Int))'; %Syllable
        Speaker = repelem(Participant, height(Int))'; %Speaker
        Duration = repelem(dataVals(nTrial).dur{1, Indx1}, height(Int))';
        Phase = repelem(expt.listConds(nTrial), height(Int))'; %Phase

        % Create a temporary table with headers
        temp = table(Int, Trial, Position, Word, Syllable, Speaker, Duration, Phase);

        % Join the temporary table with the master table
        data = [data; temp];

        % The second sylllable

        if isempty(Indx2)
            nTrial = nTrial + 1
            continue
        end

        Int = dataVals(nTrial).int{1, Indx2}; %Int

        % Skip the current trial if the Int values are missing
        if isempty(Int)
            nTrial = nTrial + 1
            continue
        end

        Int = dataVals(nTrial).int{1, Indx2}; %Int
        Trial = repelem(nTrial, height(Int))'; %Trial number
        Position = (1:height(Int))'; %Position within a measurement window
        Word = repelem(expt.listWords(nTrial), height(Int))'; %Word
        Syllable = repelem("B", height(Int))'; %Syllable
        Speaker = repelem(Participant, height(Int))'; %Speaker
        Duration = repelem(dataVals(nTrial).dur{1, Indx2}, height(Int))';
        Phase = repelem(expt.listConds(nTrial), height(Int))'; %Phase


        % Create a temporary table with headers
        temp = table(Int, Trial, Position, Word, Syllable, Speaker, Duration, Phase);

        % Join the temporary table with the master table
        data = [data; temp];

        % Go to the next trial
        nTrial = nTrial + 1;
    end

    % Write one person's data to disk

    writetable(data, strcat(Participant, '_Int.csv'));

    % Go to the next participant
    ParticipantIndex = ParticipantIndex + 1;

end