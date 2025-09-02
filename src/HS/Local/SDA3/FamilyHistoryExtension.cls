Class HS.Local.SDA3.FamilyHistoryExtension Extends HS.SDA3.DataType
{

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.FamilyHistory";

Property CustomObject As HS.SDA3.CustomObject(XMLNAME = "CustomObject");

Storage Default
{
<Data name="FamilyHistoryExtensionState">
<Subscript>"FamilyHistoryExtension"</Subscript>
<Value name="1">
<Value>CustomObject</Value>
</Value>
</Data>
<State>FamilyHistoryExtensionState</State>
<Type>%Storage.Serial</Type>
}

}
