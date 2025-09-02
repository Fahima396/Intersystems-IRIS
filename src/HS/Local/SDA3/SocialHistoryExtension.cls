Class HS.Local.SDA3.SocialHistoryExtension Extends HS.SDA3.DataType
{

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.SocialHistory";

Property CustomObject As HS.SDA3.CustomObject(XMLNAME = "CustomObject");

Storage Default
{
<Data name="SocialHistoryExtensionState">
<Subscript>"SocialHistoryExtension"</Subscript>
<Value name="1">
<Value>CustomObject</Value>
</Value>
</Data>
<State>SocialHistoryExtensionState</State>
<Type>%Storage.Serial</Type>
}

}
