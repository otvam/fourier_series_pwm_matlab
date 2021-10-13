function sig_freq = get_dft_sin(n_harm, v_pk, phase, n_freq)
%GET_DFT_PWM Get the Fourier series of sinusoidal signal.
%GET_DFT_PWM Get the Fourier series of a PWM signal with finite rise time.
%   n_harm - harmonic order of the signal (scalar / double)
%   v_pk - peak value of the sinusoidal signal (scalar / double)
%   phase - phase of the sinusoidal signal (scalar / integer)
%   sig_freq - row frequency vectors  (row vector / double)
%
%   A DC signal corresponds to the zero order harmonic.
%   A fundamental frequency signal corresponds to the first order harmonic.
%
%   The function is meant to match the GET_FFT transformation.
%
%   See also GET_F_VEC, GET_T_VEC, GET_FFT, GET_IFFT.

%   Thomas Guillod.
%   2020-2021 - BSD License.

% check the harmonic order
assert(n_harm>=0, 'invalid harmonics')
assert(n_harm<=(n_freq-1), 'invalid harmonics')

% assign the DC or AC signal
sig_freq = zeros(1, n_freq);
if n_harm==0
    sig_freq(n_harm+1) = v_pk;
else
    sig_freq(n_harm+1) = v_pk.*exp(1i.*phase);
end

end
