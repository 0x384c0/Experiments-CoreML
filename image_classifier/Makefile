all:
	$(MAKE) setup
	$(MAKE) clean
	$(MAKE) cleanup_train_data
	$(MAKE) train
	$(MAKE) to_core_ml

clean:
	rm -f tmp/chkpnt.h5
	rm -rmakef tmp/TensorBoard/
	rm -f tmp/CustomImageClassifier.mlmodel
	rm -f tmp/model_and_weights.h5

setup:
	pip install -r requirements.txt

remove_corrupted_images:
	python remove_corrupted_images.py

train:
	python train.py

to_core_ml:
	python to_core_ml.py

tensroboard:
	 sleep 5 && open "http://localhost:6006" & tensorboard --logdir tmp/TensorBoard/logs

cpulimit:
	cpulimit -l 200 -p $(pgrep python)