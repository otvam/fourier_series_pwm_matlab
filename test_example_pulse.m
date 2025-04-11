function test_example_pulse()
%TEST_EXAMPLE_PULSE Example for a pulse transmission through a transformer.
%
%   Create PWM voltage pulse in frequency domain.
%   Apply the voltage pulse to the transfomer.
%   Compute the IFFT.
%   Plot the signals.

%   Thomas Guillod.
%   2020-2021 - BSD License.

close('all');
addpath('fct');

%% discretization of the time and frequency domains
f = 1e3; % fundamental frequency of the PWM signal
n_time = 10e3; % number of time samples
n_freq = 2e3; % number of time frequencies

t_vec = get_t_vec(f, n_time);
f_vec = get_f_vec(f, n_freq);

%% compute the voltage pulse in frequency domain
n_sig = 1; % number of signals
n_pts = 4; % number of pwm points

d_pts = [0.40 0.45 0.55 0.60]; % duty cycle matrix
v_pts = [+100.0 +0.0 -100.0 +0.0]; % signal value vector
dr_pts = [0.001 0.001 0.001 0.001]; % rise time vector

V_in_freq = get_dft_pwm(d_pts, v_pts, dr_pts, n_pts, n_sig, n_freq);

%% apply low-pass filters to the voltage pulse
fn_lp1 = 1e6; % corner frequency of the first-order low-pass applied to the signal
fn_lp2 = 5e5; % corner frequency of the second-order low-pass applied to the signal
ksi_lp2 = 0.6; % damping of the second-order low-pass applied to the signal

V_in_freq = get_filter_lp1(V_in_freq, f, fn_lp1, n_freq);
V_in_freq = get_filter_lp2(V_in_freq, f, fn_lp2, ksi_lp2, n_freq);

%% compute the transformer currents and voltages
L_leak = 3e-6; % leakage inductance of the transformer (primary side)
R_leak = 20e-3; % series resistance of the transformer (primary side)
L_mag = 2e-3; % magnetizing inductance of the transformer (primary side)
R_mag = 2e-3; % parallel resistance of the transformer (primary side)
C_res = 150e-9; % parallel capacitance of the transformer (primary side)
n_trf = 3.0; % voltage transfer ratio of the transformer (primary to secondary)
R_load = 50.0; % load resistance connected to the transformer (secondary side)

s_vec = 1i.*2.*pi.*f_vec;
Y_res = s_vec.*C_res;
Y_trf = (n_trf.^2)./R_load;
Z_leak = R_leak+s_vec.*L_leak;
Y_mag = 1./(R_mag+s_vec.*L_mag);
Z_par = 1./(Y_res+Y_trf+Y_mag);
Z_tot = Z_leak+Z_par;

I_in_freq = V_in_freq./Z_tot;
V_out_freq = V_in_freq.*Z_par./Z_tot;
I_out_freq = V_out_freq.*Y_trf;

V_out_freq = V_out_freq.*n_trf;
I_out_freq = I_out_freq./n_trf;

%% compute the inverse Fourier transforms
V_in_time = get_ifft(V_in_freq, n_time);
I_in_time = get_ifft(I_in_freq, n_time);
V_out_time = get_ifft(V_out_freq, n_time);
I_out_time = get_ifft(I_out_freq, n_time);

%% plot the results
figure()

subplot(2,2,1)
plot(1e6.*t_vec, V_in_time)
xlabel('t [us]')
ylabel('V [V]')
title('Input Voltage')

subplot(2,2,2)
plot(1e6.*t_vec, V_out_time)
xlabel('t [us]')
ylabel('V [V]')
title('Output Voltage')

subplot(2,2,3)
plot(1e6.*t_vec, I_in_time)
xlabel('t [us]')
ylabel('I [A]')
title('Input Current')

subplot(2,2,4)
plot(1e6.*t_vec, I_out_time)
xlabel('t [us]')
ylabel('I [A]')
title('Output Current')

end
