function sig_freq = get_lp2(sig_freq, f, fn, ksi, n_freq)
%GET_LP_1 Apply a second-order low-pass to a frequency signal.
%   sig_freq - matrix of row frequency vectors  (matrix / double)
%   f - fundamental frequency of the PWM signal (scalar / double)
%   fn - corner frequency of the second-order low-pass (scalar / double)
%   ksi - damping factor of the second-order low-pass (scalar / double)
%   n_freq - number of frequency (scalar / integer)
%   sig_freq - matrix of row frequency vectors  (matrix / double)
%
%   See also GET_LP_1.

%   Thomas Guillod.
%   2020-2021 - BSD License.
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