clc; clear all; close all;
% Jianpan Huang - jianpanhuang@outlook.com, 20230520

%% scanner settings
b0 = 3;
gamma = 267.5154109126009;
gamma_hz = gamma/2/pi;
% b0_inhom = 0.0;
% rel_b1 = 1;
% saturation rf pulse 
pulse1_pwr = 2; % in uT
pulse1_dur = 15; % pulse duration in s
pulse1_phase = 0; % pulse duration in s
pulse1 = [pulse1_pwr*gamma_hz, pulse1_phase, pulse1_dur];
pulse2_tmix = 0; % pulse mixing time in s
pulse2 = [0, 0, pulse2_tmix];
pulse_cell = {pulse1, pulse2};
pulse_rep = 1; % repeat number of pulse cell
pulse_tpost = 6.5e-3;

%% exchange settings
%       {name,             t1 [s],   t2 [s],    exch rate [Hz],  dw [ppm],    fraction (0~1)}
water  = {'water',         3.0,      2.0        1,               0,           1};
guanid = {'creatine_gua',  1.05,     0.1,       50,              1.9,         5.0e-04};
pools = {water; guanid};

%% cest simulation
offs = [-300,-15:0.1:15]';
% Z-spectrum
zspec = zeros(length(offs),1);
for n = 1:length(offs)
    offs_temp = offs(n);
    magn = bmesolver(b0, gamma_hz, pools, pulse_cell, pulse_rep, pulse_tpost, offs_temp, 0);
    zspec(n,1) = magn(length(pools)*2+1, end, end);
end

%% plot results
figure, plot(offs(2:end), zspec(2:end));
set(gca,'xdir','reverse')
xlabel('Offsets (ppm)');
ylabel('Z');