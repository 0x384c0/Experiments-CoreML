//UI
var 
resultsBox,
imageBox,
loadingIndicator,
//nnet
nnet

//LifeCycle
window.addEventListener("DOMContentLoaded", domContentLoaded);
function domContentLoaded() {
	resultsBox = document.getElementById("resultsBox")
	imageBox = document.getElementById("imageBox")
	loadingIndicator = document.getElementById("loadingIndicator")
	document.getElementById("predictButton").addEventListener('click',predictClick)
	document.getElementById('picField').onchange = didSelectImage

	showLoading()
	nnet = new NNet()
	nnet
	.load()
	.then(() => {
		console.log("Model loaded")
		hideLoading()
	})
}

//UI Actions
function predictClick(){
	showLoading()
	nnet
	.predict(imageBox)
	.then((results) => {
		resultsBox.innerHTML = ""
		results.forEach((p) => {
			resultsBox.innerHTML += p.className + "&emsp;" + p.probability.toFixed(6) + "<br>"
		})
		hideLoading()
	})
}
function didSelectImage(evt) {
	var tgt = evt.target || window.event.srcElement,
		files = tgt.files
		
	if (FileReader && files && files.length) {
		var fr = new FileReader();
		fr.onload = function () {
			imageBox.src = fr.result;
		}
		fr.readAsDataURL(files[0]);
	} else {
		console.log("FileReader not supported")
	}
}


//loading
function showLoading(){
	loadingIndicator.className = "loader"
}
function hideLoading(){
	loadingIndicator.className = 'hidden'
}