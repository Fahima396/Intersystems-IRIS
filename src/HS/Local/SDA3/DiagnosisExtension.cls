Class HS.Local.SDA3.DiagnosisExtension Extends HS.SDA3.DataType
{

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.Diagnosis";

Property CustomObject As HS.SDA3.CustomObject(XMLNAME = "CustomObject");

Storage Default
{
<Data name="DiagnosisExtensionState">
<Subscript>"DiagnosisExtension"</Subscript>
<Value name="1">
<Value>CustomObject</Value>
</Value>
</Data>
<State>DiagnosisExtensionState</State>
<Type>%Storage.Serial</Type>
}

}
