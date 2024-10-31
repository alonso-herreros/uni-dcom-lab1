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
clear all
clc
%-- Parámetros básicos (basic parameters)

M = 16;                 % Orden de la constelación (Constellation order)
m = log2(M);            % Bits por símbolo (Bits per symbol)
nSimb = 1e6;            % Number of symbols in the simulation
nBits = nSimb * m;      % Number of bits in the simulation
tAssig = 'gray';        % Type of binary assignement ('gray', 'bin')
SNR_dB = 25;            % Relación señal a ruido en dB (S/N in dB)
Es = 10;                % Energía media por símbolo (Mean Energy per Symbol)
p=[1];                  % Canal discreto equivalente (Equivalent discrete channel)

%-- Modulador Digital QAM (Digital QAM Modulator)

% Generación de bits (Generation of Bits) 
B = randi([0 1],nBits,1);
% Codificación de bits en símbolos (Symbols encoded from bits)
A = qammod(B,M,tAssig,'InputType','bit'); 
% Diagrama de dispersión de los símbolos (Scattering diagram)
scatterplot(A);title('Scatter Plot A[n]')

% Transmisión a través del canal (Transmission through channel)
o = conv(A,p);
o = o(1:nSimb);

% Ruido Aditivo Blanco Gausiano (Additive White Gaussian Noise)
q = awgn(o,SNR_dB,10*log10(Es));
scatterplot(q);title('Scatter Plot q[n]')

% Demodulación a nivel de bit (Bit-level demodulation)
Be = qamdemod(q,M,tAssig,'OutputType','bit');
 
