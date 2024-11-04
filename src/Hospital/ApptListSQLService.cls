Class Hospital.ApptListSQLService Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
 
	set tSC = $$$OK 
	try { 
		// 1. Create new message 
		set tMsg = ##class(Hospital.PatientApptRequest).%New() 
		// 2. Parse the incoming data and populate the message 
		set tMsg.PatientID=pInput.Get("ID") 
		set tMsg.PatientName=pInput.Get("Name") 
		set tMsg.ApptTime=pInput.Get("ApptTime") 
		set tMsg.ApptDate=pInput.Get("ApptDate") 
		// 3. Send the message asynchronously to the target
		set tSC=..SendRequestAsync("Hospital.PatientApptProcess",tMsg) 
	} catch ex{ 
		set tSC = ex.AsStatus() 
	} 

	return tSC
}

}
