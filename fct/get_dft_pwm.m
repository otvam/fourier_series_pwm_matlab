function sig_freq = get_dft_pwm(duty, n_freq)
%GET_DFT_PWM Get the Fourier series on a PWM signal with finite rise time.
%   duty - description of the signal (cell of structs)
%       - duty{i}.d - duty cycle where a switching transition is happening
%       - duty{i}.dr - duration of the switching transition
%       - duty{i}.v - value of the signal after the switching transition
%   n_freq - number of frequency (scalar / integer)
%   sig_freq - row frequency vectors  (row vector / double)
%
%   For generating the signal, this function uses relative timing data (duty cycle).
%
%   This code compute the Fourier series of a PWM signal:
%       - arbitrary turn-on and turn-off times
%       - arbitrary turn-on and turn-off values
%       - finite rise time model (ramp model)
%       - generate the spectrum directly, no time domain signal is generated
%
%   The function is meant to match the GET_FFT transformation.
%   The rise time is used to obtain a continuous (C_1) signal.
%
%   See also GET_F_VEC, GET_T_VEC, GET_FFT, GET_IFFT.

%   Thomas Guillod.
%   2020-2021 - BSD License.

% extract the signal data
for i=1:length(duty)
    d_vec(i) = duty{i}.d;
    dr_vec(i) = duty{i}.dr;
    v_vec(i) = duty{i}.v;
end

% extend the signal (signal is periodic)
d_all_vec = [d_vec(1:end) d_vec(1)+1];
dr_all_vec = [dr_vec(1:end) dr_vec(1)];
v_all_vec = [v_vec(end) v_vec];

% compute the switching instants (start and end)
d_sw_vec = [];
for i=1:length(duty)
    d_1 = d_all_vec(i);
    d_2 = d_all_vec(i+1);
    dr_1 = dr_all_vec(i);
    dr_2 = dr_all_vec(i+1);

    d_sw_vec(end+1) = d_1+dr_1./2;
    d_sw_vec(end+1) = d_2-dr_2./2;
end

% check data
assert(all(dr_vec>=0), 'invalid duty cycle: transition')
assert(all(dr_vec<=1), 'invalid duty cycle: transition')
assert(all(d_vec>=0), 'invalid duty cycle: switching instant')
assert(all(d_vec<=1), 'invalid duty cycle: switching instant')
assert(all(diff(d_sw_vec)>=0), 'invalid duty cycle: signal sequence')

% init data
n_vec = (0:n_freq-1);
sig_freq = zeros(1, n_freq);

% add the constant intervals
for i=1:length(duty)
    d_1 = d_all_vec(i);
    d_2 = d_all_vec(i+1);
    dr_1 = dr_all_vec(i);
    dr_2 = dr_all_vec(i+1);
    v = v_vec(i);
    
    sig_tmp = coeff_cst(n_vec, d_1+dr_1./2, d_2-dr_2./2, v);
    sig_freq = sig_freq+sig_tmp;
end

% add the transitions
for i=1:length(duty)
    d = d_vec(i);
    dr = dr_vec(i);
    v_1 = v_all_vec(i);
    v_2 = v_all_vec(i+1);
    
    if dr==0
        sig_tmp = zeros(1, n_freq);
    else
        sig_tmp = coeff_ramp(n_vec, d, dr, v_1, v_2);
    end
    sig_freq = sig_freq+sig_tmp;
end

end

function vec = coeff_cst(n_vec, d_1, d_2, v)
%COEFF_CST Get the Fourier coefficients for a constant interval.
%   vec = COEFF_CST(f, n_vec, d_1, d_2, v)
%   f - fundamental frequency of the PWM signal (scalar / double)
%   n_vec - vector with  indices of the coefficient (row vector / integer)
%   d_1 - start time of the interval (scalar / double)
%   d_2 - start time of the interval (scalar / double)
%   v - value of the interval (scalar / double)
%   vec - row frequency vectors  (row vector / double)
%
%   The expression used in this function was extracted with a symbolic calculus software.

% get the AC coefficients
n_vec_ac = n_vec(2:end);
num = 2.*((exp(-2.*pi.*1i.*n_vec_ac.*d_1)-exp(-2.*pi.*1i.*n_vec_ac.*d_2)));
den = 2.*pi.*1i.*n_vec_ac;
vec_ac = num./den;

% get the DC coefficient
vec_dc = d_2-d_1;

% assemble and scale
vec = v.*[vec_dc vec_ac];

end

function vec = coeff_ramp(n_vec, d, dr, v_1, v_2)
%COEFF_RAMP Get the Fourier coefficients for a transition interval.
%   vec = COEFF_RAMP(f, n_vec, t, tr, v_1, v_2)
%   f - fundamental frequency of the PWM signal (scalar / double)
%   n_vec - vector with  indices of the coefficient (row vector / integer)
%   t - time of the transition (scalar / double)
%   tr - duration of the transition (scalar / double)
%   v_1 - start value of the transition (scalar / double)
%   v_2 - end value of the transition (scalar / double)
%   vec - row frequency vectors  (row vector / double)
%
%   The expression used in this function was extracted with a symbolic calculus software.

% get the AC coefficients
n_vec_ac = n_vec(2:end);
num_1 = 2.*(exp(-2.*pi.*1i.*n_vec_ac.*(d-dr./2)).*(v_1-v_2-2.*pi.*1i.*n_vec_ac.*dr.*v_1));
num_2 = 2.*(exp(-2.*pi.*1i.*n_vec_ac.*(d+dr./2)).*(v_1-v_2-2.*pi.*1i.*n_vec_ac.*dr.*v_2));
den = 4.*pi.^2.*n_vec_ac.^2.*dr;
vec_ac = (num_1-num_2)./den;

% get the DC coefficient
vec_dc = ((v_1+v_2)./2).*dr;

% assemble
vec = [vec_dc vec_ac];

end
