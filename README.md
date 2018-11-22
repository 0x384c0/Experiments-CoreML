### Create MobileNet model for ios
```
alias python=python3
cd image_classifier/
source <virtual_env_path>/bin/activate
make
```

### Create MobileNet model for tensorflow.js
```
alias python=python3
cd image_classifier/
source <virtual_env_path>/bin/activate
make setup_tf_js
make download_images_google
make remove_corrupted_images
make create_testing_data
make clean
make train

deactivate
source <virtual_env_path_for_tensorflow_js>/bin/activate
make setup_tf_js
make to_tf_js

```

### Create MobileNetV2 model for ios
```
alias python=python3
cd image_classifier/

source <virtual_env_path>/bin/activate
make setup
make download_images_google
make remove_corrupted_images
make create_testing_data
make clean

deactivate
source <virtual_env_path_for_MobileNetV2>/bin/activate
make setup_mobile_net_v2
make train_mobile_net_v2

deactivate
source <virtual_env_path>/bin/activate
make to_core_ml
```