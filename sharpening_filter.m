% Sharpening Filter
% Use in conjecture with other filters

original_image = mean_image;

mask = 3; % Mask needs to be at least 2, preferably odd
half_mask = floor(mask./2);
sharp_image = original_image;
padded_image = padarray(original_image, [half_mask, half_mask], 'replicate'); % pad the array by relicating the borders by half the mask size

% Make the mask - all elements should sum to 0
sharp_mask = zeros(mask,mask) - 1;
sharp_mask(ceil(mask./2), ceil(mask./2)) = mask ^ 2 - 1;

% Run through each pixel in image
for row = 1:size(original_image,1)
    for col = 1:size(original_image, 2)
        pixel_matrix = padded_image(row:row + mask - 1, col:col + mask - 1); % take a matrix around a pixel in the padded array
        weighted_matrix = double(pixel_matrix) .* sharp_mask;
        weighted_sum = 0;
        for x = 1:size(weighted_matrix,1)
            for y = 1:size(weighted_matrix,2)
                weighted_sum = weighted_sum + weighted_matrix(x,y);
            end
        end
        sharp_image(row, col) = weighted_sum; % As weights sum to 0, no need to divide   
    end
end

print_image(original_image, sharp_image)


% Displays orignal image and filtered image and shows their differences
function print_image(original_image, new_image)
    figure;
    subplot(3,1,1); imshow(original_image)
    subplot(3,1,2); imshow(new_image)
    subplot(3,1,3); imshowpair(original_image,new_image,'diff');
end