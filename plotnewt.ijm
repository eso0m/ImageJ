pathfile=File.openDialog("Choose the file to Open:");
filestring=File.openAsString(pathfile);
data = split(filestring," ")
linex1=data[0];
liney1=data[1];
linex2=data[2];
liney2=data[3];
makeLine(linex1, liney1, linex2, liney2);
setForegroundColor(255, 255, 255);
run("Draw");
linex1=data[0];
liney1=data[1];
linex2=data[4];
liney2=data[5];
makeLine(linex1, liney1, linex2, liney2);
setForegroundColor(255, 255, 255);
run("Draw");
linex1=data[2];
liney1=data[3];
linex2=data[4];
liney2=data[5];
makeLine(linex1, liney1, linex2, liney2);
setForegroundColor(255, 255, 255);
run("Draw");
linex1=data[0];
liney1=data[1];
linex2=data[6];
liney2=data[7];
makeLine(linex1, liney1, linex2, liney2);
setForegroundColor(255, 255, 255);
run("Draw");
nbands=data[8];
j=9
for (i=0; i<nbands; i++) {
	circx=data[j];
	circy=data[j+1];
	circh=data[j+2];
	circv=data[j+3];
	j = j+4;
	makeOval(circx, circy, circh, circv);
	setForegroundColor(255, 255, 255);
	run("Draw");
}
