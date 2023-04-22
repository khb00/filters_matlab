% Mean Filter
% Intensive Computation Algorithm

original_image = foetus;

mask = 3; % Mask needs to be at least 2, preferably odd
half_mask = floor(mask./2);
mean_image = original_image;
padded_image = padarray(original_image, [half_mask, half_mask], 'replicate'); % pad the array by relicating the borders by half the mask size

% Run through each pixel in image
for row = 1:size(original_image,1)
    for col = 1:size(original_image, 2)
        pixel_matrix = padded_image(row:row + mask - 1, col:col + mask - 1); % take a matrix around a pixel in the padded array
        mean_image(row, col) = mean(pixel_matrix,'all'); % take the mean of the matrix
    end
end

print_image(original_image, mean_image);


% Displays orignal image and filtered image and shows their differences
function print_image(original_image, new_image)
    figure;
    subplot(3,1,1); imshow(original_image)
    subplot(3,1,2); imshow(new_image)
    subplot(3,1,3); imshowpair(original_image,new_image,'diff');
end