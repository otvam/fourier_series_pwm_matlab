function t_vec = get_t_vec(f, n_time)
%GET_T_VEC Get the time vector of a fundamental period.
%   t_vec = GET_T_VEC(f, n)
%   f - fundamental frequency (scalar / double)
%   n_time - number of time samples (scalar / integer)
%   t_vec - time vector (row vector / double)
%
%   Note: The last time point (1/f) is not included is the vector.
%         Including this point would lead to aliasing for the FFT.
%
%   See also GET_F_VEC, GET_FFT, GET_IFFT.

%   Thomas Guillod.
%   2020-2021 - BSD License.

d_vec = (0:(n_time-1))./n_time;
t_vec = (1./f).*d_vec;

end