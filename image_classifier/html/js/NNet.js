var _model = null
var _loading = false

class NNet{
	load(){
		if (_model == null && !_loading){
			_loading = true
			console.log("Loading model ... ")
			return tf
			.loadModel('model/model.json')
			.then((i_model) => {
				_model = i_model
				_loading = false
				return Promise.resolve()
			})
		} else{
			return Promise.resolve()
		}
	}

	predict(image){// image - element
		return new Promise((resolve,reject) => {
			if (!this.modelLoaded){ return null }
			let results = this._getPrediction(image)
			resolve(results)
		})
	}

	get modelLoaded(){
		return _model != null
	}
	
	_getPrediction(image){
		tf.nextFrame()
		let results = tf.tidy(() => {
			let tensor = this._preprocessImage(image).expandDims(0)
			const predictions = _model.predict([tensor]).dataSync()
			console.log(predictions)
			let results = Array.from(predictions)
			.map(function (p, i) {
				return {
				probability: p,
				className: IMAGENET_CLASSES[i]
				};
			}).sort(function (a, b) {
				return b.probability - a.probability;
			});
			return results
		})
		return results
	}

	_preprocessImage(image) {
		let tensor = tf.fromPixels(image)
			.resizeNearestNeighbor([224, 224])
			.toFloat();
		// if model is mobilenet, feature scale tensor image to range [-1, 1]
		// let offset = tf.scalar(127.5);
		// return tensor.sub(offset)
		// .div(offset)
		// .expandDims();
		return tensor
	}
}