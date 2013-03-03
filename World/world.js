/*global $ */

var log =
	function (msg) {
		"use strict";
		$("div.debug").text(msg);
	},
	tick = function () {
		"use strict";
		log("Tick");
	},
	resize = function () {
		"use strict";
		$("div.debug").position.top = $(window).height() - 22;
	};
$(document).ready(function () {
	"use strict";
	var debug = $(document.createElement("div")).addClass("debug");
	$("body").append(debug);

	window.resize(resize);
	setInterval(tick, 30);
});


