# fluorescence-processing
A comprehensive workflow for processing and analyzing sets of fluorescent images.

This project was developed by Cole Nawrocki during summer 2023. Its purpose is to streamline the processing and basic image analysis of immunofluorescence stains.

The workflow utilizes Fiji, ImageJMacro, Python, Bash, and R. 

### Start Guide
The pipeline that was developed for this project can only be run on images that have a cytoplasm channel included because this channel is required for cell segmentation.

The channels can be saved with the Nikon microscope named Otto in any order. However, it will save you loads of time if you save them in the following order:

	1) Red
	2) Green
	3) Blue
	4) Grey
	5) Cyan
	6) Magenta
	7) Yellow

This is because the macros require you to specify which channel number each color is. However, the default number for each color is as shown above.
	
For analysis, you must choose a folder where analysis files will be sent. What works best is to create a folder called "Analysis-Files" within the folder where all of your images are kept. Within your analysis folder, you must create a Segmentations folder before you start the pipeline.

This project was developed by Cole Nawrocki. Here is Cole's contact info: 
	cole.nawrocki@gmail.com
	ccn7wn@virginia.edu
 
