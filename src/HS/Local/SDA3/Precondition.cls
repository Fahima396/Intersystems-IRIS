Class HS.Local.SDA3.Precondition Extends HS.SDA3.DataType
{

Property CriteriaCode As HS.SDA3.CodeTableDetail.AdministrationStatus;

Property CriteriaValue As HS.SDA3.CodeTableDetail.Diagnosis;

Storage Default
{
<Data name="PreconditionState">
<Subscript>"Precondition"</Subscript>
<Value name="1">
<Value>CriteriaCode</Value>
</Value>
<Value name="2">
<Value>CriteriaValue</Value>
</Value>
</Data>
<State>PreconditionState</State>
<Type>%Storage.Serial</Type>
}

}
