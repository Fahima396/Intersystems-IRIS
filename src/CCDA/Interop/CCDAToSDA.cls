Include CCDA.zMacros

Class CCDA.Interop.CCDAToSDA Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper)
{

Parameter BaseUrl As String = "http://IRIS/CCDAToSDAPipeline";

Property SDAToFHIRTarget As Ens.DataType.ConfigName;

// [ InitialExpession = "SDA.To.FHIR.Process" ];

Property EPHSearchTarget As Ens.DataType.ConfigName;

Property PreProcessClass As %String(MAXLEN = 200);

// [InitialExpession = "CCDATOSDA.SDA3.Transform.CDAPreProcess" ];

Property PreProcessListCCDAxsl As %String [ InitialExpression = "Foundation" ];

Property CCDAToSDAxsl As %String [ InitialExpression = "SDA3/CCDAv21-to-SDA.xsl" ];

Property CustomTransformClassOverride As %String(MAXLEN = 200);

Property SourceDataType As %String;

Property SourceMetaTag As %String;

Parameter SETTINGS As STRING = "SDAToFHIRTarget,PreProcessClass,CCDAToSDAxsl,PreProcessListCCDAxsl,CustomTransformClassOverride,SourceDataType,SourceMetaTag";

Method OnRequest(pRequest As CCDA.Messages.CCDAContainer, Output pResponse As CCDA.Messages.SDAToFHIRResponse) As %Status
{
    #dim tSC As %Status=$$$OK
    #; #dim tEPHResp As Client.ResponseMsg

    Try {
        Set tPatientIMI=""

        #;Pre-Process CCDA
        $$$THROWONERROR(tSC, $CLASSMETHOD(..PreProcessClass, "XSLT", pRequest.Stream, ..PreProcessListCCDAxsl, .tNewStream))
        Do pRequest.Stream.Rewind()
        $$$HSTRACE("XFORMCCDAToSDA", "OnRequest", "pRequest", pRequest.Stream.Read())
        $$$HSTRACE("XFORMCCDAToSDA", "OnRequest", "tNewStream", tNewStream.Read())
        Do tNewStream.Rewind()
        
        Set tTransformer=##class(HS.Util.XSLTTransformer).%New()
        $$$THROWONERROR(tSC, tTransformer.Transform(tNewStream, ..CCDAToSDAxsl, .tSDAStream))

        Set tSDA3Container=##class(HS.SDA3.Container).%New()
        $$$THROWONERROR(tSC, tSDA3Container.InitializeXMLParse(tSDAStream))

        Set tSDA3Out = ##class(HS.SDA3.Container).%New()
        Set tSDA3Out.Action=tSDA3Container.Action
        set tSDA3Out.EventDescription=tSDA3Container.EventDescription
        Set tSDA3Out.SendingFacility=tSDA3Container.SendingFacility

        Set sdaCustobj = ##class(HS.SDA3.CustomObject).%New()
        Set sdaCustobj.CustomType = "RESOURCE_META"
        $$$THROWONERROR(tSC, tSDA3Out.CustomObjects.InsertAt(sdaCustobj, 1))

        Set tPair = ##class(HS.SDA3.NVPair).%New()
        Set tPair.Name = "source"
        Set tPair.Value = pRequest.GCSBucketArchivePath
        $$$THROWONERROR(tSC, tSDA3Out.CustomObjects.GetAt(1).CustomPairs.Insert(tPair))
        Set tPair = ##class(HS.SDA3.NVPair).%New()
        Set tPair.Name = "tag.System||urn:google:source"

        #; 04/10 - AKT - Effort to Move the Meta tag as a SDS Item rather than the code

        If (""'=..SourceMetaTag) {
            Set tSourceName=..SourceMetaTag
        } else {
            Set tSourceName = $SELECT(
                $ZCONVERT(pRequest.GCSBucketArchivePath, "U")["POC":  "POC-CCDA-IRIS",
                1:                                                     "INVALID-SOURCE"
            )
        }

        Set tPair.Value = "tag.code||"_tSourceName
        $$$THROWONERROR(tSC, tSDA3Out.CustomObjects.GetAt(1).CustomPairs.Insert(tPair))
        
        // 2nd, conversion-platform
        Set tPair=##class(HS.SDA3.NVPair).%New()
        Set tPair.Name = "tag.system||http://CVS-IRIS/CCDAtoFHIRPipeline/metatag"
        Set tPair.Value = "tag.code||CVS-IRIS"
        $$$THROWONERROR(tSC,tSDA3Out.CustomObjects.GetAt(1).CustomPairs.Insert(tPair))

        While tSDA3Container.GetNextSDA(.sdatype, .sdaobj, .tSC){
            Set sdaobj.Extension.CustomObject = tSDA3Out.CustomObjects.GetAt(1)

            Set tSC = ..TransformSDACVS(.tSDA3Out, sdaobj)
        }

        // Normalize MRN from CCDA and insert the additional Patient Identifiers (Not CCDA source)
        // 1. If MRN it came from CCDA standard xform , so normalize to other identifier structure
        For i=1:1:tSDA3Out.Patient.PatientNumbers.Count() {
            If (tSDA3Out.Patient.PatientNumbers.GetAt(i).NumberType="MRN") {
                Set orgSystem = tSDA3Out.Patient.PatientNumbers.GetAt(i).Organization.Code

                Set tSDA3Out.Patient.PatientNumbers.GetAt(i).Organization = ##class(HS.SDA3.CodeTableDetail.Organization).%New()
                Set tSDA3Out.Patient.PatientNumbers.GetAt(i).NumberType = ""

                Set tSDA3Out.Patient.PatientNumbers.GetAt(i).ISOAssigningAuthority=$$$SetUrnPrefix(orgSystem)
            }
        }

        Set tCCDAtoSDA3Class = "CCDA.SDA3.Transform."_pRequest.SourceFolder
        If '(..CustomTransformClassOverride=""){
            If (..CustomTransformClassOverride["PackagePath:") {
                Set packagePath=$PIECE(..CustomTransformClassOverride, "PackageaPath:",2)
                Set tCCDAtoSDA3Class = "CCDA.SDA3.Transform."_packagePath_"."_$REPLACE(pRequest.SourceFolder,packagePath, "")
            }
            Else {
                Set tCCDAtoSDA3Class = ..CustomTransformClassOverride
            }
        }

        $$$HSTRACE("CCDA.Interop.XFormCCDAToSDA", "OnRequest", "CCDAtoSDA3Class", tCCDAtoSDA3Class)
        $$$THROWONERROR(tSC, $CLASSMETHOD(tCCDAtoSDA3Class, "CCDAtoSDA3", tNewStream, .tSDA3Out, .pRequest))
        $$$HSTRACE("CCDA.Interop.XFormCCDAToSDA", "OnRequest", "CCDAtoSDA3Class OUT")

        $$$THROWONERROR(tSC,..GetSDAStream(.tSDAOut, tSDA3Out))
        Set tRequest = ##class(CCDA.Messages.SDAToFHIRRequest).%New()
        Set tRequest.Name = "HS.SDA3.Container"
        $$$THROWONERROR(tSC, tRequest.ContentStream.CopyFrom(tSDAOut))

        $$$HSTRACE("CCDA.Interop.XFormCCDAToSDA", "OnRequest", "ToQuickXMLStream")

        Set tRequest.CCDARequestId=pRequest.%Id()
        Quit:$$$ISERR(tSC)

        Set tRequest.GCSBucketArchivePath = pRequest.GCSBucketArchivePath
        $$$THROWONERROR(tSC, ..SendRequestAsync(..SDAToFHIRTarget, tRequest, 0, "SDAToFHIR"))


    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }

    Quit tSC
}

/// Description
ClassMethod GetSDAStream(pSDAStream As %Stream.GlobalCharacter, ByRef pSDAContainer As HS.SDA3.Container) As %Status
{
    #dim tSC  As %Status=$$$OK
    #dim eException  As %Exception.AbstractException

    Try {
        
        // Check if pSDAContainer is a valid object
        If '$IsObject(pSDAContainer) {
            Set tSC = $$$ERROR($$$GeneralError, "pSDAContainer is not a valid object")
            Quit
        }
        
        Set SDAPropList = $LISTBUILD(
            "Encounters","Alerts","SocialHistories", "Medications","Appointments","Procedures")  // Fixed typo: Procedues -> Procedures

        Set pSDAStream=##class(%Stream.GlobalCharacter).%New()
        do pSDAStream.Write("<Container>")
        
        // Check if Patient object exists before accessing it
        If $IsObject(pSDAContainer.Patient) {
            $$$THROWONERROR(tSC, pSDAContainer.Patient.ToQuickXMLStream(.pSDAPatient))
            do pSDAStream.CopyFrom(pSDAPatient)
        }
        
        Set lLength = $LISTLENGTH(SDAPropList)

        For l=1:1:lLength {
            Set tProp = $LIST(SDAPropList,l)
            
            // Check if the property exists and has items
            If $IsObject($PROPERTY(pSDAContainer,tProp)) && ($PROPERTY(pSDAContainer,tProp).Count() > 0) {
                do pSDAStream.Write("<"_tProp_">")  // Fixed: removed .Count() from opening tag
                
                For j = 1:1:$PROPERTY(pSDAContainer,tProp).Count(){
                    Set pSDAObj=##class(%Stream.GlobalCharacter).%New()
                    Set tItem = $PROPERTY(pSDAContainer,tProp).GetAt(j)
                    If $IsObject(tItem) {
                        $$$THROWONERROR(tSC, tItem.ToQuickXMLStream(.pSDAObj))
                        do pSDAStream.CopyFrom(pSDAObj)
                    }
                }
                do pSDAStream.Write("</"_tProp_">")
            }
        }
        do pSDAStream.Write("</Container>")
    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }

    Quit tSC
}

/// Description
ClassMethod TransformSDACVS(ByRef pContainer As HS.SDA3.Container, pSDAObj) As %Status
{
    If $CLASSNAME(pSDAObj)="HS.SDA3.Patient"{
        Set pContainer.Patient = pSDAObj
    }
    If $CLASSNAME(pSDAObj)="HS.SDA3.Encounter"{
        Do pContainer.Encounters.Insert(pSDAObj)
    }
    If $CLASSNAME(pSDAObj)="HS.SDA3.SocialHistory"{
        Do pContainer.SocialHistories.Insert(pSDAObj)
    }
    If $CLASSNAME(pSDAObj)="HS.SDA3.Appointment"{
        Do pContainer.Appointments.Insert(pSDAObj)
    }
    If $CLASSNAME(pSDAObj)="HS.SDA3.Medication"{
        Do pContainer.Medications.Insert(pSDAObj)
    }
    If $CLASSNAME(pSDAObj)="HS.SDA3.CustomObject"{
        Do pContainer.CustomObjects.Insert(pSDAObj)
    }
    Quit $$$OK
}

/// Description
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

Storage Default
{
<Data name="CCDAToSDADefaultData">
<Subscript>"CCDAToSDA"</Subscript>
<Value name="1">
<Value>SDAToFHIRTarget</Value>
</Value>
<Value name="2">
<Value>EPHSearchTarget</Value>
</Value>
<Value name="3">
<Value>PreProcessClass</Value>
</Value>
<Value name="4">
<Value>PreProcessListCCDAxsl</Value>
</Value>
<Value name="5">
<Value>CCDAToSDAxsl</Value>
</Value>
<Value name="6">
<Value>CustomTransformClassOverride</Value>
</Value>
<Value name="7">
<Value>SourceDataType</Value>
</Value>
<Value name="8">
<Value>SourceMetaTag</Value>
</Value>
<Value name="9">
<Value>TraceOperations</Value>
</Value>
</Data>
<DefaultData>CCDAToSDADefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
