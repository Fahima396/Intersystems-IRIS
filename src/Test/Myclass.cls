Class Test.Myclass Extends %RegisteredObject
{

/// Description
ClassMethod Add(A As %Integer, B As %Integer) As %Integer
{
    read !,  "Enter 1st number: ", A 
    read !, "Enter 2nd number: ", B
    Set sc = A+B
    w !!, "The addition of two numbers is: ", sc
}

}
