%Client to receive sensor information from SMARP aircraft

% Preamble
clear variables; clc;                                           % Clear all workspace variables and prompts in the command window
i = 1;                                                                    % This variable is a counter to store the number of messages received
k = 1;                                                                    % This variable is a counter to change the file name
go_on = 1;                                                           %  This is the flag variable for the while loop: 1 is OK, otherwise is break
strlength = 24100;                                                  % Length of string to be received %261 (20 sensors) 277 (with TS)

% TCPIP Confing
t = tcpip('localhost', 5555, 'NetworkRole', 'client'); %Create TCP/IP object with selected network configuration
t.InputBufferSize=999999;                                 % Set buffer to accept any lenght of message
fopen(t); disp('Connected to the server');        %Open connection
timeout = 10;                                                       %Timeout setting (seconds)

measurements = cell (100,20);                          % Preallocate memory for measurements variable

while go_on == 1                                               % Main Loop
    
    tic;                                                                   % Start counting time
    data = fread(t,strlength);                               % Receive data from server with specified message length
    time = toc;                                                       % Store elapsed time in "time" variable
    
    if time >= timeout                                          % If elapsed time is more than timeout
        go_on = 0;
        break;                                                          % Stop excecution
    end
    
    sdata = char(data');                                       % Transpose received message and convert from ASCII to MatLab string
    cdata = strsplit(sdata);                                 % Convert string to cell array
    cdata = cellfun(@str2num,cdata,'UniformOutput',false);% Convert format to double
    cdata = cdata(~cellfun(@isempty,cdata)); % Ignore empty cells
    sz = size(cdata);                                            % Get size of received data
    n = sz(2)/100;                                                 % Get ammount of sensors
    
    fr = 0;                                                              % Initialize column index
    
    for row = 1:100
        for column = 1:n
            measurements(row,column) = cdata (1,column+fr); % Save message as 100xn matrix
        end
        fr = fr+10;                                                    % increase column index
    end
    save(strcat('data',num2str(k)),'measurements'); % Save existing data into matlab file
    k = k+1;
    
    
disp(strcat(num2str(i),' messages received'));
i = i+1;                                                              % Count iterations
end

