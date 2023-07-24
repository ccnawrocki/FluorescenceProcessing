// Nuc Stats //

	//This macro takes in an individual image and counts the number of nuclei
	//present. It also outputs basic stats about each nuclei.
	
	//This macro has not been updated in a while, and likely is not very useful.
	//However, it is very readable and simple, so serves as a good introduction 
	//to coding in the ImageJMacro language. 


// Beginning a dialogue with the user
Dialog.create("Number of Images");
Dialog.addNumber("How many images are you analyzing?", 1);
Dialog.show();

// Assigning what the user inputs to num_im
num_im = Dialog.getNumber();

// Defining an array with length num_im called im_array
im_array = Array.getSequence(num_im);

// Beginning another dialogue with the user
Dialog.create("Input Images");
for (i=0; i<num_im; i++) {
	Dialog.addString("Image Name", "");
}
Dialog.addString("Extension", ".tif");
Dialog.addString("Directory of Images","");
Dialog.show();

// Defining each index of the im_array array to be the name of an inputted image
for (i=0; i<num_im; i++) {
	im_name = Dialog.getString();
	im_array[i] = im_name;
}

// Defining variables for the extension and directory of the images
im_ext = Dialog.getString();
dir_path = Dialog.getString();

// Beginning another diaolgue with the user
Dialog.create("Analysis Parameters");
Dialog.addString("Scale: pixels or µm?", "µm");
Dialog.addString("Close all windows when done?","yes");
Dialog.show();

scale_ans = Dialog.getString();
close_ans = Dialog.getString();

// We want to specify the scale
if (scale_ans == "µm") {
	important_p = "size=10-200 circularity=0.4-1 show=Outlines exclude summarize add slice";
}
if (scale_ans == "pixels") {
	important_p = "size=200-25000 circularity=0.4-1 show=Outlines exclude summarize add slice";
}


// Running the analysis for each image that was given and outputting files
for (i=0; i<num_im; i++) {
	imOI = im_array[i];
	open(dir_path+imOI+im_ext);
	run("8-bit");
	run("Subtract Background...", "rolling=50 slice");
	setAutoThreshold("Default dark");
	//run("Threshold...");
	setOption("BlackBackground", false);
	run("Convert to Mask", "method=Default background=Dark calculate");

	selectWindow(imOI+im_ext);
	run("Make Binary", "method=Default background=Light calculate");
	run("Watershed", "slice");
	run("Analyze Particles...", important_p);
	open(dir_path+imOI+im_ext);
	roiManager("Select",Array.getSequence(roiManager("count")));
	roiManager("Measure");
	run("Summarize");
	run("Distribution...", "parameter=Area automatic");
	run("Distribution...", "parameter=Mean automatic");

	saveAs("Results", dir_path+imOI+"_Results.csv");
	selectWindow("Mean Distribution");
	saveAs("PNG", dir_path+imOI+"_Mean Distribution.png");
	selectWindow("Area Distribution");
	saveAs("PNG", dir_path+imOI+"_Area Distribution.png");
	close();
}

// We want to specify if we are going to close all the windows or not
if (close_ans == 'yes') {
	close("*");
}
