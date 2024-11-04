Class Hospital.Audit.CCDAAudit Extends (%Persistent, %Populate, %XML.Adaptor)
{

/// Description
Property Name As %String;

/// Description
Parameter Version = "v3";

Storage Default
{
<Data name="CCDAAuditDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OriginalFileName</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>ID</Value>
</Value>
</Data>
<DataLocation>^Hospital.Audit.CCDAAuditD</DataLocation>
<DefaultData>CCDAAuditDefaultData</DefaultData>
<IdLocation>^Hospital.Audit.CCDAAuditD</IdLocation>
<IndexLocation>^Hospital.Audit.CCDAAuditI</IndexLocation>
<StreamLocation>^Hospital.Audit.CCDAAuditS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
