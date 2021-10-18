function sig_freq = get_dft_sin(n_harm, v_pk, phase, n_sig, n_freq)
%GET_DFT_PWM Get the Fourier series of sinusoidal signals.
%   n_harm - harmonic order of the signals (scalar / integer)
%   v_pk - peak value of the sinusoidal signals (vector / double)
%   phase - phase of the sinusoidal signal (vector / double)
%   n_sig - number of signals to be generated (scalar / integer)
%   n_freq - number of frequency (scalar / integer)
%   sig_freq - matrix with frequency domain signals  (matrix / double)
%
%   The signals are represented as a row vector or a matrix (of row vectors).
%   A DC signal corresponds to the zero order harmonic.
%   A fundamental frequency signal corresponds to the first order harmonic.
%
%   The function is meant to match the GET_FFT transformation.
%
%   See also GET_F_VEC, GET_T_VEC, GET_FFT, GET_IFFT.

%   Thomas Guillod.
%   2020-2021 - BSD License.

% check the signal data
assert(length(n_harm)==1, 'invalid harmonics')
assert(n_harm>=0, 'invalid harmonics')
assert(n_harm<=(n_freq-1), 'invalid harmonics')
assert(all(size(v_pk)==[n_sig 1]), 'invalid harmonics')
assert(all(size(phase)==[n_sig 1]), 'invalid harmonics')

% assign the DC or AC signals
sig_freq = zeros(n_sig, n_freq);
if n_harm==0
    sig_freq(:,n_harm+1) = v_pk;
else
    sig_freq(:,n_harm+1) = v_pk.*exp(1i.*phase);
end

end
