import os
from keras import callbacks
from model import get_model
from train_data_generators import batch_size, train_generator, validation_generator, img_width, img_height

# building model
num_classes = len(train_generator.class_indices)
model = get_model(num_classes,img_width,img_height)

# training process
weights_filename = 'tmp/weights.h5'
model_and_weights_filename = 'tmp/model.h5'
nb_train_samples = 2000
nb_validation_samples = 800
epochs = 25

if os.path.isfile(weights_filename):
	model.load_weights(weights_filename)

tb = callbacks.TensorBoard(log_dir='tmp/TensorBoard/logs', histogram_freq=0, write_graph=False, write_images=True)
es = callbacks.EarlyStopping(monitor='val_loss', min_delta=0, patience=20, verbose=0, mode='auto')
mc = callbacks.ModelCheckpoint('tmp/chkpnt.h5', monitor='val_loss', verbose=0, save_best_only=False, save_weights_only=False, mode='auto', period=1)

model.fit_generator(
	train_generator,
	steps_per_epoch=nb_train_samples // batch_size,
	epochs=epochs,
	callbacks=[tb, es, mc],
	validation_data=validation_generator,
	validation_steps=nb_validation_samples // batch_size)

model.save(model_and_weights_filename)