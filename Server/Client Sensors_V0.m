%Client example

clear all; clc; i = 0;

%Create TCP/IP object with selected network configuration
t = tcpip('localhost', 30000, 'NetworkRole', 'client'); 

%Open connection
fopen(t);

disp('Connected to the server');

%Create matrix to store data
measurements = zeros (1,20);

z=1;

while z == 1
    tic;
    
    %Receive data from server
    data = fread(t,241);
    
    time = toc;
    if time >=5
       break;
    end

    %Convert ASCII to strings
    sdata = char(data');
    
    %Convert string to cell array
    cdata = strsplit(sdata);
    
    %Convert cell array to double vector
    cdata = cellfun(@str2num,cdata(1:20));
    
    %Concatenate vector to data matrix
    measurements = [measurements; cdata];
    
    %Count
    i = i+1;
    ichar = num2str(i);
    message = [ichar 'messages received'];
    disp(message);
    
    
end