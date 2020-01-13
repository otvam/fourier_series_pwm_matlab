clear('all');
close('all');
addpath('fct');

%% param
n_time = 1e3; % number of frequencies
n_freq = 50; % number of time samples

f = 50; % fundamental frequency of the PWM signal
d_on = 0.25; % duty cycle of the PWM signal turn-on
d_off = 0.50; % duty cycle of the PWM signal turn-off
v_on = +5.0; % PWM signal on-value
v_off = -3.0; % PWM signal off-value
tr = 1e-3; % transition time of the PWM signal
fn = 3e3; % corner frequency of the first-order low-pass applied to the signal

%% get time and frequency vector
t_vec = get_t_vec(f, n_time);
f_vec = get_f_vec(f, n_freq);

%% get PWM with DFT
sig_freq_dft = get_dft_pwm(f, d_on, d_off, v_on, v_off, tr, fn, n_freq);

%% ifft/fft
sig_time = get_ifft(sig_freq_dft, n_time);
sig_freq_fft = get_fft(sig_time, n_freq);

%% plot
figure()

subplot(2,1,1)
plot(t_vec, sig_time)
xlabel('t [s]')
ylabel('sig [a.u.]')
title('Time Domain')

subplot(2,1,2)
bar(f_vec, abs([sig_freq_dft ; sig_freq_fft].'))
xlabel('f [Hz]')
ylabel('sig [a.u.]')
legend('orignal DFT', 'IFFT/FFT reconstruction')
title('Frequency Domain')
