Class HS.Local.SDA3.RadOrderExtension Extends HS.SDA3.DataType
{

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.RadOrder";

Property CustomObject As HS.SDA3.CustomObject(XMLNAME = "CustomObject");

Storage Default
{
<Data name="RadOrderExtensionState">
<Subscript>"RadOrderExtension"</Subscript>
<Value name="1">
<Value>CustomObject</Value>
</Value>
</Data>
<State>RadOrderExtensionState</State>
<Type>%Storage.Serial</Type>
}

}
