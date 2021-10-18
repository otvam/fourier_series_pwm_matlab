function sig_freq = get_trf_ac_coupling(sig_freq)
%GET_TRF_AC_COUPLING Remove the DC component of frequency domain signals.
%   sig_freq - matrix with frequency domain signals  (matrix / double)
%
%   See also GET_TRF_PHASE, GET_TRF_DELAY.

%   Thomas Guillod.
%   2020-2021 - BSD License.

sig_freq(:,1) = 0;

end