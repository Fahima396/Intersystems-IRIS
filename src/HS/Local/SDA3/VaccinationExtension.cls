Class HS.Local.SDA3.VaccinationExtension Extends HS.SDA3.DataType
{

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.Vaccination";

Property CustomObject As HS.SDA3.CustomObject(XMLNAME = "CustomObject");

Storage Default
{
<Data name="VaccinationExtensionState">
<Subscript>"VaccinationExtension"</Subscript>
<Value name="1">
<Value>CustomObject</Value>
</Value>
</Data>
<State>VaccinationExtensionState</State>
<Type>%Storage.Serial</Type>
}

}
