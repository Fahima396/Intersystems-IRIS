Class CCDA.Interop.XFormSDAToFHIR Extends (HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process, HS.HC.Util.Trace.Helper)
{

Property TargetConfigName As Ens.DataType.ConfigName;

Property TransformClass As %Dictionary.Classname;

Property FHIRMetadataSet As %String(MAXLEN = 256) [ InitialExpression = "HL7v40 / FHIR R4 Core Specification" ];

Property FHIRBinaryEnabled As %Boolean [ InitialExpression = 1 ];

Parameter SETTINGS = "TargetConfigName,TransformClass,FHIRMetadataSet,FHIRBinaryEnabled";

/// Description
Method OnRequest(pRequest As CCDA.Messages.SDAToFHIRRequest, Output pResponse As CCDA.Messages.SDAToFHIRResponse) As %Status
{
    #dim tSC   As %Status=$$$OK
    #dim eException  As %Exception.AbstractException
    #dim tSDA3Container As HS.SDA3.Container

    Try {

        Set tSC=pRequest.NewResponse(.pResponse)
        Set pResponse.OriginalRequest=pRequest
        $$$HSTRACE("XFormSDAToFHIR", "OnRequest", pRequest.ContentStream.Read())
        Do pRequest.ContentStream.Read()

        Set tApplication = pRequest.AdditionalInfo.GetAt("SessionApplication")
        Set tSessionId = pRequest.AdditionalInfo.GetAt("SessionId")
        Set tPatientResourceId = pRequest.AdditionalInfo.GetAt("PatientResourceId")
        Set tQuickStreamId = pRequest.AdditionalInfo.GetAt("QuickStreamId")
        If tQuickStreamId'="" {
            Set tQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(tQuickStreamId)
            Set tSDA3StreamRef = tQuickStream
        }Else{
            Set tSDA3StreamRef = pRequest.ContentStream
        }

        $$$THROWONERROR(tSCpsr, ..ProcessSDARequest(tSDA3StreamRef, tApplication, tSessionId, tPatientResourceId))
        $$$THROWONERROR(tSCrsw, pRequest.Status.Write(tSC))
    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }

    Quit tSC
}

