model_init;

% Override sim time from init script
SimTime = length(RxSignal) + WindowLen + 30;

% Simulate model
sim('pulse_detector')

% Correlation filter output
FilterOutSL = squeeze(logsout.getElement('filter_out').Values.Data);
FilterValid = squeeze(logsout.getElement('filter_valid').Values.Data);
FilterOutSL = FilterOutSL(FilterValid);
compareData(real(FilterOut),real(FilterOutSL),{2 3 1},'ML vs SL correlator output (re)');
compareData(imag(FilterOut),imag(FilterOutSL),{2 3 2},'ML vs SL correlator output (im)');

% Magnitude squared output
MagSqSL = squeeze(logsout.getElement('mag_sq_out').Values.Data);
MagSqSL = MagSqSL(FilterValid);
compareData(MagSqOut,MagSqSL,{2 3 3},'ML vs SL mag-squared output');

% Peak value
MidSampleSL = squeeze(logsout.getElement('mid_sample').Values.Data);
Detected = squeeze(logsout.getElement('detected').Values.Data);
PeakSL = double(MidSampleSL(Detected>0));

fprintf('\nPeak location = %d, magnitude = %.3d using global max\n',location,peak);
fprintf('Peak location = %d, mag-squared = %.3d using local max\n',location_2,peak_2);
fprintf('Peak mag-squared from Simulink = %.3d, error = %.3d\n',PeakSL,abs(peak_2-PeakSL));
