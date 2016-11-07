% Log of scripts created for the Menolascina data
%
% T. Nordling 2016-07-13
%% Log_Menolascina_data.m 160713-3. Automatic loading of multiple data files

% Go to the root directory of the data, e.g. './', or
% modify the following variable.
savefigurepath = '/Users/tn/Documents/Dropbox/NordlingLab_SystemsSyntheticBiology/Figures_Data_reproduction_161106';
%savefigurepath = '/home/chiching/Dropbox/NCKU/2016/SB/Reproduction/';
%rootD = cd('/Users/tn/Documents/#Work_NCKU/Project_Menolascina_160712');
rootD = cd('/Users/tn/Documents/Dropbox/Share_with_Filippo_Menolascina');
%rootD = cd('/home/chiching/Dropbox/Share_with_Filippo_Menolascina');
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

%% Log_Menolascina_data.m 160713-5. Normalisation and calculation of mean and std for all data
% i = 2 to 11 for F_2014
%for i = 1:size(S.Data,2),
for i = 2:19,
    clear tGalend
    if isempty(S.Data(i).output),
        disp(['Fixing ' S.Data(i).loadedDir '/' S.Data(i).experimentName ' with (i): ' num2str([i])])
%         figure(i), hold on
%         xlabel('Time (min)')
        % Find the index at which the initial Galactose period ends
        if ~isempty(S.Data(i).input) && S.Data(i).input(1) > 0,
%             plot(S.Data(i).time_input,S.Data(i).input*0.2,'r'); %plot input // with scale 0.2
%           plot(S.Data(i).time_input,S.Data(i).input,'r');
%ind  =  find where 1->0 index
            ind = find(S.Data(i).input < 0.9*max(S.Data(i).input)) - 1;
%tGalend = time point where 1->0, floor(time)
            tGalend = floor(S.Data(i).time_input(ind(1)));
%             plot([tGalend, tGalend],[max(S.Data(i).input), min(S.Data(i).input)], 'ro')
        elseif S.Data(i).input(1) <= 0,
            warning('The first input is zero or negative.')
        end

        if exist('tGalend','var')
            % Calculate the mean over all cells for each timepoint
            ymean = nanmean(S.Data(i).outputRawFlourescence,2);

            % Calculate the mean over the Galactose period
            ymeanGal = nanmean(ymean(1:floor(tGalend/5)))
       

            % Normalise the arbitrary florescence readings such that the mean of mean
            % of the initial Galactose period is defind as 1
            S.Data(i).outputRawNormalised = S.Data(i).outputRawFlourescence./ymeanGal; 
            S.Data(i).output = ymean./ymeanGal;

%             plot(S.Data(i).time_min, S.Data(i).outputRawNormalised)
%              plot(S.Data(i).time_min, S.Data(i).output, 'g') %org: sg
%sg
            % Calculate the std over all cells for each timeperiod
            S.Data(i).output_std = std(S.Data(i).outputRawNormalised,0,3,'omitnan');
        end
    end

end

%save Data_Menolascina_yeast_160718.mat S

%% Plot F_2016_Figure4
% plot figure 4 ABC
% 

fig_position = [0,0,650,250];

i=16;
figure('position', fig_position)
subplot(2,1,2) 
plot(S.Data(i).time_input-180,S.Data(i).input,'r','LineWidth',3);
grid on
xlabel('Time (min)')
xlim([-180 1000])
%plot output
subplot(2,1,1) 
line([-180 0],[1.0,1.0],'Color','b','LineWidth',2)
line([0 1000],[0.5,0.5],'Color','b','LineWidth',2)
hold on
plot(S.Data(i).time_min-180,S.Data(i).output,'g','LineWidth',3);
grid on
xlabel('Time (min)')
ylim([0 1.2])
xlim([-180 1000])
title('F 2016 Figure 4C nd032 (i=16)')
saveas(gcf,strcat(savefigurepath,'F 2016 Figure 4C-2.jpg'))


