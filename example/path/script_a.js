window.addEventListener("load",()=> {
	var displayElem = document.getElementById("display_a")
	if(displayElem != null)
		displayElem.appendChild(document.createTextNode("script_a.jsが読み込まれました。"))
});
