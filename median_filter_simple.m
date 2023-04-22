% Median Filter
% Intensive Computation Algorithm
original_image = foetus;

mask = 3; % Mask needs to be at least 2, preferably odd
half_size = floor(mask./2);
median_image = original_image;
padded_image = padarray(original_image, [half_size, half_size], 'replicate'); % pad the array by relicating the borders by half the mask size

% Run through each pixel in image
for row = 1:size(original_image,1)
    for col = 1:size(original_image, 2)
        pixel_matrix = padded_image(row:row + mask - 1, col:col + mask - 1); % take a matrix around a pixel in the padded array
        median_image(row, col) = median(pixel_matrix, 'all'); % take the median of the matrix
    end
end

print_image(original_image, median_image);


% Displays orignal image and filtered image and shows their differences
function print_image(original_image, new_image)
    figure;
    subplot(3,1,1); imshow(original_image)
    subplot(3,1,2); imshow(new_image)
    subplot(3,1,3); imshowpair(original_image,new_image,'diff');
end