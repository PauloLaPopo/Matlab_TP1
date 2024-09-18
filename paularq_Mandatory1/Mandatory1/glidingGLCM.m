function [IDM, INR, SHD] = glidingGLCM(window, grayscale, d, theta, windowSize, iso)
% Calculate the GLCM for every glading window in an image.

[MOriginal, NOriginal] = size(window); % Original image size
HalfSize = floor(windowSize/2); % Size of half the filter

% Apply to the original image the zero-padding 
padded = zeros(MOriginal + windowSize - 1, NOriginal + windowSize - 1);
padded(HalfSize:end - HalfSize - 1, HalfSize:end - HalfSize - 1) = window;

[M, N] = size(padded); % Padded image size

% Index matrices
i = repmat((0:(grayscale - 1))', 1, grayscale);
j = repmat(0:(grayscale - 1), grayscale, 1);

IDM = zeros(MOriginal, NOriginal);
INR = zeros(MOriginal, NOriginal);
SHD = zeros(MOriginal, NOriginal);

% Browse image
for m = (HalfSize + 1):(M - HalfSize - 1)
    for n = (HalfSize + 1):(N - HalfSize - 1)
        window = padded(m - HalfSize:m + HalfSize, ...
            n - HalfSize:n + HalfSize);
        
        % Calculating the GLCM
        if iso == 1
            p = isoGLCM(window, grayscale, d);
        else
            p = GLCM(window, grayscale, d, theta);
        end
        
        % Calculating the IDM
        IDM(m - HalfSize, n - HalfSize) = sum(sum((1./(1 + (i - j).^2).*p)));
        
        % Calculating the INR
        INR(m - HalfSize, n - HalfSize) = sum(sum(((i - j).^2).*p));
        
        % Calculating the SHD
        ux = sum(sum(p.*(i + 1)));
        uy = sum(sum(p.*(j + 1)));
        SHD(m - HalfSize, n - HalfSize) = sum(sum((i + j - ux - uy).^3));
    end
end
end