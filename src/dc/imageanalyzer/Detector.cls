/// Detect objects and persons into images and videos
Class dc.imageanalyzer.Detector
{

/// Detect person and objects inside image parameter
ClassMethod GetImageFeatures(Image) [ Language = python ]
{
    from imageai.Detection import ObjectDetection
    import json
    
    detector = ObjectDetection()

    model_path = "/opt/irisbuild/models/yolo-tiny.h5"
    input_path = "/opt/irisbuild/input/" + Image + ".jpg"
    output_path = "/opt/irisbuild/output/" + Image + ".jpg"

    detector.setModelTypeAsTinyYOLOv3()
    detector.setModelPath(model_path)
    detector.loadModel()
    detection = detector.detectObjectsFromImage(input_image=input_path, output_image_path=output_path)
    return json.dumps(detection)
}

/// Get JSON
ClassMethod GetJSON(pythonObj) [ Language = python ]
{
    import json
    return json.dumps(pythonObj)
}

/// Description
ClassMethod GetImageAI(Image) As %Status
{
    Set sc = $$$OK
    Write ..GetImageFeatures(Image)
    Return sc
}

}
