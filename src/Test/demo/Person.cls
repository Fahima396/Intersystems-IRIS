Class Test.demo.Person Extends %Library.Persistent
{

/// Description
Property Name As %String;

Storage Default
{
<Data name="PersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^Test.demo.PersonD</DataLocation>
<DefaultData>PersonDefaultData</DefaultData>
<IdLocation>^Test.demo.PersonD</IdLocation>
<IndexLocation>^Test.demo.PersonI</IndexLocation>
<StreamLocation>^Test.demo.PersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
