Class Demo.Company Extends (%Persistent, %Library.Populate)
{

/// Name of the company
Property Name As %String [ Required ];

/// How many years the company has been active
Property YearsActive As %Integer;

/// What industry the company is part of
Property Industry As %String;

/// What country is the company based in
Parameter COUNTRY = "USA";

/// Description
ClassMethod QuarterlyProfits(Expenses As %Integer, Earnings As %Integer) As %Integer
{
        set profit = Earnings - Expenses
        // do something
        return profit
}

/// Print out all information about company
Method PrintCompany() As %Status
{

        write !, "The name of this company is ", ..Name,"."
        write !, ..Name, " has been active in the ", ..Industry, " industry for ", ..YearsActive, " years."
        return $$$OK
}

Storage Default
{
<Data name="CompanyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>YearsActive</Value>
</Value>
<Value name="4">
<Value>Industry</Value>
</Value>
</Data>
<DataLocation>^Demo.CompanyD</DataLocation>
<DefaultData>CompanyDefaultData</DefaultData>
<IdLocation>^Demo.CompanyD</IdLocation>
<IndexLocation>^Demo.CompanyI</IndexLocation>
<StreamLocation>^Demo.CompanyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
