function f_vec = get_f_vec(f, n_freq)
%GET_F_VEC Get the frequency vector (including DC component).
%   f_vec = GET_F_VEC(f, n)
%   f - fundamental frequency (scalar / double)
%   n_freq - number of frequency including DC component (scalar / integer)
%   f_vec - frequency vector (row vector / double)
%
%   See also GET_T_VEC, GET_FFT, GET_IFFT, GET_DFT_PWM.

%   Thomas Guillod.
%   2020 - BSD License.

n_vec = 0:(n_freq-1);
f_vec = f.*n_vec;

end