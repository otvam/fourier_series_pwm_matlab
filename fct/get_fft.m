function sig_freq = get_fft(sig_time, n_freq)
%GET_FFT Get the FFT of a real vector (or matrix of row vectors).
%   sig_time - matrix of row time vectors  (matrix / double)
%   n_freq - number of frequency (scalar / integer / empty for default value)
%   sig_freq - matrix of row frequency vectors  (matrix / double)
%
%   This code can make the FFT of a row vector or a matrix (of row vectors).
%   Unlike the MATLAB FFT function, the function:
%       - scale the components as (peak value) Fourier series coefficients
%       - order the components as [DC, AC_1, AC_2, AC_3, ...]
%       - make truncation / zero padding if n_freq is to small / large
%
%   The function was written as a convenient wrapper around the MATLAB FFT function.
%   The function is meant to match the GET_IFFT inverse transformation.
%   The time domain signal is accepted to be real.
%   For using the default number of frequency, n_freq can be empty.
%
%   See also GET_F_VEC, GET_T_VEC, GET_IFFT.

%   Thomas Guillod.
%   2020-2021 - BSD License.

% get the FFT with the MATLAB function
sig_freq = fft(sig_time, [], 2);

% peak value spectrum and scaling
sig_freq = 2.*sig_freq./size(sig_time, 2);

% select the positive coefficient (the signal is assumed to be real) 
sig_freq = sig_freq(:, 1:ceil(size(sig_freq, 2)./2));

% scale the DC coefficient
sig_freq(:,1) = 0.5*sig_freq(:,1);

% if the required size is specified, truncate or zero pad
if (~isempty(n_freq))
    if size(sig_freq,2)>=n_freq
        sig_freq = sig_freq(:, 1:n_freq);
    else
        sig_freq = [sig_freq zeros(size(sig_freq, 1), n_freq-size(sig_freq, 2))];
    end
end

end