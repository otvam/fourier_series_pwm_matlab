function test_example_pwm()
%TEST_EXAMPLE_PWM Example for DFT/FFT/IFFT with PWM signals.
%
%   Create a PWM signal in frequency domain.
%   Apply low pass filters to the signal.
%   Compute the IFFT.
%   Compute the FFT.
%   Compare the orginal signal with the IFFT/FFT reconstruction.

%   Thomas Guillod.
%   2020-2021 - BSD License.

close('all');
addpath('fct');

%% parameters
n_time = 1e3; % number of time samples
n_freq = 50; % number of time frequencies

f = 50; % fundamental frequency of the PWM signal

duty = {}; % cell containing the PWM signal description
duty{end+1} = struct('d', 0.25, 'v', +5.0, 'dr', 0.05); % 1st transition / segment
duty{end+1} = struct('d', 0.50, 'v', -3.0, 'dr', 0.05); % 2nd transition / segment
duty{end+1} = struct('d', 0.75, 'v', -2.0, 'dr', 0.10); % 3rd transition / segment

fn_lp1 = 3e3; % corner frequency of the first-order low-pass applied to the signal
fn_lp2 = 3e3; % corner frequency of the second-order low-pass applied to the signal
ksi_lp2 = 0.6; % damping of the second-order low-pass applied to the signal

%% get time and frequency vector
t_vec = get_t_vec(f, n_time);
f_vec = get_f_vec(f, n_freq);

%% get PWM with DFT
sig_freq_dft = get_dft_pwm(duty, n_freq);

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
title('Time Domain')

subplot(2,1,2)
bar(f_vec, abs([sig_freq_dft ; sig_freq_fft].'))
xlabel('f [Hz]')
ylabel('sig [a.u.]')
legend('original DFT', 'IFFT/FFT reconstruction')
title('Frequency Domain')

end
