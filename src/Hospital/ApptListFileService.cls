Class Hospital.ApptListFileService Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

Parameter SETTINGS = "TargetConfigNames";

Property TargetConfigNames As Ens.DataType.ConfigName;

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As %RegisteredObject) As %Status
{
	set tSC = $$$OK
	try {
			//Create new production msg
			set pRequest = ##class(Hospital.ApptListRequest).%New()
			
			//Parse the incoming data and populate the msg
			while ('pInput.AtEnd){
				set msg = ##class(Hospital.PatientApptRequest).%New()
				
				set line = pInput.ReadLine()
				set id = $piece(line,"-",2)
				set msg.PatientID = id
				
				set line = pInput.ReadLine()
				set name = $piece(line,"-",2)
				set msg.PatientName = name


				set line = pInput.ReadLine()
				set date = $piece(line,"-",2)
				set msg.ApptDate = date
				
				
				set line = pInput.ReadLine()
				set time = $piece(line,"-",2)
				set msg.ApptTime = time
				
				do pRequest.Appointments.Insert(msg)
				
				//Read blank line between entries
				do pInput.ReadLine()
				
				
				}	
				
				//send msg to targets
				set tSC = ..SendRequestAsync("Hospital.ApptListProcess",pRequest)
				
				
				//if needed populate the poutput
	
	}catch ex{
		
		set tSC = ex.AsStatus()
		
		
		}





	Quit $$$ERROR($$$NotImplemented)
}

}