/// Description
Method ProcessSDARequest(pSDAStream, pSessionApplication As %String, pSessionId As %String, pPatientResourceId As %String = "") As %Status
{
    Set tSC= $$$OK
    Try {
        // Debug: Check if pSDAStream is valid
        If '$IsObject(pSDAStream) {
            Set tSC = $$$ERROR($$$GeneralError, "pSDAStream is not a valid object")
            $$$ThrowStatus(tSC)
        }
        
        If '$DATA(%healthshare($$$CurrentClass, "isInteropHost"))#10{
            $$$THROWONERROR(tSC, ##class(HS.Director).OpenCurrentProduction(.tProdObj))
            Set tClassName = ""
            For i=1:1:tProdObj.Items.Count() {
                If tProdObj.Items.GetAt(i).Name = ..TargetConfigName {
                    Set tClassName = tProdObj.Items.GetAt(i).ClassName
                    Quit
                }
            }
            Kill tProdObj

            Set tIsInteropHost = 0
            Set tRequiredHostBases("HS.FHIRServer.Interop.Operation") = ""
            Set tRequiredHostBases("HS.FHIRServer.Interop.HTTPOperation") = ""
            Set tHostBase = ""
            For {
                Set tHostBase = $ORDER(tRequiredHostBases(tHostBase))
                If tHostBase="" Quit
                If $CLASSMETHOD(tClassName, "%IsA", tHostBase){
                    Set tIsInteropHost = 1
                    Quit
                }
            }
            Set %healthshare($$$CurrentClass, "isInteropHost")=tIsInteropHost
        } Else {
            Set tIsInteropHost = %healthshare($$$CurrentClass, "isInteropHost")
        }

        // Debug: Check if TransformClass is set
        If ..TransformClass = "" {
            Set tSC = $$$ERROR($$$GeneralError, "TransformClass is not set")
            $$$ThrowStatus(tSC)
        }
        
        // Debug: Check if TransformClass exists
        If '##class(%Dictionary.ClassDefinition).%ExistsId(..TransformClass) {
            Set tSC = $$$ERROR($$$GeneralError, "TransformClass '"_..TransformClass_"' does not exist")
            $$$ThrowStatus(tSC)
        }
        
        #; // Debug: Check if TransformStream method exists
        #; If '$CLASSMETHOD(..TransformClass, "%MethodExists", "TransformStream") {
        #;     Set tSC = $$$ERROR($$$GeneralError, "TransformStream method does not exist in class '"_..TransformClass_"'")
        #;     $$$ThrowStatus(tSC)
        #; }

        Do ..GetHostAndPort(.tHost, .tPort)
        Set tLocalHostandPort = tHost_$SELECT(tPort'="":":",1:"")_tPort

        If ..FHIRFormat="JSON" {
            Set tMessageContentType = "application/fhir+json"
        } ElseIf ..FHIRFormat="XML" {
            Set tMessageContentType = "application/fhir+xml"
        }

        Set tFHIRMetadataSetKey = $ZSTRIP($PIECE(..FHIRMetadataSet, "/", 1),"<>W")
        Set tSchema = ##class(HS.FHIRServer.Schema).LoadSchema(tFHIRMetadataSetKey)

        If '..FormatFHIROutput {
            Set tIdentChars=""
            Set tLineTerminator=""
            Set tFormatter=""
        } Else {
            Set tIdentChars=$CHAR(9)
            Set tLineTerminator=$CHAR(13,10)
            Set tFormatter=##class(%JSON.Formatter).%New()
            Set tFormatter.IndentChars=tIdentChars
            Set tFormatter.LineTerminator=tLineTerminator
        }

        #dim tTransformObj As HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR

        $$$HSTRACE("CCDA.Interop.XFormSDAToFHIR", "ProcessSDARequest", "TransformStream", ..TransformClass)
        
        // Initialize tTransformObj
        Set tTransformObj = ""
        
        // Try to call TransformStream - use different approach
        Try {
            Set tTransformObj = $CLASSMETHOD(..TransformClass, "TransformStream", pSDAStream, "HS.SDA3.Container", tFHIRMetadataSetKey, pPatientResourceId)
        } Catch ex2 {
            Set tSC = ex2.AsStatus()
            $$$ThrowStatus(tSC)
        }
        
        // Check if tTransformObj is a valid object
        If '$IsObject(tTransformObj) {
            Set tSC = $$$ERROR($$$GeneralError, "TransformStream did not return a valid object for class: "_..TransformClass)
            $$$ThrowStatus(tSC)
        }
        
        // Check if the object has the bundle property
        If '$IsObject(tTransformObj.bundle) {
            Set tSC = $$$ERROR($$$GeneralError, "TransformStream returned object but bundle property is invalid for class: "_..TransformClass)
            $$$ThrowStatus(tSC)
        }

        Set tBundleObj = tTransformObj.bundle
        $$$HSTRACE("CCDA.Interop.XFormSDAToFHIR", "ProcessSDARequest", "TransformStream OUT", ..TransformClass) 

        // Check if bundle has entries
        If '$IsObject(tBundleObj.entry) {
            Set tSC = $$$ERROR($$$GeneralError, "Bundle entry property is invalid")
            $$$ThrowStatus(tSC)
        }

        If ..TransmissionMode="individual" {
            For i=0:1:tBundleObj.entry.%Size()-1 {
                Set tEntry = tBundleObj.entry.%Get(i)
                If '$IsObject(tEntry) {
                    $$$HSTRACE("CCDA.Interop.XFormSDAToFHIR", "ProcessSDARequest", "Skipping invalid entry at index: "_i, "")
                    Continue
                }
                
                If tIsInteropHost {
                    Set tSC = ..CreateAndSendInteropMessage(tEntry, tSchema, tMessageContentType, tFormatter, tIdentChars, tLineTerminator, pSessionApplication, pSessionId)
                } Else {
                    Set tSC = ..CreateAndSendFHIRMessage(tEntry, tSchema, tLocalHostandPort, tMessageContentType, tFormatter, tIdentChars, tLineTerminator, pSessionApplication, pSessionId)
                }
                If $$$ISERR(tSC) Quit
            }
        } Else {
            // For bundle transmission, use the entire bundle
            If tIsInteropHost {
                Set tSC = ..CreateAndSendInteropMessage(tBundleObj, tSchema, tMessageContentType, tFormatter, tIdentChars, tLineTerminator, pSessionApplication, pSessionId)
            } Else {
                Set tSC = ..CreateAndSendFHIRMessage(tBundleObj, tSchema, tLocalHostandPort, tMessageContentType, tFormatter, tIdentChars, tLineTerminator, pSessionApplication, pSessionId)
            }
        }

    }
    Catch ex {
        Set tSC=ex.AsStatus()
        // Add detailed error information
        If $System.Status.GetErrorCodes(tSC) [ ",5002," {
            Set tSC = $$$ERROR($$$GeneralError, "INVALID OREF error in ProcessSDARequest. Check that TransformClass '"_$Get(..TransformClass,"UNDEFINED")_"' exists and has TransformStream method that returns valid object.")
        }
    }

    Quit tSC
}

