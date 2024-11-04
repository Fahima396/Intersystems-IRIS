Class Hospital.PatientDBOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method GetPrimaryPhysician(pRequest As Hospital.PrimaryPhysicianRequest, Output pResponse As Hospital.PrimaryPhysicianResponse) As %Status
{
	set tSC = $$$OK
	try
	{
		// Create query string - concatenate PatientID from request message onto the end
		set query = "Select PrimaryPhysician from PatientData where id = " _ pRequest.PatientID
		
		// Call to external database and execute the given query. tResult holds the resultset returned from external database
		// Connection settings for external datbase will be defined when the business operation is added to the production
		set tSC = ..Adapter.ExecuteQuery(.tResult, query)
		
		// If the adapter returns an error, throw to catch block
		// For example, the adapter will return error if it cannot connect to the external database or if they query is invalid
		$$$ThrowOnError(tSC)
		
		// Fetches the result. If more than one row of data was expected, then a loop would be necessary.
		// If no result was returned because the PatientID did not exist in table, then the "else" block will run
		if (tResult.Next()) {
			
			// Create instance of response message class
			set pResponse = ##class(Hospital.PrimaryPhysicianResponse).%New()
			
			// Fill response message with data from the resultset
			set pResponse.Name = tResult.Get("PrimaryPhysician")
		}
		else {
			set tSC = $System.Status.Error($$$GeneralError, "Invalid Patient ID")
			$$$ThrowOnError(tSC)
		}
	}
	catch ex
	{
		// Return error status. Will be put in Event Log
		set tSC = ex.AsStatus()
	}
	
	return tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Hospital.PrimaryPhysicianRequest"> 
		<Method>GetPrimaryPhysician</Method>
	</MapItem>
</MapItems>
}

}
