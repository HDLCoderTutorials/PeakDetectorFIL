model_init;

% Simulate the reference model
sim('pulse_detector');

% Set up the RFSoC 
setup_rfsoc;

%% Set up AXI Stream DMA testbench

% Load the testbench input data-- generated from pulse_detector_axis_zcu111.slx
load FIL_axis_data_in

% Reset LibIIO in case stale context exists
matlabshared.libiio.internal.ContextManager.reset;

% Create and set up the AXI Stream Write/Read objects
axisWr = pspshared.libiio.axistream.write(...
    'IPAddress','192.168.1.101',...
    'Timeout',0.1);
setup(axisWr,FIL_axis_data_in);

axisRd = pspshared.libiio.axistream.read(...
    'IPAddress','192.168.1.101',...
    'DataType','ufix128',...
    'SamplesPerFrame',length(FIL_axis_data_in),...
    'Timeout',0.1);
setup(axisRd);

%% Run the testbench

% Write input data
axisWr(FIL_axis_data_in);

% Wait for data to propagate through FPGA
pause(0.1);

% Read output data
FIL_axis_data_out = axisRd();

%% Extract output data

fil_mid_sample = bitsliceget(FIL_axis_data_out,20,3);
fil_mid_sample = reinterpretcast(fil_mid_sample, numerictype(DT_power));

fil_detected = logical(bitsliceget(FIL_axis_data_out,2,2));

fil_valid_out = logical(bitsliceget(FIL_axis_data_out,1,1));

%% Compare simulation to FIL

compareData(sim_mid_sample,fil_mid_sample,1,'mid sample');
compareData(sim_detected,fil_detected,2,'detected');
compareData(sim_valid_out,fil_valid_out,3,'valid out');
