%% User Input
clear
clc


%% Load Data
load Data_CA_Wildfire_Range.mat

fprintf('\n********** User Input **********\n\n');
fprintf('\n');


%% Hazard
fprintf('--- Input Hazard Variables (with units) ---\n\n');

HazardInputs = zeros(size(hazardfields, 1), 1);

% Loop through each input prompt
for i = 1:size(hazardfields, 1)
    varName = hazardfields{i, 1};
    unit    = hazardfields{i, 2};
    dataVec = hazardfields{i, 3};

    minVal = min(dataVec);
    maxVal = max(dataVec);

    if strcmp(varName, 'Precipitation')
        fprintf('%s range: [%.3f, %.3f]%s\n', varName, minVal, maxVal, unit);
    else
        fprintf('%s range: [%.1f, %.1f]%s\n', varName, minVal, maxVal, unit);
    end

    user_input = input(sprintf('Enter %s (%s): ', varName, unit));

    if isnumeric(user_input) && isscalar(user_input)
        internal_value = user_input;

        if internal_value < minVal || internal_value > maxVal
            if strcmp(varName, 'Precipitation')
                fprintf('Warning: Value is outside the typical range [%.3f, %.3f] %s; damage state estimation may be unreliable.\n', minVal, maxVal, unit);
            else
                fprintf('Warning: Value is outside the typical range [%.1f, %.1f] %s; damage state estimation may be unreliable.\n', minVal, maxVal, unit);
            end
        end

        HazardInputs(i) = internal_value;
    else
        error('Invalid input. Please enter a numeric scalar value.');
    end
    fprintf('\n');
end


% Assign each input to named variables
W_Max  = HazardInputs(1);
W_Mean = HazardInputs(2);
W_Dir  = HazardInputs(3);
Temp   = HazardInputs(4);
RH     = HazardInputs(5);
Prec   = HazardInputs(6)/24;


%% Vulnerability
fprintf('--- Input Vulnerability Features ---\n\n');

VulnInputs = strings(size(vulfields, 1), 1);  % Preallocate result

% Loop through each vulnerability feature
for i = 1:size(vulfields, 1)
    prompt = vulfields{i, 1};
    validOptions = vulfields{i, 2};

    % Display options with index numbers
    fprintf('\nSelect %s from the list below:\n', char(prompt));
    for j = 1:length(validOptions)
        fprintf('%d. %s\n', j, validOptions(j));
    end

    % Get valid user selection by index
    while true
        idx = input(['Enter a number from the list: ']);
        if isnumeric(idx) && idx >= 1 && idx <= length(validOptions)
            VulnInputs(i) = validOptions(idx);
            break;
        else
            fprintf('Invalid input. Please enter a number from the list.\n');
        end
    end
end


% --- Assessed Improved Value ---
fprintf('AIV range: [%.0f, %.0f]$\n', AIV_min, AIV_max);
AIV = input('Enter AIV ($): ');
if AIV < AIV_min || AIV > AIV_max
    fprintf('Warning: Value is outside the typical range [%.0f, %.0f] $; damage state estimation may be unreliable.\n', AIV_min, AIV_max);
end
fprintf('\n');


% Assign each input to named variables
NumStory   = VulnInputs(1);
StrCat     = VulnInputs(2);
Roof       = VulnInputs(3);
Eaves      = VulnInputs(4);
Vent       = VulnInputs(5);
Siding     = VulnInputs(6);
Window     = VulnInputs(7);
DeckGrade  = VulnInputs(8);
DeckElev   = VulnInputs(9);
PatioCover = VulnInputs(10);
Fence      = VulnInputs(11);
AIV        = AIV;


%% Exposure
fprintf('--- Input Exposure Variables ---\n\n');

% --- ZIP Code ---
disp('Valid ZIP Codes:');
for i = 1:length(valid_Zip)
    fprintf('%s', valid_Zip(i));
    
    if i < length(valid_Zip)
        fprintf(', ');
    end

    if mod(i, 8) == 0
        fprintf('\n');
    end
end

if mod(length(valid_Zip), 8) ~= 0
    fprintf('\n');
end

while true
    Zip = string(input('Enter ZIP Code: ', 's'));
    if ismember(Zip, valid_Zip)
        break;
    else
        fprintf('Invalid input. Please enter one of the listed ZIP Codes.\n');
    end
end
fprintf('\n');

