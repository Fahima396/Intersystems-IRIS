Class Demo1.Person Extends %Persistent
{

Property Name As %String;

Property City As %String;

Storage Default
{
<Data name="PersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>City</Value>
</Value>
</Data>
<DataLocation>^Demo1.PersonD</DataLocation>
<DefaultData>PersonDefaultData</DefaultData>
<IdLocation>^Demo1.PersonD</IdLocation>
<IndexLocation>^Demo1.PersonI</IndexLocation>
<StreamLocation>^Demo1.PersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
