function sig_freq = get_filter_lp1(sig_freq, f, fn, n_freq)
%GET_FILTER_LP_1 Apply a first-order low-pass to a frequency signal.
%   sig_freq - matrix of row frequency vectors  (matrix / double)
%   f - fundamental frequency of the PWM signal (scalar / double)
%   fn - corner frequency of the first-order low-pass (scalar / double)
%   n_freq - number of frequency (scalar / integer)
%   sig_freq - matrix of row frequency vectors  (matrix / double)
%
%   The function can be used in order to avoid Gibbs phenomenon with
%   discontinuous signal (ensuring continuity);
%
%   See also GET_FILTER_LP_2.

%   Thomas Guillod.
%   2020-2021 - BSD License.

% get the frequency vector
f_vec = get_f_vec(f, n_freq);

% get the filter transfer function
wn = 2.*pi.*fn;
s_vec = 1i.*2.*pi.*f_vec;
G = wn./(wn+s_vec);

% apply the filter
sig_freq = sig_freq.*G;

end