i=19;
figure('position', fig_position)
subplot(2,1,2) 
plot(S.Data(i).time_input-70,S.Data(i).input,'r','LineWidth',3);
grid on
xlabel('Time (min)')
xlim([-180 1000])
%plot output
subplot(2,1,1) 
line([-70 0],[1.0,1.0],'Color','b','LineWidth',2)
line([0 1000],[0.5,0.5],'Color','b','LineWidth',2)
hold on
plot(S.Data(i).time_min-70,S.Data(i).output,'g','LineWidth',3);
grid on
xlabel('Time (min)')
ylim([0 1.2])
xlim([-180 1000])
title('F 2016 Figure 4B nd041 (i=19)')
saveas(gcf,strcat(savefigurepath,'F 2016 Figure 4B-2.jpg'))

for i = 2:7,
    if i == 2 || i == 7,
        %plot input
        %figure size
        figure('position', fig_position)
        subplot(2,1,2) 
        plot(S.Data(i).time_input-180,S.Data(i).input,'r','LineWidth',3);
        grid on
        xlabel('Time (min)')
        xlim([-180 1000])
        %plot output
        subplot(2,1,1) 
        line([-180 0],[1.0,1.0],'Color','b','LineWidth',2)
        line([0 1000],[0.5,0.5],'Color','b','LineWidth',2)
        hold on
        plot(S.Data(i).time_min-180,S.Data(i).output,'g','LineWidth',3);
        grid on
        xlabel('Time (min)')
        ylim([0 1.2])
        xlim([-180 1000])
        if i ==7,
            title('F 2016 Figure 4A')
            saveas(gcf,strcat(savefigurepath,'F 2016 Figure 4A.jpg'))
        elseif i ==2,
            title('F 2016 Figure 4C')
            saveas(gcf,strcat(savefigurepath,'F 2016 Figure 4C.jpg'))
        end    
            
    elseif i == 5,
        figure('position', fig_position)
        subplot(2,1,2) 
        plot(S.Data(i).time_input-70,S.Data(i).input,'r','LineWidth',3);
        grid on
        xlabel('Time (min)')
        xlim([-70 1000])

        
        %plot output
        subplot(2,1,1) 
        line([-70 0],[1.0,1.0],'Color','b','LineWidth',2)
        line([0 1000],[0.5,0.5],'Color','b','LineWidth',2)
        hold on
        plot(S.Data(i).time_min-70,S.Data(i).output,'g','LineWidth',3);
        grid on
        xlabel('Time (min)')
        ylim([0 1.2])
        xlim([-70 1000])
        title('F 2016 Figure 4B')  
        saveas(gcf,strcat(savefigurepath,'F 2016 Figure 4B.jpg'))
    end
end

%% Plot F_2016_Figure6
%
%
for i = 17:18;
    %plot input
    %figure size
    figure('position', fig_position)
    subplot(2,1,2) 
    plot(S.Data(i).time_input-180,S.Data(i).input,'r','LineWidth',3);
    grid on
    xlabel('Time (min)')
    xlim([-180 1500])

    %plot output
    subplot(2,1,1) 
    line([-180 0],[1.0,1.0],'Color','b','LineWidth',2)
    line([0 500],[0.75,0.75],'Color','b','LineWidth',2)
    line([500 500],[0.75 0.5],'Color','b','LineWidth',2)
    line([500 1000],[0.5,0.5],'Color','b','LineWidth',2)
    line([1000 1000],[0.5 0.25],'Color','b','LineWidth',2)
    line([1000 1500],[0.25,0.25],'Color','b','LineWidth',2)
    hold on
    plot(S.Data(i).time_min-180,S.Data(i).output,'g','LineWidth',3);
    grid on
    xlabel('Time (min)')
    ylim([0 1.2])
    xlim([-180 1500])
        if i == 18,
            title('F 2016 Figure 6C nd039 (i=18)')
            saveas(gcf,strcat(savefigurepath,'F 2016 Figure 6C-2.jpg'))
        elseif i == 17,
            title('F 2016 Figure 6A nd037 (i=17)')
            saveas(gcf,strcat(savefigurepath,'F 2016 Figure 6A-2.jpg'))
        end
end


