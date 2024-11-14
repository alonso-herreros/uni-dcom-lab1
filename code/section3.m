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

function [BERs, SERs] = experiment(M, SNRBs)

    % Static params
    persistent nSimb tAssig Es p;
    nSimb = 1e6;            % Number of symbols in the simulation
    tAssig = 'gray';        % Type of binary assignement ('gray', 'bin')
    Es = 10;                % Mean Energy per Symbol
    p = [1];                % Equivalent discrete channel

    m = log2(M);            % Bits per symbol
    Eb = Es/m;              % Mean Energy per bit

    % Create original sequence A[n] and noiseless sequence o[n]
    [B, ~, o] = experiment_init(M, nSimb, tAssig, p);

    % Get bit and symbol error rates
    BERs = zeros(size(SNRBs));
    SERs = zeros(size(SNRBs));
    for i=1:numel(SNRBs)
        snrb = SNRBs(i);
        % Get error rates
        [~, ~, BERs(i), SERs(i)] = experiment_exec(M, tAssig, snrb, Eb, B, o);
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
function [q, Be, BER, SER] = experiment_exec(M, tAssig, snrb, Eb, B, o)
    % Get noisy sequence
    q = awgn(o, snrb, 10*log10(Eb));
    
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
SNRBs = 0:1:20;

% -- Run experiments
BER_data = zeros(numel(Ms), numel(SNRBs));
SER_data = zeros(numel(Ms), numel(SNRBs));
for i=1:numel(Ms)
    M = Ms(i);
    fprintf('Running experiment for %d-QAM...\n',M);
    [BER_data(i,:), SER_data(i,:)] = experiment(M, SNRBs);
end
SER_BER_ratios = SER_data./BER_data;

%% Section 3 - Plots
fprintf('Plotting data...\n');

% Figure prefix
fprefix = sprintf('../figures/section%d', section);

% BERs
figure(1); clf; hold on;
for i=1:numel(Ms)
    semilogy(SNRBs, BER_data(i,:), '-o', DisplayName=sprintf('BERs for %d-QAM', Ms(i)));
end; hold off;
grid on;
title('Bit error probabilities for different modulations');
xlabel('Signal-to-noise ratio per bit ($\frac{E_b}{N_0}$ in dB)');
ylabel('Bit error rate (probability)'); yscale log;
legend('show');
print(sprintf('%s/1-BERs.png', fprefix), '-dpng');
 
% SERs
figure(2); clf; hold on;
for i=1:numel(Ms)
    semilogy(SNRBs, SER_data(i,:), '-o', DisplayName=sprintf('SERs for %d-QAM', Ms(i)));
end; hold off;
grid on;
title('Symbol error probabilities for different modulations');
xlabel('Signal-to-noise ratio per bit ($\frac{E_b}{N_0}$ in dB)');
ylabel('Symbol error rate (probability)'); yscale log;
legend('show')
print(sprintf('%s/2-SERs.png', fprefix), '-dpng');

% SER-BER ratios
figure(3); clf; hold on;
for i=1:numel(Ms)
    plot(SNRBs, SER_BER_ratios(i,:), '-o', DisplayName=sprintf('SER/BER ratio for %d-QAM', Ms(i)))
end; hold off;
grid on;
title('SER-BER ratios for different modulations');
xlabel('Signal-to-noise ratio per bit ($\frac{E_b}{N_0}$ in dB)');
ylabel('SER/BER (ratio)'); ylim([0, max(SER_BER_ratios, [], 'all')]);
legend('show')
print(sprintf('%s/3-SER-BER-ratios.png', fprefix), '-dpng');
