/// Detect objects and persons into images and videos
Class dc.imageanalyzer.Detector
{

/// Detect person and objects inside image parameter
ClassMethod GetImageFeatures(Image) [ Language = python ]
{
    from imageai.Detection import ObjectDetection
    import json
    
    detector = ObjectDetection()

    model_path = "/opt/irisbuild/models/resnet50_coco_best_v2.1.0.h5"
    input_path = "/opt/irisbuild/input/" + Image
    output_path = "/opt/irisbuild/output/" + Image

    detector.setModelTypeAsRetinaNet()
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
