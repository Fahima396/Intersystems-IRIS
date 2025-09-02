Class CCDA.GUID.StorageUtil Extends %RegisteredObject
{

/// Description
ClassMethod CreateGUID(SessionID As %String, SuperSessionID As %String = "") As %Status
{
    Try {
        If 'SessionID {
            $$$ThrowStatus($$$ERROR($$$GeneralError, "No SessionID - Cannot Generate GUID for this transaction"))
        }
        Else {
            Set sess = SessionID
            Set guid = $SYSTEM.Util.CreateGUID()
            Set guid = REPLACE(guid, "-", "")
        }
            Set res =##class(CCDA.GUID.Storage).%New()
            Set res.GUID = guid
            Set res.SessionID = sess
            Set res.SuperSessionID = SuperSessionID
            Set res.InsertDate=##class(%Library.UTC).NowUTC()
            Set tSC = res.%Save()

            If $$$ISERR(tSC) {
                $$$ThrowStatus($$$ERROR($$$GeneralError, "Error saving to SSIDStorage"))
            }
    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }
}

ClassMethod RetrieveGUID(SessionID As %String, Output GUID As %String, Output SuperSessionID As %String = "") As %Status
{
    #dim tGUID As %String = ""
    #dim tSuperSessionID As %String = ""

    Try {
        
        If SessionID '="" {
            &Sql(Select GUID, SuperSessionID into :tGUID, :tSuperSessionID from CCDA_GUID.Storage where SessionID=:SessionID)
            If (SQLCODE < 0){
                $$$ThrowStatus($$$ERROR($$$GeneralError, "Not able to fetch GUID SQLCODE="_SQLCODE))
            }
            ElseIf (SQLCODE = 100) {
                $$$ThrowStatus($$$ERROR($$$GeneralError, "No Records Found SQLCODE="_SQLCODE))
            }
        }

        If tGUID '="" Set GUID = tGUID
        If tSuperSessionID '="" Set SuperSessionID = tSuperSessionID
    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }
}

ClassMethod RetrieveGUIDBySuperSession(SuperSessionID As %String, Output GUID As %String) As %Status
{

    #dim tGUID As %String = ""

    Try {
        If SuperSessionID '="" {
            &Sql(Select GUID into :tGUID, :tSuperSessionID from CCDA_GUID.Storage where SessionID=:SessionID)

            If (SQLCODE < 0){
                $$$ThrowStatus($$$ERROR($$$GeneralError, "Not able to fetch GUID SQLCODE="_SQLCODE))
            }
        }
        If tGUID '="" Set GUID = tGUID
    }
    Catch ex {
        Set tSC=ex.AsStatus()
        Return tSC
    }
    Return $$$OK
}

}
