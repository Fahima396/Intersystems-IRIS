Class CCDA.Messages.SDAToFHIRResponse Extends (%Persistent, %XML.Adaptor, Ens.Response)
{

Property OriginalRequest As CCDA.Messages.SDAToFHIRRequest;

Property Status As %Stream.GlobalCharacter;

Storage Default
{
<Data name="SDAToFHIRResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OriginalRequest</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^CCDA.Messages.SDAToFHIRRe2E9DD</DataLocation>
<DefaultData>SDAToFHIRResponseDefaultData</DefaultData>
<IdLocation>^CCDA.Messages.SDAToFHIRRe2E9DD</IdLocation>
<IndexLocation>^CCDA.Messages.SDAToFHIRRe2E9DI</IndexLocation>
<StreamLocation>^CCDA.Messages.SDAToFHIRRe2E9DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
