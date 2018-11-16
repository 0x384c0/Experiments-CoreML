all:
	$(MAKE) cleanup_train_data
	$(MAKE) train
	$(MAKE) to_core_ml

remove_corrupted_images:
	python remove_corrupted_images.py

train:
	python train.py

to_core_ml:
	python to_core_ml.py

tensroboard:
	 sleep 5 && open "http://localhost:6006" & tensorboard --logdir tmp/TensorBoard/logs