cd("\\wcs-cifs\wc\smng\experiments\simonSingleWord_v2\acousticdata");

% All participants

Participants = ["sp620" "sp624" "sp626" "sp627" "sp628"  "sp629" "sp630" "sp631" ...
    "sp634" "sp637" "sp638" ...
    "sp642" "sp643" "sp644" "sp645" "sp647" "sp648" "sp656" ...
    "sp657" "sp660"];


% Set up looping variable for participants
nParticipants = width(Participants);

ParticipantIndex = 1;

% Set up looping frame

% Select the first person

Participant = Participants(ParticipantIndex);

load(fullfile('.', Participant, 'dataVals.mat'));
DATA = struct2table(dataVals);
load(fullfile('.', Participant, 'expt.mat'));

% Isolate production of "bed"

data0 = DATA(DATA.word == 2, :);

%% Find the EH part

nTrial = 1;

data1 = data0.segment{nTrial, 1};
[row, col] = find(data1 == "EH");


F0 = data0.f0{nTrial, 1}{1, col};
Int = data0.int{nTrial, 1}{1, col};

Position = (1:height(F0))';
Word = repelem("bed", height(F0))';
Trial = repelem(data0.token(nTrial, 1), height(F0))';
Speaker = repelem(Participant, height(F0))';

data = table(F0, Int, Position, Word, Trial, Speaker);
% Retain only the table headers

data(1:height(data),:) = [];

%%
% Zoom into individual participants and collect data

