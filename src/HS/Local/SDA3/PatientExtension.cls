Class HS.Local.SDA3.PatientExtension Extends HS.SDA3.DataType
{

Parameter HSDEPLOY = 0;

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.Patient";

/// Description
Property CustomObject As HS.SDA3.CustomObject(XMLNAME = "CustomObject");

Property CustomObject As %String(MAXLEN = "");

Storage Default
{
<Data name="PatientExtensionState">
<Subscript>"PatientExtension"</Subscript>
<Value name="1">
<Value>CustomObjects</Value>
</Value>
<Value name="2">
<Value>CustomObject</Value>
</Value>
</Data>
<State>PatientExtensionState</State>
<Type>%Storage.Serial</Type>
}

}
