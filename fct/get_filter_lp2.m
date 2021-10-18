function sig_freq = get_filter_lp2(sig_freq, f, fn, ksi, n_freq)
%GET_FILTER_LP_2 Apply a second-order low-pass to frequency signals.
%   sig_freq - matrix with frequency domain signals  (matrix / double)
%   f - fundamental frequency of the PWM signal (vector / double)
%   fn - corner frequency of the second-order low-pass (vector / double)
%   ksi - damping factor of the second-order low-pass (vector / double)
%   n_freq - number of frequency (scalar / integer)
%   sig_freq - matrix with frequency domain signals  (matrix / double)
%
%   The function can be used in order to avoid Gibbs phenomenon with
%   discontinuous signal (ensuring continuity);
%
%   See also GET_FILTER_LP_1.

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