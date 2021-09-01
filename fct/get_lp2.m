function sig_freq = get_lp2(sig_freq, f, fn, ksi, n_freq)
%GET_DFT_PWM Get the Fourier series on a PWM signal with finite rise time.
%   sig_freq = GET_DFT_PWM(f, d_on, d_off, v_on, v_off, tr, fn, n_freq)
%   f - fundamental frequency of the PWM signal (scalar / double)
%   d_on - duty cycle of the PWM signal turn-on (scalar / double)
%   d_off - duty cycle of the PWM signal turn- (scalar / double)
%   v_on - PWM signal on-value (scalar / double)
%   v_off - PWM signal off-value (scalar / double)
%   tr - transition time of the PWM signal (scalar / double / empty for not applied)
%   fn - corner frequency of the first-order low-pass applied to the signal (scalar / double / empty for not applied)
%   n_freq - number of frequency including DC component (scalar / integer)
%   sig_freq - row frequency vectors  (row vector / double)
%
%   This code compute the Fourier series of a PWM signal:
%       - arbitrary turn-on and turn-off times
%       - arbitrary turn-on and turn-off values
%       - finite rise time model (ramp model) if required
%       - apply a first-order low pass to the resulting signal if required
%       - generate the spectrum directly, no time domain signal is generated
%
%   The function is meant to match the GET_FFT transformation.
%   The rise time (tr) is used to obtain a continuous (C_1) signal.
%   The low-pass (fn) is used to obtain a differentiable (C_2) signal.
%   For obtaining a perfect PWM signal, tr and fn can be empty (perfect transitions).
%   The functions can be combined to generate the signals of most power electronic concerters.
%
%   See also GET_F_VEC, GET_T_VEC, GET_FFT, GET_IFFT.

%   Thomas Guillod.
%   2020-2021 - BSD License.

% get the frequency vector
f_vec = get_f_vec(f, n_freq);

% get the filter transfer function
wn = 2.*pi.*fn;
s_vec = 1i.*2.*pi.*f_vec;
G = 1./(1+2.*ksi.*s_vec./wn+(s_vec.^2)./(wn.^2));

% apply the filter
sig_freq = sig_freq.*G;

end