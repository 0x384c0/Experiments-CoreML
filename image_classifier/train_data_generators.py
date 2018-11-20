from keras.preprocessing.image import ImageDataGenerator


img_width, img_height = 224, 224

image_scale = 1. / 255
batch_size = 16
class_mode = 'categorical'


train_data_dir = 'tmp/Training_Data'
validation_data_dir = 'tmp/Testing_Data'


train_datagen = ImageDataGenerator(
	rescale=image_scale,
	shear_range=0.2,
	zoom_range=0.2,
	horizontal_flip=True) # this is the augmentation configuration we will use for training

test_datagen = ImageDataGenerator(rescale=image_scale) # this is the augmentation configuration we will use for testing: only rescaling

train_generator = train_datagen.flow_from_directory(
	train_data_dir,
	target_size=(img_width, img_height),
	batch_size=batch_size,
	class_mode=class_mode)

validation_generator = test_datagen.flow_from_directory(
	validation_data_dir,
	target_size=(img_width, img_height),
	batch_size=batch_size,
	class_mode=class_mode)