Method CreateAndSendFHIRMessage(pFHIRObj As %Library.DynamicObject, pSchema As HS.FHIRServer.Schema, pLocalHostAndPort As %String, pContentType As %String, pFormatter As %JSON.Formatter, pIdentChars As %String, pLineTerminator As %String, pSessionApplication As %String, pSessionId As %String) As %Status
{
    Set tSC = $$$OK

    Try {
        // Validate input parameters
        If '$IsObject(pFHIRObj) {
            Set tSC = $$$ERROR($$$GeneralError, "pFHIRObj is not a valid object")
            Quit
        }
        
        Set tRequest = ##class(HS.Message.FHIR.Request).%New()
        If '$IsObject(tRequest) {
            Set tSC = $$$ERROR($$$GeneralError, "Failed to create FHIR Request")
            Quit
        }

        Set isBinary=0
        Set tIsBundle=0
        Set tInteraction=""
        
        // Check if pFHIRObj has resourceType property
        If pFHIRObj.%IsDefined("resourceType") {
            If (pFHIRObj.resourceType = "Bundle") {
                // Handle Bundle resource
                If pFHIRObj.%IsDefined("entry") && (pFHIRObj.entry.%Size() > 0) {
                    Set binaryCandidate = pFHIRObj.entry.%Pop()
                    If (..FHIRBinaryEnabled && $IsObject(binaryCandidate) && 
                        binaryCandidate.%IsDefined("resource") && $IsObject(binaryCandidate.resource) &&
                        binaryCandidate.resource.%IsDefined("resourceType") && 
                        (binaryCandidate.resource.resourceType = "Binary")) {
                        $$$HSTRACE("CreateAndSendFHIRMessage", "binaryCandidate", binaryCandidate.%ToJSON())
                        Set pFHIRObj = binaryCandidate
                        Set isBinary = 1
                    } Else {
                        // Push the candidate back if it's not a Binary resource
                        Do pFHIRObj.entry.%Push(binaryCandidate)
                        Set tRequest.Type = "Bundle"
                        Set tIsBundle = 1
                    }
                }
            }
        }

        Set tRequest.ContentType = pContentType

        If tIsBundle {
            Set tResourceObj = pFHIRObj
            Set tRequest.Interaction = "transaction"
        } Else {
            // Handle individual resources
            If pFHIRObj.%IsDefined("resource") {
                Set tResourceObj = pFHIRObj.resource
            } Else {
                Set tResourceObj = pFHIRObj
            }
            
            If $IsObject(tResourceObj) && tResourceObj.%IsDefined("resourceType") {
                Set tRequest.Type = tResourceObj.resourceType
            }
            
            If $IsObject(tResourceObj) && tResourceObj.%IsDefined("id") {
                Set tRequest.Id = tResourceObj.id
            }
            
            // Determine interaction type
            If pFHIRObj.%IsDefined("request") && $IsObject(pFHIRObj.request) && 
               pFHIRObj.request.%IsDefined("method") {
                If pFHIRObj.request.method = "POST" {
                    Set tInteraction = "create"
                } ElseIf pFHIRObj.request.method = "PUT" {
                    Set tInteraction = "update"
                }
            } Else {
                If (tRequest.Id = "") || (tRequest.Id = $c(0)) {
                    Set tInteraction = "create"
                } Else {
                    Set tInteraction = "update"
                }
            }
            
            If tInteraction '= "" {
                Set tRequest.Interaction = tInteraction
            }
        }

        If (isBinary) {
            Set tRequest.Interaction = "create"
            Set tResourceObj = pFHIRObj
        }

        // Validate tResourceObj before using it
        If '$IsObject(tResourceObj) {
            Set tSC = $$$ERROR($$$GeneralError, "No valid resource object found for FHIR message")
            Quit
        }

        Set tResourceStream = ..GetResourceStream(tResourceObj, ..FHIRFormat, ..FormatFHIROutput, pSchema, pFormatter, pIdentChars, pLineTerminator)

        If ..OutputToQuickStream {
            Set tQuickStream = ##class(HS.SDA3.QuickStream).%New()
            If '$IsObject(tQuickStream) {
                Set tSC = $$$ERROR($$$GeneralError, "Failed to create QuickStream")
                Quit
            }
            Set tRequest.QuickStreamId = tQuickStream.%Id()
            Do tQuickStream.CopyFrom(tResourceStream)
        } Else {
            Do tRequest.Payload.CopyFrom(tResourceStream)
        }

        Do:..FullTransactionResponse tRequest.Headers.SetAt("return=representation", "PREFER")
        Do tRequest.Headers.SetAt(pLocalHostAndPort, "HOST")
        Set tRequest.SessionApplication = pSessionApplication
        Set tRequest.SessionId = pSessionId
        Set tRequest.FormatFHIROutput = ..FormatFHIROutput

        #Dim tResponse As HS.Message.FHIR.Response

        Set tSC = ..SendRequestAsync(..TargetConfigName, tRequest, .tResponse)

        If $$$ISERR(tSC) {
            If (..OutputToQuickStream) && ($IsObject($GET(tQuickStream))) {
                Do tQuickStream.Clear()
            }
            If ($IsObject($GET(tResponse))) && (tResponse.%IsA("HS.Message.FHIR.Base")) && (tResponse.QuickStreamId '= "") {
                Set tResponseQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(tResponse.QuickStreamId)
                If $IsObject(tResponseQuickStream) {
                    Do tResponseQuickStream.Clear()
                }
                Set tResponse.QuickStreamId = ""
            }
            Quit
        }

        Set tSC = ..ProcessFHIRResponse(tResponse, .tFHIRStatus, pSchema)
        If (..OutputToQuickStream) && ($IsObject($GET(tQuickStream))) {
            Do tQuickStream.Clear()
        }
        If ($IsObject($GET(tResponse))) && (tResponse.%IsA("HS.Message.FHIR.Base")) && (tResponse.QuickStreamId '= "") {
            Set tResponseQuickStream = ##class(HS.SDA3.QuickStream).%OpenId(tResponse.QuickStreamId)
            If $IsObject(tResponseQuickStream) {
                Do tResponseQuickStream.Clear()
            }
            Set tResponse.QuickStreamId = ""
        }
    }
    Catch ex {
        Set tSC = ex.AsStatus()
    }

    Quit tSC
}

