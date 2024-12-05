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

load(fullfile('.', Participant, 'expt.mat'));

Angle1 = expt.shiftAngles(1);
Angle2 = expt.shiftAngles(2);
Degree1 = rad2deg(Angle1);
Degree2 = rad2deg(Angle2);
List = [expt.shiftsInOrder{1, 1} expt.shiftsInOrder{1, 2}];
List = convertCharsToStrings(List);
Mag = expt.shiftMag;


% Create tables with headers
data = table(Participant, Angle1, Angle2, Degree1, Degree2, List, Mag);

data(1:height(data),:) = [];

while ParticipantIndex <= nParticipants
    Participant = Participants(ParticipantIndex);

    load(fullfile('.', Participant, 'expt.mat'));

    Angle1 = expt.shiftAngles(1);
    Angle2 = expt.shiftAngles(2);
    Degree1 = rad2deg(Angle1);
    Degree2 = rad2deg(Angle2);
    List = [expt.shiftsInOrder{1, 1} expt.shiftsInOrder{1, 2}];
    List = convertCharsToStrings(List);
    Mag = expt.shiftMag;

    % Create table with headers
    temp = table(Participant, Angle1, Angle2, Degree1, Degree2, List, Mag);

    % Join the temporary table with the master table
    data = [data; temp];

    ParticipantIndex = ParticipantIndex + 1;
end

writetable(data, 'Angles.csv');

%Play sound when done
load handel
sound(y,Fs)