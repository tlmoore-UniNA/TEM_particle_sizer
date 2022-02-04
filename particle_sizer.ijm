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

//setTool("line");
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
