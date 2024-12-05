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

%Find the vowels

temp1 = find(dataVals(nTrial).segment  == "EH");

i = 1;

while i <= length(temp1)

    Indx = temp1(i);

    F1 = dataVals(nTrial).f1{1, Indx}; %F1
    F2 = dataVals(nTrial).f2{1, Indx}; %F2
    Trial = repelem(nTrial, height(F1))'; %Trial number
    Position = (1:height(F1))'; %Position within a measurement window
    Duration = repelem(dataVals(nTrial).dur{1, Indx}, height(F1))'; %Duration
    Word = repelem(expt.listWords(nTrial), height(F1))'; %Word
    Item = repelem(i, height(F1))'; %Item
    Speaker = repelem(Participant, height(F1))'; %Speaker
    Phase = repelem(expt.listConds(nTrial), height(F1))'; %Phase
    Shift =  repelem(convertCharsToStrings(expt.listShiftNames(nTrial)), height(F1))';
    list = [expt.shiftsInOrder{1, 1} expt.shiftsInOrder{1, 2}];    
    List = repelem(convertCharsToStrings(list), height(F1))';

    % Create tables with headers
    data = table(F1, F2, Trial, Position, Duration, Word, ...
        Item, Speaker, Phase, Shift, List);

    % Retain only the table headers

    data(1:height(data),:) = [];

    i = i + 1;
end


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

        %Find the vowels
        if isempty(dataVals(nTrial).segment)
            nTrial = nTrial + 1;
            continue
        end
        
        temp1 = find(dataVals(nTrial).segment  == "EH");

        i = 1;

        while i <= length(temp1)

            Indx = temp1(i);

            F1 = dataVals(nTrial).f1{1, Indx}; %F1

            %Check if this row is empty
            if isempty(F1)
                i = i + 1;
                continue
            end

            F2 = dataVals(nTrial).f2{1, Indx}; %F2
            Trial = repelem(nTrial, height(F1))'; %Trial number
            Position = (1:height(F1))'; %Position within a measurement window
            Duration = repelem(dataVals(nTrial).dur{1, Indx}, height(F1))'; %Duration
            Word = repelem(expt.listWords(nTrial), height(F1))'; %Word
            Item = repelem(i, height(F1))'; %Item
            Speaker = repelem(Participant, height(F1))'; %Speaker
            Phase = repelem(expt.listConds(nTrial), height(F1))'; %Phase
            Shift =  repelem(convertCharsToStrings(expt.listShiftNames(nTrial)), height(F1))';
            list = [expt.shiftsInOrder{1, 1} expt.shiftsInOrder{1, 2}];    
            List = repelem(convertCharsToStrings(list), height(F1))';

            % Create a temporary table with headers
            temp = table(F1, F2, Trial, Position, Duration, Word, ...
                Item, Speaker, Phase, Shift, List);

            % Join the temporary table with the master table
            data = [data; temp];


            i = i + 1;
        end

        % Go to the next trial
        nTrial = nTrial + 1;

    end

    % Write one person's data to disk

    writetable(data, strcat(Participant, '_Formant.csv'));

    % Go to the next participant
    ParticipantIndex = ParticipantIndex + 1;

end
%Play sound when done
load handel
sound(y,Fs)