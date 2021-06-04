%Client to receive sensor information from SMARP aircraft

% Preamble
clear variables; clc;                                           % Clear all workspace variables and prompts in the command window
i = 0;                                                                     % This variable is a counter to store the number of messages received
j = 0;                                                                     % This variable is a counter to store the number of messages in packs of hundreds
z=1;                                                                      %  z is the flag variable for the while loop: 1 is OK, otherwise is break
strlength = 241;                                                  % Length of string to be received

% TCPIP Confing
t = tcpip('localhost', 5555, 'NetworkRole', 'client'); %Create TCP/IP object with selected network configuration
fopen(t); disp('Connected to the server');        %Open connection
timeout = 10;                                                       %Timeout setting (seconds)

measurements = cell (100,20);                          % Preallocate memory for measurements variable

while z == 1                                                        % Main Loop
    tic;                                                                   % Start counting time
    data = fread(t,strlength);                               % Receive data from server with specified message length
    time = toc;                                                       % Store elapsed time in "time" variable
    
    if time >= timeout                                          % If elapsed time es more than timeout
        szm = size(measurements);                     % Get size of cell array
        measurements = measurements(1:j,1:szm(1,2)); % Delete empty cells
        save(strcat('data',num2str(i)),'measurements'); %Save last messages received into .mat
        break;                                                          % Stop excecution
    end
    
    sdata = char(data');                                       % Transpose received message and convert from ASCII to MatLab string
    cdata = strsplit(sdata);                                 % Convert string to cell array
    cdata = cellfun(@str2num,cdata,'UniformOutput',false);% Convert format to double
    cdata = cdata(~cellfun(@isempty,cdata)); % Ignore empty cells
    sz = size(cdata);                                            % Get size of received data
    measurements(j+1,1:sz(1,2))=cdata;           % Save data into measurements variable
    j = j+1;                                                             % Increase counter
    
    if mod(i,100)==0 && i>0;                                % If 100 receivings have ocurred
        save(strcat('data',num2str(i)),'measurements'); % Save existing data into matlab file
        measurements = cell (100,20);                 % Reallocate measurements variable
        j = 0;                                                           % Restart flag
    end
    
    i = i+1;                                                             % Count iterations
    disp(strcat(num2str(i),' messages received'));
end