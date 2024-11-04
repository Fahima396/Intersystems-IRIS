Class FHIRDemo.Audit.HL7Audit Extends (%Persistent, %Populate, %XML.Adaptor)
{

/// Description
Property HL7FileName As %String;

/// Description
Property MessageType As %String;

/// Description
Property TriggerEvent As %String;

/// Sender
Property Sender As %String;

/// Description
Property Receiver As %String;

/// Description
Property ReceivedDate As %String;

/// Description
Property ReceivedTime As %String;

/// Description
Property ReceivedPatientID As %String;

/// Description
Property HL7Version As %String;

Storage Default
{
<Data name="HL7AuditDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HL7FileName</Value>
</Value>
<Value name="3">
<Value>MessageType</Value>
</Value>
<Value name="4">
<Value>TriggerEvent</Value>
</Value>
<Value name="5">
<Value>Sender</Value>
</Value>
<Value name="6">
<Value>Receiver</Value>
</Value>
<Value name="7">
<Value>ReceivedDate</Value>
</Value>
<Value name="8">
<Value>ReceivedTime</Value>
</Value>
<Value name="9">
<Value>ReceivedPatientID</Value>
</Value>
<Value name="10">
<Value>HL7Version</Value>
</Value>
</Data>
<DataLocation>^FHIRDemo.Audit.HL7AuditD</DataLocation>
<DefaultData>HL7AuditDefaultData</DefaultData>
<IdLocation>^FHIRDemo.Audit.HL7AuditD</IdLocation>
<IndexLocation>^FHIRDemo.Audit.HL7AuditI</IndexLocation>
<StreamLocation>^FHIRDemo.Audit.HL7AuditS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
