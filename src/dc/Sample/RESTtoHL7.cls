Class dc.RESTtoHL7 Extends EnsLib.HL7.Service.Standard
{
    /// Description
    Method ProcessHL7(pInput AS %String, Output pOutput AS %String) As %Status [ WebMethod ]
    {
        #dim tSC AS %Status = $$$OK
        #dim tSC1 AS %Status = $$$OK
        #dim eException AS %Exception.AbstractException
        #Dim tOneTarget AS %String
        #Dim tHL7Msg AS EnsLib.HL7.Message
        
    }
}