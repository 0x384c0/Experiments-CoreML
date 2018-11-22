all:
	$(MAKE) setup
	$(MAKE) download_images_google
	$(MAKE) remove_corrupted_images
	$(MAKE) create_testing_data
	$(MAKE) clean
	$(MAKE) train
	$(MAKE) to_core_ml

# install dependecies
setup:
	echo "$$(tput setaf 1; tput bold;) Dont forget to change env for: coreml $$(tput sgr0)"
	pip install -r requirements.txt

setup_mobile_net_v2:
	echo "$$(tput setaf 1; tput bold;) Dont forget to change env for: mobile_net_v2$$(tput sgr0)"
	pip install -r requirements_mobile_net_v2.txt
	
setup_tf_js:
	echo "$$(tput setaf 1; tput bold;) Dont forget to change env for: tf_js$$(tput sgr0)"
	pip install -r requirements_tf_js.txt

# training
train:
	python train.py

train_mobile_net_v2:
	export MOBILE_NET_V2="True"; \
	python train.py

#converting
to_core_ml:
	python to_core_ml.py

to_tf_js:
	mkdir -p html/model
	python to_tf_js.py

#download train data
download_images_google:
	sh scripts_image_google/download_images.sh

remove_corrupted_images:
	python scripts_prepare_images/remove_corrupted_images.py

create_testing_data:
	python scripts_prepare_images/create_testing_data.py

#utils
clean:
	rm -f tmp/chkpnt.h5
	rm -rf tmp/TensorBoard/
	rm -f tmp/CustomImageClassifier.mlmodel
	rm -f tmp/model.h5

tensorboard:
	 sleep 5 && open "http://localhost:6006" & tensorboard --logdir tmp/TensorBoard/logs

cpulimit:
	cpulimit -l 200 -p $$(pgrep python)