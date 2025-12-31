% =========================
%  Phased Array Simulation
% =========================

% Housekeeping
close all; clear all; clc;


% Defining parameters
lambda = 0.3;                  % lambda = c/f [m]
K = (2*pi)/lambda;             % Wavenumber
d = lambda/2;                  % Spaceing between elements. Change to see grating lobes
N = 8;                        % Number of elements. Change to see beamwidth change

% Beamsteering
theta_degrees = 30;                      % Angle in degrees. Change to see beamforming
theta_0 = theta_degrees * (pi/180);     % Converts angle to radians
B = -K*d*sin(theta_0);

% Creating array of angles to sweep magnitude spacially
theta_radians = 90 * (pi/180);           % Angles you want to sweep converted to radians
theta = linspace(-theta_radians, theta_radians, 1000);

% Initializing the array factor to the same size as theta
ArrayFactor = zeros(size(theta));

% Creating for loop to sum all contributions from each element
for n = 0:N-1

    ArrayFactor = ArrayFactor + exp(1i * n * (K * d * sin(theta) + B));

end

% Calculate the magnitude of the array factor
ArrayFactorMagnitude = abs(ArrayFactor);

% Calculating the First-Null Bandwidth (FNBW) in degrees and displaying
FNBW = 2 * asind(lambda/(N*d));

% Calculating Half-Power Bandwidth (HPBW) in degrees
[AF_Max,Index_Max] = max(ArrayFactorMagnitude);                       % Gives Max value and where it occured

    % Left bound
Index_Left = Index_Max;
while (ArrayFactorMagnitude(Index_Left) >= (0.707 * ArrayFactorMagnitude(Index_Max))) && (Index_Left > 1)
    Index_Left = Index_Left - 1;
end

    % Right bound
Index_Right = Index_Max;
while (ArrayFactorMagnitude(Index_Right) >= (0.707 * ArrayFactorMagnitude(Index_Max))) && (Index_Right < length(ArrayFactorMagnitude))
    Index_Right = Index_Right + 1;
end

HPBW = rad2deg(theta(Index_Right) - theta(Index_Left));

% Calculating Sidelobe Level (SLL)

    % Finding left and right index of first nulls to isolate sidelobes
i_left = Index_Max;
while i_left > 1 && ArrayFactorMagnitude(i_left) >= ArrayFactorMagnitude(i_left-1)
    i_left = i_left - 1;
end

i_right = Index_Max;
while i_right < length(ArrayFactorMagnitude) && ArrayFactorMagnitude(i_right) >= ArrayFactorMagnitude(i_right+1)
    i_right = i_right + 1;
end

Left_Lobes = ArrayFactorMagnitude(1:i_left - 1);
Right_Lobes = ArrayFactorMagnitude(i_right + 1:end);

Max_Sidelobe = max(max(Left_Lobes),max(Right_Lobes));
SLL = Max_Sidelobe / AF_Max;
SLL_dB = 20*log10(SLL);


% Plotting the array factor magnitude against the angles
theta_deg = rad2deg(theta);
figure;
plot(theta_deg, ArrayFactorMagnitude);
xlabel('Angle (degrees)');
ylabel('Array Factor Magnitude');
title('Phased Array Pattern');
grid on;

% Annotating plot
txt = {
    sprintf('N = %d', N)
    sprintf('d = %.2f \\lambda', d/lambda)
    sprintf('HPBW = %.2f°', HPBW)
    sprintf('FNBW = %.2f°', FNBW)
    sprintf('SLL = %.2f dB', 20*log10(SLL))
};

text(0.02, 0.95, txt, ...
    'Units','normalized', ...
    'VerticalAlignment','top', ...
    'BackgroundColor','w', ...
    'EdgeColor','k');

% Visual for HPBW
hold on
yline(0.707*AF_Max,'--','-3 dB Level');
xline(rad2deg(theta(Index_Left)),'--');
xline(rad2deg(theta(Index_Right)),'--');
hold off

% Creating table for data
ResultsTable = table( ...
    N, d/lambda, HPBW, FNBW, 20*log10(SLL), ...
    'VariableNames', {'N','d_over_lambda','HPBW_deg','FNBW_deg','SLL_dB'});

% Displaying and saving results
display(ResultsTable);
writetable(ResultsTable,'phased_array_metrics.csv')