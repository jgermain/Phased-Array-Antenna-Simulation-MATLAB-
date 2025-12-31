% Phased Array Antenna Simulation (Uniform Linear Array)
% -----------------------------------------------------
% This script simulates the radiation pattern of a uniform linear
% phased array antenna using the analytical array factor formulation.
%
% Features:
%   - Electronic beam steering
%   - HPBW, FNBW, and Sidelobe Level computation
%   - Optional normalization and dB plotting
%   - Annotated radiation pattern visualization
%   - Export of performance metrics for analysis
%
% Author: Josiah Germain


% Housekeeping
% --------------------------
close all; clear; clc;


% User Plot Options
% --------------------------
useNormalization = true;    % true = normalize AF for plotting
useDecibelPlot  = true;    % true = plot in dB (requires normalization)


% Defining Parameters
% --------------------------
lambda = 0.3;                  % Wavelength [m]
K = 2*pi/lambda;               % Wavenumber
d = lambda/2;                  % Element spacing
N = 16;                         % Number of elements


% Beam Steering
% --------------------------
theta_degrees = 0;                    % Steering angle [deg]
theta_0 = deg2rad(theta_degrees);      % Convert to radians
B = -K*d*sin(theta_0);


% Angular Sweep
% --------------------------
theta_max = pi/2;
numPoints = 1000;
theta = linspace(-theta_max, theta_max, numPoints);


% Array Factor Calculation
% --------------------------
ArrayFactor = zeros(size(theta));

for n = 0:N-1
    ArrayFactor = ArrayFactor + exp(1i * n * (K*d*sin(theta) + B));
end

AF_mag = abs(ArrayFactor);
AF_peak = max(AF_mag);


% Beamwidth Metrics
% --------------------------

% First-Null Beamwidth (theoretical)
FNBW = 2 * asind(lambda/(N*d));

% Half-Power Beamwidth
[~, Index_Max] = max(AF_mag);

Index_Left = Index_Max;
while Index_Left > 1 && AF_mag(Index_Left) >= 0.707 * AF_peak
    Index_Left = Index_Left - 1;
end

Index_Right = Index_Max;
while Index_Right < length(AF_mag) && AF_mag(Index_Right) >= 0.707 * AF_peak
    Index_Right = Index_Right + 1;
end

HPBW = rad2deg(theta(Index_Right) - theta(Index_Left));


% Sidelobe Level (SLL)
% --------------------------

% Find first nulls to isolate sidelobes
i_left = Index_Max;
while i_left > 1 && AF_mag(i_left) >= AF_mag(i_left-1)
    i_left = i_left - 1;
end

i_right = Index_Max;
while i_right < length(AF_mag) && AF_mag(i_right) >= AF_mag(i_right+1)
    i_right = i_right + 1;
end

Left_Lobes  = AF_mag(1:i_left-1);
Right_Lobes = AF_mag(i_right+1:end);

Max_Sidelobe = max([Left_Lobes, Right_Lobes]);
SLL = Max_Sidelobe / AF_peak;
SLL_dB = 20*log10(SLL);


% Prepare Data for Plotting
% --------------------------
if useNormalization
    AF_plot = AF_mag / AF_peak;
else
    AF_plot = AF_mag;
end

theta_deg = rad2deg(theta);


% Plot Radiation Pattern
% --------------------------
figure; hold on; grid on;

if useDecibelPlot
    plot(theta_deg, 20*log10(AF_plot), 'LineWidth', 1.5);
    ylabel('Array Factor (dB)');
    yline(-3,'--','-3 dB');
else
    plot(theta_deg, AF_plot, 'LineWidth', 1.5);
    ylabel('Array Factor Magnitude');
    yline(0.707 * (useNormalization + ~useNormalization*AF_peak), ...
          '--','-3 dB Level');
end

xlabel('Angle (degrees)');
title('Phased Array Radiation Pattern');

% HPBW markers
xline(rad2deg(theta(Index_Left)),'--');
xline(rad2deg(theta(Index_Right)),'--');

% Annotation
txt = {
    sprintf('N = %d', N)
    sprintf('d = %.2f \\lambda', d/lambda)
    sprintf('HPBW = %.2f°', HPBW)
    sprintf('FNBW = %.2f°', FNBW)
    sprintf('SLL = %.2f dB', SLL_dB)
};

text(0.02, 0.95, txt, ...
    'Units','normalized', ...
    'VerticalAlignment','top', ...
    'BackgroundColor','w', ...
    'EdgeColor','k');

hold off;


% Results Table
% --------------------------
ResultsTable = table( ...
    N, d/lambda, HPBW, FNBW, SLL_dB, ...
    'VariableNames', {'N','d_over_lambda','HPBW_deg','FNBW_deg','SLL_dB'});

disp(ResultsTable);
writetable(ResultsTable,'phased_array_metrics.csv');
