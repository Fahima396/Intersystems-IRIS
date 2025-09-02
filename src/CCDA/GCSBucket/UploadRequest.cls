Class CCDA.GCSBucket.UploadRequest Extends Ens.Request
{

Property FileName As %String(MAXLEN = "");

Storage Default
{
<Data name="UploadRequestDefaultData">
<Subscript>"UploadRequest"</Subscript>
<Value name="1">
<Value>FileName</Value>
</Value>
</Data>
<DefaultData>UploadRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
