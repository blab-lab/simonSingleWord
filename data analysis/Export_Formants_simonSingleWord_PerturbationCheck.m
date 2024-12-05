cd("\\wcs-cifs\wc\smng\experiments\simonSingleWord_\acousticdata");

% All participants

Participants = ["sp620" "sp624" "sp626" "sp627" "sp628"  "sp629" "sp630" "sp631" ...
    "sp634" "sp637" "sp638" ...
    "sp642" "sp643" "sp644" "sp645" "sp647" "sp648" "sp656" ...
    "sp657" "sp660"];

% Set up looping variable for participants
nParticipants = width(Participants);

ParticipantIndex = 1;

Participant = Participants(ParticipantIndex);

while ParticipantIndex <= nParticipants

    % Zoom into one participant & Load data
    Participant = Participants(ParticipantIndex);

    cd(Participant);
    load('expt.mat');

    validate_formantShift()
    
    saveas(gcf, strcat("SingleWord_", ...
        Participant, ".png"));

    close all;

    cd("\\wcs-cifs\wc\smng\experiments\simonSingleWord_v2\acousticdata");

    ParticipantIndex = ParticipantIndex + 1;

end;

load handel
sound(y,Fs)