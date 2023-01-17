import numpy as np
import os

from tflite_model_maker import configs
from tflite_model_maker import ExportFormat
from tflite_model_maker import model_spec
from tflite_model_maker import image_classifier
from tflite_model_maker.image_classifier import DataLoader

import tensorflow as tf
assert tf.__version__.startswith('2')
tf.get_logger().setLevel('ERROR')

from google.colab import drive
drive.mount('/content/drive')

path_to_dir = os.path.join(os.path.dirname("/content/drive/MyDrive/train_eye"), 'train_eye')

train_dir = os.path.join(path_to_dir, 'train')
test_dir = os.path.join(path_to_dir, 'validation')

train_datagen = tf.keras.preprocessing.image.ImageDataGenerator(
    preprocessing_function=tf.keras.applications.mobilenet_v2.preprocess_input,
    validation_split=0.2
)

test_datagen = tf.keras.preprocessing.image.ImageDataGenerator(
    preprocessing_function=tf.keras.applications.mobilenet_v2.preprocess_input
)

batch_size = 64
height = 160
width = 160

train_generator = train_datagen.flow_from_directory(
    batch_size=batch_size,
    directory=train_dir,
    target_size=(height, width),
    class_mode='binary',
    subset='training'
)

valid_generator = train_datagen.flow_from_directory(
    batch_size=batch_size,
    directory=train_dir,
    target_size=(height, width),
    class_mode='binary',
    subset='validation'
)

test_generator = test_datagen.flow_from_directory(
    batch_size=batch_size,
    directory=test_dir,
    target_size=(height, width),
    class_mode='binary'
)

base_model = tf.keras.applications.mobilenet_v2.MobileNetV2(
    weights='imagenet', input_shape=(height, width, 3),
    include_top=False, pooling='avg'
)

x = base_model.output
x = tf.keras.layers.Dense(1, activation='sigmoid')(x)

model = tf.keras.Model(inputs=base_model.input, outputs=x)

print(len(model.layers))
print(model.layers[0] is base_model.layers[0])
print(base_model.layers[0].trainable)
print(model.layers[0].trainable)
base_model.trainable = False
print(base_model.layers[0].trainable)
print(model.layers[0].trainable)

model.compile(optimizer=tf.keras.optimizers.RMSprop(learning_rate=0.0001),
              loss='binary_crossentropy',
              metrics=['accuracy'])

print(model.evaluate(test_generator, verbose=0))

model.fit(
    train_generator,
    steps_per_epoch=train_generator.n // batch_size,
    validation_data=valid_generator,
    validation_steps=valid_generator.n // batch_size,
    epochs=6
)

idx = [l.name for l in base_model.layers].index('block_12_expand')

for layer in base_model.layers[idx:]:
    layer.trainable = True

model.compile(optimizer=tf.keras.optimizers.RMSprop(learning_rate=0.00001),
              loss='binary_crossentropy',
              metrics=['accuracy'])

model.fit(
    train_generator,
    steps_per_epoch=train_generator.n // batch_size,
    validation_data=valid_generator,
    validation_steps=valid_generator.n // batch_size,
    epochs=20
)

model.save('train.h5')

model = tf.keras.models.load_model("/content/train.h5")

converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model_keras = converter.convert()

open('eye-model.tflite', 'wb').write(tflite_model_keras)

#https://colab.research.google.com/drive/1bgvmtZDAR2ciYCJXixz9HcECv3nbnvda?usp=sharing 上で実行


