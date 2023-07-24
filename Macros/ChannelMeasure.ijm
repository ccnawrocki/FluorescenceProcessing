// Channel Measure // 

	//This macro makes basic measurements about an image's ROIs that were 
	//found with Cellpose's cell segmentation. It also calculate's the min,
	//max, and mean intensity of given channels of interest in each ROI. 
	//Finally, it outputs a training set that can be used for cell annotation
	//based on a given channel of interest.
	
Dialog.create("Setup Images");
Dialog.addString("Analysis Directory:", "");
Dialog.addString("Image Extensions:", ".tif");
channels = newArray("Red","Green","Blue","Gray","Cyan","Magenta","Yellow");
Dialog.addMessage("What channels are present? (check the cytoplasm, nuclei, and channel of interest colors)");
Dialog.addCheckboxGroup(1, 7, channels, newArray(false,false,true,false,false,false,true));
Dialog.addString("Channel of Interest:","");
Dialog.addRadioButtonGroup("Color of this channel:", channels, 1, 7, "");
Dialog.show();
	
dir = Dialog.getString();
ext = Dialog.getString();
cols_pres = newArray(0);
	for (w=0;w<7;w++) {
		col_pres = Dialog.getCheckbox();
		if (col_pres == 1) {
			col_oi = newArray(channels[w]);
			cols_pres = Array.concat(cols_pres,col_oi);
		}
	}
chan = Dialog.getString();
color = Dialog.getRadioButton();

Table.open(dir+"/"+chan+"_files.csv");
im_name_array = Table.getColumn("channel.file.name");
im_chan_pres_array = Table.getColumn("all.channels.present");
close(chan+"_files.csv");

Table.open(dir+"/Segmentations/"+chan+"_rois_files.txt");
rois_array = Table.getColumn("rois.file.name");
close(chan+"_rois_files.txt");

for (i=0; i<im_name_array.length; i++) {
	im = im_name_array[i]+im_chan_pres_array[i];
	open(dir+"/"+im+ext);
	run("Split Channels");
	for (k=1; k<cols_pres.length+1; k++) {
		selectWindow("C"+k+"-"+im+ext);
		if (cols_pres[k-1] != color) {
			close();
		}
		if (cols_pres[k-1] == color) {
			sub = k;
		}
	}
	selectWindow("C"+sub+"-"+im+ext);
	run("ROI Manager...");
	roiManager("Open", dir+"/Segmentations/"+rois_array[i]);
	roiManager("Select",Array.getSequence(roiManager("count")));
	roiManager("show all with labels");
	run("Set Measurements...", "area mean standard modal min centroid center perimeter fit shape feret's median skewness kurtosis display redirect=C"+sub+"-"+im+ext+" "+"decimal=3");
	roiManager("Measure");
	saveAs("Results", dir+"/"+im_name_array[i]+"_"+chan+"_Measurements.csv");
	close("Results");
	run("Clear Results");
	
	Dialog.create("Cell Annotation Setup");
	Dialog.addChoice("Is the image fit for classification?", newArray("Y","N"), "Y");
	Dialog.show();
	
	proceed = Dialog.getChoice();
	
	if (proceed == "N") {
		Dialog.create("Reasoning");
		Dialog.addChoice("Why not?", newArray("All cells are "+chan+"+","All cells are "+chan+"-"));
		Dialog.show();
		
		reason = Dialog.getChoice();
		reason_array = newArray(reason);
		Table.create("t_set");
		Table.setColumn("ROI.indices", reason_array);
		saveAs("Results", dir+"/"+im+"_training_set.csv");
		close(im+"_training_set.csv");
	}
	
	else {
		Dialog.create("Training Set Size");
		Dialog.addNumber("How many of each cell type would you like to label?", 5);
		Dialog.show();
		
		tset_n = Dialog.getNumber();
		
		training_set_chan = Array.getSequence(tset_n);
		training_set_norm = Array.getSequence(tset_n);
		training_set_label = Array.getSequence(tset_n*2);
		
		Dialog.create("Select "+chan+"+ Cells");
		for (j=0;j<tset_n;j++) {
			Dialog.addNumber("Report a cell number:", j+1);
		}
		Dialog.show();
		for (k=0;k<tset_n;k++) {
			training_set_chan[k] = Dialog.getNumber();
			training_set_label[k] = chan+"+";
		}
		
		Dialog.create("Select "+chan+"- Cells");
		for (l=0;l<tset_n;l++) {
			Dialog.addNumber("Report a cell number:", l+1);
		}
		Dialog.show();
		for (l=0;l<tset_n;l++) {
			training_set_norm[l] = Dialog.getNumber();
			training_set_label[l+tset_n] = "normal";
		}
		
		Table.create("t_set");
		Table.setColumn("ROI.indices", Array.concat(training_set_chan,training_set_norm));
		Table.setColumn("cell.type", training_set_label);
		saveAs("Results", dir+"/"+im+"_training_set.csv");
		close(im+"_training_set.csv");
	}
	
	roiManager("Select",Array.getSequence(roiManager("count")));
	roiManager("delete");
	roiManager("Show None");
	roiManager("reset");
	close("ROI Manager");
	close(im+".tif (green)");
}
close("*");
