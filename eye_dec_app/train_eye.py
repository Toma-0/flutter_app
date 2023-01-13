import os
import numpy as np
import cv2
import pyheif
from PIL import Image

eye_cascade_path = '/usr/local/opt/opencv/share/opencv4/haarcascades/haarcascade_eye.xml'
eye_cascade = cv2.CascadeClassifier(eye_cascade_path)
image_dir = u"images/"
image_list = os.listdir(r'images/')


def main():
    for i in range(len(image_list)):
        print(image_list[i])
        if ".HEIC" in image_list[i] :
            print(".HEIC")
            img_name = image_dir+str(image_list[i])
            new_name = img_name.replace('HEIC', 'png')
            heif_file = pyheif.read(img_name)
            data = Image.frombytes(
                heif_file.mode,
                heif_file.size,
                heif_file.data,
                "raw",
                heif_file.mode,
                heif_file.stride,
                )
            data.save(new_name, "PNG")
            dec_eye(new_name,i)

        else:
            print("NO HEIC")
            img_name = image_dir+str(image_list[i])
            dec_eye(img_name,i)
       

def dec_eye(img_name,i):
    img = cv2.imread(img_name,1)
    type(img)
    img_gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
    eyes = eye_cascade.detectMultiScale(img_gray)


    j=0

    for (ex, ey, ew, eh) in eyes:
        eye_img = img[ey:ey+eh,ex:ex+ew]
        cv2.imwrite("train/train_eye_img"+str(i)+"_"+str(j)+".png",eye_img)
        j += 1


if __name__ == "__main__":
    main()