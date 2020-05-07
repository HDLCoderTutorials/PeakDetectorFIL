IPAddr = 'ip:192.168.1.101';


%% AXI4 Stream IIO Write registers
% NOTE: This is a place holder based on auto-generated templates. Please modify these values according to your FPGA design
AXI4SReadObj = pspshared.libiio.axistream.read(...
                  'IPAddress',IPAddr,...
                  'SamplesPerFrame',1024,...
                  'DataType','ufix128',...
                  'Timeout',0.1);
setup(AXI4SReadObj);

AXI4SWriteObj = pspshared.libiio.axistream.write(...
                  'IPAddress',IPAddr,...
                  'SamplesPerFrame',1024,...                  
                  'Timeout',0.1);
setup(AXI4SWriteObj,fi(zeros(1024,1),numerictype('ufix128')));


%% AXI4 MM IIO Write registers


%% AXI4 MM IIO Read registers


%% Setup() AXI4 MM IIO Objects
% NOTE: These are placeholder values. Please update this section according to your design

% Setup AXI4MM Read IIO objects
% Setup AXI4MM Write IIO objects


%% Step() AXI4 MM IIO Objects
% NOTE: These are placeholder values. Please update this section according to your design

% ---- Step AXI4MM Read IIO objects ---- 
% ---- Step AXI4MM Write IIO objects ---- 
