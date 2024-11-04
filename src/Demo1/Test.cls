Class Demo1.Test Extends %RegisteredObject
{

/// Description
ClassMethod Add(A As %Integer, B As %Integer) As %Integer
{
    read !, "Enter a number: ", A
    read !, "Enter 2nd number: ", B
    Set sc = A+B
    W !, "The addition of 2 numbers: ", sc
}

ClassMethod AddPerson() As %Status
{
    Set tSC = $$$OK

    Set person=##class(Demo1.Person).%New()
    Set person.Name="Fahima"
    Set person.City="Meerut"
    Set tSC=person.%Save()

    return tSC
}

}
