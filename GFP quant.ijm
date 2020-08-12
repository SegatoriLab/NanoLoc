var Location = getDirectory("Choose a directory");
var Sample = getString("Input sample", "Untreated");
var Images = getNumber("Number of images", 7);
var imageTitle = "-";
var x = 1;
/* Segment whole cell from image based on iRFP*/
macro "GFPwc [a]" {
	var i = 0;
	for (i=0; i<Images; i++) {
		open(Location+Sample+toString(x)+"Nc4.tif");
		imageTitle=getTitle();
		run("Subtract Background...", "rolling=50 sliding disable");	
		run("Split Channels");
		selectWindow(imageTitle+" (red)");
		close();
		selectWindow(imageTitle+" (green)");
		close();
		selectWindow(imageTitle+" (blue)");
		run("Auto Threshold", "method=Huang white");
		run("Analyze Particles...", "size=10000-Infinity show=Outlines add");
		selectWindow(imageTitle+" (blue)");
		close();

		var y = roiManager("count");
/* Measure GFP intensity from whole cell based on iRFP segment */
		open(Location+Sample+toString(x)+"Nc2.tif");
		selectWindow(Sample+toString(x)+"Nc2.tif");
		imageTitle=getTitle();
		run("Subtract Background...", "rolling=50 sliding disable");
		run("Split Channels");
		selectWindow(imageTitle+" (red)");
		close();
		selectWindow(imageTitle+" (blue)");
		close();
		selectWindow(imageTitle+" (green)");
	
		var j = 0;
		for (j=0; j<y; j++) {
			roiManager("Select", j);
			roiManager("Measure");
		}
		close();

/* Measure iRFP intensity from whole cell based on iRFP segment */		
		open(Location+Sample+toString(x)+"Nc4.tif");
		selectWindow(Sample+toString(x)+"Nc4.tif");
		imageTitle=getTitle();
		run("Subtract Background...", "rolling=50 sliding disable");
		run("Split Channels");
		selectWindow(imageTitle+" (green)");
		close();
		selectWindow(imageTitle+" (red)");
		close();
		selectWindow(imageTitle+" (blue)");

		var j = 0;
		for (j=0; j<y; j++) {
			roiManager("Select", j);
			roiManager("Measure");
		
		}
		close();

		x=x+1;
		roiManager("reset");
	}	
}