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

// Loading data to process
dir = getDirectory("Choose a Directory to PROCESS"); // Get the directory to process
list = getFileList(dir); // Get list of all files in working directory
open(dir+list[0]); // Open the first file in the 

scale_len = getNumber("Enter scale bar length (in nanometers):", 0);

setTool("line"); // Manually set the scale for the first image
waitForUser("User Action", "All images in working directory must have the same magnification\n"+
	"and be of the same sample. Use the line tool to select the length\n"+
	"of the scale bar. Hold \"shift\" to draw a straight, horizontal line.");
getLine(x1, y1, x2, y2, lineWidth); // get the measurements of the line segment

// set scale for all images (globally)
run("Set Scale...", "distance=&lineWidth known=&scale_len unit=nm global");

// Crop the photo to remove scale bar area
setTool("rectangle");
waitForUser("User Action", "Use the rectangle tool to select only the image area");
getSelectionBounds(x, y, width, height);
xrec = x
yrec = y
xwidth = x+width
yheight = y+height

makeRectangle(xrec, yrec, xwidth, yheight);
run("Crop");

// Threshold the image
setAutoThreshold("Default");
waitForUser("User Action", "Set the threshold for the image");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Watershed");
run("Analyze Particles...", "size=50-Infinity circularity=0.65-1.00 show=Outlines display exclude clear");
saveAs("Results", "/home/tmoore/Dropbox/ProgrammingProjects/tem_analysis/Results.csv");

//setAutoThreshold("Default dark");
//run("Threshold...");

//run("Convert to Mask");
//run("Watershed");
//run("Analyze Particles...", "size=100-Infinity circularity=0.50-1.00 show=Outlines display exclude clear");
//saveAs("Results", "/home/tmoore/Dropbox/ProgrammingProjects/tem_analysis/Results.csv");

/*
makeLine(738, 2083, 1107, 2083);
run("Set Scale...", "distance=369 known=200 unit=nm");
setAutoThreshold("Default dark");
//run("Threshold...");
//setThreshold(0, 129);
setOption("BlackBackground", false);
run("Convert to Mask");
run("Watershed");
run("Analyze Particles...", "size=100-Infinity circularity=0.50-1.00 show=Outlines display exclude clear");
saveAs("Results", "/home/tmoore/Dropbox/ProgrammingProjects/tem_analysis/Results.csv");
 */
