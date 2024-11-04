Class Demo.Person Extends (%Persistent, %Populate)
{

Property Name As %String;

Property Gender As %String;

Method Print() As %Status
{
 	write !, "This person’s name is “, ..Name, “. They are now your friend!"
}

ClassMethod ShowIDs() As %Status
{
 
	
 	&sql(declare ID cursor for select * into :person() from Demo.Person)
 	&sql(open ID)
 	write !, "Available IDs"
 	write !, "--------------"
 	for {
 
	 	&sql(fetch ID)
 	 	quit:(SQLCODE '=0)
  		write !,person(1),?5,"- ",person(3)
  
 	}
 
	 &sql(close ID)
}

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
<Value>Gender</Value>
</Value>
</Data>
<DataLocation>^Demo.PersonD</DataLocation>
<DefaultData>PersonDefaultData</DefaultData>
<IdLocation>^Demo.PersonD</IdLocation>
<IndexLocation>^Demo.PersonI</IndexLocation>
<StreamLocation>^Demo.PersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
