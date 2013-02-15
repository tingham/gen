/*globals $, Raphael */

var paper,
	canvas,
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
		result = [],
		i;

	for (i = 0; i < rects.length; i++) {
		if (rects[i].x === this.x &&
				rects[i].y === this.y) {
			rects.slice(i, 1);
		}
	}

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
	}

	return result;
};

$(document).ready(function () {
	"use strict";
	var i, w, r, subs, bg;

	paper = new Raphael("g", 512, 512);
	bg = paper.rect(0, 0, 512, 512);
	bg.attr("fill", "#fff");

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
		rects[i].rect = paper.rect(rects[i].x + 1, rects[i].y + 1, rects[i].w - 2, rects[i].h - 2).attr("fill", "none").attr("stroke", "#000");
	}
});

