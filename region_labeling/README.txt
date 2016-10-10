• Select a single threshold to segment the given image (in Blackboard)
– create a binary map in which all major objects are segmented/separated
– assign all the object pixels a value of 255 and the background a value of 0
– there may exist multiple thresholds that achieve the optimal segmentation
– draw/print the values of the binary map (and/or view it in Matlab to verify)*
• Label connected components (8-connected)
– each object is uniquely labeled (keep labels consecutive)
– keep intermediate map after the first pass
– draw/print the values of the label maps (and/or view them in Matlab to verify)*
• Perform region selection
– remove all regions having areas smaller than 10 pixels
– remove all skinny regions having aspect ratios over 3:1 (use rectangular bounding boxes to decide)
– draw/print the values of the label maps (and/or view them in Matlab to verify)*
– What if you want to detect the heart shape? (Valentine’s Day bonus)