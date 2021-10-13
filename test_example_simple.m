function test_example_simple()
%TEST_EXAMPLE_SIMPLE Example for FFT/IFFT with arbitrary signals.
%
%   Define arbitrary frequency domain signals.
%   Compute the IFFT.
%   Compute the FFT.
%   Compare the orginal signals with the IFFT/FFT reconstruction.

%   Thomas Guillod.
%   2020-2021 - BSD License.

close('all');
addpath('fct');

%% parameters
n_time = 100; % number of time samples
n_freq = 5; % number of time frequencies

f = 50; % fundamental frequency of the PWM signal

sig_freq_original = [5 3 0 3i 1; 2 0 2 0 1i]; % frequency spectrum

%% get time and frequency vector
t_vec = get_t_vec(f, n_time);
f_vec = get_f_vec(f, n_freq);

%% ifft/fft
sig_time = get_ifft(sig_freq_original, n_time);
sig_freq_reconstruct = get_fft(sig_time, n_freq);

%% plot
figure()

subplot(2,1,1)
plot(t_vec, sig_time)
xlabel('t [s]')
ylabel('sig [a.u.]')
legend('sig. 1', 'sig. 2')
title('Time Domain')

subplot(2,1,2)
bar(f_vec, abs([sig_freq_original ; sig_freq_reconstruct].'))
xlabel('f [Hz]')
ylabel('sig [a.u.]')
legend('original / sig. 1', 'original / sig. 2', 'reconstruction/ sig. 1', 'reconstruction/ sig. 2')
title('Frequency Domain')

end