for i = 3:6,
    if i == 3 || i == 6 || i == 4,
        %plot input
        %figure size
        figure('position', fig_position)
        subplot(2,1,2) 
        plot(S.Data(i).time_input-180,S.Data(i).input,'r','LineWidth',3);
        grid on
        xlabel('Time (min)')
        xlim([-180 1500])

        %plot output
        subplot(2,1,1) 
        line([-180 0],[1.0,1.0],'Color','b','LineWidth',2)
        line([0 500],[0.75,0.75],'Color','b','LineWidth',2)
        line([500 500],[0.75 0.5],'Color','b','LineWidth',2)
        line([500 1000],[0.5,0.5],'Color','b','LineWidth',2)
        line([1000 1000],[0.5 0.25],'Color','b','LineWidth',2)
        line([1000 1500],[0.25,0.25],'Color','b','LineWidth',2)
        hold on
        plot(S.Data(i).time_min-180,S.Data(i).output,'g','LineWidth',3);
        grid on
        xlabel('Time (min)')
        ylim([0 1.2])
        xlim([-180 1500])
        if i ==3,
            title('F 2016 Figure 6A')
            saveas(gcf,strcat(savefigurepath,'F 2016 Figure 6A.jpg'))
        elseif i ==4,
            title('F 2016 Figure 6C')
            saveas(gcf,strcat(savefigurepath,'F 2016 Figure 6C.jpg'))
        elseif i ==6,
            title('F 2016 Figure 6B')
            saveas(gcf,strcat(savefigurepath,'F 2016 Figure 6B.jpg'))
        end 
    end
end


%% Plot F_2016_Figure8
%
%
for i = 8:11,
    if i == 8 || i == 9, 
        %plot input
        %figure size
        figure('position', fig_position)
        subplot(2,1,2) 
        plot(S.Data(i).time_input-180,S.Data(i).input,'r','LineWidth',3);
        grid on
        xlabel('Time (min)')
        xlim([-180 1500])

        %plot output
        subplot(2,1,1) 
        line([-180 0],[1.0 1.0],'Color','b','LineWidth',2)
        line([0 1500],[1.0 0.25],'Color','b','LineWidth',2)
        hold on
        plot(S.Data(i).time_min-180,S.Data(i).output,'g','LineWidth',3);
        grid on
        xlabel('Time (min)')
        ylim([0 1.2])
        xlim([-180 1500])        
        if i ==8,
            title('F 2016 Figure 8A')
            saveas(gcf,strcat(savefigurepath,'F 2016 Figure 8A.jpg'))
        elseif i ==9,
            title('F 2016 Figure 8B')
            saveas(gcf,strcat(savefigurepath,'F 2016 Figure 8B.jpg'))
        end 
    elseif i== 10 || i == 11,
        %plot input
        %figure size
        figure('position', fig_position)
        subplot(2,1,2) 
        plot(S.Data(i).time_input-180,S.Data(i).input,'r','LineWidth',3);
        grid on
        xlabel('Time (min)')
        xlim([-180 2100])

        %plot output
        subplot(2,1,1) 
        line([-180 0],[1.0 1.0],'Color','b','LineWidth',2)
        hold on
        tt = 0:0.1:2100;
        plot(tt, 0.5+0.25.*sin(((2*pi/2000).*(tt-100))+pi/2),'b','LineWidth',2);
        hold on
        plot(S.Data(i).time_min-180,S.Data(i).output,'g','LineWidth',3);
        grid on
        xlabel('Time (min)')
        ylim([0 1.1])
        xlim([-180 2100])
        if i ==10,
            title('F 2016 Figure 8C')
            saveas(gcf,strcat(savefigurepath,'F 2016 Figure 8C.jpg'))
        elseif i ==11,
            title('F 2016 Figure 8D')
            saveas(gcf,strcat(savefigurepath,'F 2016 Figure 8D.jpg'))
        end 
    end
end

