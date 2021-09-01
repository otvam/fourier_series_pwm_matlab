function sig_time = get_ifft(sig_freq, n_time)
%GET_IFFT Get the IFFT of a vector (or matrix of row vectors).
%   sig_freq - matrix of row frequency vectors  (matrix / double)
%   n_freq - number of frequency including DC component (scalar / integer / empty for default value)
%   sig_time - matrix of row time vectors  (matrix / double)
%
%   This code can make the IFFT of a row vector or a matrix (of row vectors).
%   Unlike the MATLAB IFFT function, the function:
%       - accept that the frequency vector are scaled (peak value) Fourier series coefficients
%       - accept that the frequency vector is ordered [DC, AC_1, AC_2, AC_3, ...]
%       - make over / under sampling if n_time is to large / small
%
%   The function was written as a convenient wrapper around the MATLAB IFFT function.
%   The function is meant to match the GET_FFT transformation.
%   The time domain signal is accepted to be real.
%   For using the default number of samples, n_time can be empty.
%
%   See also GET_F_VEC, GET_T_VEC, GET_FFT, GET_DFT_PWM.

%   Thomas Guillod.
%   2020-2021 - BSD License.

% scale the DC coefficient
sig_freq(:,1) = 2.*sig_freq(:,1);

% make the ifft and scale the signal
if isempty(n_time)
    sig_time = ifft(sig_freq, [], 2, 'symmetric').*(size(sig_freq, 2)./2);
else
    sig_time = ifft(sig_freq, n_time, 2, 'symmetric').*(n_time./2);
end

% delete small numerical errors (real signal)
sig_time = real(sig_time);

end