Include (%occXSLT, Ensemble, CCDA.zMacros)

Class CCDA.SDA3.Transform.Foundation Extends %RegisteredObject
{

/// Description
ClassMethod CCDAtoSDA3(pCCDA As %Stream.GlobalCharacter, ByRef pSDAContainer As HS.SDA3.Container, ByRef pRequest As CCDA.Messages.CCDAContainer) As %Status
{
    #dim tSC   As %Status=$$$OK
    #dim eException  As %Exception.AbstractException

    Try {
        $$$LOGINFO($CLASSNAME()_".CCDAtoSDA3()")
        Set tSessionId=$GET($$$JobSessionId)
        Set tDataArr("SessionId")=tSessionId

        Do pCCDA.Rewind()
        $$$LOGINFO($CLASSNAME()_"DynDoc CreateFromStream() Start")
        $$$THROWONERROR(tSC, ##class(CCDA.Utils.DynDoc).CreateFromStream(pCCDA,.xmlDoc, 1))
        $$$LOGINFO($CLASSNAME()_"DynDoc CreateFromStream() End")

        $$$THROWONERROR(tSC, xmlDoc.EvaluateExpression("/hl7:ClinicalDocument/hl7:confidentialityCode", "@codeSystem",.tResult1))
        $$$THROWONERROR(tSC, xmlDoc.EvaluateExpression("/hl7:ClinicalDocument/hl7:confidentialityCode", "@code", .tResult2))

        #; If (tResult2.Count()>0) {
        #;     $$$LOGINFO("inside if")
        #;     Set tPair=##class(HS.SDA3.NVPair).%New()
        #;     Set tPair.Name="security.coding.system||"_$$$SetUrnPrefix(tResult1.GetAt(1).Value)
        #;     Set tPair.Value="security.coding.code||"_tResult2.GetAt(1).Value
        #;     $$$LOGINFO( " tResult2.GetAt(1).Value => " _ tResult2.GetAt(1).Value)
        #;     $$$THROWONERROR(tSC, pSDAContainer.CustomObjects.GetAt(1).CustomPairs.Insert(tPair))
        #; }

        $$$THROWONERROR(tSC, ..Process(.tDataArr, .xmlDoc, .pSDAContainer, .pRequest))
    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }

    Quit tSC
}

/// Description
ClassMethod Process(ByRef pDataArray As %String, ByRef xmlDoc As %XML.XPATH.Document, ByRef pSDACont As HS.SDA3.Container, ByRef pRequest As CCDA.Messages.CCDAContainer) As %Status
{
    #dim tSC   As %Status=$$$OK
    #dim eException  As %Exception.AbstractException

    Try {
        $$$LOGINFO($CLASSNAME()_".Process()")

        Set pSDACont.Medications=##class(%ListOfObjects).%New()
        $$$THROWONERROR(tSC, ..ModifyMedicationRequest(.tDataArr, .xmlDoc, .pSDACont))

    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }

    Quit tSC
}

/// Description
ClassMethod ModifyMedicationRequest(ByRef pDataArray As %String, ByRef xmlDoc As %XML.XPATH.Document, ByRef pSDACont As HS.SDA3.Container) As %Status
{
    #dim tSC   As %Status=$$$OK
    #dim eException  As %Exception.AbstractException

    Try {
        #dim tIsMRRequested as %Boolean=1

        Set templateIds="2.16.840.1.113883.10.20.22.2.11|2.16.840.1.113883.10.20.22.2.11.1||2.16.840.1.113883.10.20.22.2.1|2.16.840.1.113883.10.20.22.2.1.1||2.16.840.1.113883.10.20.22.2.1"
        Set templateList = $LISTFROMSTRING(templateIds, "||")
        Set n=$LISTLENGTH(templateList)

        Set encNumber=""
        Set EncPath="/hl7:ClinicalDocument/hl7:componentOf/hl7:encompassingEncounter"

        For j=1:1:n {
            Set templateID=$LIST(templateList,j)
            Set tTemplateCondList=$LISTFROMSTRING(templateID, "|")
            
            // Build proper XPath predicate
            Set tTemplateCond=""
            For q=1:1:$LISTLENGTH(tTemplateCondList) {
                Set tRoot=$LIST(tTemplateCondList,q)
                If (tTemplateCond'="") Set tTemplateCond=tTemplateCond_" or "
                Set tTemplateCond=tTemplateCond_"hl7:templateId/@root='"_tRoot_"'"
            }
            
            // Use proper XPath syntax
            Set tSectionPath="/hl7:ClinicalDocument/hl7:component/hl7:structureBody/hl7:component/hl7:section["_tTemplateCond_"]"
            
            // Initialize xmlResult to avoid undefined errors
            Set xmlResult = ""
            $$$THROWONERROR(tSC, xmlDoc.EvaluateExpression(tSectionPath_"/hl7:entry",".",.xmlResult))
            
            // Check if xmlResult is defined and has entries
            If ($IsObject(xmlResult) && (xmlResult.Count() > 0)) {
                Set sectionCodePath= tSectionPath_"/hl7:code"
                
                // Initialize sectionCoding to avoid INVALID OREF errors
                Set sectionCoding = ""
                
                $$$THROWONERROR(tSC,xmlDoc.EvaluateExpression(sectionCodePath,"@code",.scResultCode))
                If (scResultCode.Count()>0){
                    Set sectionCoding=##class(HS.SDA3.CodeTableDetail).%New()
                    Set sectionCoding.Code=scResultCode.GetAt(1).Value
                    $$$THROWONERROR(tSC,xmlDoc.EvaluateExpression(sectionCodePath,"@codeSystem",.scResultCode1))
                    $$$THROWONERROR(tSC,xmlDoc.EvaluateExpression(sectionCodePath,"@displayName",.scResultCode2))
                    If (scResultCode1.Count()>0) Set sectionCoding.SDACodingStandard=scResultCode1.GetAt(1).Value
                    If (scResultCode2.Count()>0) Set sectionCoding.Description=scResultCode2.GetAt(1).Value
                }

                For i = 1:1:xmlResult.Count() {
                    Set pathList = $LISTBUILD(
                        tSectionPath_"/hl7:entry["_i_"]/hl7:act/hl7:entryRelationship/hl7:substanceAdministration",
                        tSectionPath_"/hl7:entry["_i_"]/hl7:substanceAdministration"
                    )
                    
                    Set lLength=$LISTLENGTH(pathList)
                    For l=1:1:lLength {
                        Set tSubAdminBasePath = $LIST(pathList,l)
                        
                        // Initialize tISMedicationRequest
                        Set tISMedicationRequest = ""
                        $$$THROWONERROR(tSC,xmlDoc.EvaluateExpression(tSubAdminBasePath,"@moodCode", .tISMedicationRequest))

                        If ((tISMedicationRequest.Count() > 0) && (("INT"=tISMedicationRequest.GetAt(1).Value) || (templateID="2.16.840.1.113883.10.20.22.2.10")) ) {
                            Set tMRequest = ##class(HS.SDA3.Medication).%New()
                            
                            // Only set section coding if it's a valid object
                            If ($IsObject(sectionCoding)) {
                                Set tMRequest.Extension.CDASectionCode=sectionCoding
                            }
                            
                            Set tMRSKE = ##class(HS.SDA3.CustomObject).%New()
                            // Additional medication request processing here
                            
                            $$$THROWONERROR(tSC, pSDACont.Medication.Insert(tMRequest))
                        }
                    }
                }
            }
        }
    }
    Catch ex {
        Set tSC=ex.AsStatus()
        // Debug information - moved inside catch to avoid errors
        Try {
            If '$DATA(xmlResult) {
                Write !,"DEBUG: xmlResult is undefined for path: ",$Get(tSectionPath,"UNDEFINED")_"/hl7:entry"
            } Else {
                Write !,"DEBUG: Found ",xmlResult.Count()," entries for template: ",$Get(templateID,"UNDEFINED")
            }
        } Catch debugEx {
            // Ignore debug errors
        }
    }

    Quit tSC
}

/// Description
ClassMethod GetEncounter(ByRef pDataArray As %String, ByRef xmlDoc As %XML.XPATH.Document, ByRef pSDAContainer As HS.SDA3.Container, pSecCode As HS.SDA3.CodeTableDetail, pEncPath As %String, pTIter As %Integer, Output pEncExtId As %String) As %Status
{
    #dim tSC   As %Status=$$$OK
    #dim eException  As %Exception.AbstractException

    Try {
        Set pEncExtId=""
        Set EncHash=""

        Set rolPath=pEncPath
        Set t = pTIter
        Set sectionCoding = pSecCode

        Set enEncNumber=""
        Set tSC=xmlDoc.EvaluateExpression("/hl7:ClinicalDocument/hl7:componentOf/hl7:encompassingEncounter/hl7:id","@extension",.tResult)
        If (tResult.Count() > 0) {Set enEncNumber=tResult.GetAt(1).Value}
        Set rolPath1=$REPLACE(rolPath, "[t]", "["_t_"]")

        $$$THROWONERROR(tSC, xmlDoc.EvaluateExpression(rolPath1, "*", .tEncounterResult))
        If (tEncounterResult.Count() > 0){
            Set encounter = ##class(HS.SDA3.Encounter).%New()
            Set encounter.Extension.CustomObject=pSDAContainer.CustomObjects.GetAt(1)

            Set tExtIDPath=rolPath1_"/hl7:id"

            If (rolPath'["encompassingEncounter") {
                Set encounter.Extension.CDASectionCoding=sectionCoding
            }else{
                If $D(pDataArray("EncompassingEncounter", "EncounterNumber")) {
                    Set pEncExtId=pDataArray("EncompassingEncounter", "EncounterNumber")
                    quit
                }
            }

            Set encounter.ExternalId=..GetExternalIDNoGUID(.xmlDoc, tExtIDPath)

            do $SYSTEM.Encryption.SHA1HashResult()
            do $SYSTEM.Encryption.SHA1HashInput(rolPath1)
            set EncHash= $SYSTEM.Encryption.Base64Encode($SYSTEM.Encryption.SHA1HashInput())

            Set encounter.EncounterNumber = EncHash

            If ($DATA(pDataArray("Encounter", encounter.EncounterNumber))){
                Set pEncExtId=encounter.EncounterNumber
                Quit
            }

            Set tRootVal="" , tExtnVal=""
            $$$THROWONERROR(tSC, xmlDoc.EvaluateExpression(rolPath1_"/hl7:id[1]", "@extension", .tResult))
            If ((tResult.Count() > 0) && ($ZSTRIP(tResult.GetAt(1).Value,"<>WC")'="")) {
                Set tExtnVal = $ZSTRIP(tResult.GetAt(1).Value, "<>WC")
            }

            $$$THROWONERROR(tSC, xmlDoc.EvaluateExpression(rolPath1_"/hl7:id[1]", "@root", .tResult))
            If ((tResult.Count() > 0) ){
                Set tRootVal = tResult.GetAt(1).Value
            }

            If (encounter.EncounterNumber="") {
                $$$THROWONERROR(tSC, xmlDoc.EvaluateExpression(rolPath1_"/hl7:id[2]", "@extension", .tResult))
                If ((tResult.Count() > 0) && ($ZSTRIP(tResult.GetAt(1).Value,"<>WC")'="")) {
                Set tExtnVal = $ZSTRIP(tResult.GetAt(1).Value, "<>WC")
                }
                $$$THROWONERROR(tSC, xmlDoc.EvaluateExpression(rolPath1_"/hl7:id[2]", "@root", .tResult))
                If ((tResult.Count() > 0) ){
                    Set tRootVal = tResult.GetAt(1).Value
                }
            }

        }

    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }

    Quit tSC
}

/// Description
ClassMethod GetExternalIDNoGUID(ByRef xmlDoc As %XML.XPATH.Document, pExtIDPath As %String = "", AppendGUID As %String = 1) As %String
{
    Set tExternalID=""
    Set tRoot="urn:oid"
    Set tRootValue = ""
    Set tExtn=""
    Set tRootVal=""
    Set tExtnVal=""
    Set tIdentifierVal=""

    Set tGUID=$ZSTRIP(##class(%SYSTEM.Util).CreateGUID(), "*P")

    Set tTempID="~"
    If ""=pExtIDPath Quit

    Set tSessionId=$GET($$$JobSessionId)

    $$$THROWONERROR(tSC, xmlDoc.EvaluateExpression(pExtIDPath, "@root",.tResult1))
    $$$THROWONERROR(tSC, xmlDoc.EvaluateExpression(pExtIDPath, "@extension",.tResult2))
    $$$THROWONERROR(tSC, xmlDoc.EvaluateExpression(pExtIDPath, ".",.tResultSet))

    For tI=1:1:tResultSet.Count()
    {
        Set tRootVal=""
        Set tExtnVal=""

        Set tResult=tResultSet.GetAt(tI)
        if (tResult.Type=2)
        {
            While tResult.Read()
            {
                If tResult.NodeType="element"
                {
                    If tResult.HasAttributes {
                        Set tSC=tResult.MoveToAttributeName("root")
                        If tSC {
                            Set tRootVal=tResult.Value
                        }
                        Set tSC=tResult.MoveToAttributeName("extension")
                        If tSC {
                            Set tExtnVal= $REPLACE(tResult.Value, "^", "*")
                        }
                    }
                }
            }
        }
    }

    Return tExternalID
}

}
