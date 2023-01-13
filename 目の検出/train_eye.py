import os
import pathlib
import numpy as np
import tensorflow as tf
import cv2

from tflite_model_maker import model_spec
from tflite_model_maker import image_classifier
from tflite_model_maker.config import ExportFormat
from tflite_model_maker.config import QuantizationConfig
from tflite_model_maker.image_classifier import DataLoader
import matplotlib.pyplot as plt

eye_cascade_path = '/usr/local/opt/opencv/share/'\
                   'OpenCV/haarcascades/haarcascade_eye.xml'

eye_cascade = cv2.CascadeClassifier(eye_cascade_path)

image_dir = "images/"
image_list = list(pathlib.Path(image_dir))

for i in range(len(image_list)):
    img_name = str(image_list[i])
    #img_encode = np.fromfile(img_name,dtype=np.uint8)
    img = cv2.imdecode(img_name, cv2.IMREAD_COLOR)
    img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    eyes = eye_cascade.detectMultiScale(img_gray)

    j = 0
    for (ex, ey, ew, eh) in eyes:
        eye_img = img[ey:ey+eh,ex:ex+ew]
        cv2.imwrite("train/train_eye_img"+str(i)+"_"+str(j)+".png",eye_img)
        j += 1


data = DataLoader.from_folder('train/')
train_data, test_data = data.split(0.9)
model = image_classifier.create(train_data)
loss, accuracy = model.evaluate(test_data)

model.export(export_dir='.')
model.export(export_dir='.', export_format=ExportFormat.LABEL)