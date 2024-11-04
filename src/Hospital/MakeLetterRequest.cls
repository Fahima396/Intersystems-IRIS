Class Hospital.MakeLetterRequest Extends Ens.Request
{

Property PhysicianName As %String;

Property PatientName As %String;

Property ApptAddress As %String;

Property ApptDate As %String;

Property ApptTime As %String;

Storage Default
{
<Data name="MakeLetterRequestDefaultData">
<Subscript>"MakeLetterRequest"</Subscript>
<Value name="1">
<Value>PhysicianName</Value>
</Value>
<Value name="2">
<Value>PatientName</Value>
</Value>
<Value name="3">
<Value>ApptAddress</Value>
</Value>
<Value name="4">
<Value>ApptDate</Value>
</Value>
<Value name="5">
<Value>ApptTime</Value>
</Value>
</Data>
<DefaultData>MakeLetterRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
