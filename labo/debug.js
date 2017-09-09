var xsl;
var source;
window.addEventListener("load",function() {
	document.getElementById('source').addEventListener('change', function(evt) {
		console.log(evt.target.files[0]);
		source = evt.target.files[0];
	}, false);
	document.getElementById('xsl').addEventListener('change', function(evt) {
		console.log(evt.target.files[0]);
		xsl = evt.target.files[0];
	}, false);
});



function trans() {
	var reader = new FileReader();
	reader.addEventListener('load', function (e){
		'use strict';
		var xml = e.target.result;
		// XMLのDOMをパースする
		var parser = new DOMParser();
		var dom = parser.parseFromString(xml, 'text/xml');
		var fr = new FileReader()
		fr.addEventListener('load', function(e) {
			var processor = new XSLTProcessor();
			var p = new DOMParser();
			var xd = p.parseFromString('<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"></xsl:stylesheet>', 'text/xml');
			console.log(xd);
			processor.importStylesheet(xd);
			processor.transformToFragment(dom);
		});
		fr.readAsText(xsl);
		
	}, false);
	reader.readAsText(source);
}