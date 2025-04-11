function test_example_pwm()
%TEST_EXAMPLE_PWM Example for DFT/FFT/IFFT with PWM signals.
%
%   Create PWM signals in frequency domain.
%   Compute the IFFT.
%   Compute the FFT.
%   Compare the orginal signals with the IFFT/FFT reconstructions.

%   Thomas Guillod.
%   2020-2021 - BSD License.

close('all');
addpath('fct');

%% parameters
n_time = 1e3; % number of time samples
n_freq = 40; % number of time frequencies
n_sig = 2; % number of signals
n_pts = 3; % number of pwm points

f = 50; % fundamental frequency of the PWM signal

d_pts = [0.25 0.5 0.75 ; 0.15 0.5 0.85]; % duty cycle matrix
v_pts = [+5.0 -3.0 -2.0 ; -5.0 +3.0 +2.0]; % signal value vector
dr_pts = [0.05 0.05 0.1 ; 0.1 0.0 0.05]; % rise time vector

fn_lp1 = 1e3; % corner frequency of the first-order low-pass applied to the signal
fn_lp2 = 1e3; % corner frequency of the second-order low-pass applied to the signal
ksi_lp2 = 0.6; % damping of the second-order low-pass applied to the signal

%% get time and frequency vector
t_vec = get_t_vec(f, n_time);
f_vec = get_f_vec(f, n_freq);

%% get PWM with DFT
sig_freq_dft = get_dft_pwm(d_pts, v_pts, dr_pts, n_pts, n_sig, n_freq);

%% apply filters
sig_freq_dft = get_filter_lp1(sig_freq_dft, f, fn_lp1, n_freq);
sig_freq_dft = get_filter_lp2(sig_freq_dft, f, fn_lp2, ksi_lp2, n_freq);

%% ifft/fft
sig_time = get_ifft(sig_freq_dft, n_time);
sig_freq_fft = get_fft(sig_time, n_freq);

%% plot
figure()

subplot(2,1,1)
plot(t_vec, sig_time)
xlabel('t [s]')
ylabel('sig [a.u.]')
legend('sig. 1', 'sig. 2')
title('Time Domain')

subplot(2,1,2)
bar(f_vec, abs([sig_freq_dft ; sig_freq_fft].'))
xlabel('f [Hz]')
ylabel('sig [a.u.]')
legend('original / sig. 1', 'original / sig. 2', 'reconstruction/ sig. 1', 'reconstruction/ sig. 2')
title('Frequency Domain')

end
