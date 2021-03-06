% Log of scripts created for the Menolascina data
%
% T. Nordling 2016-07-13


%% Log_Menolascina_data.m 160713-1. Quick plot of data
plot(linspace(0,5*size(y,1),size(u,2)),u)

%% Log_Menolascina_data.m 160713-2. Normalisation
time = linspace(0,5*size(y,1),size(u,2)); %Time points in u
figure, hold on
plot(time,u);
xlabel('Time (min)')

% Find the index at which the initial Galactose period ends
ind = find(u < 0.9*u(1));
tGalend = floor(time(ind(1)));
plot([tGalend, tGalend],[max(u), min(u)], 'ko')

% Calculate the mean over all cells for each timepoint
ymean = meanNaN(y,2);

% Calculate the mean over the Galactose period
ymeanGal = meanNaN(ymean(1:tGalend/5))

% Normalise the arbitrary florescence readings such that the mean of mean
% of the initial Galactose period is defind as 1
ynorm = y./ymeanGal; 
ynormmean = meanNaN(ynorm,2);

plot(linspace(0,5*size(y,1),size(y,1)), ynorm)
plot(linspace(0,5*size(y,1),size(y,1)), ynormmean, 'sk')

%% Log_Menolascina_data.m 160713-3. Automatic loading of multiple data files

% Go to the root directory of the data, e.g. './', or
% modify the following variable.
%rootD = cd('/Users/tn/Documents/#Work_NCKU/Project_Menolascina_160712');
rootD = cd('/Users/tn/Documents/Dropbox/Share_with_Filippo_Menolascina');
rootD = cd; % Matlab returns the previous directory when changing directory
exclude = {'Data4Identification.mat','GFquantification.mat','GFnd003SingleCellDataWE.mat','GFnd007SingleCellDataWE.mat','GFnd265SingleCellDataInit.mat','GFnd272SingleCellData.mat', 'nd265_data_sh.mat', 'nd272_data_sh.mat'}; %.mat file to exclude
%exclude = {exclude{:}, 'nd032.mat', 'nd037.mat', 'nd039.mat', 'nd041.mat'}
dataD = dir(rootD);
DataS = struct('experimentName',[],'loadedDir','','time_min',[],'time_input',[],'NrCells',[],'input',[],'output',[],'output_std',[],'output_pred',[],'inputRawNormalised',[],'outputRawNormalised',[],'inputRawFlourescence',[],'outputRawFlourescence',[],'RFP',[]);
S = struct('description','','rootDir','','loadedDir','','Data',DataS);
tol = 10^-9;
S(1).rootDir = rootD;
if exist('description.txt','file')
    fileID = fopen('description.txt'); Temp = '';
    while ~feof(fileID),
        Temp = [Temp fscanf(fileID,'%c')];
    end
    S(1).description = Temp;
elseif exist('description','file')
    fileID = fopen('description'); Temp = '';
    while ~feof(fileID),
        Temp = [Temp fscanf(fileID,'%c')];
    end
    S(1).description = Temp;
else
    warning('No description exists');
