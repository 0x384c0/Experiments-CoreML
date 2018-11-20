import os
import coremltools
import keras
from keras.models import load_model
from keras.utils.generic_utils import CustomObjectScope
from train_data_generators import train_generator, image_scale

model_filename = 'tmp/model.h5'
coreml_filename = 'tmp/CustomImageClassifier.mlmodel'

#get labels
class_labels = list(train_generator.class_indices.keys())

with CustomObjectScope({'relu6': keras.applications.mobilenet.relu6,'DepthwiseConv2D': keras.applications.mobilenet.DepthwiseConv2D}): # https://github.com/keras-team/keras/issues/7431#issuecomment-334959500
	model = load_model(model_filename)

	coreml_model = coremltools.converters.keras.convert(model,
		input_names="image",
		image_input_names="image",
		output_names="classLabelProbs",
		image_scale=image_scale,
		class_labels=class_labels,
		is_bgr=True)

	coreml_model.save(coreml_filename)
	print(len(class_labels))