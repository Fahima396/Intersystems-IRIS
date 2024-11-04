Class Sample.HL7Rest Extends Sample.REST.Base
{

Parameter HandleCorsRequest = 1;

Parameter Version = "1.0.6";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Server Info -->
<Route Url="/" Method="GET" Call="GetInfo" Cors="true"/>
<!-- Get all records of Person class -->
<Route Url="/all" Method="GET" Call="GetAllMsgs"/>
<!-- Swagger specs -->
<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />
<!-- GET method to return JSON for a given person id-->
<Route Url="/hl7/:id" Method="GET" Call="GetHL7"/>
<!-- Update a person with id-->
<Route Url="/hl7/:id" Method="PUT" Call="UpdateMsg"/>
<!-- Delete a person with id-->
<Route Url="/hl7/:id" Method="DELETE" Call="DeleteMsg"/>
<!-- Create a person-->
<Route Url="/create" Method="POST" Call="CreateHL7Msgs"/>
<!-- Create random persons-->
<Route Url="/hl7/:amount" Method="POST" Call="CreateRandomHL7Msgs"/>


</Routes>
}

/// PersonsREST general information
ClassMethod GetInfo() As %Status
{
  SET version = ..#Version
  SET info = {
    "version": (version)
  }
  RETURN ..%ProcessResult($$$OK, info)
}

ClassMethod GetAllMsgs() As %Status
{
    #dim tSC As %Status = $$$OK

    // Fetch instances of Sample.HL7 using an extent query
    Set result = ##class(Sample.HL7).ExtentFunc()

    // Set the response content type to JSON
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Write "["

    // Loop through the result set
    if result.%Next() {
        Set hl7 = ##class(Sample.HL7).%OpenId(result.ID)
        // Export the first HL7 instance as JSON
        Do hl7.%JSONExport()
    }

    // Loop through the remaining instances
    While result.%Next() {
        Write ","
        Set hl7 = ##class(Sample.HL7).%OpenId(result.ID)
        // Export each HL7 instance as JSON
        Do hl7.%JSONExport()
    }

    Write "]"

    Quit tSC
}

/// Return one record fo dc.Sample.Person
ClassMethod GetHL7(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException


    #; Set the response header to plain text
    Set %response.ContentType = ..#CONTENTTYPEJSON

    Set hl7 = ##class(Sample.HL7).%OpenId(id)

    If '$IsObject(hl7) Quit ..Http405()

    Do hl7.%JSONExport()

    Quit tSC
}

/// Creates a new dc.Sample.Person record
ClassMethod CreateHL7Msgs() As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    Set hl7 = ##class(Sample.HL7).%New()
    Set data=%request.Content


    $$$TOE(tSC,hl7.%JSONImport(data))
    $$$TOE(tSC,hl7.%Save())

    Set %response.Status = 204
    Set %response.ContentType = ..#CONTENTTYPEJSON
    //d data.%ToJSON()
    Do hl7.%JSONExport()

    Quit tSC
}

/// Update a record in dc.Sample.Person with id
ClassMethod UpdateMsg(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    Set hl7 = ##class(Sample.HL7).%OpenId(id)
    If '$IsObject(hl7) Return ..Http405()
    Set data=%request.Content

    $$$TOE(tSC,hl7.%JSONImport(data))
    $$$TOE(tSC,hl7.%Save())

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Do hl7.%JSONExport()

    Quit tSC
}

/// Delete a record with id in dc.Sample.Person
ClassMethod DeleteMsg(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    Set hl7 = ##class(Sample.HL7).%OpenId(id)
    If '$IsObject(hl7) Return ..Http405()

    $$$TOE(tSC,hl7.%DeleteId(id))

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON

    Quit tSC
}

ClassMethod CreateRandomHL7Msgs(amount As %Integer) As %Status
{
#dim tSC As %Status = $$$OK
    Set %response.ContentType = ..#CONTENTTYPEJSON

    Try {
        set status = ##class(Sample.HL7).AddTestData(amount)
        $$$ThrowOnError(status)
        Set message = "Created "_amount_" random persons in Sample.Person data"
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
