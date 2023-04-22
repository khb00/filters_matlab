% Adaptive Weighted Median Filter
original_image = foetus;

mask = 9;

% These constants are used in to calculate the weight matrix, and must be
% adjusted to be ideal.
constant = 10;
central_weight = 100;

adapt_image = adaptive_weighted_median_filter_main(original_image, mask, constant, central_weight);
print_image(original_image, adapt_image) % Not in main code as not necessary to filter


% Main code - runs adaptive weighted median filter
function adapt_image = adaptive_weighted_median_filter_main(original_image, mask, constant, central_weight)
    half_mask = floor(mask./2);
    adapt_image = original_image;
    padded_image = padarray(original_image, [half_mask, half_mask], 'replicate');

    for row = 1:size(original_image,1)
        for col = 1:size(original_image, 2)                
            pixel_matrix = padded_image(row:row + mask - 1, col:col + mask - 1);
            pixel_matrix = double(pixel_matrix);
            if (mean(pixel_matrix,'all') == 0) && (std2(pixel_matrix) == 0)
                median_value = 0 ;
            else

                weight_matrix = calculate_weighted_matrix(pixel_matrix, constant, central_weight, half_mask);
                sorted_matrix = sort_matrix(pixel_matrix, weight_matrix);
                median_value = find_median(sorted_matrix);
            end
            adapt_image(row, col) = median_value;
        end
    end
end


% Calculates matrix of weights for the specific pixel
function weight_matrix = calculate_weighted_matrix(pixel_matrix, constant, central_weight, half_mask)
    weight_matrix = pixel_matrix;
    sigma = std2(pixel_matrix); % Standard deviation of pixel matrix
    pixel_matrix_mean = mean2(pixel_matrix); % Mean of pixel matrix

    % For each element in pixel matrix, going by distance from centre 
    for row = -half_mask:half_mask
        for col = -half_mask:half_mask
            weight = calculate_weight(row, col, sigma, pixel_matrix_mean, constant, central_weight);
            weight_matrix( row + half_mask + 1, col + half_mask + 1) = weight;
        end
    end
end


%Calculate weight for each element of the weight matrix with formula
function weight = calculate_weight(row, col, sigma, pixel_mean, constant, cen_weight)
    distance = ((row^2)+(col^2))^0.5;
    numerator = constant .* distance .* sigma;
    left = numerator ./ pixel_mean;
    weight = cen_weight - left;
    if weight < 0
        weight = 0;
    end
end


%Sort all pixel matrix elements and their corresponding weights into rows
%where they are on the same row.
function sorted_matrix = sort_matrix(pixel_matrix, weight_matrix)
    mask = size(pixel_matrix,1);
    unsorted_matrix = zeros( mask^2, 2); % if mask is 3, this matrix should be 9x2

    %for each element in the pixel matrix
    for row = 1:size(pixel_matrix,1)
        for col = 1:size(pixel_matrix,2)
            pixel = pixel_matrix(row,col);
            weight = weight_matrix(row,col);
            index = (row-1) * mask + col; % calculate how many elements have been placed in the matrix
            unsorted_matrix (index,:) = [pixel weight]; % Place the pixel value and its corresponding weight into the same row
        end
    end
    sorted_matrix = sortrows(unsorted_matrix); %sort the matrix rows by their first column
end


% find the median value in the sort matrix
function median_value = find_median(sorted_matrix)
    total = sum(sorted_matrix(:,2)); % Sum all the weights i.e. how many elements to find median within.
    threshold = total./2; % the median value
    weight_total = 0;
    
    % for each row in the sorted matrix
    for row = 1:size(sorted_matrix,1)
        weight_total = weight_total + sorted_matrix(row,2); % find the culminative total of the weights
        %if the culminative weights exceed the threshold
        if weight_total > threshold
            median_value = sorted_matrix(row,1);
            break
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