Class CCDA.Messages.SDAToFHIRRequest Extends (%Persistent, HS.Message.XMLMessage, Ens.Request)
{

Parameter RESPONSECLASSNAME = "CCDA.Messages.SDAToFHIRResponse";

Property GCSBucketArchivePath As %String(MAXLEN = 500);

Property CCDAIDRoot As %String;

Property CCDAAssigningAuthorityName As %String;

Property CCDARequestId As %String;

Storage Default
{
<Data name="AdditionalInfo">
<Attribute>AdditionalInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"AdditionalInfo"</Subscript>
</Data>
<Data name="CustomAuditInfo">
<Attribute>CustomAuditInfo</Attribute>
<Structure>subnode</Structure>
<Subscript>"CustomAuditInfo"</Subscript>
</Data>
<Data name="SDAToFHIRRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GCSBucketArchivePath</Value>
</Value>
<Value name="3">
<Value>CCDAIDRoot</Value>
</Value>
<Value name="4">
<Value>CCDAAssigningAuthorityName</Value>
</Value>
<Value name="5">
<Value>CCDARequestId</Value>
</Value>
<Value name="6">
<Value>DocType</Value>
</Value>
<Value name="7">
<Value>Name</Value>
</Value>
<Value name="8">
<Value>ContentStream</Value>
</Value>
<Value name="9">
<Value>StreamCollection</Value>
</Value>
<Value name="10">
<Value>SOAPFault</Value>
</Value>
<Value name="11">
<Value>SAMLData</Value>
</Value>
</Data>
<DataLocation>^CCDA.Messages.SDAToFHIRReC11DD</DataLocation>
<DefaultData>SDAToFHIRRequestDefaultData</DefaultData>
<IdLocation>^CCDA.Messages.SDAToFHIRReC11DD</IdLocation>
<IndexLocation>^CCDA.Messages.SDAToFHIRReC11DI</IndexLocation>
<StreamLocation>^CCDA.Messages.SDAToFHIRReC11DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
