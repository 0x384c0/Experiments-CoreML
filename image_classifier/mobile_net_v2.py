from keras import layers, models, optimizers
from keras.applications.mobilenetv2 import MobileNetV2
from keras import backend as K

def get_model(num_classes,img_width,img_height):
	print("Using MobileNet V2")
	if K.image_data_format() == 'channels_first':
		input_shape = (3, img_width, img_height)
	else:
		input_shape = (img_width, img_height, 3)

	pretrained_model = MobileNetV2(input_shape=input_shape, include_top=False, weights='imagenet')
	for layer in pretrained_model.layers: # first: train only the top layer 
		layer.trainable = False
	model = models.Sequential()
	model.add(pretrained_model)
	model.add(layers.GlobalAveragePooling2D())
	model.add(layers.Dense(num_classes, activation='softmax'))
	model.compile(loss='categorical_crossentropy',
				optimizer=optimizers.RMSprop(lr=1e-4))
	return model