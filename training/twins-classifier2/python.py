import numpy as np
import cv2

cascade = cv2.CascadeClassifier('./training/twins-classifier2/cascade.xml')

img = cv2.imread('joe-mauer.jpg')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

for scale in [float(i)/10 for i in range(11, 15)]:
  for neighbors in range(2,5):
    rects = cascade.detectMultiScale(img, scaleFactor=scale, minNeighbors=neighbors, minSize=(20, 20), flags=cv2.cv.CV_HAAR_SCALE_IMAGE)
    print 'scale: %s, neighbors: %s, len rects: %d' % (scale, neighbors, len(rects))

logos = cascade.detectMultiScale(gray, 1.3, 5)
for (x,y,w,h) in logos:
  cv2.rectangle(img,(x,y),(x+w,y+h),(255,0,0),2)
  roi_gray = gray[y:y+h, x:x+w]
  roi_color = img[y:y+h, x:x+w]

cv2.imshow('img', img)
cv2.waitKey(0)
cv2.destroyAllWindows()