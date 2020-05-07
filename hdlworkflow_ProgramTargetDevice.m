% Load the Model
load_system('pulse_detector_axis_zcu111');

% Model HDL Parameters
hdlset_param('pulse_detector_axis_zcu111','HDLSubsystem','pulse_detector_axis_zcu111/DUT');
hdlset_param('pulse_detector_axis_zcu111','ReferenceDesign','ADC & DAC XM500 Balun Single-Ended 4x4');
hdlset_param('pulse_detector_axis_zcu111','TargetPlatform','Xilinx Zynq UltraScale+ RFSoC ZCU111 Evaluation Kit [Rev 1.0]');

% Construct the Workflow Configuration Object with default settings
hWC = hdlcoder.WorkflowConfig('SynthesisTool','Xilinx Vivado','TargetWorkflow','IP Core Generation');

% Specify the top level project directory
hWC.ProjectFolder = 'hdl_prj';
hWC.ReferenceDesignToolVersion = '2018.3';
hWC.IgnoreToolVersionMismatch = false;

% Set Workflow tasks to run
hWC.RunTaskGenerateRTLCodeAndIPCore = false;
hWC.RunTaskCreateProject = false;
hWC.RunTaskGenerateSoftwareInterfaceModel = false;
hWC.RunTaskBuildFPGABitstream = false;
hWC.RunTaskProgramTargetDevice = true;

% Set properties related to 'RunTaskProgramTargetDevice' Task
hWC.ProgrammingMethod = hdlcoder.ProgrammingMethod.Custom;

% Validate the Workflow Configuration Object
hWC.validate;

% Run the workflow
hdlcoder.runWorkflow('pulse_detector_axis_zcu111/DUT', hWC);
