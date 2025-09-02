Class CCDA.Messages.ProcessResponse Extends (%Persistent, Ens.Response)
{

Property StatusText As %String(MAXLEN = "");

Property Status As %String;

Storage Default
{
<Data name="ProcessResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StatusText</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^CCDA.Messages.ProcessResponseD</DataLocation>
<DefaultData>ProcessResponseDefaultData</DefaultData>
<IdLocation>^CCDA.Messages.ProcessResponseD</IdLocation>
<IndexLocation>^CCDA.Messages.ProcessResponseI</IndexLocation>
<StreamLocation>^CCDA.Messages.ProcessResponseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
