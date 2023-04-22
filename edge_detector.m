%Edge Detector
%Sobel Filter
%Can be adapted for other filters

original_image = foetus;
distance_from_pixel = 1;
threshold = 10;
edge_detector_main(distance_from_pixel, threshold, original_image)
%edge_detector_main(distance_from_pixel, threshold, mean_image)
%edge_detector_main(distance_from_pixel, threshold, median_image)
%edge_detector_main(distance_from_pixel, threshold, gauss_image)
%edge_detector_main(distance_from_pixel, threshold, adapt_image)
%edge_detector_main(distance_from_pixel, threshold, sharp_image)


% Main code - runs edge detector
function edge_detector_main(distance_from_pixel, threshold, original_image)
    % Establish all matrix that will be used

    % Must calculate horizontal and vertical values separately
    taylor_matrix_row = zeros(size(original_image,1),size(original_image,2));
    taylor_matrix_col = zeros(size(original_image,1),size(original_image,2));
    filtered_matrix_row = zeros(size(original_image,1),size(original_image,2));
    filtered_matrix_col = zeros(size(original_image,1),size(original_image,2));

    magnitude_matrix = zeros(size(original_image,1),size(original_image,2));
    angle_matrix = zeros(size(original_image,1),size(original_image,2));
    edge_matrix = zeros(size(original_image,1),size(original_image,2));

    %Find taylor series values and make a matrix out of them
    
    % Vertical first - My
    % Complete Taylor series value for pixel on that row with the pixels
    % above and below it.
    for row = 1 + distance_from_pixel : size(original_image,1) - distance_from_pixel
        for col = 1 : size(original_image,2)
            taylor_val = central_diff(distance_from_pixel, double(original_image(row-1,col)), double(original_image(row+1,col)));
            taylor_matrix_row(row,col) = taylor_val;
        end
    end
    
    % Horizontal second - Mx
    % Complete Taylor series value for pixel on that row with the pixels
    % beside it.
    for col = distance_from_pixel + 1 : size(original_image,2) - distance_from_pixel
        for row = 1 : size(original_image,1)
            taylor_val = central_diff(distance_from_pixel, double(original_image(row,col-1)), double(original_image(row,col+1)));
            taylor_matrix_col(row,col) = taylor_val;
        end
    end
    
    for row = 1 + distance_from_pixel : size(original_image,1) - distance_from_pixel
        for col = 1 + distance_from_pixel : size(original_image,2) - distance_from_pixel
            % Put each pixel in row and column through a sobel filter
            % change these lines to implement other filters
            filtered_matrix_row(row , col) = sobel_filter(taylor_matrix_row(row, col-distance_from_pixel:col+distance_from_pixel));
            filtered_matrix_col(row , col) = sobel_filter(taylor_matrix_col(row-distance_from_pixel:row+distance_from_pixel, col));
            % Combine the row and column values by finding magnitude and
            % angle.
            magnitude_matrix(row , col) = (filtered_matrix_row(row , col)^2 + filtered_matrix_col(row , col)^2) ^ 0.5;
            angle_matrix(row , col) = atan(filtered_matrix_row(row , col)/filtered_matrix_col(row , col));
            if magnitude_matrix(row,col) > threshold
                edge_matrix(row,col) = 255;
            end
        end
    end
    % As edge detecot is used for evaluation purposes, print images is
    % included in the main code
    print_image(original_image, filtered_matrix_row, filtered_matrix_col, magnitude_matrix, angle_matrix, edge_matrix)
end


% Displays orignal image and filtered image and shows their differences
function print_image(original_image, filtered_matrix_row, filtered_matrix_col, magnitude_matrix, angle_matrix, edge_matrix)
    figure;
    subplot(2,3,1); imshow(original_image)
    subplot(2,3,2); imshow(filtered_matrix_row)
    subplot(2,3,3); imshow(filtered_matrix_col)
    subplot(2,3,4); imshow(magnitude_matrix)
    subplot(2,3,5); imshow(angle_matrix)
    subplot(2,3,6); imshow(edge_matrix)
end
 

%finds taylor series value using central difference formula
function taylor_value = central_diff(diff_x, neg_x, pos_x)
    top = pos_x - neg_x;
    bottom = 2.*diff_x;
    addon = 2.*(diff_x^2);
    taylor_value = (top/bottom) + addon;
end


% Completes a sobel filter - always a 3x3 mask
function average = sobel_filter(pixels)
    coefficient_side = 1;
    coefficient_mid = 2;
    average = (coefficient_side .* pixels(1) + coefficient_mid.*pixels(2) + coefficient_side.*pixels(3))/3; % Not sure whether to dvide by 3 or 4
end
