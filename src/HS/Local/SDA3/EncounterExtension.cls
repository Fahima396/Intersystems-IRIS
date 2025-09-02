Class HS.Local.SDA3.EncounterExtension Extends HS.SDA3.DataType
{

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.Encounter";

Property CustomObject As HS.SDA3.CustomObject(XMLNAME = "CustomObject");

Property CDASectionCoding As HS.SDA3.CodeTableDetail;

Storage Default
{
<Data name="EncounterExtensionState">
<Subscript>"EncounterExtension"</Subscript>
<Value name="1">
<Value>CustomObject</Value>
</Value>
<Value name="2">
<Value>CDASectionCoding</Value>
</Value>
</Data>
<State>EncounterExtensionState</State>
<Type>%Storage.Serial</Type>
}

}
