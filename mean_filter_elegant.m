% Mean Filter
% Less intensive computation algorithm - could be improved

original_image = image;

mask = 3; % Mask needs to be at least 2, preferably odd
half_mask = floor(mask./2);
elegant_mean_image = original_image;
padded_image = padarray(original_image, [half_mask, half_mask], 'replicate'); % pad the array by relicating the borders by half the mask size

for row = mask:size(padded_image,1)
    pixel_sum = zeros(3, 1); % reset vector at the beginning of each row
    for col = 1:size(padded_image, 2)
        pixel_rows = row - (mask - 1):row; % retrieve rows that are to be summed
        col_sum = sum(padded_image(pixel_rows, col)); % sum the pixels of the rows and column
        pixel_sum = [pixel_sum;col_sum]; % add it to the pixel_sum
        pixel_sum = pixel_sum(2:end); % remove first value from pixel_sum

        %once the 0s from the pixel_sum have been pushed out
        if col >= mask
            %find the mean of the vector
            matrix_total = sum(pixel_sum);
            average = matrix_total/(mask^2);
            %calculate position of the new pixel value in the new image
            new_row = row - mask + 1;
            new_col = col - mask + 1;
            elegant_mean_image(new_row,new_col) = average;
        end
    end
end

print_image(original_image, elegant_mean_image)  % Not in main code as not necessary to filter


% Displays orignal image and filtered image and shows their differences
function print_image(original_image, new_image)   
    figure;
    subplot(3,1,1); imshow(original_image)
    subplot(3,1,2); imshow(new_image)
    subplot(3,1,3); imshowpair(original_image,new_image,'diff');
end