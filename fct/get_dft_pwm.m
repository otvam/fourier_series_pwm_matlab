function sig_freq = get_dft_pwm(d_pts, v_pts, dr_pts, n_pts, n_sig, n_freq)
%GET_DFT_PWM Get the Fourier series of a PWM signal with finite rise time.
%   d_pts - duty cycles where a switching transition is happening (matrix / double)
%   v_pts - values of the signal after the switching transitions (matrix / double)
%   dr_pts - durations of the switching transitions (matrix / double)
%   n_sig - number of signals to be generated (scalar / integer)
%   n_freq - number of frequency (scalar / integer)
%   sig_freq - matrix with frequency domain signals  (matrix / double)
%
%   The signals are represented as a row vector or a matrix (of row vectors).
%   For generating the signal, this function uses relative timing data (duty cycle).
%
%   This code compute the Fourier series of a PWM signal:
%       - arbitrary turn-on and turn-off times
%       - arbitrary turn-on and turn-off values
%       - finite rise time model (ramp model) or perfect transition
%       - generate the spectrum directly, no time domain signal is generated
%
%   The function is meant to match the GET_FFT transformation.
%   The rise time is used to obtain a continuous (C_1) signal.
%
%   See also GET_F_VEC, GET_T_VEC, GET_FFT, GET_IFFT.

%   Thomas Guillod.
%   2020-2021 - BSD License.

% check the signal data
assert(all(size(d_pts)==[n_sig n_pts]), 'invalid harmonics')
assert(all(size(v_pts)==[n_sig n_pts]), 'invalid harmonics')
assert(all(size(dr_pts)==[n_sig n_pts]), 'invalid harmonics')

% extend the signal (signal is periodic)
d_all_pts = [d_pts(:,1:end) d_pts(:,1)+1];
dr_all_pts = [dr_pts(:,1:end) dr_pts(:,1)];
v_all_pts = [v_pts(:,end) v_pts(:,1:end)];

% compute the switching instants (start and end)
d_sw_pts = [];
for i=1:n_pts
    d_1 = d_all_pts(:,i);
    d_2 = d_all_pts(:,i+1);
    dr_1 = dr_all_pts(:,i);
    dr_2 = dr_all_pts(:,i+1);

    d_sw_pts(:,end+1) = d_1+dr_1./2;
    d_sw_pts(:,end+1) = d_2-dr_2./2;
end

% check duty cycle data
assert(all(all(dr_pts>=0)), 'invalid duty cycle: transition')
assert(all(all(dr_pts<=1)), 'invalid duty cycle: transition')
assert(all(all(d_pts>=0)), 'invalid duty cycle: switching instant')
assert(all(all(d_pts<=1)), 'invalid duty cycle: switching instant')
assert(all(all(diff(d_sw_pts, 1, 2)>=0)), 'invalid duty cycle: signal sequence')

% init data
n_vec = get_f_vec(1, n_freq);
sig_freq = zeros(n_sig, n_freq);

% add the constant intervals
for i=1:n_pts
    d_1 = d_all_pts(:,i);
    d_2 = d_all_pts(:,i+1);
    dr_1 = dr_all_pts(:,i);
    dr_2 = dr_all_pts(:,i+1);
    v = v_pts(:,i);
    
    % get signal segment
    sig_tmp = coeff_cst(n_vec, d_1+dr_1./2, d_2-dr_2./2, v);
    
    % make superposition
    sig_freq = sig_freq+sig_tmp;
end

% add the transitions
for i=1:n_pts
    d = d_pts(:,i);
    dr = dr_pts(:,i);
    v_1 = v_all_pts(:,i);
    v_2 = v_all_pts(:,i+1);
    
    % get transition segment
    sig_tmp = coeff_ramp(n_vec, d, dr, v_1, v_2);
    
    % perfect transitions can be ignored
    idx_perfect = dr==0;
    sig_tmp(idx_perfect,:) = 0;
    
    % make superposition
    sig_freq = sig_freq+sig_tmp;
end

end

function sig_freq = coeff_cst(n_vec, d_1, d_2, v)
%COEFF_CST Get the Fourier coefficients for a constant interval.
%   n_vec - vector with  indices of the coefficient (vector / integer)
%   d_1 - start time of the interval (vector / double)
%   d_2 - start time of the interval (vector / double)
%   v - value of the interval (vector / double)
%   sig_freq - matrix with frequency domain signals  (matrix / double)
%
%   The expression used in this function was extracted with a symbolic calculus software.

% get the AC coefficients
num = 2.*((exp(-2.*pi.*1i.*n_vec.*d_1)-exp(-2.*pi.*1i.*n_vec.*d_2)));
den = 2.*pi.*1i.*n_vec;
sig_freq = num./den;

% get the DC coefficient
idx_dc = n_vec==0;
sig_freq(:,idx_dc) = d_2-d_1;

% scale the value
sig_freq = v.*sig_freq;

end

function sig_freq = coeff_ramp(n_vec, d, dr, v_1, v_2)
%COEFF_RAMP Get the Fourier coefficients for a transition interval.
%   n_vec - vector with  indices of the coefficient (vector / integer)
%   d - instant of the transition (vector / double)
%   dr - duration of the transition (vector / double)
%   v_1 - start value of the transition (vector / double)
%   v_2 - end value of the transition (vector / double)
%   sig_freq - matrix with frequency domain signals  (matrix / double)
%
%   The expression used in this function was extracted with a symbolic calculus software.

% get the AC coefficients
num_1 = 2.*(exp(-2.*pi.*1i.*n_vec.*(d-dr./2)).*(v_1-v_2-2.*pi.*1i.*n_vec.*dr.*v_1));
num_2 = 2.*(exp(-2.*pi.*1i.*n_vec.*(d+dr./2)).*(v_1-v_2-2.*pi.*1i.*n_vec.*dr.*v_2));
den = 4.*pi.^2.*n_vec.^2.*dr;
sig_freq = (num_1-num_2)./den;

% get the DC coefficient
idx_dc = n_vec==0;
sig_freq(:,idx_dc) = ((v_1+v_2)./2).*dr;

end
