Class CCDA.CCDAProcess Extends Ens.BusinessProcess
{

Property TargetConfigName As Ens.DataType.ConfigName;

Property GCSBucketArchive As Ens.DataType.ConfigName;

Property GCSBucketError As Ens.DataType.ConfigName;

Property Logger As Ens.DataType.ConfigName;

Property BigQueryWaterMark As Ens.DataType.ConfigName;

Property SourceDataType As %String;

Property GCSUseCase As %String;

Property PreValidationXSLTClass As %String(MAXLEN = 200);

/// Description
Parameter SETTINGS = "TargetConfigName,GCSBucketArchive,Logger,BigQueryWaterMark,SourceDataType,GCSUseCase,PreValidationXSLTClass";

Method OnRequest(pRequest As Ens.StreamContainer, Output pResponse As CCDA.Messages.ProcessResponse) As %Status
{

    #dim tSC As %Status=$$$OK
    #dim tSC1 As %Status=$$$OK
    #dim tSC2 As %Status=$$$OK
    #dim tSC3 As %Status=$$$OK
    #dim eException As %Exception.AbstractException

    Set pResponse = ##class(CCDA.Messages.ProcessResponse).%New()

    Try {
        
        If 'pRequest.Stream.Size Set tSC1 = $$$ERROR($$$GeneralError, "Empty Document Found")
        If $$$ISERR(tSC1) $$$ThrowStatus(tSC1)
        Set tReqStream=pRequest.Stream
        If (..PreValidationXSLTClass'="") {
            // Get the XSLT
            Set tDocumentTransform=##class(%Dictionary.XDataDefinition).%OpenId(..PreValidationXSLTClass_"||PreXMLValidation",0).Data 
            // Get a stream of XOIL from the Example block contained in this class
            $$$THROWONERROR(tSC,##class(%XML.XSLT.CompiledStyleSheet).CreateFromStream(tDocumentTransform, .tCompiledStyleSheet)) 
            $$$THROWONERROR(tSC,##class(%XML.XSLT.Transformer).TransformStreamWithCompiledXSL(tReqStream, tCompiledStyleSheet, .tReqStream,,,))
        }
        #; Set 10-#class(EnsLib.EDI..Document). ImportFroelibraryStream(pRequest.Stream,.tSC2)
        Set tXML=##class(EnsLib.EDI.XML.Document).ImportFromLibraryStream(tReqStream,.tSC2)
        If $$$ISERR(tSC2),..GCSBucketError'="" {
            Set tSCWriteToError=..WriteToErrorBucket(pRequest, pRequest.OriginalFilename)
            $$$ThrowStatus(tSC2)
        }
        Set tDocXmlns=tXML.GetValueAt("/ClinicalDocument/@xmlns")
        If '(tDocXmlns="urn:h17-org:v3") Set tSC3=$$$ERROR($$$GeneralError, "Not a CCDA stream") 
        If $$$ISERR(tSC3),..GCSBucketError'="" {
            Set tSCWriteToError=..WriteToErrorBucket(pRequest, pRequest.OriginalFilename)
        $$$ThrowStatus(tSC3)
        }
        Set tContainer=##class(CCDA.Messages.CCDAContainer).%New()

        #; Getting some information required to map meta.source.
        #; Used to map meta.tag[0]: "urn:google:source and meta.source:<gcp_archive_path>
        Set tContainer.GCSBucketArchivePath="gs://unknown/unk"
        
        // TODO: Don't have a notification payload ingestion process yet so hard coding test data for now
        #; EPP or CQ DocumentReference (CDA) masterIdentifier
        Set tContainer.DocRefMasterID=""
        #;  For EPP, store BinaryFhirID
        Set tContainer.BinaryFhirID="EPP-BinaryfhirID-Not-Set" //EPP-BinaryFhirID-Dont Have Access To This Yet #; Store any patient identifiers located outside of the CCDA (e.g. Notification 250

        Set tContainer.FilePath=pRequest.OriginalFilename

        If ($ZCONVERT(pRequest.OriginalFilename, "L") [ "/archive") {
            Set tContainer.SourceFolder=$PIECE(pRequest.OriginalFilename, "/", "*-2")
        } Else {
            Set tContainer.SourceFolder=$PIECE(pRequest.OriginalFilename, "/", "*-1")
        }

        $$$THROWONERROR(tSC, tContainer.Stream.CopyFrom(tReqStream))

        If ((..GCSUseCase'="") && ($PIECE(pRequest.OriginalFilename, "/", *)'="")){

            If $GET(^Ens.LookupTable(..GCSUseCase, $PIECE(pRequest.OriginalFilename,"/",*))) '=""{
                Set tContainer.GCSBucketArchivePath = $GET(^Ens.LookupTable(..GCSUseCase, $PIECE(pRequest.OriginalFilename," /",*)))
            } Else {
                If ..GCSBucketArchive'=""{
                    Set tGCSBucketReq = ##class(CCDA.GCSBucket.UploadRequest).%New()
                    Set tGCSBucketReq.FileName = pRequest.OriginalFilename //$P(pRequest OriginalFilename,"/", 1,*-1)"/archive/"$P(pRequest.C
                    $$$THROWONERROR(tSC, ..SendRequestSync(..GCSBucketArchive, tGCSBucketReq, .tGCSResp))
                    If $ISOBJECT(tGCSResp){
                        Set tContainer.GCSBucketArchivePath = "gs://" _ tGCSResp.BucketFileName
                    }
                }
            }
        }
        
        #; Done making changes to Container (Request) so save it since we will be re-opening it in SDATFHIR. cls
        $$$THROWONERROR(tSC, tContainer.%Save())
        Set tContainerId=tContainer.%Id()
        Set tContainer=##class(CCDA.Messages.CCDAContainer).%OpenId(tContainerId, 0)
        #; Dispatch Async request with response #; PT - Don't process response
        Set tSC = ..SendRequestAsync(..TargetConfigName, tContainer, 0, "CCDATOSDA")    

        Set pDelimiter="^", tGUID=""
        Set tSuperSessionID = ##class(%SYS.System).GetNodeName()_pDelimiter_##class(%SYS.System).GetInstanceName()_
                                pDelimiter_$NAMESPACE_pDelimiter_..%SessionId
        #; Set tSC=##class(CCDA.GUID.StorageUtil).RetrieveGUIDBySuperSession(tSuperSessionID, .tGUID)

        If $$$ISERR(tSC) $$$LOGERROR(tSC)
        
    }
    Catch ex {
        Set tSC=ex.AsStatus()
        $$$LOGERROR(tSC)
        Set pResponse.Status="Error"
        Set pResponse.StatusText=tSC
    }

    Quit tSC
}

