Class Hospital.Appointment Extends (%Persistent, %Library.Populate)
{

Property Name As %String [ Required ];

Property FavoriteColor As %String(POPSPEC = "ValueList("",Red,Purple,Orange,Pink,Yellow,Green,Blue"")");

Property ApptTime As %Time [ Required ];

Property ApptDate As %Date [ Required ];

Storage Default
{
<Data name="AppointmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>FavoriteColor</Value>
</Value>
<Value name="4">
<Value>ApptTime</Value>
</Value>
<Value name="5">
<Value>ApptDate</Value>
</Value>
</Data>
<DataLocation>^Hospital.AppointmentD</DataLocation>
<DefaultData>AppointmentDefaultData</DefaultData>
<IdLocation>^Hospital.AppointmentD</IdLocation>
<IndexLocation>^Hospital.AppointmentI</IndexLocation>
<StreamLocation>^Hospital.AppointmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
