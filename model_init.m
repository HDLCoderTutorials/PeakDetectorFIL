% Setup
% clear; clc; close all;

% Create pulse to detect
rng('default');
PulseLen = 64;
theta = rand(PulseLen,1);
pulse = exp(1i*2*pi*theta);

% Insert pulse to Tx signal
% rng('shuffle');
TxLen = 5000;
PulseLoc = randi(TxLen-PulseLen*2);

TxSignal = zeros(TxLen,1);
TxSignal(PulseLoc:PulseLoc+PulseLen-1) = pulse;

% Create Rx signal by adding noise
Noise = complex(randn(TxLen,1),randn(TxLen,1));
RxSignal = TxSignal + Noise;

% Scale Rx signal to +/- one
scale1 = max([abs(real(RxSignal)); abs(imag(RxSignal))]);
RxSignal = RxSignal/scale1;

% Create matched filter coefficients
CorrFilter = conj(flip(pulse))/PulseLen;

% Correlate Rx signal against matched filter
FilterOut = filter(CorrFilter,1,RxSignal);

% Find peak magnitude & location
[peak, location] = max(abs(FilterOut));

% Print results
% figure(1)
% subplot(311); plot(real(TxSignal)); title('Tx Signal (real)');
% subplot(312); plot(real(RxSignal)); title('Rx Signal (real)');
% 
% t = 1:length(FilterOut);
% str = sprintf('Peak found at %d with a value of %.3d',location,peak);
% subplot(313); plot(t,abs(FilterOut),location,peak,'o'); title(str);

WindowLen = 11;
MidIdx = ceil(WindowLen/2);
threshold = 0.03;

% Compute magnitude squared to avoid sqrt operation
MagSqOut = abs(FilterOut).^2;

% Sliding window operation
for n = 1:length(FilterOut)-WindowLen

    % Compare each value in the window to the middle sample via subtraction
    DataBuff = MagSqOut(n:n+WindowLen-1);
    MidSample = DataBuff(MidIdx);
    CompareOut = DataBuff - MidSample; % this is a vector

    % if all values in the result are negative and the middle sample is
    % greater than a threshold, it is a local max
    if all(CompareOut <= 0) && (MidSample > threshold)
        peak_2 = MidSample;
        location_2 = n + (MidIdx-1);
    end
end

% Simulate in fixed-point or floating-point
if 1 % fixed-point
    DT_input = fixdt(1,16,14);
    DT_coeff = fixdt(1,18);
    DT_filter = fixdt(1,18,15);
    DT_power = fixdt(1,18,11);
else
    DT_input = 'double';
    DT_coeff = 'double';
    DT_filter = 'double';
    DT_power = 'double';
end

if iscolumn(CorrFilter)
    CorrFilter = transpose(CorrFilter); % need row vector for filter block
end

SimTime = length(RxSignal) + WindowLen + 30;
