Class User.PatientData Extends (%Persistent, %XML.Adaptor)
{

Property PatientID As %Integer;

Property Name As %String;

Property InsuranceCompany As %String;

Property PrimaryPhysician As %String;

Property CreditRating As %Numeric;

Property HomePhone As %String;

Property WorkPhone As %String;

Property MobilePhone As %String;

Property HomeAdd As User.Address;

Property WorkAdd As User.Address;

ClassMethod ImportFromXML(filename As %String = "/tmp/irisupdate/PatientData.xml") As %Status
{
	
	Set reader=##class(%XML.Reader).%New()
	Set status=reader.OpenFile(filename)
	quit:$$$ISERR(status) status
	
	Do reader.Correlate("Patient","User.PatientData")
	
	While (reader.Next(.object,.status)){
	 	set status=object.%Save()
	 	quit:$$$ISERR(status) 
	}
	
	Quit status
}

Storage Default
{
<Data name="PatientDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>InsuranceCompany</Value>
</Value>
<Value name="5">
<Value>PrimaryPhysician</Value>
</Value>
<Value name="6">
<Value>CreditRating</Value>
</Value>
<Value name="7">
<Value>HomePhone</Value>
</Value>
<Value name="8">
<Value>WorkPhone</Value>
</Value>
<Value name="9">
<Value>MobilePhone</Value>
</Value>
<Value name="10">
<Value>HomeAdd</Value>
</Value>
<Value name="11">
<Value>WorkAdd</Value>
</Value>
</Data>
<DataLocation>^User.PatientDataD</DataLocation>
<DefaultData>PatientDataDefaultData</DefaultData>
<IdLocation>^User.PatientDataD</IdLocation>
<IndexLocation>^User.PatientDataI</IndexLocation>
<StreamLocation>^User.PatientDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
