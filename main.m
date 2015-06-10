% algorithm flow
% perproc -> walk or not
% pre proc -> extract step <<<<<<<<<<this file stage
% couter
clc
clear all

global g_gvr
global g_smp
global g_ne
global g_pn
global g_nd
global g_of

%% running parameter
% g_gvr = 0.5;
% g_ne = 1;
% g_pn = 5;
% g_nd = 3;
% g_smp = 1;
% g_of = 0.04;

%% walking parameter
g_gvr = 0.5;
g_ne = 1;
g_pn = 10;
g_nd = 4;
g_smp = 2;
g_of = 0.03;

file = fopen('./PedoData_Watch/WalkSlowly20140123_2.txt');
Cols = textscan(file, '%f %f %f %f %f %f %d %f %f %f %d %d %d %s %s %s');
fclose(file);
st = 50;
min_1_Hz_30 = 2000;
acc = [Cols{8} Cols{9} Cols{10}];
acc = acc(st:g_smp:st+min_1_Hz_30,:);
%acc = acc(1:g_smp:end,:);

% load './PedoData_Watch/pni/56_steps_handheld.mat'
% resultData = data_rec.dataSimRec.data_result_ay;
% acc = resultData(1:g_smp:end,5:7);
%acc = acc(500:700,:);

%% moving average test
n = 10; % moving avg tabs
for t=1:3,
    accmv(:,t) = moving_avg(acc(:,t), n);
end

accraw = acc;
acc = acc - g_gvr*accmv;
%acc = accmv;

%% pedometer pre proc elimiate partial mean

pn = g_pn;
nd = g_nd;

accssq = ssq(acc);
accssq_raw = accssq;
accssq = moving_avg(accssq, pn);
accssq_diff = diff_p(accssq, nd);

signal = accssq_diff;

sign_desc = zeros(size(signal,1),1);
sign_desc_b = sign_desc;
sign_desc_1 = sign_desc;
sign_desc_m1 = sign_desc;
%wid = [0.02:0.01:0.05];
wid = g_of;
for i=[wid wid.*-1],
    x = signal + i;
    x_dif = sign(x);
    x_dif_m = sig_shift(x_dif,1);
    x_desc = (x_dif_m - x_dif)./2;
    sign_desc = sign_desc + x_desc;
    if i>0, sign_desc_1 = sign_desc_1 + x_desc; end
    if i<0, sign_desc_m1 = sign_desc_m1 + x_desc; end
end
sign_desc_1 = abs(sign_desc_1).*-1;
sign_desc_1 = sign_desc_1./30 - g_of;
sign_desc_m1 = abs(sign_desc_m1);
sign_desc_m1 = sign_desc_m1./30 + g_of;
fprintf('total steps are %d', round(sum(abs(sign_desc))/4));


%% Plot for algorithm parameter atuning 
figure(991)
subplot(3,1,1), plot(accraw); ylim([-1.5 1.5]); xlabel('timestamp'); ylabel('acc raw');
subplot(3,1,2), plot(accmv); ylim([-1.5 1.5]); xlabel('timestamp'); ylabel('DC gain');
subplot(3,1,3), plot(acc); ylim([-1.5 1.5]); xlabel('timestamp'); ylabel('acc stay close');

figure(992)
clf; 
subplot(3,1,1), plot(acc); xlabel('timestamp'); ylabel('acc');
subplot(3,1,2), plot(accssq_raw,'c'); %ylim([0 2]);
hold on
plot(accssq); xlabel('timestamp'); ylabel('sum of squ & moving avg');
subplot(3,1,3), plot(accssq_diff); grid; ylim([-0.2 0.2]); 
hold on 
plot(sign_desc_1, 'r');
plot(sign_desc_m1, 'r');
hold on;
plot(zeros(size(accssq_diff(g_pn*2:end),1),1),'r'); xlabel('timestamp'); ylabel('diff & count');