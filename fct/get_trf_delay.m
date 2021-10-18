function sig_freq = get_trf_delay(sig_freq, f, t_delay, n_freq)
%GET_TRF_AC_DELAY Add a time delay to frequency domain signals.
%   sig_freq - matrix with frequency domain signals  (matrix / double)
%   f - fundamental frequency (vector / double)
%   t_delay - time delay (vector / double)
%   n_freq - number of frequency (scalar / integer)
%   sig_freq - matrix with frequency domain signals  (matrix / double)
%
%   See also GET_TRF_PHASE, GET_TRF_AC_COUPLING.

%   Thomas Guillod.
%   2020-2021 - BSD License.

f_vec = get_f_vec(f, n_freq);
phase_vec = 2.*pi.*f_vec.*t_delay;
sig_freq = sig_freq.*exp(-1i.*phase_vec);

end