%% Plot M_2014_Figure5
%
%
for i = 12:15,
    %plot input
    %figure size
    
    figure('position', [0,0,600,250])
    line([-180 0],[1.0,1.0],'Color','b','LineWidth',2)
    line([0 2000],[0.5,0.5],'Color','b','LineWidth',2)
    hold on
    plot(S.Data(i).time_input-180,S.Data(i).input*0.2,'r','LineWidth',1.5);
    hold on
    plot(S.Data(i).time_min-180,S.Data(i).output,'g','LineWidth',2.5);
    hold on

    grid on
    xlabel('Time (min)')
    xlim([-180 2000])
    ylim([0 1.3])

    if i ==13,
        title('M 2014 Figure 5A')
        saveas(gcf,strcat(savefigurepath,'M 2014 Figure 5A.jpg'))
    elseif i ==12,
        title('M 2014 Figure 5B')
        saveas(gcf,strcat(savefigurepath,'M 2014 Figure 5B.jpg'))
    elseif i ==14,
        title('M 2014 Figure 5C')
        ylim auto
        saveas(gcf,strcat(savefigurepath,'M 2014 Figure 5C.jpg'))
    elseif i ==15,
        title('M 2014 Figure 5D')
        saveas(gcf,strcat(savefigurepath,'M 2014 Figure 5D.jpg'))
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
% for i = 1:size(S.Data,2),
for i = 17:19,
    S.Data(i)
%     figure(i)
    figure('position', [0, 0, 700, 280])
%     
%     xlabel('Time (min)')
%     title([S.Data(i).loadedDir '/' S.Data(i).experimentName ' with (i): ' num2str(i)])
    % Find the index at which the initial Galactose period ends
    if ~isempty(S.Data(i).input),
        hind = hind + 1; hlabel{hind} = 'Input';
%         h(hind) = plot(S.Data(i).time_input,S.Data(i).input*0.2,'r','LineWidth',2);
        subplot(2,1,2) 
        plot(S.Data(i).time_input,S.Data(i).input,'r','LineWidth',3);
        grid on
        xlabel('Time (min)')        
        xlim([0 1180])

        
%         plot(S.Data(i).time_input,S.Data(i).input*0.2,'r','LineWidth',2);

        ind = find(S.Data(i).input < 0.9*S.Data(i).input(1)) - 1;
        tGalend = floor(S.Data(i).time_input(ind(1)));
%         plot([tGalend, tGalend],[max(S.Data(i).input), min(S.Data(i).input)], 'ro')
    end
    if plotErr && ~isempty(S.Data(i).output) && ~isempty(S.Data(i).output_std),
        %hind = hind + 1; hlabel{hind} = 'Output';
        %shadedErrorBar(S.Data(i).time_min',S.Data(i).output',S.Data(i).output_std','g'); % Standard deviation
%         shadedErrorBar(S.Data(i).time_min',S.Data(i).output',1.96.*S.Data(i).output_std','g'); % Confidence interval 95%
    end
    if ~isempty(S.Data(i).inputRawNormalised),
        hind = hind + 1; hlabel{hind} = 'Input Raw';
%         h(hind) = plot(S.Data(i).time_min,S.Data(i).inputRawNormalised,'y');
    end    
    if plotCells && ~isempty(S.Data(i).outputRawNormalised),
        %hind = hind + 1; hlabel{hind} = 'Output Raw';
        %h(hind) = 
%         plot(S.Data(i).time_min,S.Data(i).outputRawNormalised);
    end    
    if ~isempty(S.Data(i).outputRawNormalised),
        hind = hind + 1; hlabel{hind} = 'Output Median';
        % Calculate the median over all cells for each timeperiod
%         h(hind) = plot(S.Data(i).time_min, median(S.Data(i).outputRawNormalised,2,'omitnan'), '--g');
    end
    if ~isempty(S.Data(i).output),
        hind = hind + 1; hlabel{hind} = 'Output';        
%         subplot(2,2,i-11)        
%         h(hind) = plot(S.Data(i).time_min,S.Data(i).output,'g','LineWidth',2);
        subplot(2,1,1) 


%       line([200 1200],[0.5,0.5],'Color','b','LineWidth',2)
        
        hold on
        plot(S.Data(i).time_min,S.Data(i).output,'g','LineWidth',3);
        grid on
        xlabel('Time (min)')
        ylim([0 1.1])
        xlim([0 1180])
        title([num2str(i)])
        
    end
    
%     saveas(gcf, sprintf('Fig%d.png', i));
 end

