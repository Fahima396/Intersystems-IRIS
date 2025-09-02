Class HS.Local.SDA3.OtherOrderExtension Extends HS.SDA3.DataType
{

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.OtherOrder";

Property CustomObject As HS.SDA3.CustomObject(XMLNAME = "CustomObject");

Storage Default
{
<Data name="OtherOrderExtensionState">
<Subscript>"OtherOrderExtension"</Subscript>
<Value name="1">
<Value>CustomObject</Value>
</Value>
</Data>
<State>OtherOrderExtensionState</State>
<Type>%Storage.Serial</Type>
}

}
