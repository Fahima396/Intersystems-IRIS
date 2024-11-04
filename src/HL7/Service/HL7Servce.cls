Class HL7.Service.HL7Servce Extends Ens.BusinessService
{

// Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

Property TargetConfigName As Ens.DataType.ConfigName [ InitialExpression = "HL7.Process.HL7Procs" ];

/// Description
Property Category As Ens.Config.Item;

/// Description
/// Parameter SETTINGS = "AckTargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";
Parameter SETTINGS = "TargetConfigName:Category";

/// Description
Method OnProcessInput(pInput As HL7.HL7Msg, pOutput As %RegisteredObject) As %Status
{
        #dim tSC As %Status=$$$OK
        #dim eException As %Exception.AbstractException
        #dim tProcess As %String=""
        #; #dim tSendToProcess As %Boolean = 0     

        Set tSC=..ForceSessionId()


        #; $$$SetLogAttributes("EPP")

        Set tArr("APP_NAME") = "IRIS"
        Set tArr("JOB_NAME") =..%ConfigName
        Set tArr("METHOD_NAME") =##Expression($$$quote(%methodname))
        Set tArr("CLASS_NAME") = $CLASSNAME()
        Set tArr("CIS_SESSION_ID") =..%SessionId
        Set tArr("CIS_IRIS_NSP") = $namespace
        Set tArr("WORKSTREAM") = "EPP-ADT"
        Set tArr("CATEGORY") =..Category
        #; %Ensemble("%Process").%PrimaryRequestHeader.SourceConfigName
        #; pInput.SourceNetwork_"-"_pInput.TypeOfArtifact

        Try {
                #; $$$PushLogAttributes("BeforeEvaluatingRules",.tArr)
                Set tArr("STEP_NAME") = "BeforeEvaluatingRules"
                Set tSC = ##class(Logging.Util).LogStdout(.tArr)

                #; If ..SendToProcessRule'= ""{
                set hl7Msg = ##class(EnsLib.HL7.Message).ImportFromLibraryStream(pInput.DecodedHL7Msg, .tSC)
                $$$THROWONERROR(tSC,..SendRequestAsync(..TargetConfigName,.hl7Msg))
                        ;set hl7Msg.CopyValues(pInput.DecodedHL7Msg, pOutput.)
                

                
                #; $$$PushLogAttributes("AfterEvaluatingRules",.tArr)
                Set tArr("STEP_NAME") = "AfterEvaluatingRules"
                Set tSC = ##class(Logging.Util).LogStdout(.tArr)

                #; }
  
        
                #; if 'tSendToProcess{
                #;         $$$THROWONERROR(tSC,..SendRequestAsync(..TargetConfigName,.pInput))
                #; }
        }
        Catch eException {
                Set tSC=eException.AsStatus()
        }

        Quit tSC
}

}
