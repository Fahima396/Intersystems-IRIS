Class CCDA.GUID.Storage Extends %Persistent
{

Property GUID As %String;

Property SessionID As %String;

Property SuperSessionID As %String(MAXLEN = 200);

Index GUIDIdx On GUID;

Index SuperSessionIDx On SuperSessionID;

Property InsertDate As %UTC;

Index InsertDate On InsertDate;

Index SuperSessionIDIdx On SuperSessionID;

Index SessionIDIdx On SessionID;

Storage Default
{
<Data name="StorageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GUID</Value>
</Value>
<Value name="3">
<Value>SessionID</Value>
</Value>
<Value name="4">
<Value>SuperSessionID</Value>
</Value>
<Value name="5">
<Value>InsertDate</Value>
</Value>
</Data>
<DataLocation>^CCDA.GUID.StorageD</DataLocation>
<DefaultData>StorageDefaultData</DefaultData>
<IdLocation>^CCDA.GUID.StorageD</IdLocation>
<IndexLocation>^CCDA.GUID.StorageI</IndexLocation>
<StreamLocation>^CCDA.GUID.StorageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