% --- Latitude ---
fprintf('Latitude range: [%.4f, %.4f]°N\n', lat_min, lat_max);
Latitude = input('Enter Latitude (°N): ');
if Latitude < lat_min || Latitude > lat_max
    fprintf('Warning: Value is outside the typical range [%.4f, %.4f] degrees; damage state estimation may be unreliable.\n', lat_min, lat_max);
end
fprintf('\n');

% --- Longitude ---
fprintf('Longitude range: [%.4f, %.4f]°W\n', lon_min, lon_max);
Longitude = input('Enter Longitude (°W): ');

if Longitude < lon_min || Longitude > lon_max
    fprintf('Warning: Value is outside the typical range [%.4f, %.4f] degrees; damage state estimation may be unreliable.\n', lon_min, lon_max);
end
fprintf('\n');


% Assign each input to named variables
Zip = Zip;
Lat = Latitude;
Lon = -Longitude;


%% Input
NumStory_Ind     = find(strcmp(NumStory, valid_NumStory));
StrCat_Ind       = find(strcmp(StrCat, valid_StrCat));
Roof_Ind         = find(strcmp(Roof, valid_Roof));
Eaves_Ind        = find(strcmp(Eaves, valid_Eaves));
Vent_Ind         = find(strcmp(Vent, valid_Vent));
Siding_Ind       = find(strcmp(Siding, valid_Siding));
Window_Ind       = find(strcmp(Window, valid_Window));
DeckGrade_Ind    = find(strcmp(DeckGrade, valid_DeckGrade));
DeckElevated_Ind = find(strcmp(DeckElev, valid_DeckElev));
PatioCover_Ind   = find(strcmp(PatioCover, valid_PatioCover));
Fence_Ind        = find(strcmp(Fence, valid_Fence));
Zip_Ind          = find(strcmp(Zip, valid_Zip));


Input_New = [NumStory_Ind, ...
            StrCat_Ind, ...
            Roof_Ind, ...
            Eaves_Ind, ...
            Vent_Ind, ...
            Siding_Ind, ...
            Window_Ind, ...
            DeckGrade_Ind, ...
            DeckElevated_Ind, ...
            PatioCover_Ind, ...
            Fence_Ind, ...
            Zip_Ind, ...
            AIV, ...
            Lat, ...
            Lon, ...
            W_Max, ...
            W_Mean, ...
            W_Dir, ...
            Temp, ...
            RH, ...
            Prec];


%% Dummy Encoding
% Number of continuous variables
NumCat = 9;

