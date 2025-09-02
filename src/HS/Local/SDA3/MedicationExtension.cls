Class HS.Local.SDA3.MedicationExtension Extends HS.SDA3.DataType
{

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.Medication";

Property CDASectionCode As HS.SDA3.CodeTableDetail;

Property CustomObject As HS.SDA3.CustomObject(XMLNAME = "CustomObject");

Storage Default
{
<Data name="MedicationExtensionState">
<Subscript>"MedicationExtension"</Subscript>
<Value name="1">
<Value>CDASectionCode</Value>
</Value>
<Value name="2">
<Value>CustomObject</Value>
</Value>
</Data>
<State>MedicationExtensionState</State>
<Type>%Storage.Serial</Type>
}

}
