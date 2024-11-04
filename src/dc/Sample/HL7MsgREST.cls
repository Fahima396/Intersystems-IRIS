Class dc.Sample.HL7MsgREST Extends Sample.REST.Base
{

Parameter HandleCorsRequest = 1;

Parameter Version = "1.0.6";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Server Info -->
<Route Url="/all" Method="GET" Call="GetInfo" Cors="true"/>
<!-- Get all records of HL7 class -->
<Route Url="/hl7/all" Method="GET" Call="GetAllHL7s"/>
<!-- Swagger specs -->
<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />
<!-- GET method to return JSON for a given hl7 id-->
<Route Url="/:id" Method="GET" Call="GetHL7"/>
<!-- Update a hl7 with id-->
<Route Url="/:id" Method="PUT" Call="UpdateHL7"/>
<!-- Delete a hl7 with id-->
<Route Url="/:id" Method="DELETE" Call="DeleteHL7"/>
<!-- Create a hl7-->
<Route Url="/" Method="POST" Call="CreateHL7"/>
<!-- Create random hl7s-->
<Route Url="/gen/:amount" Method="POST" Call="CreateRandomHL7s"/>


</Routes>
}

/// HL7sREST general information
ClassMethod GetInfo() As %Status
{
  SET version = ..#Version
  SET info = {
    "version": (version)
  }
  RETURN ..%ProcessResult($$$OK, info)
}

/// Retreive all the records of dc.Sample.HL7
ClassMethod GetAllHL7s() As %Status
{

    #dim tSC As %Status = $$$OK

    Set rset = ##class(dc.Sample.HL7).ExtentFunc()

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Write "["
    if rset.%Next() {
        Set hl7 = ##class(dc.Sample.HL7).%OpenId(rset.ID)    
        Do hl7.%JSONExport()
    }
    While rset.%Next() {   
        Write ","
        Set hl7 = ##class(dc.Sample.HL7).%OpenId(rset.ID)    
        Do hl7.%JSONExport()
    }
    Write "]"
    
    Quit tSC
}

/// Return one record fo dc.Sample.HL7
ClassMethod GetHL7(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException


    #; Set the response header to plain text
    Set %response.ContentType = ..#CONTENTTYPEJSON

    Set hl7 = ##class(dc.Sample.HL7).%OpenId(id)

    If '$IsObject(hl7) Quit ..Http405()

    Do hl7.%JSONExport()

    Quit tSC
}

/// Creates a new dc.Sample.HL7 record
ClassMethod CreateHL7() As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    #dim tService  AS dc.HL7Servce
    Set hl7 = ##class(dc.Sample.HL7).%New()
    Set data=%request.Content


    $$$TOE(tSC,hl7.%JSONImport(data))
    Do ##class(HS.Util.StreamUtils).Base64Decode(hl7.RawContent,.tDecodedStream)
    Set hl7.DecodedHL7Msg = tDecodedStream
    $$$TOE(tSC,hl7.%Save())
    $$$TOE(tSC, ##class(Ens.Director).CreateBusinessService("dc.HL7Servce", .tService))
    $$$TOE(tSC, tService.OnProcessInput(hl7))

    Set %response.Status = 204
    Set %response.ContentType = ..#CONTENTTYPEJSON
    //d data.%ToJSON()
    Do hl7.%JSONExport()

    Quit tSC
}

/// Update a record in dc.Sample.HL7 with id
ClassMethod UpdateHL7(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    Set hl7 = ##class(dc.Sample.HL7).%OpenId(id)
    If '$IsObject(hl7) Return ..Http405()
    Set data=%request.Content

    $$$TOE(tSC,hl7.%JSONImport())
    $$$TOE(tSC,hl7.%Save())

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Do hl7.%JSONExport()

    Quit tSC
}

/// Delete a record with id in dc.Sample.HL7
ClassMethod DeleteHL7(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    Set hl7 = ##class(dc.Sample.HL7).%OpenId(id)
    If '$IsObject(hl7) Return ..Http405()

    $$$TOE(tSC,hl7.%DeleteId(id))

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON

    Quit tSC
}

ClassMethod CreateRandomHL7s(amount As %Integer) As %Status
{
#dim tSC As %Status = $$$OK
    Set %response.ContentType = ..#CONTENTTYPEJSON

    Try {
        set status = ##class(dc.Sample.HL7).AddTestData(amount)
        $$$ThrowOnError(status)
        Set message = "Created "_amount_" random hl7s in Sample.HL7 data"
    } Catch(ex) {
        Set tSC = ex.Code
    }
    Return tSC
}

ClassMethod SwaggerSpec() As %Status
{
  Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
  Do swagger.info.%Remove("x-ISC_Namespace")
  Set swagger.basePath = "/crud"
  Set swagger.info.title = "InterSystems IRIS REST CRUD demo"
  Set swagger.info.version = "0.1"
  Set swagger.host = "localhost:52773"
  Return ..%ProcessResult($$$OK, swagger)
}

}
