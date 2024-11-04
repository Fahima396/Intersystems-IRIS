Class Package.Person Extends (%Persistent, %JSON.Adaptor, %XML.Adaptor, %Library.Populate)
{

/// Patient Name
Property Name As %String [ Required ];

/// Phone
Property Phone As %String;

/// Age
Property Age As %Integer;

/// Sum of two integers
ClassMethod Sum(A As %Integer = 0, B As %Integer = 0) As %Integer
{
    Set result = A + B
    // do something
    Return result
}

/// Print out information
Method Print() As %Status
{
    write !, "This person is named ", ..Name,"."
    write !, ..Name, "'s phone number is", ..Phone,"."
    write !, ..Name, " is ", ..Age, "years old."
}

/// Planet
Parameter PLANET = "Earth";

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
<Value>Phone</Value>
</Value>
<Value name="4">
<Value>Age</Value>
</Value>
</Data>
<DataLocation>^Package.PersonD</DataLocation>
<DefaultData>PersonDefaultData</DefaultData>
<IdLocation>^Package.PersonD</IdLocation>
<IndexLocation>^Package.PersonI</IndexLocation>
<StreamLocation>^Package.PersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
