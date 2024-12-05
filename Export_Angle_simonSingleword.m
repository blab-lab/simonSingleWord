cd("\\wcs-cifs\wc\smng\experiments\simonSingleWord\acousticdata");

% All participants

% All participants
Participants = ["sp322" "sp352" "sp353" "sp354" "sp355" "sp356" "sp358" ...
    "sp359" "sp360" "sp363" "sp364" "sp365" "sp366" "sp367" "sp368" ...
    "sp369" "sp371" "sp372" "sp373" "sp375"];

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