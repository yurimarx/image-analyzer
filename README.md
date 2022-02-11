
## About Image Analyzer Application
This is an application to Analyze images and videos using Machine Learning and ImageAI from InterSystems IRIS Embedded Python  

## Installation
1. Clone/git pull the repo into any local directory

```
$ git clone https://github.com/yurimarx/image-analyzer.git
```

2. Open a Docker terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container:

```
$ docker-compose up -d 
```

4. Go to your Postman (or other similar REST client) and config the request like this image:

![Request Image Analysis input](https://github.com/yurimarx/image-analyzer/raw/main/postman_input.png "Request Image Analysis input")

- Method: POST
- URL: http://localhost:52773/image-analyzer/analyzeImage (if you want to run online: http://ymservices.tech:52773/image-analyzer/analyzeImage)
- Body: form-data
- Key: file (the name of file field must be file) and type File 
- Value: select an image with persons and/or objects from your computer

5. Click send and get a response with detected objects like this:

![Request Image Analysis output](https://github.com/yurimarx/image-analyzer/raw/main/postman_output.png "Request Image Analysis output")


# Credits
This application used ImageAI framework

# Run online
http://ymservices.tech:52773/image-analyzer/analyzeImage

@misc {ImageAI,
    author = "Moses and John Olafenwa",
    title  = "ImageAI, an open source python library built to empower developers to build applications and systems  with self-contained Computer Vision capabilities",
    url    = "https://github.com/OlafenwaMoses/ImageAI",
    month  = "mar",
    year   = "2018--"
}