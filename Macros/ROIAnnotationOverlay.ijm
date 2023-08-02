// ROI Annotation Overlay // 

	//This macro will take in an image, ROIs, and metadata about the 
	//ROIs, and it will overlay annotations onto the image in colors that 
	//correspond to the colors of the channels in question. It will save 
	//the overlayed image as PNG.

Dialog.create("Setup Images");
Dialog.addString("Analysis Directory:", "");
Dialog.addString("Image Extensions:", ".tif");
Dialog.addString("Channel of Interest:","")
Dialog.addChoice("Scale bar?", newArray("Y","N"));
Dialog.addRadioButtonGroup("Units:", newArray("pixels","µm"), 1, 2, "pixels");
Dialog.show();
	
dir = Dialog.getString();
ext = Dialog.getString();
chan = Dialog.getString();
scalebar = Dialog.getChoice();
units = Dialog.getRadioButton();

Dialog.create("Color Customization");
colors = newArray("red","green","blue","gray","cyan","magenta","yellow");
Dialog.addRadioButtonGroup(chan+"+"+" Cells:", colors, 1, 7, "green");
Dialog.addRadioButtonGroup("Normal Cells:", colors, 1, 7, "yellow");
Dialog.show();

chan_oi_color = Dialog.getRadioButton();
normal_color = Dialog.getRadioButton();

Table.open(dir+"/"+chan+"_files.csv");
im_array = Table.getColumn("channel.file.name");
im_chans_present_array = Table.getColumn("all.channels.present");
im_nuc_cyt_chans_array = Table.getColumn("nuc.cyt.channels");
close(chan+"_files.csv");

Table.open(dir+"/Segmentations/"+chan+"_rois_files.txt");
rois_array = Table.getColumn("rois.file.name");
close(chan+"_rois_files.txt");

for (i=0; i<im_array.length; i++) {
	im = im_array[i]+im_chans_present_array[i];
	ROIs = rois_array[i];
	ROI_indices = im+"_positive_indices";
	open(dir+"/"+im+ext);
	run("Flatten");
	if (scalebar == "Y") {
		if (units == "pixels") {
			run("Scale Bar...", "width=100 height=100 horizontal overlay");
		}
		if (units == "µm") {
			run("Scale Bar...", "width=25 height=100 horizontal overlay");
		}
	}
	saveAs("Tiff", dir+"/"+im+ext);
	close();
	roiManager("open", dir+"/Segmentations/"+ROIs);
	Table.open(dir+"/"+ROI_indices+".txt");
	indices = Table.getColumn("index");
	RoiManager.setGroup(0);
	RoiManager.setPosition(0);
	roiManager("Set Color", "none");
	roiManager("Set Fill Color", normal_color);
	roiManager("deselect");
	if (indices.length != 0) {
		roiManager("select", indices);
		RoiManager.setGroup(1);
		RoiManager.setPosition(1);
		roiManager("Set Color", "none");
		roiManager("Set Fill Color", chan_oi_color);
	}
	roiManager("Show All with labels");
	roiManager("deselect"); 
	selectWindow(im+ext);
	run("Flatten");
	if (scalebar == "Y") {
		if (units == "pixels") {
			run("Scale Bar...", "width=100 height=100 horizontal overlay");
		}
		if (units == "µm") {
			run("Scale Bar...", "width=25 height=100 horizontal overlay");
		}
	}
	saveAs("PNG",dir+"/"+im+"_positive_overlay.png");
	
	close("*");
	close("ROI Manager");
	close(ROI_indices+".txt");
	
	roiManager("reset");
	open(dir+"/"+im+ext);
	roiManager("open", dir+"/Segmentations/"+ROIs);
	roiManager("show all");
	run("Flatten");
	if (scalebar == "Y") {
		if (units == "pixels") {
			run("Scale Bar...", "width=100 height=100 horizontal overlay");
		}
		if (units == "µm") {
			run("Scale Bar...", "width=25 height=100 horizontal overlay");
		}
	}
	saveAs("PNG",dir+"/"+im+"_segmentation.png");
	close("*");
	close("ROI Manager");
}