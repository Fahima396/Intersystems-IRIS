Class dc.HL7Servce Extends Ens.BusinessService
{

// Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

Property TargetConfigName As Ens.DataType.ConfigName [ InitialExpression = "dc.HL7Procs" ];

/// Description
/// Parameter SETTINGS = "AckTargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";
Parameter SETTINGS = "TargetConfigName";

/// Description
Method OnProcessInput(pInput As dc.Sample.HL7, pOutput As %RegisteredObject) As %Status
{
        Set sc = $$$OK
        set hl7Msg = ##class(EnsLib.HL7.Message).ImportFromLibraryStream(pInput.DecodedHL7Msg, .tSC)
        $$$THROWONERROR(sc,..SendRequestAsync(..TargetConfigName,.hl7Msg))
        ;set hl7Msg.CopyValues(pInput.DecodedHL7Msg, pOutput.)
        Return sc
}

}
