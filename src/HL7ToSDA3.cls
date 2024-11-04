Class Hospital.SDA3.HL7ToSDA3 Extends HS.Gateway.HL7.HL7ToSDA3 [ Not ProcedureBlock ]
{

/// Description
Method OnRequest(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
        set status = ##class(Hospital.SDA3.HL7ToSDA3).GetSDA(pRequest,.xml)
        if $data(xml)
        {
            set SDAmsg = ##class(Hospital.StreamRequest).%New()
            set SDAmsg.SDAStream = xml
            set status = ..SendRequestAsync("Hospital.HL7ToSDAOperation",SDAmsg)

            Quit status
        }
}

Method OnResponse(request As %Library.Persistent, ByRef response As %Library.Persistent)
{
        quit $$$OK
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
