Use the provided image (“ peppersRGB.tif ”)  (in Blackboard)
– Use ( r,g,b ) as the feature vector
– Use ( L,s,t ) as the feature vector
• L = ( r+g+b )/3  s =( r-b) /2  t = (2g-r-b)/4
– Use (H,S,V) as the feature vector
– Use floating point operations
• Use K-means clustering algorithm (more hints on the next page)
– Assume input is 3D feature vectors; and K = 2 or  3 or your choice
– Use random (or arbitrary/extreme) initialization for the K centroids
– M-step: loop over pixels, class, and then feature dimension (Euclidean distance)
– E-step: loop over class, feature dimension, and then pixels
– Set two stopping conditions
• The sum of changes (over 3D over K) in the centroids < T (0.01)
• Maximum number of iterations  MaxIter  = 30
– Use   imagesc  to display the segmentation result (class labels)
• Interpret the results
– How do you pick the best K for a color image?
– Which color space is better?
How would you handle the specular highlights? (could be a bonus  if you do something about it)

• The input is 3D feature vectors for the 3 color channels of pixels
• Use random or hard-coded initialization for the K centroids, {(e.g.,
 
i\k  class1  class2  class3 (if necessary)
f1  0  100  200 
f2  0  100  200 
f3  0  100  200 
• Calculate the change in the centroids by
SUM k=1,…K  SUM i=1,2,3  | Ck,i(t) – C k,i (t-1)|  
where t denotes time (iteration)   
• If you results are not good, should you try different initialization?

• Should you de-weight the brightness factor in segmentation?
Pseudo-code
Form K-means clusters from a set of n-dim vectors
1.  Set  ic  (iteration count) to 1
2. Choose a set of  K  means  m 1 (1),  m 2 (1), …,  m K (1)
3. For each vector  x i  (pixel), compute  D ( x i ,  m k ( ic )) for each  k =1,2,… K , and assign  x i  to the cluster  C j  with the closest mean  m j ( ic ) according to  D  (Euclidean distance)   D ( x i ,  m k ( ic )) = sum (| x j,l  – m k,l | 2  )  over_ l =1,2,… n 
4. Increment  ic  by 1 and update the means to get a new set  m 1 ( ic ),  m 2 ( ic ), …,  m k ( ic )
5. Repeat steps 3 and 4 until  D ( m k ( ic ),  m k ( ic -1)) <  T  (e.g., 0.01) for all  k =1,2,…,K, or  ic  = max