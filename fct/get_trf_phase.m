function sig_freq = get_trf_phase(sig_freq, phase, n_freq)
%GET_TRF_AC_PHASE Phase shifting of a frequency domain signal.
%   sig_freq - matrix of row frequency vectors  (matrix / double)
%   phase - phase shift (scalar / double)
%   n_freq - number of frequency (scalar / integer)
%   sig_freq - matrix of row frequency vectors  (matrix / double)
%
%   See also GET_TRF_AC_DELAY, GET_TRF_AC_COUPLING.

n_vec = get_f_vec(1, n_freq);
phase_vec = n_vec.*phase;
sig_freq = sig_freq.*exp(+1i.*phase_vec);

end