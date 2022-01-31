/// Detect objects and persons into images and videos
Class dc.imageanalyzer.Detector
{

/// Detect person and objects inside image parameter
ClassMethod GetImageFeatures(Image) [ Language = python ]
{
    # import imageai and json libs
    from imageai.Detection import ObjectDetection
    import json
    
    # instantiate imageai
    detector = ObjectDetection()

    # set retinanet as model to detect objects
    model_path = "/opt/irisbuild/models/resnet50_coco_best_v2.1.0.h5"
    # set folder to receive the image to be processed
    input_path = "/opt/irisbuild/input/" + Image
    # set folder to stores the results (visual tags inside image processed)
    output_path = "/opt/irisbuild/output/" + Image

    # instantiate retina model
    detector.setModelTypeAsRetinaNet()
    
    # set trained detection model - retina
    detector.setModelPath(model_path)
    # load the model
    detector.loadModel()
    # do the object image detection
    detection = detector.detectObjectsFromImage(input_image=input_path, output_image_path=output_path)
    # return json with the results of the processing 
    # if you want you can see the result image inside output folder
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
