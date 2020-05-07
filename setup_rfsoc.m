% This script was auto-generated from the HDL Coder Workflow Advisor for the ZCU111
% Edit this script as necessary to conform to your design specification or settings

%% Instantiate object and basic settings
rfobj = ZynqRF.comm.rfcontrol;
rfobj.RemoteIPAddr = '192.168.1.101';


PLLSrc = 'Internal';
ReferenceClock = 245.76; % MHz 
ADCSamplingRate = 1024; % MHz 
DACSamplingRate = 1024; % MHz 
DecimationFactor = 4;
InterpolationFactor = 4;


%% User FPGA-logic settings
rfobj.FPGASamplesPerClock = 4;
rfobj.ConverterClockRatio = 1;

% Check if FPGA clock-rate exceeds timing used during synthesis
FPGAClockRate = ADCSamplingRate/DecimationFactor/4;
if FPGAClockRate > 64
    warning('Selected FPGA rate %3.3f MHz exceeds the timing that was used during synthesis (%3.3f MHz) for this design! Timing failures may occur which can lead to unexpected behavior. Re-synthesizing your design may be required to achieve faster rates.',...
            FPGAClockRate,64);
end

%% Establish TCP/IP connection
setup(rfobj)

%% At boot-up, the ZCU111 will pick 245.76 MHz as the default PLL reference clock
% When selecting a different reference clock value you must configure it here
if ReferenceClock ~= 245.76
   rfobj.SetLMXExtPLL(ReferenceClock);
end



%% Setup ADC Tile sampling and PLL rates

% Tile 1 ADC
rfobj.Tile1_ADC.PLLSrc = PLLSrc;
rfobj.Tile1_ADC.PLLReferenceClk = ReferenceClock;
rfobj.Tile1_ADC.PLLSampleRate = ADCSamplingRate;
rfobj.Tile1_ADC.Ch0.DecimationMode = DecimationFactor;
rfobj.Tile1_ADC.Ch1.DecimationMode = DecimationFactor;

% Tile 2 ADC
rfobj.Tile2_ADC.PLLSrc = PLLSrc;
rfobj.Tile2_ADC.PLLReferenceClk = ReferenceClock;
rfobj.Tile2_ADC.PLLSampleRate = ADCSamplingRate;
rfobj.Tile2_ADC.Ch0.DecimationMode = DecimationFactor;
rfobj.Tile2_ADC.Ch1.DecimationMode = DecimationFactor;

% Tile 3 ADC
rfobj.Tile3_ADC.PLLSrc = PLLSrc;
rfobj.Tile3_ADC.PLLReferenceClk = ReferenceClock;
rfobj.Tile3_ADC.PLLSampleRate = ADCSamplingRate;
rfobj.Tile3_ADC.Ch0.DecimationMode = DecimationFactor;
rfobj.Tile3_ADC.Ch1.DecimationMode = DecimationFactor;

% Tile 4 ADC
rfobj.Tile4_ADC.PLLSrc = PLLSrc;
rfobj.Tile4_ADC.PLLReferenceClk = ReferenceClock;
rfobj.Tile4_ADC.PLLSampleRate = ADCSamplingRate;
rfobj.Tile4_ADC.Ch0.DecimationMode = DecimationFactor;
rfobj.Tile4_ADC.Ch1.DecimationMode = DecimationFactor;

%% Setup DAC Tiles sampling and PLL rates

% Tile 1 DAC
rfobj.Tile1_DAC.PLLSrc = PLLSrc;
rfobj.Tile1_DAC.PLLReferenceClk = ReferenceClock;
rfobj.Tile1_DAC.PLLSampleRate = DACSamplingRate;
rfobj.Tile1_DAC.Ch0.InterpolationMode = InterpolationFactor;
rfobj.Tile1_DAC.Ch1.InterpolationMode = InterpolationFactor;
rfobj.Tile1_DAC.Ch2.InterpolationMode = InterpolationFactor;
rfobj.Tile1_DAC.Ch3.InterpolationMode = InterpolationFactor;

% Tile 1 DAC
rfobj.Tile2_DAC.PLLSrc = PLLSrc;
rfobj.Tile2_DAC.PLLReferenceClk = ReferenceClock;
rfobj.Tile2_DAC.PLLSampleRate = DACSamplingRate;
rfobj.Tile2_DAC.Ch0.InterpolationMode = InterpolationFactor;
rfobj.Tile2_DAC.Ch1.InterpolationMode = InterpolationFactor;
rfobj.Tile2_DAC.Ch2.InterpolationMode = InterpolationFactor;
rfobj.Tile2_DAC.Ch3.InterpolationMode = InterpolationFactor;





%% Apply settings to RFTool
step(rfobj)

%% Set Tile Clock for re-sampling rate
% In the Vivado design, DAC Tile 0 supplies the clock source for the DUT
% When changing decimation/interpolation rates, the clock supplying the DUT must also be adjusted
% to match the new clock rate
rfobj.SetTileFPGAClock(0,1,InterpolationFactor);



%% Disconnect and clear system object
release(rfobj)

