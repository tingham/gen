/*globals $ */

var canvas,
	context,
	rects = [];

function Rect(x, y, w, h) {
	"use strict";
	this.x = x;
	this.y = y;
	this.w = w;
	this.h = h;
	this.center = {
		x: (this.x + (this.w / 2)),
		y: (this.y + (this.h / 2))
	};
}

Rect.prototype.divide = function () {
	"use strict";
	var r = Math.random(),
		result = [];

	rects.slice(rects.length - 1, 1);

	if (r > 0.75) {
		result.push(
			new Rect(
				this.x,
				this.y,
				this.center.x - this.x,
				this.h
			)
		);

		result.push(
			new Rect(
				this.center.x,
				this.y,
				this.center.x - this.x,
				this.h
			)
		);

	} else if (r > 0.5) {
		result.push(
			new Rect(
				this.x,
				this.y,
				this.w,
				this.center.y - this.y
			)
		);

		result.push(
			new Rect(
				this.x,
				this.center.y,
				this.w,
				this.center.y - this.y
			)
		);

	} else if (r > 0.25) {
		result.push(
			new Rect(
				this.x,
				this.y,
				this.center.x - this.x,
				this.center.y - this.y
			)
		);
		result.push(
			new Rect(
				this.center.x,
				this.y,
				this.center.x - this.x,
				this.center.y - this.y
			)
		);
		result.push(
			new Rect(
				this.x,
				this.center.y,
				this.center.x - this.x,
				this.center.y - this.y
			)
		);
		result.push(
			new Rect(
				this.center.x,
				this.center.y,
				this.center.x - this.x,
				this.center.y - this.y
			)
		);
	}
	return result;
};

$(document).ready(function () {
	"use strict";
	var i, w, r, subs;
	canvas = document.getElementById("g");
	context = canvas.getContext("2d");

	canvas.width = "512";
	canvas.height = "512";
	
	context.fillStyle = "#ffffff";
	context.fillRect(0, 0, canvas.width, canvas.height);

	w = 512;
	r = new Rect(0, 0, 512, 512);
	while (w > 2) {
		r = new Rect(
			r.x,
			r.y,
			w,
			w
		);
		subs = r.divide();
		for (i = 0; i < subs.length; i++) {
			w = subs[i].w;
			rects.push(subs[i]);
		}
	}

	for (i = 1; i < rects.length; i++) {
		context.fillStyle = "#000000";
		context.fillRect(rects[i].x + 1, rects[i].y + 1, rects[i].w - 2, rects[i].h - 2);
		context.fillStyle = "#ff0000";
		context.fillRect(rects[i].center.x - 1, rects[i].center.y - 1, 2, 2);
	}
});

