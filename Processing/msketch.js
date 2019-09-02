#!/usr/bin/env node

var fs = require("fs"),
	sketchName = process.argv[2],
	today = new Date(),
	alphas = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z".split(","),
	stream,
	template;

function dateSlug(d) {
	"use strict";
	var year = d.getFullYear().toString().substr(2, 2),
		month = (d.getMonth() + 1).toString(),
		day = d.getDate().toString();

	if (month.length < 2) { month = "0" + month; }
	if (day.length < 2) { day = "0" + day; }

	return year + month + day;
}


if (sketchName === undefined) {
	sketchName = "sketch_" + dateSlug(today);
	
	while (fs.existsSync(sketchName)) {
		sketchName = "sketch_" + dateSlug(today) + alphas.shift();
	}
}

template = '// # ' + sketchName + "\n";
template += '// **Created By:** + ' + process.env.USER + "\n";
template += '// **Created On:** + ' + today.toDateString() + "\n";
template += '// ' + "\n\n";
template += "int tick = 0;\n";
template += 'String outputName = "data/output/" + System.currentTimeMillis() + "/";' + "\n\n";
template += "void setup ()\n";
template += "{\n";
template += "  // P3D, P2D \n";
template += "  size(512, 512, P2D);\n";
template += "}\n\n";
template += "void draw ()\n";
template += "{\n";
template += "	long t = System.currentTimeMillis();\n";
template += "	if (t % 30 == 0) {\n";
template += '		save(outputName + "s-" + t + ".jpg");' + "\n";
template += "	}\n";
template += "}\n\n";

fs.mkdirSync("./" + sketchName);

stream = fs.createWriteStream("./" + sketchName + "/" + sketchName + ".pde");
stream.write(template);
stream.end();

fs.mkdirSync("./" + sketchName + "/data");
fs.mkdirSync("./" + sketchName + "/data/output");
fs.mkdirSync("./" + sketchName + "/data/input");

process.stdout.write("./" + sketchName + "/" + sketchName + ".pde");
