Class HS.Local.SDA3.ProcedureExtension Extends HS.SDA3.DataType
{

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.Procedure";

Property CustomObject As HS.SDA3.CustomObject(XMLNAME = "CustomObject");

Storage Default
{
<Data name="ProcedureExtensionState">
<Subscript>"ProcedureExtension"</Subscript>
<Value name="1">
<Value>CustomObject</Value>
</Value>
</Data>
<State>ProcedureExtensionState</State>
<Type>%Storage.Serial</Type>
}

}
