Include (Ensemble, %occStream)

Class CCDA.Utils.DynDoc Extends %RegisteredObject
{

Property DynDocument As %Library.DynamicObject;

Property IdxArrValuePaths As array Of %String;

Property IdxArrSectionPaths As array Of %String;

Property IdxArrIdWildcardPaths As array Of %String;

Property XMLDocument As %XML.XPATH.Document;

Property OptimizationEnabled As %Boolean;

Property JobSID As %Integer;

Parameter PERCENTMAXMEM = 1;

/// Description
ClassMethod CreateFromStream(pStream As %AbstractStream, Output pDocument As CCDA.Utils.DynDoc, pEnableOptimizations As %Boolean = 0) As %Status
{
    #dim tSC   As %Status=$$$OK
    #dim eException  As %Exception.AbstractException

    Try {
        Set pDocument=##class(CCDA.Utils.DynDoc).%New()
        Set pDocument.OptimizationEnabled=pEnableOptimizations

        Do pStream.Rewind()
        $$$THROWONERROR(tSC, ##class(%XML.XPATH.Document).CreateFromStream(pStream,.xmlDoc))
        Set xmlDoc.PrefixMappings="hl7 urn:hl7-org:v3,sdtc urn:hl7-org:sdtc,ep2 urn:hl7-org:sdtc,xsi http://www.w3.org/2001/XMLSchema-instance"
        Set pDocument.XMLDocument=xmlDoc

        Set pDocument.JobSID = $GET($$$JobSessionId)
        Set %zExpCache(pDocument.JobSID, "EXPCACHE") = "" //actual cache subscript but it is monitoring available process memory
        Set %zExpCache(pDocument.JobSID, "JOBID") = $JOB
        Set %zExpCache(pDocument.JobSID, "JOBOBJ") = ##class(%SYS.ProcessQuery).%OpenId($JOB)
        Set %zExpCache(pDocument.JobSID, "JOBMEMA") = %zExpCache(pDocument.JobSID, "JOBOBJ").MemoryAllocated
        Set %zExpCache(pDocument.JobSID, "JOBMEMMAX") = %zExpCache(pDocument.JobSID, "JOBMEMA")*(..#PERCENTMAXMEM/100) // % of allocated memory

        $$$LOGINFO("Starting Job cache - MemoryAllocated: " _ %zExpCache(pDocument.JobSID, "JOBMEMA") _ "CacheMaxMemory: "_%zExpCache(pDocument.JobSID, "JOBMEMMAX"))
    
        If (pDocument.OptimizationEnabled) {
            Do pStream.Rewind()
            Set tJSONStream = ..XMLStreamToJSONStream(pStream)
            Set pDocument.DynDocument={}.%FromJSON(tJSONStream)

            $$$LOGINFO("After Calling xml Stream")

            Set tDynDocument = pDocument.DynDocument
            Set tIndexArray=""
            do ..RecurseJSON(.tDynDocument,0,"obj",.tIndexArray )

            set cursub = $order(tIndexArray("PathValue", ""))
            While (cursub '="") {
                do pDocument.IdxArrValuePaths.SetAt(tIndexArray("PathValue",cursub),cursub)
                set cursub=$ORDER(tIndexArray("PathValue",cursub))
            }
            
            set cursub = $order(tIndexArray("SectionTemplateId", ""))
            While (cursub '="") {
                do pDocument.IdxArrValuePaths.SetAt(tIndexArray("SectionTemplateId",cursub),cursub)
                set cursub=$ORDER(tIndexArray("SectionTemplateId",cursub))
            }
            
            set cursub = $order(tIndexArray("WildcardIDs", ""))
            While (cursub '="") {
                do pDocument.IdxArrValuePaths.SetAt(tIndexArray("WildcardIDs",cursub),cursub)
                set cursub=$ORDER(tIndexArray("WildcardIDs",cursub))
            }

            // FIXED: Process IdLookAhead section separately
            Set tIdPrevPath=""
            set cursub1 = $order(tIndexArray("IdLookAhead","TMP", ""))  // Changed to use IdLookAhead directly
            While (cursub1 '="") {
                If (tIdPrevPath '= cursub1) {
                    Set tIdGroup = ##class(%SYSTEM.Util).CreateGUID()
                }

                Set tExcludeIdent = 0
                Set curSub2 = $ORDER(tIndexArray("IdLookAhead","TMP",cursub1,""))
                While (curSub2 '= "") {
                    Set tIdValue = tIndexArray("IdLookAhead","TMP",cursub1, curSub2)
                    If ((curSub2="[0]") && (($PIECE(tIdValue,":::",1)="") || ($PIECE(tIdValue,":::",2)="")))
                    {
                        Set tExcludeIdent = 1
                        Quit
                    }

                    Set curSub2 = $ORDER(tIndexArray("IdLookAhead","TMP",cursub1,curSub2))
                }

                If (tExcludeIdent = 1) {
                    Set cursub1 = $ORDER(tIndexArray("IdLookAhead", "TMP", cursub1))
                    Continue
                } 

                // Look if Group GUID already exist for any of the identifiers
                Set tFoundGUID = 0
                Set curSub2 = $Order(tIndexArray("IdLookAhead","TMP",cursub1, ""))
                While (curSub2 '= "") {
                    Set tIdValue = tIndexArray("IdLookAhead","TMP",cursub1,curSub2)  // FIXED: Removed quotes
                    If (($PIECE(tIdValue,":::",1)'="") && ($PIECE(tIdValue,":::",2)'="") && ($D(tIndexArray("IdLookAhead","IdGUID",tIdValue)))){
                        Set tFoundGUID = tFoundGUID + 1
                        Set tIndexArray("IdLookAhead","MoveIds",tFoundGUID_"||"_tIdValue) = tIndexArray("IdLookAhead", "IdGUID", tIdValue)  // FIXED: Changed IDGUID to IdGUID
                    }

                    Set curSub2 = $ORDER(tIndexArray("IdLookAhead", "TMP", cursub1, curSub2))
                }

                // Now go through all the identifiers to move to this new GUID
                Set curSub2=$ORDER(tIndexArray("IdLookAhead", "MoveIds", ""))
                While (curSub2'="") {
                    Set tIdValue = $PIECE(curSub2, "||", 2)
                    Set tIdoldGUID = tIndexArray("IdLookAhead", "MoveIds", curSub2)

                    Set curSub3 = $ORDER(tIndexArray("IdLookAhead", "GroupGUID", tIdoldGUID, ""))
                    While (curSub3 '="") {
                        Set tIndexArray("IdLookAhead", "GroupGUID",tIdGroup, curSub3)=tIdGroup
                        Set tIndexArray("IdLookAhead", "IdGUID",curSub3)=tIdGroup

                        Set curSub3=$ORDER(tIndexArray("IdLookAhead", "GroupGUID", tIdoldGUID, curSub3))
                    }
                    kill tIndexArray("IdLookAhead", "GroupGUID", tIdoldGUID)

                    Set curSub2=$ORDER(tIndexArray("IdLookAhead", "MoveIds",curSub2))
                }
                kill tIndexArray("IdLookAhead", "MoveIds")

                // Now go through all the identifiers in that path and group them with a single GUID
                Set curSub2=$ORDER(tIndexArray("IdLookAhead", "TMP",cursub1,""))
                While (curSub2'=""){
                    Set tIdValue = tIndexArray("IdLookAhead", "TMP",cursub1, curSub2)

                    Set tIndexArray("IdLookAhead", "GroupGUID", tIdGroup, tIdValue)=tIdGroup
                    Set tIndexArray("IdLookAhead", "IdGUID",tIdValue) = tIdGroup

                    Set curSub2 = $ORDER(tIndexArray("IdLookAhead", "TMP",cursub1, curSub2))
                }

                Set tIdPrevPath=cursub1
                Set cursub1 = $ORDER(tIndexArray("IdLookAhead", "TMP",cursub1))
            }

            kill tIndexArray("IdLookAhead", "TMP")
            kill tIndexArray
        }
    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }

    Quit tSC
}

Method EvaluateExpression(pContext As %String, pExpression As %String, Output pResult As %ListOfObjects) As %Status
{
    #dim tSC As %Status=$$$OK
    #dim eException As %Exception.AbstractException
    #dim optFound As %Boolean=0


    Try {
        If (..OptimizationEnabled){
            // Create a new results collection
            Set pResults=##class(%ListOfObjects).%New("%Library.DynamicObject")

            If (pContext [ "//hl7:*[@ID='") {
                Set tOrigContext = pContext
                Set pContext = "//hl7:*[@ID='"_$PIECE(pContext, "//hl7:*[@ID='",2)
                Set tResultValue = ..IdxArrIdWildcardPaths.GetAt(pContext)
                If (tResultValue '= ""){
                    set pContext = "/" _ tResultValue
                }
                Else{
                    set pContext = tOrigContext
                }
            }

            If (pExpression [ "@") {
                $$$THROWONERROR(tSC,..GetAttributeResult(pContext, pExpression, .pResults))
                If (pResults.Count() > 0) {
                    set optFound = 1
                }
            }
                
        }

        If '(optFound) {
            $$$THROWONERROR(tSC, ..XMLDocument.EvaluateExpression(pContext, pExpression, .pResults))
        }
    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }
    Quit tSC
}

Method GetAttributeResult(pContext As %String, pExpression As %String, ByRef pResult As %ListOfObjects) As %Status
{
    #dim tSC As %Status=$$$OK
    #dim eException As %Exception.AbstractException

    Try {
        $$$THROWONERROR(tSC, ..ContextToEntityPath(pContext, pExpression, .tEntPath))
        Set tResultValue = ..IdxArrValuePaths.GetAt(tEntPath)

        If (tResultValue '= ""){
            Set tResul = ##class(%Library.DynamicObject).%New()
            Set tResul.Value = tResultValue

            $$$THROWONERROR(tSC,pResult.Insert(tResul))
        }
    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }
    Quit tSC
}

Method ContextToEntityPath(pContext As %String, pExpression As %String, Output pEntPath As %String) As %Status
{
    #dim tSC As %Status=$$$OK
    #dim eException As %Exception.AbstractException

    Try {
        Set tCtxList = $LISTFROMSTRING(pContext,"/hl7:")

        Set ptr1=0,count=0,pEntPath=""
        while $LISTNEXT(tCtxList, ptr1,val1){
            if (val1 [ "[") {
                Set tValkey = $PIECE(val1, "[", 2)
                Set tValkey = $PIECE(tValkey, "]", 1)
                If (tValkey [ "hl7:templateId/@root=") {
                    Set tValkey = $REPLACE(tValkey, " or ", "__")
                    Set tValkey = $REPLACE(tValkey, " OR ", "__")
                    Set tValkey = $REPLACE(tValkey, " Or ", "__")
                    Set tValkey = $REPLACE(tValkey, " oR ", "__")
                    Set tTemplateList = $LISTFROMSTRING(tValkey, "__")

                    Set ptr2 = 0
                    while $LISTNEXT(tTemplateList, ptr1, val2){
                        Set tFound = ..IdxArrSectionPaths.GetAt(val2)
                        If (tFound '= ""){
                            Set tValkey = $EXTRACT($REPLACE(tFound,"hl7:section[",""),1,*-1)
                            Quit
                        }
                    }

                }
                Set tValBase = $PIECE(val1, "[", 1)
                If (count > 0) {set pEntPath = pEntPath _ ".hl7:" _ tValBase _ "[" _ tValkey _ "]"}
            }Else{
                If (count > 0) {set pEntPath = pEntPath _ ".hl7:" _ val1 }
            }

            Set count = count + 1

        }

        Set pEntPath = "obj" _ pEntPath _ "." _ pExpression
    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }
    Quit tSC
}

ClassMethod RecurseJSON(ByRef obj As %DynamicAbstractObject, level = 0, path = "obj", ByRef pIdxArr As %String)
{
    set indent = $J("", level * 4)

    #dim iterator As %Iterator.Array
    set iterator = obj.%GetIterator()

    while iterator.%GetNext(.key, .value, .tType) {
        set type = obj.%GetTypeOf(key)

        If (1=1){
            If $CLASSNAME(obj) = "%Library.DynamicArray" {
                Set tKey = key + 1
                Set newPath = path _ "[" _ key _ "]"
            } Else{
                set newPath = path _ "." _ key
            }

            If (($ISOBJECT(value)) && (tType '= "string")) {
                do ..RecurseJSON(.value, level + 1, newPath, .pIdxArr)
            } Else{
                set pIdxArr("PathValue", newPath) = value
                If (($PIECE(newPath,".",7) [ "hl7:templateId") && (newPath [ "@root")) {
                    set pIdxArr("SectionTemplateId", "hl7:templateId/@root='" _ value _ "'") = $PIECE(newPath, ".", 6)
                }
                If (newPath [ ".@ID") {
                    Set tXpath = $REPLACE(newPath, "obj.", "")
                    Set tXpath = $REPLACE(tXpath, ".@ID", "")
                    Set tXpath = $REPLACE(tXpath, ".", "/")
                    Set pIdxArr("WildcardIDs", "//hl7:*[@ID='" _ value _ "']") = tXpath
                }
                If ((newPath [ ".hl7:id") && 
                   ((newPath [ "hl7:assignedAuthor.hl7:id") || (newPath [ "hl7:assignedPerson.hl7:id")
                   || (newPath [ "hl7:assignedEntity.hl7:id") || (newPath [ "hl7:associatedEntity.hl7:id")
                   || (newPath [ "hl7:playingEntity.hl7:id")))
                {
                    If (newPath [ ".@root") {
                        Set tBaseIdPath = $REPLACE(newPath,".@root", "")
                        Set tIdPath = $PIECE(tBaseIdPath,".hl7:id",1)_".hl7:id"
                        Set tIdRep = $PIECE(tBaseIdPath,".hl7:id",2)
                        If (tIdRep = "") {Set tIdRep = "[0]"}
                        Set tCurrentVal=":::"
                        // FIXED: Use tIdPath variable instead of literal "tIdPath"
                        If ($D(pIdxArr("IdLookAhead","TMP",tIdPath,tIdRep))) {
                            Set tCurrentVal = ":::" _ pIdxArr("IdLookAhead","TMP",tIdPath,tIdRep)
                        }
                        Set pIdxArr("IdLookAhead", "TMP", tIdPath, tIdRep) = value _ tCurrentVal
                    }
                    If (newPath [ ".@extension") {
                        Set tBaseIdPath = $REPLACE(newPath,".@extension", "")
                        Set tIdPath = $PIECE(tBaseIdPath,".hl7:id",1) _ ".hl7:id"
                        Set tIdRep = $PIECE(tBaseIdPath,".hl7:id",2)
                        If (tIdRep = "") {Set tIdRep = "[0]"}
                        Set tCurrentVal = ":::"
                        // FIXED: Use tIdPath variable instead of literal "tIdPath"
                        If ($D(pIdxArr("IdLookAhead","TMP",tIdPath,tIdRep))){
                            Set tCurrentVal = pIdxArr("IdLookAhead","TMP",tIdPath,tIdRep)
                        }
                        Set pIdxArr("IdLookAhead", "TMP", tIdPath, tIdRep) = tCurrentVal _ value
                    }
                }
            }
        }
    }
}

// ClassMethod XMLStreamToJSONStream(Stream As %Stream.TmpCharacter) As %Stream.DynamicCharacter [ Language = python ]

// {

//     import iris

//     import traceback  

//     import xmltodict, ujson 

//     #; def _run_with_trace(fn, *args, **kwargs):

//     #;     try:

//     #;         return {"ok": True, "result": fn(*args, **kwargs)}

//     #;     except Exception:

//     #;         return {"ok": False, "error": traceback.format_exc()}

//     def stream_to_string(stream)-> str:

//         string = ""

//         stream.Rewind()

//         while not stream.AtEnd:

//             string += stream.Read(1026)

//         return string 

//     result = _run_with_trace(stream_to_string, stream)

//     # iris.log("Python NameError: " + str(string))

//     def string_to_stream(string:str):

//         stream = iris.cls('%Stream.GlobalCharacter')._New()

//         n = 1026

//         chunks = [string[i:i+n] for i in range(0, len(string), n)]

//         for chunk in chunks:

//             stream.Write(chunk)

//         return stream

//     # iris.log("Python NameError: " + str(stream))

//     # XML to JSON 

//     namespaces = {

//         'urn:hl7-org:v3':'hl7',

//     }

//     pDict = xmltodict.parse(stream_to_string(stream), process_namespaces=True, namespaces=namespaces)

//     return string_to_stream(ujson.dumps(pDict))

// }

ClassMethod XMLStreamToJSONStream(Stream As %Stream.TmpCharacter) As %Stream.DynamicCharacter [ Language = python ]
{
    import iris
    import xmltodict, ujson 

    def stream_to_string(stream) -> str:
        string = ""
        stream.Rewind()
        while not stream.AtEnd:
            string += stream.Read(1026)
        return string 

    def string_to_stream(string: str):
        stream = iris.cls('%Stream.GlobalCharacter')._New()
        n = 1026
        chunks = [string[i:i+n] for i in range(0, len(string), n)]
        for chunk in chunks:
            stream.Write(chunk)
        return stream

    try:
        # Convert stream to string
        xml_string = stream_to_string(Stream)
        
        # XML to JSON conversion
        namespaces = {
            'urn:hl7-org:v3': 'hl7',
        }
        pDict = xmltodict.parse(xml_string, process_namespaces=True, namespaces=namespaces)
        json_string = ujson.dumps(pDict)
        
        return string_to_stream(json_string)
        
    except Exception as e:
        iris.log("Error in XMLStreamToJSONStream: " + str(e))
        raise e
}

/*ClassMethod XMLStreamToJSONStream(ByRef Stream As %Stream.TmpCharacter) As %Stream.DynamicCharacter
{
    // Helper: Convert stream to string
    Set xmlString = ""
    Do Stream.Rewind()
    While 'Stream.AtEnd {
        Set xmlString = xmlString _ Stream.Read(1026)
    }

    // Parse XML to object using %XML.Reader
    Set reader = ##class(%XML.Reader).%New()
    Set status = reader.OpenString(xmlString)
    If $$$ISERR(status) {
        Throw ##class(%Exception.General).%New("Failed to parse XML")
    }

    // Convert parsed XML to dynamic object
    Set dynObj = reader.CanonicalDocument()

    // Convert dynamic object to JSON string
    Set jsonString = dynObj.%ToJSON()

    // Convert JSON string to dynamic character stream
    Set jsonStream = ##class(%Stream.DynamicCharacter).%New()
    Set chunkSize = 1026
    For i=1:chunkSize:$Length(jsonString) {
        Do jsonStream.Write($Extract(jsonString, i, i+chunkSize-1))
    }

    Return jsonStream
}*/

/*ClassMethod XMLStreamToJSONStream(ByRef Stream As %Stream.TmpCharacter) As %Stream.DynamicCharacter
{
    // Step 1: Read XML stream into string
    Set xmlString = ""
    Do Stream.Rewind()
    While 'Stream.AtEnd {
        Set xmlString = xmlString _ Stream.Read(1024)
    }

    // Step 2: Create a dynamic object to hold parsed XML
    Set dynObj = ##class(%DynamicObject).%New()

    // Step 3: Use %XML.TextReader to parse XML manually
    Set reader = ##class(%XML.TextReader).%New()
    Set status = reader.OpenString(xmlString)
    If $$$ISERR(status) {
        Throw ##class(%Exception.General).%New("Failed to open XML string")
    }

    // Simple parser: build a flat dynamic object from XML elements
    While reader.Read() {
        If reader.NodeType = "element" {
            Set tag = reader.Name
            Set value = ""
            If reader.HasValue {
                Set value = reader.Value
            }
            DO dynObj.%Set(tag, value)
        }
    }

    // Step 4: Convert dynamic object to JSON string
    Set jsonString = dynObj.%ToJSON()

    // Step 5: Write JSON string to dynamic character stream
    Set jsonStream = ##class(%Stream.DynamicCharacter).%New()
    Set chunkSize = 1024
    For i=1:chunkSize:$Length(jsonString) {
        Do jsonStream.Write($Extract(jsonString, i, i+chunkSize-1))
    }

    Return jsonStream
}*/

// ClassMethod XMLStreamToJSONStream(Stream As %Stream.TmpCharacter) As %Stream.DynamicCharacter

// {

//     // Step 1: Read XML stream into string

//     $$$LOGINFO("Inside XMLStreamToJSONStream")

//     Set xmlString = ""

//     Do Stream.Rewind()

//     While 'Stream.AtEnd {

//         Set xmlString = xmlString _ Stream.Read(1024)

//     }

//     $$$LOGINFO("Inside XMLStreamToJSONStream at line 457")

//     // Step 2: Create dynamic object

//     Set dynObj = ##class(%DynamicObject).%New()

//     // Step 3: Very basic XML parsing (flat structure only)

//     // This assumes simple <tag>value</tag> format

//     Set pos = 1

//     While pos {

//         $$$LOGINFO("Inside while loop")

//         Set startTag = $Find(xmlString, "<", pos)

//         Set endTag = $Find(xmlString, ">", startTag)

//         Quit:(startTag=0)!(endTag=0)

//         Set tag = $Extract(xmlString, startTag+1, endTag-1)

//         Set closeTag = "</"_tag_">"

//         Set closePos = $Find(xmlString, closeTag, endTag)

//         Set value = $Extract(xmlString, endTag+1, closePos-$Length(closeTag)-1)

//         Do dynObj.%Set(tag, value)

//         Set pos = closePos + $Length(closeTag)

//     }

//     // Step 4: Convert to JSON string

//     Set jsonString = dynObj.%ToJSON()

//     // Step 5: Write JSON string to dynamic character stream

//     Set jsonStream = ##class(%Stream.DynamicCharacter).%New()

//     Set chunkSize = 1024

//     For i=1:chunkSize:$Length(jsonString) {

//         Do jsonStream.Write($Extract(jsonString, i, i+chunkSize-1))

//     }

//     Return jsonStream

// }

/*ClassMethod XMLStreamToJSONStream(ByRef Stream As %Stream.TmpCharacter) As %Stream.DynamicCharacter
{
        Try {
            // Convert stream to string
            Set xmlString = ""
            Do Stream.Rewind()
            While 'Stream.AtEnd {
                Set xmlString = xmlString _ Stream.Read(1026)
            }
            $$$LOGINFO("XML Input: "_xmlString)


            #; // Parse XML to dynamic object
            #; Set pDict = ##class(%XML.Reader).Parse(xmlString)
            #; $$$LOGINFO("pDict: "_pDict)
            #; // Convert dynamic object to JSON string
            #; Set jsonString = ##class(%DynamicObject).%ToJSON(pDict)

            #; // Convert JSON string to stream
            #; Set jsonStream = ##class(%Stream.GlobalCharacter).%New()
            #; Set chunkSize = 1026
            #; For i=1:chunkSize:$Length(jsonString) {
            #;     Set chunk = $Extract(jsonString, i, i+chunkSize-1)
            #;     Do jsonStream.Write(chunk)
            #; }
            // Step 1: Load XML into DOM
            Set doc = ##class(%XML.Document).%New()
            Set status = doc.LoadFromString(xmlString)
            If '$$$ISOK(status) {
                Throw ##class(%Exception.General).%New("Invalid XML format")
            }
            $$$LOGINFO("doc.DocumentElement: "_doc.DocumentElement)
            // Step 2: Convert DOM to DynamicObject
            Set root = doc.DocumentElement
            Set dynObj = {}
            For i = 1:1:root.ChildCount {
                Set child = root.GetChildNode(i)
                Set dynObj(child.Name) = child.NodeValue
            }

            // Step 3: Convert DynamicObject to JSON string
            Set jsonString = dynObj.%ToJSON()
            $$$LOGINFO("jsonString: "_jsonString)
            // Step 4: Convert JSON string to stream
            Set jsonStream = ##class(%Stream.TmpCharacter).%New()
            Do jsonStream.Write(jsonString)

            Return jsonStream
        }
        Catch ex {
            Set errorStream = ##class(%Stream.GlobalCharacter).%New()
            Do errorStream.Write("Error: "_ex.DisplayString())
            Return errorStream
        }
}*/
}
