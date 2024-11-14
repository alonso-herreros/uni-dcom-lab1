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

% -- Basic parameters
M = 16;                 % Constellation order
m = log2(M);            % Bits per symbol
nSimb = 1e6;            % Number of symbols in the simulation
nBits = nSimb * m;      % Number of bits in the simulation
tAssig = 'gray';        % Type of binary assignement ('gray', 'bin')
% SNR_dB = 25;          % S/N in dB
Es = 10;                % Mean Energy per Symbol
Eb = Es/m;              % Mean Energy per bit
p=[1];                  % Equivalent discrete channel


%% -- Digital QAM Modulator

% Generation of Bits 
B = randi([0 1], nBits, 1);
% Symbols encoded from bits
A = qammod(B, M, tAssig, InputType='bit'); 
% Scatter diagram
f = figure(1);
scatterplot(A);title('Scatter plot of original A[n]');
print('../figures/section1/0-A.png', '-dpng');


%% -- Transmission through channel
o = conv(A, p);
o = o(1:nSimb);


%% -- AWGN

snrb_values = [20 15 10 5]; % Eb/N0 in decibels, a.k.a. SNR per bit
for i=1:numel(snrb_values)
    snrb = snrb_values(i);
    % Additive White Gaussian Noise
    q = awgn(o, snrb, 10*log10(Eb));
    scatterplot(q);
    title(sprintf('Scatter plot of q[n] for $\\frac{E_b}{N_0}=%d$ dB ($N_0 = %.3f$)', snrb, Eb * 10^(-snrb/10)))
    print(sprintf('../figures/section1/%d-snrb%d.png', i, snrb), '-dpng');
end
