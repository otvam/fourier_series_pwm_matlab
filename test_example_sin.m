function test_example_sin()
%TEST_EXAMPLE_SIMPLE Example for FFT/IFFT with sinusoidal signals.
%
%   Create arbitrary frequency domain signals.
%   Compute the IFFT.
%   Compute the FFT.
%   Compare the orginal signals with the IFFT/FFT reconstructions.

%   Thomas Guillod.
%   2020-2021 - BSD License.

close('all');
addpath('fct');

%% parameters
n_time = 100; % number of time samples
n_freq = 5; % number of time frequencies
n_sig = 2; % number of signals

f = 50; % fundamental frequency of the PWM signal

%% create a frequency domain signal
sig_freq_dc = get_dft_sin(0, [1.0 ; 0.5], [NaN ; NaN], n_sig, n_freq);
sig_freq_ac_1 = get_dft_sin(1, [0.5 ; 1.0], [+pi./6 ; -pi./6], n_sig, n_freq);
sig_freq_ac_2 = get_dft_sin(3, [1.0 ; 0.6], [-pi./4 ; +pi./4], n_sig, n_freq);
sig_freq__dft = sig_freq_dc+sig_freq_ac_1+sig_freq_ac_2;

%% get time and frequency vector
t_vec = get_t_vec(f, n_time);
f_vec = get_f_vec(f, n_freq);

%% ifft/fft
sig_time = get_ifft(sig_freq__dft, n_time);
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
bar(f_vec, abs([sig_freq__dft ; sig_freq_fft].'))
xlabel('f [Hz]')
ylabel('sig [a.u.]')
legend('_dft / sig. 1', '_dft / sig. 2', 'reconstruction/ sig. 1', 'reconstruction/ sig. 2')
title('Frequency Domain')

end