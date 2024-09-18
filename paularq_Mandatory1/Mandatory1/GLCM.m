function [glcm] = GLCM(window, grayscale, d, theta)
% GLCM function calculates the GLCM of an image and the result is
% normalized and symmetric. 

[N,M] = size(window);
glcm = zeros(grayscale);

% Translating input
if theta == 0
    dx = d;
    dy = 0;
elseif theta == 45
    dx = d;
    dy = d;
elseif theta == 90
    dx = 0;
    dy = d;
elseif theta == -45
    dx = d;
    dy = d;
    %Flip the rows of window
    window = flipud(window);
end

% Counting transitions for indexing
for i = 1:N
    for j = 1:M
        if i + dy > N || i + dy < 1 || i + dx < 1 || ...
           j + dx > M || j + dy < 1 || j + dx < 1
           continue
        end
        first = window(i,j);
        second = window(i + dy, j + dx);
        glcm(first + 1, second + 1) = glcm(first + 1, second + 1) + 1;
    end
end

% Make symmetric and normalize
glcm = glcm + glcm';
glcm = glcm/sum(sum(glcm));
end