Class HS.Local.SDA3.DocumentExtension Extends HS.SDA3.DataType
{

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.Document";

Property CustomObject As HS.SDA3.CustomObject(XMLNAME = "CustomObject");

Storage Default
{
<Data name="DocumentExtensionState">
<Subscript>"DocumentExtension"</Subscript>
<Value name="1">
<Value>CustomObject</Value>
</Value>
</Data>
<State>DocumentExtensionState</State>
<Type>%Storage.Serial</Type>
}

}
