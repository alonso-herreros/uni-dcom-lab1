---
title: Lab 1 Report
---

<style>
:root {
    --markdown-font-family: "Times New Roman", Times, serif;
    --markdown-font-size: 10.5pt;
}
</style>

<p class="supt1 center">Communication Theory</p>

# Lab 1 Report

<p class="subt2 center">
Academic year 2024-2025
</p>
<p class="subt2 center">
Alonso Herreros Copete
</p>

---

### Table of Contents

* [1. Signal-to-Noise ratio](#1-signal-to-noise-ratio)
* [2. Inter-symbol interference](#2-inter-symbol-interference)
* [3. Noise and BER](#3-noise-and-ber)

---

## 1. Signal-to-Noise ratio

As instructed, the dispersion diagram for the 16-QAM signal was created for
different SNRs, including the corresponding values of $N_0$. The results can be
found in the following figures.

![alt](./figures/1.1.0-A.png)
<p class="caption">
Figure 1.1.0: Original 16-QAM signal.
</p>

![alt](./figures/1.1.1-snr20.png)
<p class="caption">
Figure 1.1.1: q[n] observed at SNR = 20 dB.
</p>

![alt](./figures/1.1.2-snr15.png)
<p class="caption">
Figure 1.1.1: q[n] observed at SNR = 15 dB.
</p>

![alt](./figures/1.1.3-snr10.png)
<p class="caption">
Figure 1.1.1: q[n] observed at SNR = 10 dB.
</p>

![alt](./figures/1.1.4-snr5.png)
<p class="caption">
Figure 1.1.1: q[n] observed at SNR = 5 dB.
</p>

As we can observe in the figures, as the SNR decreases, the signal becomes very
hard to interpret.

## 2. Inter-symbol interference

The dispersion diagrams requested were all created and can be found below. In
these experiments, sine the SNR is very high (40 dB), the received sequences
still look like they could be interpreted for the most part, except for the
cases with $a = \frac{1}{4}$ and a 16-QAM signal.

The results are displayed in the following table, where the first two rows
correspond to the experiment with the first discrete channel ($p[n] = δ[n] +
aδ[n-1]$) and the last two rows correspond to the experiment with the second
discrete channel ($p[n] = δ[n] + aδ[n-1] + \frac{a}{a} δ[n-2]$). The first and
third rows use 4-QAM modulation, while the second and fourth rows use 16-QAM
modulation.

| Original A[n] | q[n] with $a = \frac{1}{16}$ | q[n] with $a = \frac{1}{8}$ | q[n] with $a = \frac{1}{4}$ |
|---------------|-------------------------------|-----------------------------|-----------------------------|
| ![alt](./figures/2.1.1.0-A.png) | ![alt](./figures/2.1.1.1-a-1-16th.png) | ![alt](./figures/2.1.1.2-a-1-8th.png) | ![alt](./figures/2.1.1.3-a-1-4th.png) |
| ![alt](./figures/2.1.2.0-A.png) | ![alt](./figures/2.1.2.1-a-1-16th.png) | ![alt](./figures/2.1.2.2-a-1-8th.png) | ![alt](./figures/2.1.2.3-a-1-4th.png) |
| ![alt](./figures/2.2.1.0-A.png) | ![alt](./figures/2.2.1.1-a-1-16th.png) | ![alt](./figures/2.2.1.2-a-1-8th.png) | ![alt](./figures/2.2.1.3-a-1-4th.png) |
| ![alt](./figures/2.2.2.0-A.png) | ![alt](./figures/2.2.2.1-a-1-16th.png) | ![alt](./figures/2.2.2.2-a-1-8th.png) | ![alt](./figures/2.2.2.3-a-1-4th.png) |

## 3. Noise and BER
