function [isoGLCM] = isoGLCM(window, grayscale, d)
% isoGLCM calculates the isometric GLCM of an image and the 
% result is normalized and symmetric.

isoGLCM = zeros(grayscale);
theta = [0, 45, 90, -45];

for t = 1:length(theta)
    isoGLCM = isoGLCM + GLCM(window, grayscale, d, theta(t));
end

isoGLCM = isoGLCM/3;
end
    