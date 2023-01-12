import os
import numpy as np
import tensorflow as tf
import cv2

from tflite_model_maker import model_spec
from tflite_model_maker import image_classifier
from tflite_model_maker.config import ExportFormat
from tflite_model_maker.config import QuantizationConfig
from tflite_model_maker.image_classifier import DataLoader
import matplotlib.pyplot as plt

data = DataLoader.from_folder('train/')
train_data, test_data = data.split(0.9)
model = image_classifier.create(train_data)
loss, accuracy = model.evaluate(test_data)

model.export(export_dir='.')
model.export(export_dir='.', export_format=ExportFormat.LABEL)