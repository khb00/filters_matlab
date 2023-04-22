% Gaussian Filter
original_image = foetus;

sigma = 1;
gauss_image = gaussian_filter_main(sigma, original_image);
print_image(original_image, gauss_image) % Not in main code as not necessary to filter


% Main code - runs gaussian filter
function gauss_image = gaussian_filter_main(sigma, original_image)
    half_mask = ceil(3.*sigma);
    mask = 2.*(half_mask)+1;
    gauss_image = original_image;
    padded_image = padarray(original_image, [half_mask, half_mask], 'replicate'); % pad the array by relicating the borders by half the mask size
    weight_matrix = calculate_weight_matrix(sigma, half_mask);
    weight_sum = sum(weight_matrix,'all');
    
    % For each pixel in the image
    for row = 1:size(original_image,1)
        for col = 1:size(original_image, 2)
            pixel_matrix = padded_image(row:row + mask - 1, col:col + mask - 1); % Take a matrix around the pixel in the padded array
            weighted_pixel_matrix = weight_matrix .* double(pixel_matrix); % Make a matrix of weighted pixels
            new_pixel = sum(weighted_pixel_matrix,"all") ./ weight_sum; % Normalise the sum of all the weighted pixels
            gauss_image(row, col) = new_pixel;
        end
    end

end


% Calculate gaussian weight with formula
function weight = calculate_weight(x,y,sigma)
    numerator = x^2 + y^2
    denominator = 2 .* (sigma^2)
    weight = exp(-(numerator./denominator))
end


% Create matrix filled with gaussian weights
function weight_matrix = calculate_weight_matrix(sigma,half_mask)
    weight_matrix = zeros(2.*half_mask+1, 2.*half_mask+1)
    for x = - half_mask:half_mask
        for y = - half_mask:half_mask
            weight = calculate_weight(x,y,sigma)
            weight_matrix(x + half_mask + 1, y + + half_mask + 1) = weight
        end
    end
end


% Displays orignal image and filtered image and shows their differences
function print_image(original_image, new_image)   
    figure;
    subplot(3,1,1); imshow(original_image)
    subplot(3,1,2); imshow(new_image)
    subplot(3,1,3); imshowpair(original_image,new_image,'diff');
end