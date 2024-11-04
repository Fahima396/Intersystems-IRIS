Class Demo.test Extends (%Persistent, %Populate)
{

/// Description
Property Name As %String [ Required ];

/// Description
Property Address As %String;

Storage Default
{
<Data name="testDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Address</Value>
</Value>
</Data>
<DataLocation>^Demo.testD</DataLocation>
<DefaultData>testDefaultData</DefaultData>
<IdLocation>^Demo.testD</IdLocation>
<IndexLocation>^Demo.testI</IndexLocation>
<StreamLocation>^Demo.testS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
