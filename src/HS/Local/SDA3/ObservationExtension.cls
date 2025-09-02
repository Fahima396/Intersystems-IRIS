Class HS.Local.SDA3.ObservationExtension Extends HS.SDA3.DataType
{

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.Observation";

Property CustomObject As HS.SDA3.CustomObject(XMLNAME = "CustomObject");

Storage Default
{
<Data name="ObservationExtensionState">
<Subscript>"ObservationExtension"</Subscript>
<Value name="1">
<Value>CustomObject</Value>
</Value>
</Data>
<State>ObservationExtensionState</State>
<Type>%Storage.Serial</Type>
}

}
