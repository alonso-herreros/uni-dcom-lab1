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

function experiment(M, p_, section)

    % Static params
    persistent nSimb tAssig SNR_dB Es a_values;
    nSimb = 1e6;            % Number of symbols in the simulation
    tAssig = 'gray';        % Type of binary assignement ('gray', 'bin')
    SNR_dB = 40;            % S/N in dB
    Es = 10;                % Mean Energy per Symbol

    a_values = [1/16 1/8 1/4];

    % Figure prefix
    fprefix = sprintf('../figures/%d.%d.%d', section(1), section(2), section(3));

    % Experiment 1: Original sequence A[n]
    [~, A] = experiment1(M, nSimb, tAssig);
    print(sprintf('%s.0-A.png', fprefix), '-dpng');

    % Experiment 2: q[n] after channel and noise
    for i=1:numel(a_values)
        a = a_values(i);
        p = p_(a);
        experiment2(M, nSimb, SNR_dB, Es, p, A, a);
        print(sprintf('%s.%d-a-1-%dth.png', fprefix, i, 1/a), '-dpng');
    end
end

function [B, A] = experiment1(M, nSimb, tAssig)
    % Discrete channel and transmission
    m = log2(M);            % Bits per symbol
    nBits = nSimb * m;      % Number of bits in the simulation

    % Digital QAM Modulator
    B = randi([0 1], nBits, 1); % Generation of Bits 
    A = qammod(B, M, tAssig, InputType='bit'); % Symbols encoded from bits

    % Plot
    scatterplot(A);
    title(sprintf('Scatter plot of original A[n] (%d-QAM)',M));
end

function [q] = experiment2(M, nSimb, SNR_dB, Es, p, A, a)
    o = conv(A, p); o = o(1:nSimb);

    q = awgn(o, SNR_dB, 10*log10(Es));

    % Plot
    scatterplot(q);
    title(sprintf('Scatter plot of q[n] for %d-QAM dB and $a=\\frac{1}{%d}$', M, 1/a))
end

%% Section 2.1. (p = δ[n] + a δ[n-1])

p_ = @(a) [1 a];

%% Section 2.1.1. (4-QAM)
section = [2 1 1];

% Section parameters
M = 4;

experiment(M, p_, section)

%% Section 2.1.2. (16-QAM)
section = [2 1 2];

% Section parameters
M = 16;

experiment(M, p_, section)

%% Section 2.2. (p = δ[n] + a δ[n-1] + a/4 δ[n-2])

p_ = @(a) [1 a a/4];

%% Section 2.2.1. (4-QAM)
section = [2 2 1];

% Section parameters
M = 4;

experiment(M, p_, section)

%% Section 2.2.2. (16-QAM)
section = [2 2 2];

% Section parameters
M = 16;

experiment(M, p_, section)


