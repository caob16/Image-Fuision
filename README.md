# Image-Fuision
-  Below is an outline of the methodologies applied and solutions developed within this project:

Implemented mean filtering for the preliminary processing of images, successfully rectifying geometric distortions and mitigating noise artifacts, thus ensuring a cleaner and more accurate base for further operations.

Developed a brightness normalization method through linear mapping, using the average luminance data extracted from dual-image comparisons. This step is crucial for maintaining visual consistency across the series of images to be stitched.

Applied the Speeded Up Robust Features (SURF) algorithm as a robust method for image registration, ensuring precise alignment of multiple images. This was complemented by homography estimation, which utilized a projective transformation model to accurately identify the necessary geometric transformations for image stitching.

Pioneered a simple yet effective mean filtering technique to blend the stitched areas seamlessly, eliminating visible seams and discontinuities for a uniform and coherent final image.
