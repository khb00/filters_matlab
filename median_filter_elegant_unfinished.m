% Median Filter
% Intensive Computation Algorithm

original_image = foetus;
mask = 3; % Mask needs to be at least 2, preferably odd
half_size = floor(mask./2);
th = half_size;
median_image = original_image;
padded_image = padarray(original_image, [half_size, half_size], 'replicate'); % pad the array by replicating the borders by half the mask size
LTM = th; % LTM stands for less than the median and is the number of position before the median value

% Going through each row in the padded_image
for row = mask:size(padded_image,1)
    pixel_vector = zeros(1, mask*mask); % Create a vector of 1xsqrd(mask)
    current_median = pixel_vector(th + 1); % The current median is in the middle postion of the vector
    % for each column in the row.
    for col = 1:size(padded_image, 2)
        row_coord = row - (mask - 1):row;
        % if the column exceeds the mask
        if col > mask
            % Remove the pixel added to the pixel_vector taht are no longer
            % in the mask.
            % Look through each pixel on removing_col and removing_row
            removing_col = col - mask;
            for removing_row = row - (mask - 1):row
                % If an pixel from the removing column or a removing row is
                % in a position before the current median in the
                % pixel_vector.
                if padded_image(removing_row, removing_col) < current_median
                    LTM = LTM - 1; % The number of positons less than the median position decreases. 
                pixel_vector.remove(padded_image(removing_row, removing_col)); % Remove the the pixel from the pixel_vector
                end
            end
        else
            for i = 1:mask
                % As all the intial values in pixel_vector are 0, they will
                % always be the first in the vector.
                pixel_vector.remove(0); % remove the first position in the pixel_vector
            end
        end
        
        % this for loop should run of the same number of times as mask.
        for adding_row = row - (mask - 1):row
            if padded_image(adding_row, col) < current_median
                LTM = LTM + 1; % the position of the median incrreases in the pixel vector
            end
            % The new pixels should be added to the pixel_vector in order.
            pixel_vector.add(padded_image(adding_row, col));
            % Still have yet to implement this line properly. 
            pixel_vector.sort() % Despite trying to improve the efficiency of the algorithm, sort is very computationally expensive.
        end
        if LTM <= th:
            % These lines have yet to be implemented.
            % The current median would be at position LTM
            % move along the vector until LTM is equal to or exceeds th
            % That is the element that should be used as the median
            % I am confused about how to do this in MATLAB as it would be
            % much simpler to say that median is at position th + 1 and use
            % that as the index for the matix.
        if col >= mask
            new_row = row-mask_size;
            new_col = col-mask+1;
            median_image(new_row , new_col) = median_value;
        end
    end
end

print_image(image, mean_image);


% Displays original image and filtered image and shows their differences
function print_image(original_image, new_image)
    figure;
    subplot(3,1,1); imshow(original_image)
    subplot(3,1,2); imshow(new_image)
    subplot(3,1,3); imshowpair(original_image,new_image,'diff');
end