Method ProcessFHIRResponse(pFHIRResponse As HS.Message.FHIR.Response, ByRef pFHIRSC As %Status, pSchema As HS.FHIRServer.Schema) As %Status
{
	Set tSC = $$$OK
	Set pFHIRSC = $$$OK
	
	Try {
		// Validate input parameters
		If '$IsObject(pFHIRResponse) {
			Set tSC = $$$ERROR($$$GeneralError, "pFHIRResponse is not a valid object")
			Quit
		}
		
		If '$IsObject(pSchema) {
			Set tSC = $$$ERROR($$$GeneralError, "pSchema is not a valid object")
			Quit
		}
		
		// Check if Status property exists and is accessible
		If '$Data(pFHIRResponse.Status) {
			Set tSC = $$$ERROR($$$GeneralError, "FHIR response Status property is missing")
			Quit
		}
		
		// If Status is 200 OK or 201 Created or 202 Accepted, then don't
		// worry about any warnings that might be in an OperationOutcome.
		If (+pFHIRResponse.Status=200)||(+pFHIRResponse.Status=201)||(+pFHIRResponse.Status=202) Quit
		
		// The only expected Payload is an OperationOutcome resource or a Bundle of OperationOutcome resources.
		If pFHIRResponse.Payload.Size>0 {
			If pFHIRResponse.ContentType["json" {
				Set tDynObj = {}.%FromJSON(pFHIRResponse.Payload)
			} Else {
				Set tDynObj = ##class(HS.FHIRServer.Util.XMLToJSON).XMLToJSON(pFHIRResponse.Payload, pSchema)
			}
			
			// Validate the dynamic object
			If '$IsObject(tDynObj) {
				Set tSC = $$$ERROR($$$GeneralError, "Failed to parse FHIR response payload")
				Quit
			}
			
			If tDynObj.resourceType="Bundle" {
				For i = 0:1:tDynObj.entry.%Size()-1 {
					Set tEntry = tDynObj.entry.%Get(i)
					If ('$IsObject(tEntry))||('$IsObject(tEntry.resource))||(tEntry.resource.resourceType'="OperationOutcome") {
						$$$ThrowStatus($$$ERROR($$$GeneralError, "Unexpected payload in FHIR response"))
					}
					For j = 0:1:tEntry.resource.issue.%Size()-1 {
						Set tIssue = tEntry.resource.issue.%Get(j)
						If (tIssue.severity="error") && (tIssue.diagnostics'="") {
							Set pFHIRSC = $$$ERROR($$$GeneralError, tIssue.diagnostics)
							Quit
						}
					}
				}
			} ElseIf tDynObj.resourceType="OperationOutcome" {
				For i = 0:1:tDynObj.issue.%Size()-1 {
					Set tIssue = tDynObj.issue.%Get(i)
					If (tIssue.severity="error") && (tIssue.diagnostics'="") {
						Set pFHIRSC = $$$ERROR($$$GeneralError, tIssue.diagnostics)
						Quit
					}
				}
			} Else {
				Set tSC = $$$ERROR($$$GeneralError, "Unexpected payload in FHIR response")
				Quit
			}
			Kill tDynObj
		}
		If $$$ISERR(tSC) Quit
		If $$$ISERR(pFHIRSC) Quit
		
		Set pFHIRSC = $$$ERROR($$$GeneralError, "FHIR response status = "_pFHIRResponse.Status)
		
	} Catch ex {
		Set tSC = ex.AsStatus()
	}
	
	Quit tSC
}

Storage Default
{
<Data name="XFormSDAToFHIRDefaultData">
<Subscript>"XFormSDAToFHIR"</Subscript>
<Value name="1">
<Value>FHIRBinaryEnabled</Value>
</Value>
</Data>
<DefaultData>XFormSDAToFHIRDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
