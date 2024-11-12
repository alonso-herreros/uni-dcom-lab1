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

%% Experiment definition

function [BER_data, SER_data] = experiment(Ms, SNRs)

    % Static params
    persistent nSimb tAssig Es p;
    nSimb = 1e6;            % Number of symbols in the simulation
    tAssig = 'gray';        % Type of binary assignement ('gray', 'bin')
    Es = 10;                % Mean Energy per Symbol
    p = [1];                % Equivalent discrete channel

    % Create original sequence A[n] and noiseless sequence o[n]
    
    % Get BERs for each M
    BER_data = zeros(numel(Ms), numel(SNRs));
    SER_data = zeros(numel(Ms), numel(SNRs));
    for i=1:numel(Ms)
        M = Ms(i);
        [B, A, o] = experiment_init(M, nSimb, tAssig, p);
        [BERs, SERs] = experiment_bers(M, tAssig, Es, A, B, o, SNRs);
        BER_data(i,:) = BERs;
        SER_data(i,:) = SERs;
    end
end

function [B, A, o] = experiment_init(M, nSimb, tAssig, p)
    m = log2(M);            % Bits per symbol
    nBits = nSimb * m;      % Number of bits in the simulation
    % Digital QAM Modulator
    B = randi([0 1], nBits, 1); % Generation of Bits 
    A = qammod(B, M, tAssig, InputType='bit'); % Symbols encoded from bits
    % Discrete equivalent channel
    o = conv(A, p); o = o(1:nSimb);
end

function [q, Be] = experiment_exec(M, tAssig, SNR_dB, Es, o)
    q = awgn(o, SNR_dB, 10*log10(Es));
    Be = qamdemod(q, M, tAssig, OutputType='bit');
end

function [BERs, SERs] = experiment_bers(M, tAssig, Es, A, B, o, snr_values)
    m = log2(M);
    
    % Get error rates for each snr
    BERs = zeros(size(snr_values));
    SERs = zeros(size(snr_values));
    for i=1:numel(snr_values)
        snr = snr_values(i);

        % Get demodulated bits
        [~, Be] = experiment_exec(M, tAssig, snr, Es, o);
        
        % Bit error rate
        [~, BERs(i)] = biterr(B, Be);

        % Symbol error rate. Since qamdemod doesn't output estimated
        % symbols, we'll use the fact that a single bit error in an
        % aligned group of m=log2(M) bits is a symbol error
        Berrs = B~=Be;
        symbol_errors = 0;
        for j=0:numel(B)/m-1
            if (sum(Berrs(m*j+1:m*(j+1))) ~= 0)
                symbol_errors = symbol_errors +1;
            end
        end
        SERs(i) = double(symbol_errors)/double(numel(A));
    end
end

%% Section 3.

section = [3 1];
% Figure prefix
fprefix = sprintf('../figures/%d.%d', section(1), section(2));

% Experiment parameters
Ms = [4 16 64];
SNRs = 0:1:20;

[BER_data, SER_data] = experiment(Ms, SNRs);

% Plots
figure(1); clf; hold on;
for i=1:numel(Ms)
    semilogy(SNRs, BER_data(i,:), DisplayName=sprintf('BERs for %d-QAM', Ms(i)));
end
title('Bit error probabilities for different modulations');
xlabel('Signal-to-noise ratio (dB)');
ylabel('Bit error rate (probability)'); yscale log;
legend('show');
print(sprintf('%s.1-BERs.png', fprefix), '-dpng');
 
figure(2); clf; hold on;
for i=1:numel(Ms)
    semilogy(SNRs, SER_data(i,:), DisplayName=sprintf('SERs for %d-QAM', Ms(i)));
end
title('Symbol error probabilities for different modulations');
xlabel('Signal-to-noise ratio (dB)');
ylabel('Symbol error rate (probability)'); yscale log;
legend('show')
print(sprintf('%s.2-SERs.png', fprefix), '-dpng');
