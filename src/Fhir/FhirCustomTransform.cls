Class Fhir.FhirCustomTransform Extends HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process
{

/// Description
Method OnRequest(pRequest As Ens.Request, pResponse As Ens.Response) As %Status
{
    Set sc = $$$OK
	#; $$$LOGINFO(..%PrimaryRequestHeader.SourceConfigName)

    Try {
			Set tApplication = ""
			Set tSessionId = ""
            Set sc = ..ProcessFhirRequest(pRequest, tApplication, tSessionId)
    }
    Catch ex {
        Set SC=ex.AsStatus()
    }
    Return sc
}

/// Description
Method ProcessFhirRequest(pRequest, pSessionApplication As %String, pSessionId As %String) As %Status
{
    Set sc = $$$OK
	
	Try {
		// Check the base class for the Target business host. Determine if it is
		// a FHIRServer Interop business host or not.
		If '$Data(%healthshare($$$CurrentClass, "isInteropHost"))#10 {
			$$$ThrowOnError(##class(HS.Director).OpenCurrentProduction(.tProdObj))
			Set tClassName = ""
			For i = 1:1:tProdObj.Items.Count() {
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
				Set tHostBase = $Order(tRequiredHostBases(tHostBase))
				If tHostBase="" Quit
				If $ClassMethod(tClassName, "%IsA", tHostBase) {
					Set tIsInteropHost = 1
					Quit
				}
			}
			Set %healthshare($$$CurrentClass, "isInteropHost") = tIsInteropHost
			
		} Else {
			Set tIsInteropHost = %healthshare($$$CurrentClass, "isInteropHost")
		}
		
		// Get the host and web server port of the current instance, to be used for populating
		// the FHIR request message HOST header.  The HOST header is needed in the FHIR request
		// message when the message is being routed for processing in the local production, as
		// opposed to being passed to an external server.
		Do ..GetHostAndPort(.tHost, .tPort)
		Set tLocalHostAndPort = tHost_$Select(tPort'="":":",1:"")_tPort
		
		If ..FHIRFormat="JSON" {
			Set tMessageContentType = "application/fhir+json"
		} ElseIf ..FHIRFormat="XML" {
			Set tMessageContentType = "application/fhir+xml"
		}
		
		Set tFHIRMetadataSetKey = $ZStrip($Piece(..FHIRMetadataSet, "/", 1), "<>W")
		
		Set tSchema = ##class(HS.FHIRServer.Schema).LoadSchema(tFHIRMetadataSetKey)
		
		If '..FormatFHIROutput {
			Set tIndentChars = ""
			Set tLineTerminator = ""
			Set tFormatter = ""
		} Else {
			Set tIndentChars = $Char(9)
			Set tLineTerminator = $Char(13,10)
			Set tFormatter = ##class(%JSON.Formatter).%New()
			Set tFormatter.IndentChars = tIndentChars
			Set tFormatter.LineTerminator = tLineTerminator
		}
		
		#dim tTransformObj As HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR
		
		#; Set tTransformObj = $ClassMethod(..TransformClass, "TransformStream", pSDAStream, "HS.SDA3.Container", tFHIRMetadataSetKey, pPatientResourceId)
		
		#; // tTransformObj.bundle is a %DynamicObject.
		#; Set tBundleObj = tTransformObj.bundle$$$LOGINFO(process.%PrimaryRequestHeader.SourceConfigName)
	    Set tBundleObj = ##class(%DynamicObject).%FromJSON(pRequest.Stream)
		$$$HSTRACE("Bundle object", "tBundleObj", tBundleObj.%ToJSON())
		
		// "individual" is not a transaction type or interaction.
		// This mode causes each entry in the Bundle to be sent
		// to TargetConfigName individually, not as a transaction.
		If ..TransmissionMode="individual" {
			For i = 0:1:tBundleObj.entry.%Size()-1 {
				If tIsInteropHost {
					Set tSC = ..CreateAndSendInteropMessage(tBundleObj.entry.%Get(i), tSchema, tMessageContentType, tFormatter, tIndentChars, tLineTerminator, pSessionApplication, pSessionId)
				} Else {
					Set tSC = ..CreateAndSendFHIRMessage(tBundleObj.entry.%Get(i), tSchema, tLocalHostAndPort, tMessageContentType, tFormatter, tIndentChars, tLineTerminator, pSessionApplication, pSessionId)
				}
			}
		} Else {
			If tIsInteropHost {
				Set tSC = ..CreateAndSendInteropMessage(tBundleObj, tSchema, tMessageContentType, tFormatter, tIndentChars, tLineTerminator, pSessionApplication, pSessionId)
			} Else {
				Set tSC = ..CreateAndSendFHIRMessage(tBundleObj, tSchema, tLocalHostAndPort, tMessageContentType, tFormatter, tIndentChars, tLineTerminator, pSessionApplication, pSessionId)
			}
		}
		
	} Catch eException {
		Set SC = eException.AsStatus()
	}
    Return sc
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
