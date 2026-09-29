import cv2
import requests
from ultralytics import YOLO

model = YOLO('runs/detect/fruit_web_model/weights/best.pt')

API_URL = "http://<SERVER_IP>/smart_farm/api/store_inventory.php"

cap = cv2.VideoCapture(0)

while cap.isOpened():

    ret, frame = cap.read()

    if not ret:
        break

    results = model(frame)

    counts = {
        'apple': 0,
        'mango': 0,
        'orange': 0
    }

    for r in results:
        for box in r.boxes:

            cls_id = int(box.cls[0])
            class_name = model.names[cls_id]

            if class_name in counts:
                counts[class_name] += 1

    payload = {
        'apple': counts['apple'],
        'mango': counts['mango'],
        'orange': counts['orange']
    }

    try:
        res = requests.post(
            API_URL,
            json=payload,
            timeout=2
        )

        print("API Response:", res.json())

    except Exception as e:
        print("Error sending inventory data:", e)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
