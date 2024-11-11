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

function experiment(section)

    % Static params
    persistent nSimb tAssig Es p Ms SNRs;
    nSimb = 1e6;            % Number of symbols in the simulation
    tAssig = 'gray';        % Type of binary assignement ('gray', 'bin')
    Es = 10;                % Mean Energy per Symbol
    p = [1];                % Equivalent discrete channel

    Ms = [4 16 64];
    SNRs = 0:1:20;

    % Figure prefix
    fprefix = sprintf('../figures/%d.%d', section(1), section(2));

    % Create original sequence A[n] and noiseless sequence o[n]
    
    % Get BERs for each M
    BER_data = zeros(numel(Ms), numel(SNRs));
    for i=1:numel(Ms)
        M = Ms(i);
        [B, ~, o] = experiment_init(M, nSimb, tAssig, p);
        BER_data(i,:) = experiment_bers(M, tAssig, Es, B, o, SNRs);

        % Plot
        semilogy(SNRs, BER_data(i,:));
        title(sprintf('Error probabilities for for %d-QAM and SNR=%d', M, snr))
    end
    
    print(sprintf('%s-plots.png', fprefix), '-dpng')
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

function [BERs] = experiment_bers(M, tAssig, Es, B, o, snr_values)
    % Get BER for each snr
    BERs = zeros(size(snr_values));
    for i=1:numel(snr_values)
        snr = snr_values(i);
        [~, Be] = experiment_exec(M, tAssig, snr, Es, o);
        BERs(i) = biterr(B, Be);
    end
end

%% Section 3.1. (p = δ[n] + a δ[n-1])

section = [3 1];

% Section parameters
M = 4;

experiment(M, section)
