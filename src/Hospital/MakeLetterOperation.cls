Class Hospital.MakeLetterOperation Extends Ens.BusinessOperation
{

Property Adapter As EnsLib.File.OutboundAdapter;

Parameter ADAPTER = "EnsLib.File.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method WriteLetter(pRequest As Hospital.MakeLetterRequest, Output pResponse As Ens.Response) As %Status
{
    set tSC = $$$OK

    try
    {
        set out = "Dear " _ pRequest.PatientName _","_ $char(13,10) _ $char(13,10)

        set out = out _ "This is a reminder of your upcoming appointment at " _ pRequest.ApptAddress
        set out = out _ " with " _ pRequest.PhysicianName _ " at " _pRequest.ApptTime
        set out = out _ " on " _ pRequest.ApptDate _ "." _ $char(13,10) _ $char(13,10)

        set out = out _ "Sincerely, " _ $char(13,10) _ $char(13,10) _ "ISC Health"

        set fileName = pRequest.PatientName _ ".txt"
        set tSC = ..Adapter.PutString(fileName, out)
    }
    catch ex
    {
        set tSC = ex.AsStatus()
    }
    quit tSC
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="Hospital.MakeLetterRequest">
        <Method>WriteLetter</Method>
    </MapItem>
</MapItems>
}

}
