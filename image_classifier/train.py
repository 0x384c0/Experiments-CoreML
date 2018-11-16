import os

from keras.preprocessing.image import ImageDataGenerator
from keras.layers import GlobalAveragePooling2D, Dense
from keras.models import Model
from keras.applications.mobilenet import MobileNet
from keras.callbacks import EarlyStopping, TensorBoard, ModelCheckpoint

from keras import backend as K

image_scale = 1. / 255
weights_filename = 'tmp/weights.h5'
model_and_weights_filename = 'tmp/model_and_weights.h5'
train_data_dir = 'tmp/Training_Data'
validation_data_dir = 'tmp/Testing_Data'

# dimensions of our images.
img_width, img_height = 224, 224

nb_train_samples = 2000
nb_validation_samples = 800
epochs = 25
batch_size = 16
class_mode = 'categorical'

# this is the augmentation configuration we will use for training
train_datagen = ImageDataGenerator(
    rescale=image_scale,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True)

# this is the augmentation configuration we will use for testing:
# only rescaling
test_datagen = ImageDataGenerator(rescale=image_scale)

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


# create the base pre-trained model

class_count = len(train_generator.class_indices)
if K.image_data_format() == 'channels_first':
    input_shape = (3, img_width, img_height)
else:
    input_shape = (img_width, img_height, 3)

base_model = MobileNet(input_shape=input_shape, weights='imagenet', include_top=False)
x = base_model.output # add a global spatial average pooling layer
x = GlobalAveragePooling2D()(x)
x = Dense(1024, activation='relu')(x) # let's add a fully-connected layer
predictions = Dense(class_count, activation='softmax', name="classLabelProbs")(x) # and a logistic layer -- let's say we have #{class_count} classes
for layer in base_model.layers: # first: train only the top layer 
    layer.trainable = False
model = Model(inputs=base_model.input, outputs=predictions)
model.compile(optimizer='adam', loss='categorical_crossentropy')

# model = Sequential()
# model.add(Conv2D(32, (3, 3), input_shape=input_shape))
# model.add(Activation('relu'))
# model.add(MaxPooling2D(pool_size=(2, 2)))

# model.add(Conv2D(32, (3, 3)))
# model.add(Activation('relu'))
# model.add(MaxPooling2D(pool_size=(2, 2)))

# model.add(Conv2D(64, (3, 3)))
# model.add(Activation('relu'))
# model.add(MaxPooling2D(pool_size=(2, 2)))

# model.add(Flatten())
# model.add(Dense(64))
# model.add(Activation('relu'))
# model.add(Dropout(0.5))
# model.add(Dense(outputs, activation="sigmoid", name="classLabelProbs"))

# model.compile(loss='binary_crossentropy',
#               optimizer='rmsprop',
#               metrics=['accuracy'])

#load weight train save
if os.path.isfile(weights_filename):
    model.load_weights(weights_filename)


tb = TensorBoard(log_dir='tmp/TensorBoard/logs', histogram_freq=0, write_graph=False, write_images=True)
es= EarlyStopping(monitor='val_loss', min_delta=0, patience=5, verbose=0, mode='auto')
mc = ModelCheckpoint('tmp/chkpnt.h5', monitor='val_loss', verbose=0, save_best_only=False, save_weights_only=False, mode='auto', period=1)

model.fit_generator(
    train_generator,
    steps_per_epoch=nb_train_samples // batch_size,
    epochs=epochs,
    callbacks=[tb, es, mc],
    validation_data=validation_generator,
    validation_steps=nb_validation_samples // batch_size)

model.save_weights(weights_filename)
model.save(model_and_weights_filename)