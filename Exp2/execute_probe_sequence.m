function execute_probe_sequence(uExp,nProbes,nProbes2)

%% Probe + Burst
% Tests = repmat([2 15 ; 11 7],[nProbes 1]);
% Tests(:,2) = [0 ; Tests(1:size(Tests,1)-1,2)];

%% Probe
% Tests = repmat([11 15],[nProbes 1]);
% Tests(:,2) = [0 ; Tests(1:size(Tests,1)-1,2)];


%% Burst
% Tests = repmat([2 15],[nProbes 1]);
% Tests(:,2) = [0 ; Tests(1:size(Tests,1)-1,2)];

%% Burst => Burst + Probe
% Tests = repmat([2 15],[nProbes 1]);
% Tests = [Tests;repmat([2 15 ; 11 7],[nProbes2 1])];
% Tests(:,2) = [0 ; Tests(1:size(Tests,1)-1,2)];

%%  Burst + Probe => Burst
% Tests = repmat([2 15 ; 11 7],[nProbes 1]);
% Tests = [Tests;repmat([2 15],[nProbes2 1])];
% Tests(:,2) = [0 ; Tests(1:size(Tests,1)-1,2)];

%% New protocol Burst + Probe + Train
% Tests = repmat([2 7 ;12 7; 10 7],[nProbes 1]);
% Tests(:,2) = [0 ; Tests(1:size(Tests,1)-1,2)];

%% New protocol Burst + Probe 
% Tests = repmat([2 7 ;12 14],[nProbes 1]);
% Tests(:,2) = [0 ; Tests(1:size(Tests,1)-1,2)];

% Tests = repmat([12 10;],[nProbes 1]);
% Tests(:,2) = [0 ; Tests(1:size(Tests,1)-1,2)];

%% New protocol Probe + Train
Tests = repmat([12 9; 10 7],[nProbes 1]);
Tests(:,2) = [0 ; Tests(1:size(Tests,1)-1,2)];

display(sprintf('Expected start time of last test : %s', datestr(now + sum(Tests(:,2))/1440,'HH:MM PM')));
ExecuteTestSeries(uExp,Tests)


end