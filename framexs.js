
var sourceLocation;
(function(){
	var hash = new URI(document.location).hash();
	if(hash !== null && hash.length !== 0) {
		sourceLocation = hash.substring(1);
	} else {
		sourceLocation = document.location.pathname;
	}
	console.log(sourceLocation);
})();

var XSLT_NAMESPACE = "http://www.w3.org/1999/XSL/Transform";

var vue = {
	el:"#framexs-panel",
	data: {
		version: 0.0,
		sourceLocation: sourceLocation,
		stylesheet: null
	},
	computed: {},
	methods: {
		transform: function(event) {
			console.log(event);
			var xsltElem = jQuery('#root-template stylesheet')[0];
			var importElem = jQuery(document.createElementNS("http://www.w3.org/1999/XSL/Transform","import")).attr("href",this.$stylesheet);
			xsltElem.first().before(importElem);
			console.log(xsltElem);
		},
		load: function(event) {
			console.log(event);
			jQuery.ajax({
				url: this.sourceLocation,
				dataType: "xml",
				type: "GET",
				success: function(response) {
					console.log(response);
					jQuery("#main-panel").empty().append(jQuery(response.documentElement));
				}
			});
		}
	}
}
var framexsPanel;
var onSaxonLoaded = function() {
	framexsPanel = new Vue(vue);
};
window.addEventListener('load',function() {
	if(framexsPanel == undefined) framexsPanel = new Vue(vue);
},false);

function xslt() {
	builder.xsl("stylesheet").appendChild(
		builder.xsl("template").appendChild(
			builder.elem("div").appandChild(
				builder.elem("p")
				).appendChild(builder.elem("span"))
		)
	)
}

var XSL = function(node, ns) {
	this.node = node;
	this.ns = ns;
	this.children = [];
};
var builder = {
	hns: null,
	xns: XSLT_NAMESPACE,
	xsl: function(name) {
		return document.createElementNS(XSLT_NAMESPACE, "xsl:" + name);
	},
	elem : function(name) {
		return document.createElemetNS(this.ns, name);
	},
	text : function(val) {
		return document.createTextNode();
	}
}
function distance(a,b) {
	
}