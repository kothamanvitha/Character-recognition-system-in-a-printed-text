# Character-recognition-system-in-a-printed-text
Design a Character Recognition System for Printed Text using K Nearest Neighbour Classification(KNN)

Steps:

Training Phase:-

i) Read character images ( Capital and small letters ) from the database folder char_images. (char_image folder contains five samples of capital letters and five
samples of small letters)

ii) Convert all the images to binary images using rgb2gray and im2bw function. Resize all the images to 32 x 32 usiing imresize .

iii) The images obtained from step 1 and 2 will be patterns of 1 and 0. Convert matrix to avector by concatenating each rows of the matrix. Each character image will be of size 1x 1024. ( Use colon operator)

iv) Create a text file or mat file which will be of size 260 x 1024 [( 26 x5 + 26 x5) =260, 1024(32 x 32)]. This file will be your training feature vector.

v) Create a label list for the training file. ( Example Y=[ A A A ……..])

vi) Create a model for KNN using the function fitcknn() using training feature vector and
labels.


Testing Phase:-

i) Read a printed English text with at least 3 lines.

ii) Perform line segmentation, word segmentation and character segmentation and save the segmented characters in a folder

iii) Read the segmented characters , convert to binary and resize to 32 x 32 and make a vector of size 1024. ( As in step 3 of training phase).

iv) Determine the class of all the segmented characters using the net created in the training phase.
 
 v) Create a output file which contains the recognized Text document
