import os
import numpy as np
import tensorflow as tf
 
from tflite_model_maker import model_spec
from tflite_model_maker import image_classifier
from tflite_model_maker.config import ExportFormat
from tflite_model_maker.config import QuantizationConfig
from tflite_model_maker.image_classifier import DataLoader
import matplotlib.pyplot as plt
 
# 画像データフォルダを指定
data = DataLoader.from_folder('train/')
# 画像データの中の90%をトレーニングデータとして設定
train_data, test_data = data.split(0.9)
model = image_classifier.create(train_data)
loss, accuracy = model.evaluate(test_data)
# 分類器を出力
model.export(export_dir='.', tflite_filename='eye.tflite', label_filename='eye.txt', with_metadata=False)
