clc; clear all; close all;
% Jianpan Huang, email: jianpanhuang@outlook.com, 20230520

%% scanner settings
b0 = 3;
gamma = 267.5154109126009;
gamma_hz = gamma/2/pi;
% b0_inhom = 0.0;
% rel_b1 = 1;
% pulse information
pulse_pwr = 2; % in uT
pulse_dur = 2; % pulse duration in s
pulse1 = [pulse_pwr*gamma_hz, 0, pulse_dur];
pulse2 = [0, 0, 6.5e-3]; % post-pulse delay in s
pulse_cell = {pulse1, pulse2};
pulse_rep = 1;     % repeat number of pulse

%% exchange settings
%       {name,            t1 [s],   t2 [s],    exch rate [Hz],  dw [ppm],    fraction (0~1)}
water  = {'water',        1.0,      0.04       1,               0,           1};
mt     = {'mt',           1.0,      4.0e-05,   30,              -3.0,        0.1351};
amide  = {'amide',        1.0,      0.1        50,              3.5,         0.0009009};
guanid = {'guanidine',    1.0,      0.1,       1000,            2.0,         0.0009009};
noe    = {'noe',          1.3,      0.005,     20,              -3.0,        0.0045};
pools = {water; mt; amide; guanid; noe};

%% cest simulation
offs_list = [-300,-15:0.1:15]';
% Z-spectrum
zspec = zeros(length(offs_list),1);
for n = 1:length(offs_list)
    offs = offs_list(n);
    mag_all = bmsolver(b0, gamma_hz, pools, pulse_cell, pulse_rep, offs, 0);
    zspec(n,1) = mag_all(length(pools)*2+1, end, end);
end

%% plot results
figure, plot(offs_list(2:end), zspec(2:end));
set(gca,'xdir','reverse')
xlabel('Offsets (ppm)');
ylabel('Z');