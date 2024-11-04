Class Library.Book Extends (%Persistent, %XML.Adaptor, %Populate)
{

/// Friend of jilly
Property Friend As Library.Person;

/// Title of the Book
Property Title As %String [ Required ];

/// Author of the Book
Property Author As Library.Person;

/// Genre of the Book
Property Genre As %String;

Storage Default
{
<Data name="BookDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Title</Value>
</Value>
<Value name="3">
<Value>Author</Value>
</Value>
<Value name="4">
<Value>Genre</Value>
</Value>
<Value name="5">
<Value>Friend</Value>
</Value>
<Value name="6">
<Value>Publication</Value>
</Value>
</Data>
<DataLocation>^Library.BookD</DataLocation>
<DefaultData>BookDefaultData</DefaultData>
<IdLocation>^Library.BookD</IdLocation>
<IndexLocation>^Library.BookI</IndexLocation>
<StreamLocation>^Library.BookS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
