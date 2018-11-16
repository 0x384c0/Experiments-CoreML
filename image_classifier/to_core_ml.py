import os
import coremltools
import keras
from keras.models import load_model
from keras.utils.generic_utils import CustomObjectScope
from keras.preprocessing.image import ImageDataGenerator

image_scale = 1. / 255
model_and_weights_filename = 'tmp/model_and_weights.h5'
model_and_weights_coreml_filename = 'tmp/CustomImageClassifier.mlmodel'
train_data_dir = 'tmp/Training_Data'

#get labels
train_data_dir = 'tmp/Training_Data'
img_width, img_height = 224, 224
batch_size = 16
class_mode = 'categorical'
train_datagen = ImageDataGenerator(
    rescale=image_scale,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True)
train_generator = train_datagen.flow_from_directory(
    train_data_dir,
    target_size=(img_width, img_height),
    batch_size=batch_size,
    class_mode=class_mode)

class_labels = list(train_generator.class_indices.keys())

with CustomObjectScope({'relu6': keras.applications.mobilenet.relu6,'DepthwiseConv2D': keras.applications.mobilenet.DepthwiseConv2D}): # https://github.com/keras-team/keras/issues/7431#issuecomment-334959500
	model = load_model(model_and_weights_filename)

	coreml_model = coremltools.converters.keras.convert(model,
		input_names="image",
		image_input_names="image",
		output_names="classLabelProbs",
		image_scale=image_scale,
		class_labels=class_labels,
		is_bgr=True)

	coreml_model.save(model_and_weights_coreml_filename)
	print(len(class_labels))