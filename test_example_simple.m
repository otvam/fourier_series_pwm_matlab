function test_example_simple()

close('all');
addpath('fct');

%% parameters
n_time = 100; % number of frequencies
n_freq = 5; % number of time samples

f = 50; % fundamental frequency of the PWM signal

sig_freq_original = [5 3 0 3i 1]; % frequency spectrum

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
title('Time Domain')

subplot(2,1,2)
bar(f_vec, abs([sig_freq_original ; sig_freq_reconstruct].'))
xlabel('f [Hz]')
ylabel('sig [a.u.]')
legend('orignal', 'reconstruction')
title('Frequency Domain')

end