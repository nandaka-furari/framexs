window.addEventListener("load",()=> {
	var displayElem = document.getElementById("display_c")
	if(displayElem != null)
		displayElem.appendChild(document.createTextNode("script_c.jsが読み込まれました。"))
});