%Client to receive sensor information from SMARP aircraft

% Preamble
clear variables; clc;                                           % Clear all workspace variables and prompts in the command window
i = 0;                                                                     % This variable is a counter to store the number of messages received
j = 0;                                                                     % This variable is a flag for the first time the data matrix is written
z=1;                                                                      %  z is the flag variable for the while loop: 1 is OK, otherwise is break

% TCPIP Confing
t = tcpip('1.1.1.50', 5555, 'NetworkRole', 'client'); %Create TCP/IP object with selected network configuration
fopen(t); disp('Connected to the server');        %Open connection
timeout = 10;                                                       %Timeout setting (seconds)

measurements = zeros (1,5);                            %Create matrix to store data

while z == 1                                                        % Main Loop
    tic;                                                                   % Start counting time     
    data = fread(t,66);                                           % Receive data from server with specified message length    
    time = toc;                                                       % Store elapsed time in "time" variable
    
    if time >= timeout                                          % If elapsed time es more than timeout
        save(strcat('data',num2str(i)),'measurements'); %Save last messages received into .mat
        break;                                                          % Stop excecution
    end
        
    sdata = char(data');                                        % Transpose received message and convert from ASCII to MatLab string    
    cdata = strsplit(sdata);                                   % Convert string to cell array     
    cdata = cellfun(@str2num,cdata(1:5),'UniformOutput',false);% Convert cell array to double vector
    
    %Concatenate vector to data matrix
    if j == 0;                                                           % If this is the first saving of data into variable
        measurements = cdata;                            % Save data received into measurements variable
        j = 1;                                                            % Change to concatenate mode
    else                                                                 % If this is not the first saving of data, concatenate
        measurements = [measurements; cdata];   % Concatenate to existing data
    end       
    
    if mod(i,100)==0;                                           % If 100 receivings have ocurred
        save(strcat('data',num2str(i)),'measurements'); % Save existing data into matlab file
        measurements = cell(1,5);                       % Reallocate variable
        j = 0;                                                           % Restart flag 
    end   
   
    i = i+1;                                                             % Count iterations
    disp(strcat(num2str(i),' messages received'));
    
end