Method OnResponse(pRequest As Ens.Request, ByRef pResponse As Ens.Response, pCallRequest As Ens.Request, pCallResponse As Ens.Response, pCompleteKey As %String) As %Status
{
    #dim tSC As %Status=$$$OK
    #dim eException As %Exception.AbstractException

    Try {
        If pCompleteKey="CCDAToSDA" {

        } Else {
            Set tSC = $$$ERROR($$$GeneralError, "Can't haandle this async response")
        }
    }
    Catch ex {
        Set tSC=ex.AsStatus()
        $$$LOGERROR(tSC)
    }

    Quit tSC
}

/// Description
Method WriteToErrorBucket(pStreamContainer As Ens.StreamContainer, pFileName As %String) As %Status
{
    #dim tSC As %Status=$$$OK
    #dim eException As %Exception.AbstractException
    Try {
        Set tGCSBucketReq=##class(CCDA.GCSBucket.UploadRequest).%New()
        Set tGCSBucketReq.FileName=pFileName

        $$$THROWONERROR(tSC,..SendRequestAsync(..GCSBucketError, tGCSBucketReq,0))
    }
    Catch ex {
        Set tSC=ex.AsStatus()
        $$$LOGERROR(tSC)
    }
    Quit tSC
}

Storage Default
{
<Data name="CCDAProcessDefaultData">
<Subscript>"CCDAProcess"</Subscript>
<Value name="1">
<Value>TargetConfigName</Value>
</Value>
<Value name="2">
<Value>GCSBucketArchive</Value>
</Value>
<Value name="3">
<Value>Logger</Value>
</Value>
<Value name="4">
<Value>BigQueryWaterMark</Value>
</Value>
<Value name="5">
<Value>SourceDataType</Value>
</Value>
<Value name="6">
<Value>GCSUseCase</Value>
</Value>
<Value name="7">
<Value>PreValidationXSLTClass</Value>
</Value>
<Value name="8">
<Value>GCSBucketError</Value>
</Value>
</Data>
<DefaultData>CCDAProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
