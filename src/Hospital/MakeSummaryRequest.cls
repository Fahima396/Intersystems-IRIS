Class Hospital.MakeSummaryRequest Extends Ens.Request
{

Property MainStreetCount As %Integer;

Property MemorialDriveCount As %Integer;

Storage Default
{
<Data name="MakeSummaryRequestDefaultData">
<Subscript>"MakeSummaryRequest"</Subscript>
<Value name="1">
<Value>MainStreetCount</Value>
</Value>
<Value name="2">
<Value>MemorialDriveCount</Value>
</Value>
</Data>
<DefaultData>MakeSummaryRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
