# Start Guide
The pipeline that was developed for this project can only be run on images that have a cytoplasm channel included because this channel is required for cell segmentation.

The channels can be saved with a fluorescent microscope in any order. However, it will save you loads of time if you save them in the following order:

	1) Red
	2) Green
	3) Blue
	4) Grey
	5) Cyan
	6) Magenta
	7) Yellow

This is because the macros require you to specify which channel number each color is. However, the default number for each color is as shown above.
	
For analysis, you must choose a folder where analysis files will be sent. What works best is to create a folder called "Analysis-Files" within the folder where all of your images are kept. Within your analysis folder, you must create a Segmentations folder before you start the pipeline.

Download and open the appropriate workflow and follow the extensive directions.

To download a library of projects for which this pipeline has been run, click [here](https://myuva-my.sharepoint.com/:f:/r/personal/ccn7wn_virginia_edu/Documents/WORK/Ting-Lab/Summer%202023/Microscopy/library?csf=1&web=1&e=TT6l8r).
This library is ~2 GB.

To download a video recording of an example walkthrough, open your terminal and run the following:
```
wget -O <full-destination-directory-path/file-name> https://tinglab.s3.amazonaws.com/FluorescenceProcessing/Example-Walkthrough.mp4
```
This video is ~300 MB.
