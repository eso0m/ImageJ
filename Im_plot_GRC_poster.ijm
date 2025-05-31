path = File.openDialog("Choose the first Mask_H file");
fname = File.getName(path); 
dir = File.getParent(path);
Dialog.create("Number of fits to display?");
Dialog.addNumber("No. of files",6);
Dialog.show();
nfile = Dialog.getNumber();
datname_h = newArray(nfile);
datname_v = newArray(nfile);
fitname_h = newArray(nfile);
fitname_v = newArray(nfile);
set = "Im1";
i = 1;
set_h = "_h";
set_v = "_v";

while (i <= nfile) {
	newset = "Im" + i;
	
	fname = replace(fname,set,newset);
	fname_h = fname;
	inpath = dir + "/" + fname_h;
	run("Text Image... ","open=" + inpath);
	getMinAndMax(min,max_h);
	
	fname_v = replace(fname_h,set_h,set_v);
	inpath = dir + "/" + fname_v;
	run("Text Image... ","open=" + inpath);
	getMinAndMax(min,max_v);
	
	fname_fit_h = replace(fname_h,"mask_h","imout_h");
	inpath = dir + "/" + fname_fit_h;
	run("Text Image... ","open=" + inpath);
	fname_fit_v = replace(fname_fit_h,"imout_h","imout_v");
	inpath = dir + "/" + fname_fit_v;
	run("Text Image... ","open=" + inpath);

	
	if (max_h > max_v) {
		max = max_h;
	} else {
		max = max_v;
	}

	selectWindow(fname_h);
	setMinAndMax(0.0,max);
	datname_h[i-1] = "dat_h_"+newset;
	rename(datname_h[i-1]);
	run("royal");

	selectWindow(fname_v);
	setMinAndMax(0.0,max);
	datname_v[i-1] = "dat_v_"+newset;
	rename(datname_v[i-1]);
	run("royal");
	
	selectWindow(fname_fit_h);
	setMinAndMax(0.0,max);
	fitname_h[i-1] = "fit_h_"+newset;
	rename(fitname_h[i-1]);
	run("royal");

	selectWindow(fname_fit_v);
	setMinAndMax(0.0,max);
	fitname_v[i-1] = "fit_v_"+newset;
	rename(fitname_v[i-1]);
	run("royal");
	
	set = newset;
	i = i + 1;
}


	Dialog.create("Crop details");
	Dialog.addNumber("Top Left x",0);
	Dialog.addNumber("Top Left y",0);
	Dialog.addNumber("Width", 500);
	Dialog.addNumber("Height", 500);
	Dialog.show();
	xcrop = Dialog.getNumber();
	ycrop = Dialog.getNumber();
	width = Dialog.getNumber();
	height = Dialog.getNumber();

	height2 = height*2;
	height3 = height*3;
	height4 = height*4;
	height5 = height*5;
	width2 = width*2;
	width3 = width*3;

	newImage("Avg_dat_h", "32-bit",width,height,1);
	newImage("Avg_dat_v", "32-bit",width,height,1);
	newImage("Avg_fit_h", "32-bit",width,height,1);
	newImage("Avg_fit_v", "32-bit",width,height,1);
	newImage("Sub_dat", "32-bit",width,height,1);
	newImage("Sub_fit", "32-bit",width,height,1);
	
	
	i = 1;	
	while (i <= nfile) {
		selectWindow(datname_h[i-1]);
		makeRectangle(xcrop,ycrop,width,height);
		run("Crop");
		
		selectWindow(fitname_h[i-1]);
		makeRectangle(xcrop,ycrop,width,height);
		run("Crop");
		
		selectWindow(datname_v[i-1]);
		makeRectangle(xcrop,ycrop,width,height);
		run("Crop");
		
		selectWindow(fitname_v[i-1]);
		makeRectangle(xcrop,ycrop,width,height);
		run("Crop");	

		imageCalculator("Add", "Avg_dat_h", datname_h[i-1]);
		imageCalculator("Add", "Avg_dat_v", datname_v[i-1]);
		imageCalculator("Add", "Avg_fit_h", fitname_h[i-1]);
		imageCalculator("Add", "Avg_fit_v", fitname_v[i-1]);
		
		close(datname_h[i-1]);
		close(datname_v[i-1]);
		close(fitname_h[i-1]);
		close(fitname_v[i-1]);
		
		i = i + 1;
	}

		imageCalculator("Add", "Sub_dat", "Avg_dat_v");
		imageCalculator("Subtract", "Sub_dat", "Avg_dat_h");
		imageCalculator("Add", "Sub_fit", "Avg_fit_v");
		imageCalculator("Subtract", "Sub_fit", "Avg_fit_h");

		selectWindow("Avg_dat_h");
		getMinAndMax(min, max_h);
		selectWindow("Avg_dat_v");
		getMinAndMax(min, max_v);
		
	if (max_h > max_v) {
		max = max_h;
	} else {
		max = max_v;
	}
		selectWindow("Avg_dat_h");
		setMinAndMax(0.0,max);
		run("royal");
		selectWindow("Avg_dat_v");
		setMinAndMax(0.0,max);
		run("Royal");
		selectWindow("Avg_fit_h");
		setMinAndMax(0.0,max);
		run("Royal");
		selectWindow("Avg_fit_v");
		setMinAndMax(0.0,max);
		run("Royal");
		
		selectWindow("Sub_fit");
		getMinAndMax(min_s, max_s);
	if (max_s > -min_s) {
		min_s = -max_s;
	} else {
		max_s = - min_s;
	}
		setMinAndMax(min_s,max_s);
		run("Phase");
		selectWindow("Sub_dat");
	    setMinAndMax(min_s,max_s);
		run("Phase");
	
		newImage("Data and Fits","32-bit",width*3,height*2,1);
	
						
			imgstr = "image=Avg_dat_h  x=0 y=0 opactity=100";
			run("Add Image...", imgstr);
			imgstr = "image=Avg_fit_h x=0 y=height opactity=100";
			run("Add Image...", imgstr);
			imgstr = "image=Avg_dat_v x=width y=0 opactity=100";
			run("Add Image...", imgstr);
			imgstr = "image=Avg_fit_v x=width  y=height opactity=100";
			run("Add Image...", imgstr);
			imgstr = "image=Sub_dat x=width2  y=0 opactity=100";
			run("Add Image...", imgstr);
			imgstr = "image=Sub_fit x=width2  y=height opactity=100";
			run("Add Image...", imgstr);


			close("avg_dat_h");
			close("avg_dat_v");
			close("avg_fit_h");
			close("avg_fit_v");
			close("sub_dat");
			close("sub_fit");

		run("Flatten");
		close("Data and Fits");
		rename("Data_and_Fits");
		
	
