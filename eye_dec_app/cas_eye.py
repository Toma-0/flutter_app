import os
import numpy as np
import cv2

eye_cascade_path = '/usr/local/opt/opencv/share/opencv4/haarcascades/haarcascade_eye.xml'
eye_cascade = cv2.CascadeClassifier(eye_cascade_path)


def main():
    count = 1

    while(count != 0):
        count = eye_dec()
    
    count_img()

        

def eye_dec():
    image_dir = u"train/"
    image_list = os.listdir(r'train/')
    count = 0
    for i in range(len(image_list)):
        img_name = image_dir+str(image_list[i])
        img = cv2.imread(img_name,1)

        if img is None:
            print("写真が見当たりません")
            os.remove(img_name)
        else:
            img_gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)

            eyes = eye_cascade.detectMultiScale(img_gray)

            if len(eyes)==0 :
                print("remove")
                os.remove(img_name)
                count = 1

            elif len(eyes)>1:
                print("add")
                os.remove(img_name)
                j=0

                for (ex, ey, ew, eh) in eyes:
                    eye_img = img[ey:ey+eh,ex:ex+ew]
                    cv2.imwrite(img_name+str(j+400)+".png",eye_img)
                    j += 1
                    count = 1
    print(count)
    return count

def count_img():
    image_list = os.listdir(r'train/')
    print(len(image_list))


if __name__ == "__main__":
    main()