Class HS.Local.SDA3.ProblemExtension Extends HS.SDA3.DataType
{

Parameter STREAMLETCLASS = "HS.SDA3.Streamlet.Problem";

Property CustomObject As HS.SDA3.CustomObject(XMLNAME = "CustomObject");

Storage Default
{
<Data name="ProblemExtensionState">
<Subscript>"ProblemExtension"</Subscript>
<Value name="1">
<Value>CustomObject</Value>
</Value>
</Data>
<State>ProblemExtensionState</State>
<Type>%Storage.Serial</Type>
}

}
