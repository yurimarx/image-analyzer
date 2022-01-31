Class dc.imageanalyzer.ImageAnalyzerRESTApp Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CONTENTTYPE = "application/json";

Parameter Version = "1.0.0";

Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Server Info -->
<Route Url="/" Method="GET" Call="GetInfo" Cors="true"/>
<!-- Swagger specs -->
<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />

<!-- Detect objects inside an image -->
<Route Url="/analyzeImage" Method="POST" Call="AnalyzeImage" />

<!-- post image -->
<Route Url="/postFile" Method="POST" Call="PostFile" />


</Routes>
}

// Detect objects inside an image

ClassMethod AnalyzeImage() As %Status
{
    Set tSC = $$$OK
    
    try {
        Set source = %request.GetMimeData("file")
        Set destination=##class(%Stream.FileBinary).%New()
        Set destination.Filename="/opt/irisbuild/input/"_source.FileName
        set tSC=destination.CopyFrom(source) //reader open the file
        set result=destination.%Save()
        
        Set %response.ContentType = ..#CONTENTTYPEJSON
        Set %response.Headers("Access-Control-Allow-Origin")="*"

        Write ##class(dc.imageanalyzer.Detector).GetImageAI(source.FileName)

        Set tSC=$$$OK
    
    //returns error message to the user
    } catch e {
        Set tSC=e.AsStatus()
        Set pOutput = tSC
    }

    Quit tSC
}

ClassMethod PostFile() As %Status
{
   
    //try to do the actions
    try {
        Set info = {}
        Set source = %request.GetMimeData("file")
        Set destination=##class(%Stream.FileBinary).%New()
        Set destination.Filename="/opt/irisbuild/input/"_source.FileName
        set tSC=destination.CopyFrom(source) //reader open the file
        set result=destination.%Save()
        set info.return = result
        set info.message = "File saved into /opt/irisbuild/input/"_source.FileName
        
        Set %response.ContentType = ..#CONTENTTYPEJSON
        Set %response.Headers("Access-Control-Allow-Origin")="*"

        Write info.%ToJSON()

        Set tSC=$$$OK
    
    //returns error message to the user
    } catch e {
        Set tSC=e.AsStatus()
        Set pOutput = tSC
    }

    Quit tSC
}

/// General information
ClassMethod GetInfo() As %Status
{
  SET version = ..#Version
  SET fmt=##class(%SYS.NLS.Format).%New("ptbw")
  
  SET info = {
    "Service": "Image Analyzer API",
    "version": (version),
    "Developer": "Yuri Gomes",
    "Status": "Ok",
    "Date": ($ZDATETIME($HOROLOG))
  }
  Set %response.ContentType = ..#CONTENTTYPEJSON
  Set %response.Headers("Access-Control-Allow-Origin")="*"

  Write info.%ToJSON()
  Quit $$$OK
}

ClassMethod %ProcessResult(pStatus As %Status = {$$$OK}, pResult As %DynamicObject = "") As %Status [ Internal ]
{
  #dim %response As %CSP.Response
  SET tSC = $$$OK
  IF $$$ISERR(pStatus) {
    SET %response.Status = 500
    SET tSC = ..StatusToJSON(pStatus, .tJSON)
    IF $isobject(tJSON) {
      SET pResult = tJSON
    } ELSE {
      SET pResult = { "errors": [ { "error": "Unknown error parsing status code" } ] }
    }
  } 
  ELSEIF pStatus=1 {
    IF '$isobject(pResult){
      SET pResult = {
      }
    }
  }
  ELSE {
    SET %response.Status = pStatus
    SET error = $PIECE(pStatus, " ", 2, *)
    SET pResult = {
      "error": (error)
    }
  }
  
  IF pResult.%Extends("%Library.DynamicAbstractObject") {
    WRITE pResult.%ToJSON()
  }
  ELSEIF pResult.%Extends("%JSON.Adaptor") {
    DO pResult.%JSONExport()
  }
  ELSEIF pResult.%Extends("%Stream.Object") {
    DO pResult.OutputToDevice()
  }
  
  QUIT tSC
}

ClassMethod SwaggerSpec() As %Status
{
  Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
  Do swagger.info.%Remove("x-ISC_Namespace")
  Set swagger.basePath = "/image-analyzer" 
  Set swagger.info.title = "Image Analyzer API"
  Set swagger.info.version = "1.0"
  Set swagger.host = "localhost:52773"
  Return ..%ProcessResult($$$OK, swagger)
}

}
