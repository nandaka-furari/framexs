window.addEventListener("load",()=> {
	var displayElem = document.getElementById("display_b")
	if(displayElem != null)
		displayElem.appendChild(document.createTextNode("script_b.jsが読み込まれました。"))
});