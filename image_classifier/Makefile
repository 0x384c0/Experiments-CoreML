all:
	$(MAKE) setup
	$(MAKE) clean
	$(MAKE) cleanup_train_data
	$(MAKE) train
	$(MAKE) to_core_ml

setup:
	echo "Dont forget to change env"
	read -n 1
	pip install -r requirements.txt

setup_mobile_net_v2:
	echo "Dont forget to change env"
	read -n 1
	pip install -r requirements_mobile_net_v2.txt
	
setup_tf_js:
	echo "Dont forget to change env"
	read -n 1
	pip install -r requirements_tf_js.txt

train:
	python train.py

train_mobile_net_v2:
	export MOBILE_NET_V2="True"; \
	python train.py

to_core_ml:
	python to_core_ml.py

to_tf_js:
	python to_tf_js.py

#utils
clean:
	rm -f tmp/chkpnt.h5
	rm -rmakef tmp/TensorBoard/
	rm -f tmp/CustomImageClassifier.mlmodel
	rm -f tmp/model.h5

remove_corrupted_images:
	python remove_corrupted_images.py

tensorboard:
	 sleep 5 && open "http://localhost:6006" & tensorboard --logdir tmp/TensorBoard/logs

cpulimit:
	cpulimit -l 200 -p $$(pgrep python)