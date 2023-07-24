// Image Combine //

	//This macro simply takes in image parameters and outputs files that can be
	//used with cellpose for cell segmentation (just nuclei and cytoplasm 
	//channels). These outputs will assign the nuclei as being blue and the 
	//cytoplasm as being red and can be found in "Segmentations".
	
	//It will also output images of each of the other markers of interest on top 
	//of the nuclei and cytoplasm markers individually. These outputs will assign 
	//colors to the channels with which they actually correspond.

Dialog.create("Setup Images");
Dialog.addString("Project Directory:", "");
Dialog.addString("Analysis Directory:", "");
Dialog.addString("Image Extensions:", ".tif");
Dialog.addChoice("Do quickly?", newArray("N","Y"));
Dialog.show();
	
dir = Dialog.getString();
out = Dialog.getString();
ext = Dialog.getString();
quick = Dialog.getChoice();

if (quick == "Y"){
	setBatchMode(true);
}
	
Table.open(dir+"/image_names.txt");
im_array = Table.getColumn("image.name");
close("image_names.txt");

for (i=0; i<im_array.length; i++) {
	im = im_array[i];
	channels = newArray("Red","Green","Blue","Gray","Cyan","Magenta","Yellow");
	defaults = newArray(true,true,true,false,false,false,true);
	default_names = newArray("Cy5","FITC","DAPI","","","","TxRed");

	Dialog.create("Setup "+im+"'s"+" Channels");
	Dialog.addMessage("Select channels that were used:");
	Dialog.addCheckboxGroup(1,7,channels,defaults);
	Dialog.show();

	CHANNELS = newArray(0);
	DEFAULT_NAMES = newArray(0);
	COLOR_NUMS = newArray(0);
	channel_presence = newArray(7);
	for (w=0;w<7;w++) {
		channel_presence[w] = Dialog.getCheckbox();
		if (channel_presence[w] == 1) {
			chan_not_array = channels[w];
			chan = newArray(channels[w]);
			CHANNELS = Array.concat(CHANNELS,chan);
			nam = newArray(default_names[w]);
			DEFAULT_NAMES = Array.concat(DEFAULT_NAMES,nam);
			if (chan_not_array == "Red") {
				COLOR_NUMS = Array.concat(COLOR_NUMS,newArray("1"));
			}
			if (chan_not_array == "Green") {
				COLOR_NUMS = Array.concat(COLOR_NUMS,newArray("2"));
			}
			if (chan_not_array == "Blue") {
				COLOR_NUMS = Array.concat(COLOR_NUMS,newArray("3"));
			}
			if (chan_not_array == "Grey") {
				COLOR_NUMS = Array.concat(COLOR_NUMS,newArray("4"));
			}
			if (chan_not_array == "Cyan") {
				COLOR_NUMS = Array.concat(COLOR_NUMS,newArray("5"));
			}
			if (chan_not_array == "Magenta") {
				COLOR_NUMS = Array.concat(COLOR_NUMS,newArray("6"));
			}
			if (chan_not_array == "Yellow") {
				COLOR_NUMS = Array.concat(COLOR_NUMS,newArray("7"));
			}
		}
	}

	Dialog.create("Configure "+im+"'s"+" Channels");
	for (p=0;p<CHANNELS.length;p++) {
		Dialog.addMessage("...................."+CHANNELS[p]+"...................."+"\n"+"\n");
		Dialog.addString("Name", DEFAULT_NAMES[p]);
		Dialog.addNumber("Channel Number:", p+1);
		if (CHANNELS[p] == "Blue") {
			Dialog.addRadioButtonGroup("Label for", newArray("Nuclei","Cytoplasm","Other"), 1, 3, "Nuclei");
		}
		else if (CHANNELS[p] == "Yellow") {
			Dialog.addRadioButtonGroup("Label for", newArray("Nuclei","Cytoplasm","Other"), 1, 3, "Cytoplasm");
		}
		else {
			Dialog.addRadioButtonGroup("Label for", newArray("Nuclei","Cytoplasm","Other"), 1, 3, "Other");
		}
	}
	Dialog.show();

	CHANNEL_NAMES = newArray(CHANNELS.length);
	CHANNEL_NUMBERS = newArray(CHANNELS.length);
	CHANNEL_LABELS = newArray(CHANNELS.length);
	other_chan_array = newArray(0);
	other_chan_num_array = newArray(0);
	other_chan_sub_array = newArray(0);
	for (v=0;v<CHANNELS.length;v++) {
		CHANNEL_NAMES[v] = Dialog.getString();
		CHANNEL_NUMBERS[v] = Dialog.getNumber();
		CHANNEL_LABELS[v] = Dialog.getRadioButton();
		if (CHANNEL_LABELS[v] == "Nuclei") {
			nuc_num = "-000"+CHANNEL_NUMBERS[v];
			nuc_chan = CHANNEL_NAMES[v];
			nuc_sub = v;
		}
		if (CHANNEL_LABELS[v] == "Cytoplasm") {
			cyt_num = "-000"+CHANNEL_NUMBERS[v];
			cyt_chan = CHANNEL_NAMES[v];
			cyt_sub = v;
		}
		if (CHANNEL_LABELS[v] == "Other") {
			num_oi = newArray("-000"+CHANNEL_NUMBERS[v]);
			other_chan_num_array = Array.concat(other_chan_num_array,num_oi);
			chan_oi = newArray(CHANNEL_NAMES[v]);
			other_chan_array = Array.concat(other_chan_array,chan_oi);
			sub_oi = newArray(""+v);
			other_chan_sub_array = Array.concat(other_chan_sub_array,sub_oi);
		}
	}
	
	open(dir+"/"+im+ext);
	run("Stack to Images");

	NUC = im+nuc_num;
	selectWindow(NUC);
	run("Subtract Background...", "rolling=50");
	if (quick == "Y") {
		run("Enhance Contrast", "saturated=0.35");
		run("Enhance Contrast", "saturated=0.35");
	}
	else {
		run("Brightness/Contrast...");
		waitForUser("adjust "+nuc_chan+" brightness and contrast (remember to click reset)");
	}
	
	CYT = im+cyt_num;
	selectWindow(CYT);
	run("Subtract Background...", "rolling=30");
	if (quick == "Y") {
		run("Enhance Contrast", "saturated=0.35");
		run("Enhance Contrast", "saturated=0.35");
	}
	else {
		run("Brightness/Contrast...");
		waitForUser("adjust "+cyt_chan+" brightness and contrast (remember to click reset)");
	}

	run("Merge Channels...", "c1="+CYT+" "+"c3="+NUC+" "+"create keep");
	run("Stack to RGB");
	saveAs("Tiff", out+"/Segmentations/"+im+"_"+nuc_chan+"_"+cyt_chan+ext);
	
	all_chans_command = "c"+COLOR_NUMS[cyt_sub]+"="+CYT+" "+"c"+COLOR_NUMS[nuc_sub]+"="+NUC;	
	for (b=0; b<other_chan_array.length; b++) {
		CHAN = im+other_chan_num_array[b];
		selectWindow(CHAN);
		run("Subtract Background...", "rolling=30");
		if (quick == "Y") {
			run("Enhance Contrast", "saturated=0.35");
			run("Enhance Contrast", "saturated=0.35");
		}
		else {
			run("Brightness/Contrast...");
			waitForUser("adjust "+other_chan_array[b]+" brightness and contrast (remember to click reset)");
		}
		run("Merge Channels...", "c"+COLOR_NUMS[cyt_sub]+"="+CYT+" "+"c"+COLOR_NUMS[nuc_sub]+"="+NUC+" "+"c"+COLOR_NUMS[other_chan_sub_array[b]]+"="+CHAN+" "+"create keep");
		saveAs("Tiff", out+"/"+im+"_"+nuc_chan+"_"+cyt_chan+"_"+other_chan_array[b]+ext);
		
		all_chans_command = all_chans_command+" "+"c"+COLOR_NUMS[other_chan_sub_array[b]]+"="+CHAN;
	}
	all_chans_command = all_chans_command+" "+"create keep";
	run("Merge Channels...", all_chans_command);
	run("Stack to RGB");
	saveAs("Tiff", out+"/"+im+"_all_channels"+ext);
	close("*");
}		

if (quick == "Y"){
	setBatchMode(false);
}