%-------------------------------------------------------------------------
%
% This file was created based on the demo file while carrying out the lab
% exercise, following the lab guide.
%
% Updated by : Alonso Herreros <alonso.herreros.c@gmail.com>
%       Date : november 2024
%
%-------------------------------------------------------------------------

%% -- Basic parameters

M = 16;                 % Constellation order
m = log2(M);            % Bits per symbol
nSimb = 1e6;            % Number of symbols in the simulation
nBits = nSimb * m;      % Number of bits in the simulation
tAssig = 'gray';        % Type of binary assignement ('gray', 'bin')
SNR_dB = 25;            % S/N in dB
Es = 10;                % Mean Energy per Symbol
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

i = 1;
for snr=[20 15 10 5]
    % Additive White Gaussian Noise
    q = awgn(o, snr, 10*log10(Es));
    scatterplot(q);
    title(sprintf('Scatter plot of q[n] for SNR=%d dB ($N_0 = %.3f$)', snr, Es * 10^(-snr/10)))
    print(sprintf('../figures/section1/%d-snr%d.png', i, snr), '-dpng');
    i = i+1;
end
