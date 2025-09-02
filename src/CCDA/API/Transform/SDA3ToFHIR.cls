Class CCDA.API.Transform.SDA3ToFHIR Extends (HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR, HS.HC.Util.Trace.Helper)
{

Parameter BaseUrl As STRING = "http://CVS-IRIs/CCDAToFHIRPipeline";

Parameter OverrideDTLBasePackage As STRING = "Local.FHIR.DTL";

/// This method is needed to match the expected TransformStream signature
ClassMethod TransformStream(pStream As %Stream.Object, pSourceClass As %String, pMetadataSetKey As %String, pPatientResourceId As %String = "") As HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR
{
    #dim tSC As %Status = $$$OK
    #dim tTransform As HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR = ""
    
    Try {
        // Load the FHIR schema first
        Set tSchema = ##class(HS.FHIRServer.Schema).LoadSchema(pMetadataSetKey)
        If '$IsObject(tSchema) {
            Set tSC = $$$ERROR($$$GeneralError, "Failed to load FHIR schema for: "_pMetadataSetKey)
            $$$ThrowStatus(tSC)
        }
        
        // Create the transformer instance with the schema
        Set tTransform = ..%New(tSchema)
        If '$IsObject(tTransform) {
            Set tSC = $$$ERROR($$$GeneralError, "Failed to create transformer instance")
            $$$ThrowStatus(tSC)
        }
        
        // Convert stream to SDA3 Container
        Set tReader = ##class(%XML.Reader).%New()
        Set tSC = tReader.OpenStream(pStream)
        $$$ThrowOnError(tSC)
        
        Do tReader.Correlate("Container", "HS.SDA3.Container")
        Do tReader.Next(.tContainer, .tSC)
        $$$ThrowOnError(tSC)
        
        If '$IsObject(tContainer) {
            Set tSC = $$$ERROR($$$GeneralError, "Failed to parse SDA3 Container from stream")
            $$$ThrowStatus(tSC)
        }
        
        // Transform the container
        Do tTransform.TransformContainer(tContainer, pPatientResourceId)
        
    }
    Catch ex {
        Set tSC = ex.AsStatus()
        // Create empty transformer on error to ensure we return something
        If '$IsObject(tTransform) {
            Set tSchema = ##class(HS.FHIRServer.Schema).LoadSchema("HL7v40") // Default schema
            Set tTransform = ##class(HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR).%New(tSchema)
        }
    }
    
    Quit tTransform
}

/// Original TransformObject method
ClassMethod TransformObject(source, fhirVersion As %String, patientId As %String = "", encounterId As %String = "") As HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR
{
    #dim tSC As %Status = $$$OK
    #dim tTransform As HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR = ""
    
    Try {
        Set tSchema = ##class(HS.FHIRServer.Schema).LoadSchema(fhirVersion)
        If '$IsObject(tSchema) {
            Set tSC = $$$ERROR($$$GeneralError, "Failed to load FHIR schema for: "_fhirVersion)
            $$$ThrowStatus(tSC)
        }
        
        Set tTransform = ..%New(tSchema)
        If '$IsObject(tTransform) {
            Set tSC = $$$ERROR($$$GeneralError, "Failed to create transformer instance")
            $$$ThrowStatus(tSC)
        }

        If source.%ClassName(1) = "HS.SDA3.Container" {
            Do tTransform.TransformContainer(source, patientId)
        }
        Else {
            Do tTransform.TransformSDA(source, patientId, encounterId)
        }
    }
    Catch ex {
        Set tSC = ex.AsStatus()
        // Create empty transformer on error
        If '$IsObject(tTransform) {
            Set tSchema = ##class(HS.FHIRServer.Schema).LoadSchema("HL7v40") // Default schema
            Set tTransform = ##class(HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR).%New(tSchema)
        }
    }

    Quit tTransform
}

}
