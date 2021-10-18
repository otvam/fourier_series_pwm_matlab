function f_vec = get_f_vec(f, n_freq)
%GET_F_VEC Get the frequency vector (including DC component).
%   f - fundamental frequency (vector / double)
%   n_freq - number of frequency (scalar / integer)
%   f_vec - frequency vector (matrix / double)
%
%   The DC component is included.
%
%   See also GET_T_VEC, GET_FFT, GET_IFFT.

%   Thomas Guillod.
%   2020-2021 - BSD License.

n_vec = 0:(n_freq-1);
f_vec = f.*n_vec;

end