%-------------------------------------------------------------------------
%
% Fichero de demostración para la Práctica 1 del LAB
%
%   Bloques básicos para la simulación de un sistema digital de
%   comunicaciones
%
% Demo file for LAB Experiment 1
%
%   Basic blocks for the simulation of a digital communication system
%
%-------------------------------------------------------------------------
%
% LABORATORIO : COMUNICACIONES DIGITALES
% LABORATORY  : DIGITAL COMMUNICATIONS
%
%        Versión: 1.0
%  Realizado por: Marcelino Lázaro
%                 Departamento de Teoria de la Señal y Comunicaciones
%                 Universidad Carlos III de Madrid
%      Creación : septiembre 2022
% Actualización : septiembre 2022
%
%-------------------------------------------------------------------------
%
% This file was modified in carrying out the lab exercise, following the
% lab guide.
%
% Updated by : Alonso Herreros <alonso.herreros.c@gmail.com>
%       Date : november 2024
%
%-------------------------------------------------------------------------

%% -- Init
% Apparently, "Using 'clear' with the 'all' option usually decreases code
% performance and is often unnecessary"
% clear all
% clc


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
print('../figures/1.A.png', '-dpng');

%% -- Tx & Rx

% Transmission through channel
o = conv(A, p);
o = o(1:nSimb);

for snr=[20 15 10 5]
    % Additive White Gaussian Noise
    q = awgn(o, snr, 10*log10(Es));
    scatterplot(q);
    title(sprintf('Scatter Plot of q[n] for N_0 = %d', Es * 10^(-snr/10)))
    print(sprintf('../figures/1.snr%d.png', snr), '-dpng');
end


% Bit-level demodulation
Be = qamdemod(q, M, tAssig, OutputType='bit');
 