while ParticipantIndex <= nParticipants

    % Zoom into one participant & Load data
    Participant = Participants(ParticipantIndex);

    load(fullfile('.', Participant, 'dataVals.mat'));
    DATA = struct2table(dataVals);
    load(fullfile('.', Participant, 'expt.mat'));

    % Retain only the table headers

    data(1:height(data),:) = [];

    %% Access "bed" trials

    data0 = DATA(DATA.word == 2, :);

    nTrial = 1;
    nRow = height(data0);

    while nTrial <= nRow

        data1 = data0.segment{nTrial, 1};

        % Skip the current trial is empty
        if isempty(data1)
            nTrial = nTrial + 1;
            continue
        end

        [row, col] = find(data1 == "EH");


        F0 = data0.f0{nTrial, 1}{1, col};
        Int = data0.int{nTrial, 1}{1, col};

        Position = (1:height(F0))';
        Word = repelem("bed", height(F0))';
        Trial = repelem(data0.token(nTrial, 1), height(F0))';
        Speaker = repelem(Participant, height(F0))';

        temp = table(F0, Int, Position, Word, Trial, Speaker);

        % Join the temporary table with the master table
        data = [data; temp];

        % Go to the next trial
        nTrial = nTrial + 1;
    end

    %% Access "head" trials

    data0 = DATA(DATA.word == 3, :);

    nTrial = 1;
    nRow = height(data0);

    while nTrial <= nRow

        data1 = data0.segment{nTrial, 1};

        % Skip the current trial is empty
        if isempty(data1)
            nTrial = nTrial + 1;
            continue
        end


        [row, col] = find(data1 == "EH");


        F0 = data0.f0{nTrial, 1}{1, col};
        Int = data0.int{nTrial, 1}{1, col};

        Position = (1:height(F0))';
        Word = repelem("head", height(F0))';
        Trial = repelem(data0.token(nTrial, 1), height(F0))';
        Speaker = repelem(Participant, height(F0))';

        temp = table(F0, Int, Position, Word, Trial, Speaker);

        % Join the temporary table with the master table
        data = [data; temp];

        % Go to the next trial
        nTrial = nTrial + 1;
    end


    %% Access "bedhead" trials

    data0 = DATA(DATA.word == 1, :);

    nTrial = 1;
    nRow = height(data0);

    while nTrial <= nRow

        data1 = data0.segment{nTrial, 1};

        % Skip the current trial is empty
        if isempty(data1)
            nTrial = nTrial + 1;
            continue
        end

        [row, col] = find(data1 == "EH");
        col_1 = col(1);
        col_2 = col(2);

        %%%% Access the first "EH"


        F0 = data0.f0{nTrial, 1}{1, col};
        Int = data0.int{nTrial, 1}{1, col};

        Position = (1:height(F0))';
        Word = repelem("bedhead_1", height(F0))';
        Trial = repelem(data0.token(nTrial, 1), height(F0))';
        Speaker = repelem(Participant, height(F0))';


        temp = table(F0, Int, Position, Word, Trial, Speaker);

        % Join the temporary table with the master table
        data = [data; temp];

        %%%% Access the second "EH"
        F0 = data0.f0{nTrial, 1}{1, col};
        Int = data0.int{nTrial, 1}{1, col};

        Position = (1:height(F0))';
        Word = repelem("bedhead_2", height(F0))';
        Trial = repelem(data0.token(nTrial, 1), height(F0))';
        Speaker = repelem(Participant, height(F0))';


        temp = table(F0, Int, Position, Word, Trial, Speaker);

        % Join the temporary table with the master table
        data = [data; temp];

        % Go to the next trial
        nTrial = nTrial + 1;
    end

    %% Access "redhead" trials

    data0 = DATA(DATA.word == 4, :);

    nTrial = 1;
    nRow = height(data0);

    while nTrial <= nRow

        data1 = data0.segment{nTrial, 1};

        % Skip the current trial is empty
        if isempty(data1)
            nTrial = nTrial + 1;
            continue
        end

        [row, col] = find(data1 == "EH");
        col_1 = col(1);
        col_2 = col(2);

        %%%% Access the first "EH"
        F0 = data0.f0{nTrial, 1}{1, col};
        Int = data0.int{nTrial, 1}{1, col};

        Position = (1:height(F0))';
        Word = repelem("redhead_1", height(F0))';
        Trial = repelem(data0.token(nTrial, 1), height(F0))';
        Speaker = repelem(Participant, height(F0))';

        temp = table(F0, Int, Position, Word, Trial, Speaker);

        % Join the temporary table with the master table
        data = [data; temp];

        %%%% Access the second "EH"
        F0 = data0.f0{nTrial, 1}{1, col};
        Int = data0.int{nTrial, 1}{1, col};
        Position = (1:height(F0))';
        Word = repelem("redhead_2", height(F0))';
        Trial = repelem(data0.token(nTrial, 1), height(F0))';
        Speaker = repelem(Participant, height(F0))';

        temp = table(F0, Int,Position, Word, Trial, Speaker);

        % Join the temporary table with the master table
        data = [data; temp];

        % Go to the next trial
        nTrial = nTrial + 1;
    end

    %% Access "bedspread" trials

    data0 = DATA(DATA.word == 5, :);

    nTrial = 1;
    nRow = height(data0);

    while nTrial <= nRow

        data1 = data0.segment{nTrial, 1};

        % Skip the current trial is empty
        if isempty(data1)
            nTrial = nTrial + 1;
            continue
        end

        [row, col] = find(data1 == "EH");
        col_1 = col(1);
        col_2 = col(2);

        %%%% Access the first "EH"

        F0 = data0.f0{nTrial, 1}{1, col};
        Int = data0.int{nTrial, 1}{1, col};
        Position = (1:height(F0))';
        Word = repelem("bedspread_1", height(F0))';
        Trial = repelem(data0.token(nTrial, 1), height(F0))';
        Speaker = repelem(Participant, height(F0))';


        temp = table(F0, Int, Position, Word, Trial, Speaker);

        % Join the temporary table with the master table
        data = [data; temp];

        %%%% Access the second "EH"

        F0 = data0.f0{nTrial, 1}{1, col};
        Int = data0.int{nTrial, 1}{1, col};
        Position = (1:height(F0))';
        Word = repelem("bedspread_2", height(F0))';
        Trial = repelem(data0.token(nTrial, 1), height(F0))';
        Speaker = repelem(Participant, height(F0))';

        temp = table(F0, Int,Position, Word, Trial, Speaker);

        % Join the temporary table with the master table
        data = [data; temp];

        % Go to the next trial
        nTrial = nTrial + 1;
    end

    %% Access "headrest" trials

    data0 = DATA(DATA.word == 6, :);

    nTrial = 1;
    nRow = height(data0);

    while nTrial <= nRow

        data1 = data0.segment{nTrial, 1};

        % Skip the current trial is empty
        if isempty(data1)
            nTrial = nTrial + 1;
            continue
        end

        [row, col] = find(data1 == "EH");
        col_1 = col(1);
        col_2 = col(2);

        %%%% Access the first "EH"

        F0 = data0.f0{nTrial, 1}{1, col};
        Int = data0.int{nTrial, 1}{1, col};
        Position = (1:height(F0))';
        Word = repelem("headrest_1", height(F0))';
        Trial = repelem(data0.token(nTrial, 1), height(F0))';
        Speaker = repelem(Participant, height(F0))';

        temp = table(F0, Int, Position, Word, Trial, Speaker);

        % Join the temporary table with the master table
        data = [data; temp];

        %%%% Access the second "EH"

        F0 = data0.f0{nTrial, 1}{1, col};
        Int = data0.int{nTrial, 1}{1, col};
        Position = (1:height(F0))';
        Word = repelem("headrest_2", height(F0))';
        Trial = repelem(data0.token(nTrial, 1), height(F0))';
        Speaker = repelem(Participant, height(F0))';

        temp = table(F0, Int, Position, Word, Trial, Speaker);

        % Join the temporary table with the master table
        data = [data; temp];

        % Go to the next trial
        nTrial = nTrial + 1;
    end

    %% Access "deathbed" trials

    data0 = DATA(DATA.word == 7, :);

    nTrial = 1;
    nRow = height(data0);

    while nTrial <= nRow

        data1 = data0.segment{nTrial, 1};

        % Skip the current trial is empty
        if isempty(data1)
            nTrial = nTrial + 1;
            continue
        end

        [row, col] = find(data1 == "EH");
        col_1 = col(1);
        col_2 = col(2);

        %%%% Access the first "EH"

        F0 = data0.f0{nTrial, 1}{1, col};
        Int = data0.int{nTrial, 1}{1, col};
        Position = (1:height(F0))';
        Word = repelem("deathbed_1", height(F0))';
        Trial = repelem(data0.token(nTrial, 1), height(F0))';
        Speaker = repelem(Participant, height(F0))';

        temp = table(F0, Int, Position, Word, Trial, Speaker);

        % Join the temporary table with the master table
        data = [data; temp];

        %%%% Access the second "EH"
        F0 = data0.f0{nTrial, 1}{1, col};
        Int = data0.int{nTrial, 1}{1, col};
        Position = (1:height(F0))';
        Word = repelem("deathbed_2", height(F0))';
        Trial = repelem(data0.token(nTrial, 1), height(F0))';
        Speaker = repelem(Participant, height(F0))';

        temp = table(F0, Int, Position, Word, Trial, Speaker);

        % Join the temporary table with the master table
        data = [data; temp];

        % Go to the next trial
        nTrial = nTrial + 1;
    end

    %% Access "brestfed" trials

    data0 = DATA(DATA.word == 8, :);

    nTrial = 1;
    nRow = height(data0);

    while nTrial <= nRow

        data1 = data0.segment{nTrial, 1};

        % Skip the current trial is empty
        if isempty(data1)
            nTrial = nTrial + 1;
            continue
        end

        [row, col] = find(data1 == "EH");
        col_1 = col(1);
        col_2 = col(2);

        %%%% Access the first "EH"

        F0 = data0.f0{nTrial, 1}{1, col};
        Int = data0.int{nTrial, 1}{1, col};
        Position = (1:height(F0))';
        Word = repelem("breastfed_1", height(F0))';
        Trial = repelem(data0.token(nTrial, 1), height(F0))';
        Speaker = repelem(Participant, height(F0))';

        temp = table(F0, Int, Position, Word, Trial, Speaker);

        % Join the temporary table with the master table
        data = [data; temp];

        %%%% Access the second "EH"

        F0 = data0.f0{nTrial, 1}{1, col};
        Int = data0.int{nTrial, 1}{1, col};
        Position = (1:height(F0))';
        Word = repelem("breastfed_2", height(F0))';
        Trial = repelem(data0.token(nTrial, 1), height(F0))';
        Speaker = repelem(Participant, height(F0))';
        Phase = repelem(expt.listConds(data0.token(nTrial,1)), height(F0))';

        temp = table(F0, Int, Position, Word, Trial, Speaker);

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