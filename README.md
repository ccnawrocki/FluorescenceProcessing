# FluorescenceProcessing
A comprehensive workflow for processing and analyzing sets of fluorescent images. The workflow utilizes `Fiji`, `ImageJMacro`, `Python`, `Bash`, and `R`. Here is an example of what this workflow does: 
1. Segment an image of cells, using `cellpose`.
   
2. Train and implement a KNN classification model for identifying tumor cells, based on a marker's IF signal.
   
3. Vizualize cells of interest.
   
4. Produce data for downstream Statistical analysis.
   

## Disclaimer
This R package and repository was a project that I completed during my __summer internship__ in the Ting Lab at the Massachusetts General Hospital Center for Cancer Research over the course of summer 2023. The project's purpose was to streamline the processing and basic image analysis of immunofluorescence (IF) stains. This repository is __no longer updated__, and it is __not representative__ of best practices that I use in my current workflows for completing this same task. The project was an opportunity for me to learn about image analysis and to practice applying Statistics to imaging data.   

## Start Guide
To download a video recording of an example walkthrough, click [here]().
This video is ~300 MB.

Alternatively, download and open the appropriate workflow and follow the extensive directions.

## Notes
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

## Examples
To download a library of projects for which this pipeline has been run, click [here]().
This library is ~2 GB.
