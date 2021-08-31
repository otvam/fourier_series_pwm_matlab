function sig_freq = get_lp1(sig_freq, f, fn, n_freq)
%GET_LP_1 Apply a first-order low-pass to a frequencz signal.
%   sig_freq - row frequency vectors  (row vector / double)
%   f - fundamental frequency of the PWM signal (scalar / double)
%   fn - corner frequency of the first-order low-pass applied to the signal (scalar / double)
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
%   2020 - BSD License.

% get the frequency vector
f_vec = get_f_vec(f, n_freq);

% get the filter transfer function
wn = 2.*pi.*fn;
s_vec = 1i.*2.*pi.*f_vec;
G = wn./(wn+s_vec);

% apply the filter
sig_freq = sig_freq.*G;

end