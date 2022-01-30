from imageai.Detection import ObjectDetection
import json

def detect(Image):
    detector = ObjectDetection()

    model_path = "/opt/irisbuild/models/yolo-tiny.h5"
    input_path = "/opt/irisbuild/input/" + Image + ".jpg"
    output_path = "/opt/irisbuild/output/" + Image + ".jpg"

    detector.setModelTypeAsTinyYOLOv3()
    detector.setModelPath(model_path)
    detector.loadModel()
    detection = detector.detectObjectsFromImage(input_image=input_path, output_image_path=output_path)
    return json.dumps(detection)

print(detect("persons"))