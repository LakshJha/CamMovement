#To enable computer vision
import cv2

#variable that will define the function (task) we need to perform
#1-parenthesis if you are dealing with multiple webcams.
cam = cv2.VideoCapture(0)

while cam.isOpened():
    #it will return a border(frame) and camera visuals(visuals)
    #create two visuals to compare them and notice the movement
    visuals, frame1 = cam.read()
    visuals, frame2 = cam.read()

    diff = cv2.absdiff(frame1, frame2)

    #refining the obtained difference
    gray = cv2.cvtColor(diff, cv2.COLOR_RGB2GRAY)
    blur = cv2.GaussianBlur(gray, (5, 5), 0)

    #Removing noises
    x, thresh = cv2.threshold(blur, 20, 255, cv2.THRESH_BINARY)

    #Dilating for the better visuals
    dilated = cv2.dilate(thresh, None, iterations=5)

    #Contours for specifying the moving areas
    contours, y = cv2.findContours(dilated, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    #pass image, contour, -1 to drop everything, (0, 255, 0) for green contour, thickness of contour
    #For movement of every little things
    #cv2.drawContours(frame1, contours, -1, (0, 255, 0), 3)

    #for movement of bigger things
    for c in contours:
        if cv2.contourArea(c) < 5000:
            continue
        x, y, w, h = cv2.boundingRect(c)
        cv2.rectangle(frame1, (x,y), (x+w, y+h), (0, 255, 0), 3)
    #creating a key to end the process
    if cv2.waitKey(10) == ord('s'):
        break

    cv2.imshow("WARNING!!!! YOU ARE UNDER SURVEILLANCE", frame1)
