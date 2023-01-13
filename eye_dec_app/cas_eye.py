import os
import numpy as np
import cv2

eye_cascade_path = '/usr/local/opt/opencv/share/opencv4/haarcascades/haarcascade_eye.xml'
eye_cascade = cv2.CascadeClassifier(eye_cascade_path)
image_dir = u"train/"
image_list = os.listdir(r'train/')

def main():
    for i in range(len(image_list)):
        img_name = image_dir+str(image_list[i])
        img = cv2.imread(img_name,1)
        type(img)
        img_gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)

        eyes = eye_cascade.detectMultiScale(img_gray)

        if not eyes :
            os.remove(img_name)

        elif len(eyes)>1:
            j=0

            for (ex, ey, ew, eh) in eyes:
                eye_img = img[ey:ey+eh,ex:ex+ew]
                cv2.imwrite(img_name+str[j]+".png",eye_img)
                j += 1

if __name__ == "__main__":
    main()