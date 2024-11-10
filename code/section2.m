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


%% -- Static

% Base parameters
% M = 16;                 % Constellation order -- VAR
% m = log2(M);            % Bits per symbol -- f(VAR)
% nBits = nSimb * m;      % Number of bits in the simulation -- f(VAR)
nSimb = 1e6;            % Number of symbols in the simulation
tAssig = 'gray';        % Type of binary assignement ('gray', 'bin')
SNR_dB = 40;            % S/N in dB
Es = 10;                % Mean Energy per Symbol
% p=[1];                  % Equivalent discrete channel -- VAR

alphas = [1/16 1/8 1/4];

%% Section 2.1. 4-QAM

% Section parameters
M = 4;                  % Constellation order
m = log2(M);            % Bits per symbol
nBits = nSimb * m;      % Number of bits in the simulation

% Digital QAM Modulator
B = randi([0 1], nBits, 1); % Generation of Bits 
A = qammod(B, M, tAssig, InputType='bit'); % Symbols encoded from bits

% Original Scatter diagram
scatterplot(A);
title(sprintf('Scatter plot of original A[n] (%d-QAM)',M));
print('../figures/2.1.0-A.png', '-dpng');

for i=1:numel(alphas)
    alpha = alphas(i);
    % Discrete channel and transmission
    p = [1 alpha];
    o = conv(A, p); o = o(1:nSimb);

    % Additive White Gaussian Noise
    q = awgn(o, SNR_dB, 10*log10(Es));

    % Plot
    scatterplot(q);
    title(sprintf('Scatter plot of q[n] for SNR=%d dB and $\\alpha=\\frac{1}{%d}$', SNR_dB, 1/alpha))
    print(sprintf('../figures/2.1.%d-alpha-1-over-%d.png', i, 1/alpha), '-dpng');
end


