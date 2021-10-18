function test_example_transform()
%TEST_EXAMPLE_TRANSFORM Apply different transformation to a frequency domain signal.
%
%   Define a frequency domain signal.
%   Apply delay, phase shift, and AC coupling to the signal.
%   Compute the IFFT.
%   Plot the different obtained signals.

%
%   Thomas Guillod.
%   2020-2021 - BSD License.

close('all');
addpath('fct');

%% parameters
n_time = 100; % number of time samples
n_freq = 5; % number of time frequencies
n_sig = 1; % number of signals

f = 50; % fundamental frequency of the PWM signal
t_delay = 1e-3; % time delay to be added to the signal
phase = pi./6; % phase to be added to the signal

%% create a frequency domain signal
sig_freq_ac = get_dft_sin(1, 1, 0, n_sig, n_freq);
sig_freq_dc = get_dft_sin(0, 1, NaN, n_sig, n_freq);
sig_freq = sig_freq_ac+sig_freq_dc;

%% get time vector
t_vec = get_t_vec(f, n_time);

%% transform frequency domain signals
sig_freq_delay = get_trf_delay(sig_freq, f, t_delay, n_freq);
sig_freq_phase = get_trf_phase(sig_freq, phase, n_freq);
sig_freq_ac_coupling = get_trf_ac_coupling(sig_freq);

%% ifft
sig_time = get_ifft(sig_freq, n_time);
sig_time_delay = get_ifft(sig_freq_delay, n_time);
sig_time_phase = get_ifft(sig_freq_phase, n_time);
sig_time_ac_coupling = get_ifft(sig_freq_ac_coupling, n_time);

%% plot
figure()

plot(t_vec, sig_time)
hold('on')
plot(t_vec, sig_time_delay)
plot(t_vec, sig_time_phase)
plot(t_vec, sig_time_ac_coupling)
legend('original', 'delay' ,'phase', 'ac coupling')
xlabel('t [s]')
ylabel('sig [a.u.]')
title('Time Domain')

end
