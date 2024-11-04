Class Hospital.SDA3.ZTransplant Extends HS.SDA3.SuperClass
{

Property OrganType As %String;

Property TransplantPhysician As HS.SDA3.CodeTableDetail.CareProvider;

Storage Default
{
<Data name="SuperClassState">
<Subscript>"SuperClass"</Subscript>
<Value name="1">
<Value>ActionCode</Value>
</Value>
<Value name="2">
<Value>ActionScope</Value>
</Value>
<Value name="3">
<Value>EnteredBy</Value>
</Value>
<Value name="4">
<Value>EnteredAt</Value>
</Value>
<Value name="5">
<Value>EnteredOn</Value>
</Value>
<Value name="6">
<Value>ExternalId</Value>
</Value>
<Value name="7">
<Value>EncounterNumber</Value>
</Value>
<Value name="8">
<Value>FromTime</Value>
</Value>
<Value name="9">
<Value>ToTime</Value>
</Value>
<Value name="10">
<Value>Deleted</Value>
</Value>
<Value name="11">
<Value>UpdatedOn</Value>
</Value>
<Value name="12">
<Value>CustomPairs</Value>
</Value>
<Value name="13">
<Value>SourceFormat</Value>
</Value>
<Value name="14">
<Value>ProvenanceIds</Value>
</Value>
<Value name="15">
<Value>OrganType</Value>
</Value>
<Value name="16">
<Value>TransplantPhysician</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
