# MATLAB Code for Fourier Series Handling (with FFT)

![license - BSD](https://img.shields.io/badge/license-BSD-green)
![language - MATLAB](https://img.shields.io/badge/language-MATLAB-blue)
![category - science](https://img.shields.io/badge/category-science-lightgrey)
![status - unmaintained](https://img.shields.io/badge/status-unmaintained-red)

The **MATLAB FFT/IFFT** functions are good but not so easy to use for real periodic signal:
* the ordering of the frequency vector is confusing due to the negative frequencies (spectrums are symmetric)
* the coefficients are not scaled as in a Fourier series due to the definition of the DFT

The provided **MATLAB** functions offer different functionalities around **Fourier series**:
* get time and frequency vector
* wrappers around the MATLAB **FFT/IFFT** functions that scale periodic signals as Fourier series coefficients
* many signals can be processed at the same time (matrices)

The following functions are offered for signal generation:
* generate spectrum of arbitrary **PWM periodic signals** directly in the frequency domain
* generate PWM signals with a **finite/infinite slew rate**
* generate **DC and AC sinusoidal signals**

Additionally, several transformations can be applied to frequency domain signals: 
* apply low-pass filters (e.g., first-order, second-order)
* apply simple transformations (eg., delay, phase shift, AC coupling)

## Examples

<p float="middle">
    <img src="readme_img/example_sin.png" width="250">
    <img src="readme_img/example_pwm.png" width="250">
    <img src="readme_img/example_transform.png" width="250">
</p>

## Compatibility

* Tested with MATLAB R2018b and R2021b.
* No toolboxes are required.
* Compatibility with GNU Octave not tested but probably easy to achieve.

## Author

**Thomas Guillod** - [GitHub Profile](https://github.com/otvam)

## License

This project is licensed under the **BSD License**, see [LICENSE.md](LICENSE.md).
