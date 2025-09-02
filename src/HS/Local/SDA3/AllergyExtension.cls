Class HS.Local.SDA3.AllergyExtension Extends HS.SDA3.DataType
{

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.Allergy";

Property CustomObject As HS.SDA3.CustomObject(XMLNAME = "CustomObject");

Storage Default
{
<Data name="AllergyExtensionState">
<Subscript>"AllergyExtension"</Subscript>
<Value name="1">
<Value>CustomObject</Value>
</Value>
</Data>
<State>AllergyExtensionState</State>
<Type>%Storage.Serial</Type>
}

}