% Loop for each fold
for q = 1:5

    % Load data range
    load Data_CA_Wildfire_Range.mat

    % User input data
    Input = Input_New;

    % Categorical input
    NumStory = Input(:,1);
    StrCat = Input(:,2);
    Roof = Input(:,3);
    Eaves = Input(:,4);
    Vent = Input(:,5);
    Siding = Input(:,6);
    Window = Input(:,7);
    DeckGrade = Input(:,8);
    DeckElevated = Input(:,9);
    PatioCover = Input(:,10);
    Fence = Input(:,11);
    Zip = Input(:,12);
    
    
    NumStory_Mat = zeros(length(NumStory),NumStory_Len);
    for i = 1:length(NumStory)
        NumStory_Mat(i,NumStory(i,1)) = 1;
    end

    StrCat_Mat = zeros(length(StrCat),StrCat_Len);
    for i = 1:length(StrCat)
        StrCat_Mat(i,StrCat(i,1)) = 1;
    end

    Roof_Mat = zeros(length(Roof),Roof_Len);
    for i = 1:length(Roof)
        Roof_Mat(i,Roof(i,1)) = 1;
    end

    Eaves_Mat = zeros(length(Eaves),Eaves_Len);
    for i = 1:length(Eaves)
        Eaves_Mat(i,Eaves(i,1)) = 1;
    end

    Vent_Mat = zeros(length(Vent),Vent_Len);
    for i = 1:length(Vent)
        Vent_Mat(i,Vent(i,1)) = 1;
    end

    Siding_Mat = zeros(length(Siding),Siding_Len);
    for i = 1:length(Siding)
        Siding_Mat(i,Siding(i,1)) = 1;
    end

    Window_Mat = zeros(length(Window),Window_Len);
    for i = 1:length(Window)
        Window_Mat(i,Window(i,1)) = 1;
    end

    DeckGrade_Mat = zeros(length(DeckGrade), DeckGrade_Len);
    for i = 1:length(DeckGrade)
        DeckGrade_Mat(i, DeckGrade(i, 1)) = 1;
    end

    DeckElevated_Mat = zeros(length(DeckElevated), DeckElevated_Len);
    for i = 1:length(DeckElevated)
        DeckElevated_Mat(i, DeckElevated(i, 1)) = 1;
    end

    PatioCover_Mat = zeros(length(PatioCover), PatioCover_Len);
    for i = 1:length(PatioCover)
        PatioCover_Mat(i, PatioCover(i, 1)) = 1;
    end

    Fence_Mat = zeros(length(Fence), Fence_Len);
    for i = 1:length(Fence)
        Fence_Mat(i, Fence(i, 1)) = 1;
    end

    Zip_Mat = zeros(length(Zip), Zip_Len);
    for i = 1:length(Zip)
        Zip_Mat(i, Zip(i, 1)) = 1;
    end

    
    % Continuous input
    AIV = Input(:,13);
    Lat = Input(:,14);
    Lon = Input(:,15);
    W_Max = Input(:,16);
    W_Mean = Input(:,17);
    W_Dir = Input(:,18);
    Temp = Input(:,19);
    RH = Input(:,20);
    Prec = Input(:,21);


    % x_test
    x_test_raw = [NumStory_Mat(:,1:end-1), ...
                  StrCat_Mat(:,1:end-1), ...
                  Roof_Mat(:,1:end-1), ...
                  Eaves_Mat(:,1:end-1), ...
                  Vent_Mat(:,1:end-1), ...
                  Siding_Mat(:,1:end-1), ...
                  Window_Mat(:,1:end-1), ...
                  DeckGrade_Mat(:,1:end-1), ...
                  DeckElevated_Mat(:,1:end-1), ...
                  PatioCover_Mat(:,1:end-1), ...
                  Fence_Mat(:,1:end-1), ...
                  Zip_Mat(:,1:end-1), ...
                  AIV, ...
                  Lat, ...
                  Lon, ...
                  W_Max, ...
                  W_Mean, ...
                  W_Dir, ... 
                  Temp, ...
                  RH, ...
                  Prec];
    
    % Normalize data from 0 to 1
    x_test = x_test_raw;

    for i = length(x_test(1,:))-NumCat+1:length(x_test(1,:))
        x_test(:,i) = (x_test_raw(:,i)-min(Range{q,1}(:,i)))/(max(Range{q,1}(:,i))-min(Range{q,1}(:,i)));
    end


    % Input data
    Input_NumStory_Test = NumStory_Mat(:, 1:end-1);
    Input_StrCat_Test = StrCat_Mat(:, 1:end-1);
    Input_Roof_Test = Roof_Mat(:, 1:end-1);
    Input_Eaves_Test = Eaves_Mat(:, 1:end-1);
    Input_Vent_Test = Vent_Mat(:, 1:end-1);
    Input_Siding_Test = Siding_Mat(:, 1:end-1);
    Input_Window_Test = Window_Mat(:, 1:end-1);
    Input_DeckGrade_Test = DeckGrade_Mat(:, 1:end-1);
    Input_DeckElevated_Test = DeckElevated_Mat(:, 1:end-1);
    Input_PatioCover_Test = PatioCover_Mat(:, 1:end-1);
    Input_Fence_Test = Fence_Mat(:, 1:end-1);
    Input_Zip_Test = Zip_Mat(:, 1:end-1);
    
    Input_AIV_Test = AIV;
    Input_Lat_Test = Lat;
    Input_Lon_Test = Lon;
    Input_W_Max_Test = W_Max;
    Input_W_Mean_Test = W_Mean;
    Input_W_Dir_Test = W_Dir;
    Input_Temp_Test = Temp;
    Input_RH_Test = RH;
    Input_Prec_Test = Prec;


    x_test_fold(q,:) = x_test;

    clearvars -except q NumCat Input_New ...
                      x_test x_test_fold
end


%% Save Data
fprintf('\n\n********** User Input Complete **********\n\n');
fprintf('User input data has been successfully generated and saved.\n');
fprintf('Please run "P2_Damage_Prediction.ipynb" in Jupyter Notebook.\n');
fprintf('\n*****************************************\n');


save(sprintf('Data1_User_Input.mat'),'x_test_fold');


