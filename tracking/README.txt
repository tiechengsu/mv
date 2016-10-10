Take a simple video sequence (~30 seconds)  of a constructed scene
– For  Example:  https:// www.youtube.com/watch?v=g43Uj0s-eHU
– OR  https://www.youtube.com/watch?v=0aG2R1N4WDs
• Option  1 :  use color information to track a uniquely colored foreground blob
– Can  you handle lighting changes (to some degree)?
• Option  2:  use template matching
• Would pose change or lighting change cause problems ?
 
• AND  Implement a 2D  Kalman  filter tracker  (assuming constant velocity)
– Decide the state space (position of the blob, its velocity;  optional:   what about its orientation, which can be computed from the second moments, and its moving direction?)
– How do you perform prediction? Does it help tracking?

– Interpreting the results