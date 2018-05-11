# ObjectRecognition Using Shape features.
The shape of an object has always been a key attribute through which humans have been able to distinguish and identify them. 
It is a very important part in the field of computer vision. Object shape recognition deals with creating an automated computer-based 
approach to correctly identify the type of object in an image or video. Object shape recognition is an important pre-processing step for
many applications such as recognition of a tiny cell under a microscope to outliner detection in an intelligent surveillance system. 
Although object shape recognition has seen a lot of progress in the past few years and many systems have been proposed, there is still a 
massive scope for improvement as a myriad of factors which include variation in object instances through pose and appearance, 
environmental factors such as the degree of occlusion, and lighting tend to cause failures in the existing system. In order to combat 
the above mentioned short-comings of the existing systems, a system has been developed that detects the contour of the object which serves
as a major factor in the recognition process, and the objects whose contours are found are labeled. Canny and Sobel edge detecting 
algorithm are used for edge detection, while scale invariant feature transform is used for detecting the local features that are present.
Support vector machine is employed in order to use the features that are extracted by SIFT and recognize the objects that are present. 
Object shape recognition finds use in a host of varying fields like Biometric Recognition, Surveillance, Industrial Inspection, Content 
Based Image Retrieval, Robotic Vision, Medical Analysis, Human Computer Interaction, Intelligent Vehicle System, Traffic Control and 
Pedestrian Monitoring and Assistance for visually impaired people.


Run the matlab main.m to run the main program.
Train with a folder and detect a few images.
