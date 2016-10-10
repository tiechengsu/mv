function  [I_segmentation,I_segmentation_class]= k_means(I,k_values,max_iterations)
[r,c,d] = size(I);
for k = k_values
    %Initialize k means
    means = zeros(k,3);
    for i = 1:k
        means(i,:) = 256/(k+1)*i;
    end
    %Maximum number of iterations
    for iter = 1:max_iterations
        new_means = zeros(size(means));
        num_assigned = zeros(k,1);
        for i = 1:r
            for j = 1:c
                f1 = I(i,j,1);
                f2 = I(i,j,2);
                f3 = I(i,j,3);
                diff = ones(k,1)*[f1,f2,f3]-means;
                distance = sum(diff.^2,2);
                [val,index]=min(distance);
                %assign fi to the cluster means
                new_means(index,1) = new_means(index,1)+f1;
                new_means(index,2) = new_means(index,2)+f2;
                new_means(index,3) = new_means(index,3)+f3;
                num_assigned(index) = num_assigned(index)+1;
            end
        end
        for i = 1:k
            if(num_assigned(i)>0)
                new_means(i,:) = new_means(i,:)./num_assigned(i);
            end
        end
        T = sum(sqrt(sum((new_means - means).^2,2)));
        %The sum of changes in the centroids<T(0.01)
        if T <0.01
            converge = sprintf('\t For k = %d: \n \t\t Iteration number for converge: %d \n',k,iter);
            disp(converge);
            break
        end
        means = new_means;
    end
    % replace the individual pixel values with k-means
    I_segmentation = I;
    I_segmentation_class = zeros(r,c,3,k);
    for i = 1:r
        for j = 1:c
            f1 = I(i,j,1);
            f2 = I(i,j,2);
            f3 = I(i,j,3);
            diff = ones(k,1)*[f1,f2,f3]-means;
            distance = sum(diff.^2,2);
            [val,index]=min(distance);
            I_segmentation(i,j,:) = means(index,:);
            I_segmentation_class(i,j,:,index)=means(index,:);
        end
    end
    figure;
    imagesc(I_segmentation/256);title(['k = ',num2str(k)]);
end