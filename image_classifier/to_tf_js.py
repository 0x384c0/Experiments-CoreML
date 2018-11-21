import json
import tensorflowjs as tfjs
import keras
from keras.models import load_model
from keras.utils.generic_utils import CustomObjectScope
from train_data_generators import train_generator

model_filename = "tmp/model.h5"
tfjs_target_path = "html/model/"
tfjs_classes_file = "html/model/classes.js"

class_labels = list(train_generator.class_indices.keys())
class_labels_string = json.dumps(class_labels)

text_file = open(tfjs_classes_file, "w+")
text_file.write("const IMAGENET_CLASSES = %s" % class_labels_string)
text_file.close()

exit()

print("Keras must be 2.1.6, model must be MobileNet")
# with CustomObjectScope({'relu6': keras.layers.ReLU(6.),'DepthwiseConv2D': keras.layers.DepthwiseConv2D}): # https://github.com/keras-team/keras/issues/7431#issuecomment-413450470
with CustomObjectScope({'relu6': keras.applications.mobilenet.relu6,'DepthwiseConv2D': keras.applications.mobilenet.DepthwiseConv2D}): # https://github.com/keras-team/keras/issues/7431#issuecomment-334959500
	model = load_model(model_filename)
	model.summary()
	tfjs.converters.save_keras_model(model, tfjs_target_path)
