Class HS.Local.SDA3.SocialDeterminantExtension Extends HS.SDA3.DataType
{

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.SocialDeterminant";

Property CustomObject As HS.SDA3.CustomObject(XMLNAME = "CustomObject");

Storage Default
{
<Data name="SocialDeterminantExtensionState">
<Subscript>"SocialDeterminantExtension"</Subscript>
<Value name="1">
<Value>CustomObject</Value>
</Value>
</Data>
<State>SocialDeterminantExtensionState</State>
<Type>%Storage.Serial</Type>
}

}
