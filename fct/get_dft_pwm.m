function sig_freq = get_dft_pwm(f, d_on, d_off, v_on, v_off, tr, fn, n_freq)
%GET_DFT_PWM Get the Fourier series on a PWM signal with finite rise time.
%   sig_freq = GET_DFT_PWM(f, d_on, d_off, v_on, v_off, tr, fn, n_freq)
%   f - fundamental frequency of the PWM signal (scalar / double)
%   d_on - duty cycle of the PWM signal turn-on (scalar / double)
%   d_off - duty cycle of the PWM signal turn- (scalar / double)
%   v_on - PWM signal on-value (scalar / double)
%   v_off - PWM signal off-value (scalar / double)
%   tr - transition time of the PWM signal (scalar / double / empty for not applied)
%   fn - corner frequency of the first-order low-pass applied to the signal (scalar / double / empty for not applied)
%   n_freq - number of frequency including DC component (scalar / integer)
%   sig_freq - row frequency vectors  (row vector / double)
%
%   This code compute the Fourier series of a PWM signal:
%       - arbitrary turn-on and turn-off times
%       - arbitrary turn-on and turn-off values
%       - finite rise time model (ramp model) if required
%       - apply a first-order low pass to the resulting signal if required
%       - generate the spectrum directly, no time domain signal is generated
%
%   The function is meant to match the GET_FFT transformation.
%   The rise time (tr) is used to obtain a continuous (C_1) signal.
%   The low-pass (fn) is used to obtain a differentiable (C_2) signal.
%   For obtaining a perfect PWM signal, tr and fn can be empty (perfect transitions).
%   The functions can be combined to generate the signals of most power electronic concerters.
%
%   See also GET_F_VEC, GET_T_VEC, GET_FFT, GET_IFFT.

%   Thomas Guillod.
%   2020 - BSD License.

% the the Fourier coefficient
sig_freq = get_dft_pwm_sub(f ,d_on, d_off, v_on, v_off, tr, n_freq);

% if required, apply a first-order low pass filter
if (~isempty(fn))
    f_vec = get_f_vec(f, n_freq);
    G = fn./(fn+1i.*f_vec);
    sig_freq = sig_freq.*G;
end

end

function sig_freq = get_dft_pwm_sub(f, d_on, d_off, v_on, v_off, tr, n_freq)
%GET_DFT_PWM_SUB Get the Fourier series on a PWM signal.
%   sig_freq = GET_DFT_PWM(f, d_on, d_off, v_on, v_off, tr, fn, n_freq)
%   f - fundamental frequency of the PWM signal (scalar / double)
%   d_on - duty cycle of the PWM signal turn-on (scalar / double)
%   d_off - duty cycle of the PWM signal turn- (scalar / double)
%   v_on - PWM signal on-value (scalar / double)
%   v_off - PWM signal off-value (scalar / double)
%   tr - transition time of the PWM signal (scalar / double / empty for not applied)
%   n_freq - number of frequency including DC component (scalar / integer)
%   sig_freq - row frequency vectors  (row vector / double)

% check that the signal is feasible
assert(d_on<d_off,'root_error','invalid data')
assert((d_on>=0)&&(d_on<=1),'root_error','invalid data')
assert((d_off>=0)&&(d_off<=1),'root_error','invalid data')

% the the indices of the coefficient
n_vec = (0:n_freq-1);

% get the switching instants
t_on = d_on./f;
t_off = d_off./f;

% get the signal with perfect transition or finite rise time
if isempty(tr)
    % perfect signal has two intervals
    vec_on = coeff_cst(f,n_vec,t_on,t_off,v_on);
    vec_off = coeff_cst(f,n_vec,t_off,t_on+1./f,v_off);
    
    % assemble the intervals
    sig_freq = vec_on+vec_off;
else
    % check that the signal is feasible
    d_transition = tr.*f;
    assert((d_off-d_on)>=d_transition,'root_error','invalid data')
    assert((d_on-(d_off-1))>=d_transition,'root_error','invalid data')
    
    % signal with finite rise time has four intervals
    vec_on = coeff_cst(f,n_vec,t_on+tr./2,t_off-tr./2,v_on);
    vec_off = coeff_cst(f,n_vec,t_off+tr./2,t_on+1./f-tr./2,v_off);
    vec_off_on = coeff_ramp(f,n_vec,t_on,tr,v_off,v_on);
    vec_on_off = coeff_ramp(f,n_vec,t_off,tr,v_on,v_off);
    
    % assemble the intervals
    sig_freq = vec_on+vec_off+vec_on_off+vec_off_on;
end

end

function vec = coeff_cst(f, n_vec, t_1, t_2, v)
%COEFF_CST Get the Fourier coefficients for a constant interval.
%   vec = COEFF_CST(f, n_vec, t_1, t_2, v)
%   f - fundamental frequency of the PWM signal (scalar / double)
%   n_vec - vector with  indices of the coefficient (row vector / integer)
%   t_1 - start time of the interval (scalar / double)
%   t_2 - start time of the interval (scalar / double)
%   v - value of the interval (scalar / double)
%   vec - row frequency vectors  (row vector / double)
%
%   The expression used in this function was extracted with a symbolic calculus software.

% get the AC coefficients
n_vec_ac = n_vec(2:end);
num = 2.*((exp(-2.*pi.*1i.*f.*n_vec_ac.*t_1)-exp(-2.*pi.*1i.*f.*n_vec_ac.*t_2)));
den = 2.*pi.*1i.*n_vec_ac;
vec_ac = num./den;

% get the DC coefficient
vec_dc = ((t_2-t_1)).*f;

% assemble and scale
vec = v.*[vec_dc vec_ac];

end

function vec = coeff_ramp(f, n_vec, t, tr, v_1, v_2)
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
num_1 = 2.*(exp(-2.*pi.*1i.*f.*n_vec_ac.*(t-tr./2)).*(v_1-v_2-2.*pi.*1i.*f.*n_vec_ac.*tr.*v_1));
num_2 = 2.*(exp(-2.*pi.*1i.*f.*n_vec_ac.*(t+tr./2)).*(v_1-v_2-2.*pi.*1i.*f.*n_vec_ac.*tr.*v_2));
den = 4.*pi.^2.*n_vec_ac.^2.*f.*tr;
vec_ac = (num_1-num_2)./den;

% get the DC coefficient
vec_dc = ((v_1+v_2)./2).*tr.*f;

% assemble
vec = [vec_dc vec_ac];

end