end
countExp = 1;
for i = 3:size(dataD,1);
    if dataD(i).isdir,
        % Stores the directory name
        if isempty(S(1).loadedDir),
            S(1).loadedDir = dataD(i).name;
        else
            S(1).loadedDir = [S(1).loadedDir sprintf('\n') dataD(i).name];
        end
        T = whos('S'); 
        disp(['Loading data from ' dataD(i).name ' Memory usage: ' num2str(T.bytes/10^6)])
        % Load data from all .mat files in folder
        dataDM = dir(dataD(i).name);
        for k = 3:size(dataDM,1),
            if ~dataDM(k).isdir && ~isempty(strfind(dataDM(k).name,'mat')) && isempty(strmatch(dataDM(k).name,exclude)), %Only read .mat files
                if ~isempty(S(1).Data(1).experimentName) && ~isempty(strmatch(dataDM(k).name,{S(1).Data(:).experimentName}))
                    % Checks if a file with identical name has been read
                    % before
                    warning([num2str(k) ' File with identical name ' dataDM(k).name ' has been read previously.'])
                end
                % Checks if an experiment with the same number in the
                % file name has been read before. If it has, then the
                % info is added to that entry.
                for j = numel(S(1).Data):-1:1,
                    if ~isempty(S(1).Data(j).experimentName) && strcmp(S(1).Data(j).loadedDir, dataD(i).name) && strcmp(lower(dataDM(k).name(1:4)), 'data') && strcmp(lower(S(1).Data(j).experimentName(end-4:end)), lower(dataDM(k).name(end-8:end-4))),
                        % If the last five letters are the same then the
                        % number is the same.
                        countExp = j;
                        break
                    end
                end
                disp(['Loading ' dataD(i).name '/' dataDM(k).name(1:end-4) ' with (i,j,k): ' num2str([i j k]) ' placing data in ' num2str(countExp) ','])
                if numel(S(1).Data) >= countExp && ~isempty(S(1).Data(countExp).experimentName),
                    disp(['which since before contains ' S(1).Data(countExp).loadedDir '/' S(1).Data(countExp).experimentName])
                end
                % Adds data to the Cell with number countExp        
                if numel(S(1).Data) < countExp,
                    S(1).Data(countExp).experimentName = dataDM(k).name(1:end-4); %Initiates new matrix
                    S(1).Data(countExp).loadedDir = dataD(i).name;
                end
                DataLoaded = load([dataD(i).name '/' dataDM(k).name]);
                fieldnamesDL = fieldnames(DataLoaded);
                allIdentical = true;
                for l = 1:numel(fieldnamesDL),
                    %disp([num2str(l) ' ' fieldnamesDL{l}])
                    switch (fieldnamesDL{l}),
                        case 'u'
                            if isempty(S(1).Data(countExp).input),
                                S(1).Data(countExp).input = DataLoaded.u';
                            else
                                if numel(S(1).Data(countExp).input) == numel(DataLoaded.u'),
                                    differ = norm(S(1).Data(countExp).input - DataLoaded.u');
                                else
                                    differ = inf;
                                end
                                if differ < tol,
                                    % All fine
                                else
                                    allIdentical = false;
                                    warning(['File ' dataDM(k).name ' contains a variable that is different from an existing one in the experiment by ' num2str(differ)])
                                end
                            end
                            
                        case 'y'
                            if isempty(S(1).Data(countExp).outputRawFlourescence),
                                S(1).Data(countExp).outputRawFlourescence = DataLoaded.y;
                            else
                                differ = norm(S(1).Data(countExp).outputRawFlourescence - DataLoaded.y);
                                if differ < tol,
                                    % All fine
                                else
                                    allIdentical = false;
                                    warning(['File ' dataDM(k).name ' contains a variable that is different from an existing one in the experiment by ' num2str(differ)])
                                end
                            end
                            
                        case 'input'
                            if isempty(S(1).Data(countExp).inputRawNormalised),
                                S(1).Data(countExp).inputRawNormalised = DataLoaded.input';
                            else
                                differ = norm(S(1).Data(countExp).inputRawNormalised - DataLoaded.input');
                                if differ < tol,
                                    % All fine
                                else
                                    allIdentical = false;
                                    warning(['File ' dataDM(k).name ' contains a variable that is different from an existing one in the experiment by ' num2str(differ)])
                                end
                            end
                            
                        case 'plantinput'
                            if isempty(S(1).Data(countExp).inputRawFlourescence),
                                S(1).Data(countExp).inputRawFlourescence = DataLoaded.plantinput';
                            else
                                differ = norm(S(1).Data(countExp).inputRawFlourescence - DataLoaded.plantinput');
                                if differ < tol,
                                    % All fine
                                else
                                    allIdentical = false;
                                    warning(['File ' dataDM(k).name ' contains a variable that is different from an existing one in the experiment by ' num2str(differ)])
                                end
                            end
                            
                        case 'IN'
                            if isempty(S(1).Data(countExp).input),
                                S(1).Data(countExp).input = DataLoaded.IN';
                            else
                                differ = norm(S(1).Data(countExp).input - DataLoaded.IN');
                                if differ < tol,
                                    % All fine
                                else
                                    allIdentical = false;
                                    warning(['File ' dataDM(k).name ' contains a variable that is different from an existing one in the experiment by ' num2str(differ)])
                                end
                            end
                             
                        case 'OUT'
                            if isempty(S(1).Data(countExp).output),
                                S(1).Data(countExp).output = DataLoaded.OUT';
                            else
                                differ = norm(S(1).Data(countExp).output - DataLoaded.OUT');
                                if differ < tol,
                                    % All fine
                                else
                                    allIdentical = false;
                                    warning(['File ' dataDM(k).name ' contains a variable that is different from an existing one in the experiment by ' num2str(differ)])
                                end
                            end
                            
                        case 'plantstate'
                            if isempty(S(1).Data(countExp).outputRawFlourescence),
                                S(1).Data(countExp).outputRawFlourescence = DataLoaded.plantstate';
                            else
                                differ = norm(S(1).Data(countExp).outputRawFlourescence - DataLoaded.plantstate');
                                if differ < tol,
                                    % All fine
                                else
                                    allIdentical = false;
                                    warning(['File ' dataDM(k).name ' contains a variable that is different from an existing one in the experiment by ' num2str(differ)])
                                end
                            end
                            
                        case 'RFP'
                            if isempty(S(1).Data(countExp).RFP),
                                S(1).Data(countExp).RFP = DataLoaded.RFP';
                            else
                                differ = norm(S(1).Data(countExp).RFP - DataLoaded.RFP');
                                if differ < tol,
                                    % All fine
                                else
                                    allIdentical = false;
                                    warning(['File ' dataDM(k).name ' contains a variable that is different from an existing one in the experiment by ' num2str(differ)])
                                end
                            end
                            
                        case 'err'
                            if isempty(S(1).Data(countExp).output_std),
                                S(1).Data(countExp).output_std = DataLoaded.err';
                            else
                                differ = norm(S(1).Data(countExp).output_std - DataLoaded.err');
                                if differ < tol,
                                    % All fine
                                else
                                    allIdentical = false;
                                    warning(['File ' dataDM(k).name ' contains a variable that is different from an existing one in the experiment by ' num2str(differ)])
                                end
                            end
                            
                        case 'DATA'
                            if isempty(S(1).Data(countExp).outputRawFlourescence),
                                S(1).Data(countExp).outputRawFlourescence = DataLoaded.DATA;
                            else
                                differ = norm(S(1).Data(countExp).outputRawFlourescence - DataLoaded.DATA);
                                if differ < tol,
                                    % All fine
                                else
                                    allIdentical = false;
                                    warning(['File ' dataDM(k).name ' contains a variable that is different from an existing one in the experiment by ' num2str(differ)])
                                end
                            end
                            
                        case 'ingresso'
                            if isempty(S(1).Data(countExp).input),
                                S(1).Data(countExp).input = [ones(DataLoaded.inittime*60,1); DataLoaded.ingresso'];
                                if ~isempty(S(1).Data(countExp).outputRawFlourescence) && numel(S(1).Data(countExp).input) ~= 5*size(S(1).Data(countExp).outputRawFlourescence,1),
                                    warning(['The input has the wrong number of elements: ' num2str([numel(S(1).Data(countExp).input) 5*size(S(1).Data(countExp).outputRawFlourescence,1)])]);
                                end
                                if ~isempty(S(1).Data(countExp).input) && isempty(S(1).Data(countExp).time_input),
                                    if ~isempty(S(1).Data(countExp).time_min),
                                        if numel(S(1).Data(countExp).input) ~= numel(S(1).Data(countExp).time_min),
                                            S(1).Data(countExp).time_input = linspace(0,5*size(S(1).Data(countExp).outputRawFlourescence,1),numel(S(1).Data(countExp).input))';
                                        else
                                            S(1).Data(countExp).time_input = S(1).Data(countExp).time_min;
                                        end
                                    end
                                end
                            else
                                differ = norm(S(1).Data(countExp).input - DataLoaded.ingresso');
                                if differ < tol,
                                    % All fine
                                else
                                    allIdentical = false;
                                    warning(['File ' dataDM(k).name ' contains a variable that is different from an existing one in the experiment by ' num2str(differ)])
                                end
                            end
                             
                    end
                end
                if allIdentical,
                    S(1).Data(countExp).experimentName = dataDM(k).name(1:end-4); %Replaces old experimentName if one with the same number is found
                else
                    error('At least one confliciting variable detected.')
                end
                disp(['Fixing time vectors. OutputRawFlourescence contains ' num2str(size(S(1).Data(countExp).outputRawFlourescence)) ' elements.'])
                if ~isempty(S(1).Data(countExp).outputRawFlourescence),
                    S(1).Data(countExp).time_min = linspace(0,5*size(S(1).Data(countExp).outputRawFlourescence,1),size(S(1).Data(countExp).outputRawFlourescence,1))';
                    if ~isempty(S(1).Data(countExp).input) && isempty(S(1).Data(countExp).time_input),
                        disp(['input contains ' num2str(size(S(1).Data(countExp).input)) ' elements.'])
                        if numel(S(1).Data(countExp).input) ~= numel(S(1).Data(countExp).time_min),
                            S(1).Data(countExp).time_input = linspace(0,5*size(S(1).Data(countExp).outputRawFlourescence,1),size(S(1).Data(countExp).input,1))';
                        else
                            S(1).Data(countExp).time_input = S(1).Data(countExp).time_min;
                        end
                    elseif ~isempty(S(1).Data(countExp).input) && ~isempty(S(1).Data(countExp).time_input),
                        disp(['input contains ' num2str(size(S(1).Data(countExp).input)) ' elements.'])
                        disp(['time_input contains ' num2str(size(S(1).Data(countExp).time_input)) ' elements.'])
                    end
                    S(1).Data(countExp).NrCells = size(S(1).Data(countExp).outputRawFlourescence,2);
                    if S(1).Data(countExp).NrCells == 1,
                        S(1).Data(countExp).NrCells = []; %Leave empty to mark that a mean value is used
                    end
                else
                    S(1).Data(countExp).time_min = linspace(0,5*size(S(1).Data(countExp).output,1),size(S(1).Data(countExp).output,1))';
                    if ~isempty(S(1).Data(countExp).input) && isempty(S(1).Data(countExp).time_input),
                        if numel(S(1).Data(countExp).input) ~= numel(S(1).Data(countExp).time_min),
                            S(1).Data(countExp).time_input = linspace(0,5*size(S(1).Data(countExp).output,1),5*60*size(S(1).Data(countExp).output,1))';
                        else
                            S(1).Data(countExp).time_input = S(1).Data(countExp).time_min;
                        end
                    end
                    S(1).Data(countExp).NrCells = size(S(1).Data(countExp).output,2);
                    if S(1).Data(countExp).NrCells == 1,
                        S(1).Data(countExp).NrCells = []; %Leave empty to mark that a mean value is used
                    end
                end
                countExp = numel(S(1).Data) +1;
            end
        end
    end
end
clear i j k l rootD fileID fieldnamesDL DataS dataDM dataD DataLoaded countExp T Temp exclude allIdentical tol

% Change order of the experiments so Filippo partial comes last.
Temp = S.Data(end-7:end-4);
S.Data(end-7:end-4) = [];
S.Data(end+1:end+4) = Temp; clear Temp;

% Remove the one missing input
%S.Data(11)=[];

%% Log_Menolascina_data.m 160713-4. Listing of loaded data
% Assume that S containing all data exist

S
S.loadedDir
for i = 1:size(S.Data,2),
    S.Data(i)
end

%% Log_Menolascina_data.m 160713-5. Normalisation and calculation of mean and std for all data

for i = 1:2;size(S.Data,2),
    clear tGalend
    if isempty(S.Data(i).output),
        disp(['Fixing ' S.Data(i).loadedDir '/' S.Data(i).experimentName ' with (i): ' num2str([i])])
        figure(i), hold on
        xlabel('Time (min)')
        % Find the index at which the initial Galactose period ends
        if ~isempty(S.Data(i).input) && S.Data(i).input(1) > 0,
            plot(S.Data(i).time_input,S.Data(i).input,'r');
            ind = find(S.Data(i).input < 0.9*max(S.Data(i).input)) - 1;
            tGalend = floor(S.Data(i).time_input(ind(1)));
            plot([tGalend, tGalend],[max(S.Data(i).input), min(S.Data(i).input)], 'ro')
        elseif S.Data(i).input(1) <= 0,
            warning('The first input is zero or negative.')
        end

        if exist('tGalend','var')
            % Calculate the mean over all cells for each timepoint
            ymean = meanNaN(S.Data(i).outputRawFlourescence,2);

            % Calculate the mean over the Galactose period
            ymeanGal = meanNaN(ymean(1:floor(tGalend/5)))

            % Normalise the arbitrary florescence readings such that the mean of mean
            % of the initial Galactose period is defind as 1
            S.Data(i).outputRawNormalised = S.Data(i).outputRawFlourescence./ymeanGal; 
            S.Data(i).output = ymean./ymeanGal;

            plot(S.Data(i).time_min, S.Data(i).outputRawNormalised)
            plot(S.Data(i).time_min, S.Data(i).output, 'sg')

            % Calculate the std over all cells for each timeperiod
            S.Data(i).output_std = std(S.Data(i).outputRawNormalised,0,2,'omitnan');
        end
    end

end

%save Data_Menolascina_yeast_160718.mat S

%% Log_Menolascina_data.m 160713-6. Test if the input is constant between samples

% RESULT: It is not constant

for i = 1:size(S.Data,2),
    % Makes the input have same number of time points as output
    if ~isempty(S.Data(i).input) && numel(S.Data(i).input) > numel(S.Data(i).time_min),
        input = S.Data(i).input(1:60*5:end);
        if numel(input) ~= numel(S.Data(i).time_min),
            error('Number of time points in input is not 60 times number of time points in output.')
        end
        for j = 0:numel(input)-1,
            if all(S.Data(i).input(j*60*5+1:(j+1)*60*5) == max(S.Data(i).input(j*60*5+1:(j+1)*60*5))),
                %All identical so no information lost
            else
                warning([num2str(i) ': The value of the input between two samples is not constant between indecies ' num2str([j*60*5+1 (j+1)*60*5])])
            end
        end
    end    
end


%% Log_Menolascina_data.m 160718-1. Plotting of one data set
% Assume that S containing all data exist
%load Data_Menolascina_yeast_160718.mat


plotCells = false; % Plot the output trajectory of every cell
plotErr = false; % Plot the errorbars as a shaded area 
plotErr = true; % Plot the errorbars as a shaded area 

S
S.loadedDir
hind = 0; h =[]; hlabel = {};
for i = 1:size(S.Data,2),
    S.Data(i)
    figure(i), hold on
    xlabel('Time (min)')
    title([S.Data(i).loadedDir '/' S.Data(i).experimentName ' with (i): ' num2str(i)])
    % Find the index at which the initial Galactose period ends
    if ~isempty(S.Data(i).input),
        hind = hind + 1; hlabel{hind} = 'Input';
        h(hind) = plot(S.Data(i).time_input,S.Data(i).input,'r');
        ind = find(S.Data(i).input < 0.9*S.Data(i).input(1)) - 1;
        tGalend = floor(S.Data(i).time_input(ind(1)));
        plot([tGalend, tGalend],[max(S.Data(i).input), min(S.Data(i).input)], 'ro')
    end
    if plotErr && ~isempty(S.Data(i).output) && ~isempty(S.Data(i).output_std),
        %hind = hind + 1; hlabel{hind} = 'Output';
        %shadedErrorBar(S.Data(i).time_min',S.Data(i).output',S.Data(i).output_std','g'); % Standard deviation
        shadedErrorBar(S.Data(i).time_min',S.Data(i).output',1.96.*S.Data(i).output_std','g'); % Confidence interval 95%
    end
    if ~isempty(S.Data(i).inputRawNormalised),
        hind = hind + 1; hlabel{hind} = 'Input Raw';
        h(hind) = plot(S.Data(i).time_min,S.Data(i).inputRawNormalised,'y');
    end    
    if plotCells && ~isempty(S.Data(i).outputRawNormalised),
        %hind = hind + 1; hlabel{hind} = 'Output Raw';
        %h(hind) = 
        plot(S.Data(i).time_min,S.Data(i).outputRawNormalised);
    end    
    if ~isempty(S.Data(i).outputRawNormalised),
        hind = hind + 1; hlabel{hind} = 'Output Median';
        % Calculate the median over all cells for each timeperiod
        h(hind) = plot(S.Data(i).time_min, median(S.Data(i).outputRawNormalised,2,'omitnan'), '--g');
    end
    if ~isempty(S.Data(i).output),
        hind = hind + 1; hlabel{hind} = 'Output';
        h(hind) = plot(S.Data(i).time_min,S.Data(i).output,'g','LineWidth',1);
    end
end

