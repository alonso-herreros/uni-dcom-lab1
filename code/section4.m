%-------------------------------------------------------------------------
%
% This file was created hile carrying out the lab exercise, following the
% lab guide.
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

function [BERs, SERs] = experiment(a, b, snr, ds, compensate)
    arguments
        a (1,1) double
        b (1,1) double
        snr (1,:) double
        ds (1,:) double
        compensate (1,1) logical = false
    end

    % Static params
    persistent M nSym tAssig Es p;
    M = 16;                 % Constellation order
    nSym = 1e6;             % Number of symbols in the simulation
    tAssig = 'gray';        % Type of binary assignement ('gray', 'bin')
    Es = 10;                % Mean Energy per Symbol

    p = [-b/2 b a b -b/2];  % Equivalent discrete channel

    % Create original sequence A[n] and noiseless sequence o[n]
    [B, ~, ~, q] = experiment_init(M, nSym, tAssig, p, snr, Es);

    % Get bit and symbol error rates
    BERs = zeros(size(ds));
    SERs = zeros(size(ds));
    for i=1:numel(ds)
        d = ds(i);
        if (compensate); qfactor = 1/p(i); else; qfactor = 1; end
        % Get error rates
        [~, BERs(i), SERs(i)] = experiment_exec(M, tAssig, d, B, q, qfactor);
    end
end

function [B, A, o, q] = experiment_init(M, nSym, tAssig, p, snr, Es)
    m = log2(M);            % Bits per symbol
    nBits = nSym * m;       % Number of bits in the simulation

    % Digital QAM Modulator
    B = randi([0 1], nBits, 1);                % Generation of Bits 
    A = qammod(B, M, tAssig, InputType='bit'); % Symbols encoded from bits

    % Discrete equivalent channel
    o = conv(A, p);
    o = o(1:nSym); % Truncate end - observations based on empty transmission

    % Get noisy sequence
    q = awgn(o, snr, 10*log10(Es));
end

% Get noisy sequence, estimated bits, BER, and SER
function [Be, BER, SER] = experiment_exec(M, tAssig, d, B, q, qfactor)
    m = log2(M);

    % -- Apply delay d
    % - Eliminate first d observations (info about A[n], n<0)
    q_d = q(d+1:end);   % q[d] ... q[N], which is info about A[0] ... A[N-d]
    % - Truncate last m*d bits (estimation requires q[N+1] ... q[N+d])
    B_d = B(1:end-m*d); % B[0] ... B[m(N-d)]

    % Apply q compensation factor
    q_d = qfactor*q_d;
    
    % Get demodulated bits A[0] ... A[N-d]
    Be = qamdemod(q_d, M, tAssig, OutputType='bit');
    % Bit and symbol error rates
    [~, BER, Berrs] = biterr(B_d, Be);
    SER = symerr(Berrs, M);
end

% Plot results
function experiment_plot(a, b, snr, ds, BERs, SERs, secstr, title_append)
    arguments
        a (1,1) double
        b (1,1) double
        snr (1,:) double
        ds (1,:) double
        BERs (1,:) double
        SERs (1,:) double
        secstr (1,1) string
        title_append (1,1) string = ""
    end


    % Figure prefix
    fprefix = sprintf('../figures/%s', secstr);

    % BERs
    figure; clf;
    bar(ds, BERs);
    text(ds, BERs, num2str(BERs', '%.5f'),'vert','bottom','horiz','center'); 
    grid on;
    title(sprintf('BERs for $a=\\frac{1}{%d}$, $b=\\frac{1}{%d}$, SNR=%d dB%s', 1/a, 1/b, snr, title_append));
    xlabel('Delay $d$');
    ylabel('Bit error rate (probability)'); ylim([0 0.6]);
    print(sprintf('%s.1-BERs.png', fprefix), '-dpng');
    
    % SERs
    figure; clf;
    bar(ds, SERs);
    text(ds, SERs, num2str(SERs', '%.5f'),'vert','bottom','horiz','center'); 
    grid on;
    title(sprintf('SERs for $a=\\frac{1}{%d}$, $b=\\frac{1}{%d}$, SNR=%d dB%s', 1/a, 1/b, snr, title_append));
    xlabel('Delay $d$');
    ylabel('Bit error rate (probability)'); ylim([0 1]);
    print(sprintf('%s.2-SERs.png', fprefix), '-dpng');
end

%% Section 4.1 (a=1, b=1/16, SNR=15 dB)
section = [4 1]; secstr = join(string(section), '.');

% Experiment parameters
a = 1;
b = 1/16;
snr = 15;
ds = [0 1 2 3 4];

% Run experiments
fprintf('Running experiment %s with a=%d, b=%.2f, SNR=%d dB...\n', secstr,a,b,snr);
[BERs, SERs] = experiment(a, b, snr, ds);

% Plots
fprintf('Plotting data for section %s ...\n', secstr);
experiment_plot(a,b,snr,ds, BERs, SERs, secstr);


%% Section 4.2 (a=1, b=1/4, SNR=15 dB)
section = [4 2]; secstr = join(string(section), '.');

% Experiment parameters
a = 1;
b = 1/4;
snr = 15;
ds = [0 1 2 3 4];

% Run experiments
fprintf('Running experiment %s with a=%d, b=%.2f, SNR=%d dB...\n', secstr, a,b,snr);
[BERs, SERs] = experiment(a, b, snr, ds);

% Plots
fprintf('Plotting data for section %s ...\n', secstr);
experiment_plot(a,b,snr,ds, BERs, SERs, secstr);

%% Section 4.3 (a=1/2, b=1/32, SNR=21 dB)
section = [4 3]; secstr = join(string(section), '.');

% Experiment parameters
a = 1/2;
b = 1/32;
snr = 21;
ds = [0 1 2 3 4];

% Run experiments
fprintf('Running experiment %s with a=%.2f, b=%.2f, SNR=%d dB...\n', secstr, a,b,snr);
[BERs, SERs] = experiment(a, b, snr, ds);

% Plots
fprintf('Plotting data for section %s ...\n', secstr);
experiment_plot(a,b,snr,ds, BERs, SERs, secstr);

%% Section 4.4 (a=1, b=1/4, SNR=15 dB, receiver adjusted)
section = [4 4]; secstr = join(string(section), '.');

% Experiment parameters do not change

% Run experiments
fprintf('Running experiment %s with a=%.2f, b=%.2f, SNR=%d dB, with q compensation...\n', secstr, a,b,snr);
[BERs, SERs] = experiment(a, b, snr, ds, true);

% Plots
fprintf('Plotting data for section %s ...\n', secstr);
experiment_plot(a,b,snr,ds, BERs, SERs, secstr, " with compensation");
