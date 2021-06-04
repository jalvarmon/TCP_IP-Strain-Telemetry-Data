% Client to receive sensor information from SMARP aircraft 
%
% This scripts gets the data streaming from the SMARP aircraft's on-board
% computer and saves it locally into current folder. The program creates a
% TCPIP connection to the specified server IP direction and port, with a client
% role. After creating the connection, the received data is stored in
% memory and it is written to disc every 100 lines of data. If connection
% is lost, the program waits for a message during the selected timeout
% period. When this period elapses, execution is terminated. Message length
% must be provided at strlength variable for proper execution.

% Preamble
clear variables; clc;                                           % Clear all workspace variables and prompts in the command window
i = 1;                                                                    % This variable is a counter to store the number of messages received
j = 0;                                                                     % This variable is a counter to store the number of messages in packs of hundreds
k = 1;                                                                    % This variable is a counter to change the file name
go_on = 1;                                                           %  This is the flag variable for the while loop: 1 is OK, otherwise is break
strlength = 241;                                                  % Length of string to be received

% TCPIP Confing
t = tcpip('localhost', 5555, 'NetworkRole', 'client'); %Create TCP/IP object with selected network configuration
fopen(t); disp('Connected to the server');        %Open connection
timeout = 10;                                                       %Timeout setting (seconds)

start = input('Start transmission? (y/n) [y] : ','s'); %Ask to start transmission and save user imput as string
if isempty(start)                                             % If nothing is provided set the variable as 'y'
    start = 'y';
end

if start == 'y'
    fwrite(t,'S');
    akn = char(fread(t,10)'); 
    disp(['Message from server: ',akn]);
else
    fwrite(t,'N');
    akn = char(fread(t,17)');
    disp(['Message from server: ',akn]);
    fclose(t)
    go_on = 0;
end
    
measurements = cell (100,20);                          % Preallocate memory for measurements variable

    while go_on == 1                                               % Main Loop
        
        tic;                                                                   % Start counting time
        data = fread(t,strlength);                               % Receive data from server with specified message length
        time = toc;                                                       % Store elapsed time in "time" variable
        
        if time >= timeout                                          % If elapsed time is more than timeout
            szm = size(measurements);                     % Get size of cell array
            measurements = measurements(1:j,1:szm(1,2)); % Delete empty cells
            save(strcat('data',num2str(k)),'measurements'); % Save last messages received into .mat
            go_on = 0;
            break;                                                          % Stop excecution
        end
        
        sdata = char(data');                                       % Transpose received message and convert from ASCII to MatLab string
        cdata = strsplit(sdata);                                 % Convert string to cell array
        cdata = cellfun(@str2num,cdata,'UniformOutput',false);% Convert format to double
        cdata = cdata(~cellfun(@isempty,cdata)); % Ignore empty cells
        sz = size(cdata);                                            % Get size of received data
        measurements(j+1,1:sz(1,2))=cdata;           % Save data into measurements variable
        j = j+1;                                                             % Increase counter
        
        if mod(i,100)==0 && i>0;                                % If 100 lines of data have been received
            save(strcat('data',num2str(k)),'measurements'); % Save existing data into matlab file
            measurements = cell (100,20);                 % Reallocate measurements variable
            k = k+1;
            j = 0;                                                           % Restart flag
        end
        
        disp(strcat(num2str(i),' messages received'));
        i = i+1;                                                             % Count iterations
    end
