/*
 * This is a generalized script to batch analyze TEM images.
 * It will import all images in the working directory,
 * threshold the image and run particle sizer.
 *
 * Written by:  Thomas L. Moore
 *
 * Contact: tlmoore1928@gmail.com
 *
 * This macro is in the public domain. Feel free to use and
 * modify it.
 */


waitForUser("","Each directory should contain replicates of the same\n"+
				"sample (i.e. put each sample and it's replicates in\n"+
				"their own folder");
// Loading data to process
proc_dir = getDirectory("Choose a Directory to PROCESS"); // Get the directory to process
list = getFileList(proc_dir); // Get list of all files in working directory
open(proc_dir+list[0]); // Open the first file in the 

// Define the length of the scale bare in the image
scale_len = getNumber("Enter scale bar length (in nanometers):", 0);

setTool("line"); // Manually set the scale for the first image
waitForUser("User Action", "All images in working directory must have the same magnification\n"+
	"and be of the same sample. Use the line tool to select the length\n"+
	"of the scale bar. Hold \"shift\" to draw a straight, horizontal line.\n"+
	"Press OK when done");
getLine(x1, y1, x2, y2, lineWidth); // get the measurements of the line segment

// set scale for all images (globally)
run("Set Scale...", "distance=&lineWidth known=&scale_len unit=nm global");

// Crop the photo to remove scale bar area
setTool("rectangle");
waitForUser("User Action", "Use the rectangle tool to select the image area of interest\n"+
	"Press OK when done");
getSelectionBounds(x, y, width, height);
xrec = x
yrec = y
xwidth = x+width
yheight = y+height

// Now that the image and scale parameters are set, close the current window
close();

// Choose where to save the script output
results_dir = getDirectory("Choose Directory to save results");

// Create function for processing images
function particle_sizer(input, output, filename){
	open(input+filename);
	title = getTitle(); // get window title
	dotIndex = indexOf(title, "."); // set dot index for image title
	img_title = substring(title, 0, dotIndex); // subset only image title (remove file type)
	makeRectangle(xrec, yrec, xwidth, yheight);
	run("Crop");
	setAutoThreshold("Default");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	run("Watershed");
	run("Analyze Particles...", "size=50-Infinity circularity=0.65-1.00 show=Outlines display exclude clear");
	// Save the image/results files
	saveAs("Results", results_dir+img_title+".csv");
	saveAs("Drawing of "+title, results_dir+"outlines_"+title);
	selectWindow(title);
	close();
	selectWindow("outlines_"+title);
	close();
	selectWindow("Results");
}


// Batch process the image for particle sizing for all images in directory
setBatchMode(true)
for (i=0; i < list.length; i++){
	particle_sizer(proc_dir, results_dir, list[i]);
}
setBatchMode(false);
 








/*
title = getTitle(); // get window title
dotIndex = indexOf(title, "."); // set dot index for image title
img_title = substring(title, 0, dotIndex); // subset only image title (remove file type)
makeRectangle(xrec, yrec, xwidth, yheight);
run("Crop");
setAutoThreshold("Default");
//waitForUser("User Action", "Set the threshold for the image");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Watershed");
run("Analyze Particles...", "size=50-Infinity circularity=0.65-1.00 show=Outlines display exclude clear");
 
 // Saving outputs
saveAs("Results", results_dir+img_title+".csv");
saveAs("Drawing of "+title, results_dir+"outlines_"+title);
selectWindow(title);
close();
selectWindow("outlines_"+title);
close();
selectWindow("Results");

 */
