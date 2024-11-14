%-------------------------------------------------------------------------
%
% This file was created based on the demo file while carrying out the lab
% exercise, following the lab guide.
%
% Updated by : Alonso Herreros <alonso.herreros.c@gmail.com>
%       Date : november 2024
%
%-------------------------------------------------------------------------

%% -- Init

set(groot,'defaulttextinterpreter','latex');
set(groot, 'defaultLegendInterpreter', 'latex');


% M = 16;                 % Constellation order -- VAR
% m = log2(M);            % Bits per symbol -- f(VAR)
% nBits = nSimb * m;      % Number of bits in the simulation -- f(VAR)
% global nSimb tAssig SNR_dB Es;
% nSimb = 1e6;            % Number of symbols in the simulation
% tAssig = 'gray';        % Type of binary assignement ('gray', 'bin')
% SNR_dB = 40;            % S/N in dB
% Es = 10;                % Mean Energy per Symbol
% p=[1];                  % Equivalent discrete channel -- VAR

%% Custom functions

% Calculate symbol error rate based on bit errors and QAM order
function SER = symerr(Berrs, M)
    m = log2(M);
    nSym = numel(Berrs)/m;

    % Since qamdemod doesn't output estimated symbols, we'll use the fact that
    % one or more bit errors in an aligned group of m=log2(M) bits is 1 symbol
    % error
    SER = sum(sum(reshape(Berrs, m, nSym)) ~= 0)/nSym;
end


%% Experiment definition

function [BERs, SERs] = experiment(M, SNRs)

    % Static params
    persistent nSimb tAssig Es p;
    nSimb = 1e6;            % Number of symbols in the simulation
    tAssig = 'gray';        % Type of binary assignement ('gray', 'bin')
    Es = 10;                % Mean Energy per Symbol
    p = [1];                % Equivalent discrete channel

    % Create original sequence A[n] and noiseless sequence o[n]
    [B, ~, o] = experiment_init(M, nSimb, tAssig, p);

    % Get bit and symbol error rates
    BERs = zeros(size(SNRs));
    SERs = zeros(size(SNRs));
    for i=1:numel(SNRs)
        snr = SNRs(i);
        % Get error rates
        [~, ~, BERs(i), SERs(i)] = experiment_exec(M, tAssig, snr, Es, B, o);
    end
end

function [B, A, o] = experiment_init(M, nSimb, tAssig, p)
    m = log2(M);            % Bits per symbol
    nBits = nSimb * m;      % Number of bits in the simulation

    % Digital QAM Modulator
    B = randi([0 1], nBits, 1);                % Generation of Bits 
    A = qammod(B, M, tAssig, InputType='bit'); % Symbols encoded from bits

    % Discrete equivalent channel
    o = conv(A, p); o = o(1:nSimb);
end

% Get noisy sequence, estimated bits, BER, and SER
function [q, Be, BER, SER] = experiment_exec(M, tAssig, snr, Es, B, o)
    % Get noisy sequence
    q = awgn(o, snr, 10*log10(Es));
    
    % Get demodulated bits
    Be = qamdemod(q, M, tAssig, OutputType='bit');

    % Bit and symbol error rates
    [~, BER, Berrs] = biterr(B, Be);
    SER = symerr(Berrs, M);
end


%% Section 3 - Running experiments
section = 3;

% Experiment parameters
Ms = [4 16 64];
SNRs = 0:1:20;

% -- Run experiments
BER_data = zeros(numel(Ms), numel(SNRs));
SER_data = zeros(numel(Ms), numel(SNRs));
for i=1:numel(Ms)
    M = Ms(i);
    fprintf('Running experiment for %d-QAM...\n',M);
    [BER_data(i,:), SER_data(i,:)] = experiment(M, SNRs);
end
SER_BER_ratios = SER_data./BER_data;

%% Section 3 - Plots
fprintf('Plotting data...\n');

% Figure prefix
fprefix = sprintf('../figures/section%d', section);

% BERs
figure(1); clf; hold on;
for i=1:numel(Ms)
    semilogy(SNRs, BER_data(i,:), DisplayName=sprintf('BERs for %d-QAM', Ms(i)));
end; hold off;
grid on;
title('Bit error probabilities for different modulations');
xlabel('Signal-to-noise ratio (dB)');
ylabel('Bit error rate (probability)'); yscale log;
legend('show');
print(sprintf('%s/1-BERs.png', fprefix), '-dpng');
 
% SERs
figure(2); clf; hold on;
for i=1:numel(Ms)
    semilogy(SNRs, SER_data(i,:), DisplayName=sprintf('SERs for %d-QAM', Ms(i)));
end; hold off;
grid on;
title('Symbol error probabilities for different modulations');
xlabel('Signal-to-noise ratio (dB)');
ylabel('Symbol error rate (probability)'); yscale log;
legend('show')
print(sprintf('%s/2-SERs.png', fprefix), '-dpng');

% SER-BER ratios
figure(3); clf; hold on;
for i=1:numel(Ms)
    plot(SNRs, SER_BER_ratios(i,:), DisplayName=sprintf('SER/BER ratio for %d-QAM', Ms(i)))
end; hold off;
grid on;
title('SER-BER ratios for different modulations');
xlabel('Signal-to-noise ratio (dB)');
ylabel('SER/BER (ratio)'); ylim([0, max(SER_BER_ratios, [], 'all')]);
legend('show')
print(sprintf('%s/3-SER-BER-ratios.png', fprefix), '-dpng');
