/// RECORDMAP: Generated from RecordMap 'Demo.ComplexMap.StudentWCD'
/// on 2018-04-26 at 09:37:01.045 [2018-04-26 14:37:01.045 UTC]
/// by user _SYSTEM
Class Demo.ComplexMap.StudentWCD.Record Extends (EnsLib.RecordMap.ComplexChild, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property ClassID As %String [ Required ];

Property StudentID As %Integer [ Required ];

Property Grade As %Decimal;

Property LastName As %String [ Required ];

Property FirstName As %String [ Required ];

Property MiddleName As %String;

Property Email As %String;

Property Phone As %String;

Property Phone1 As %String;

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ##class(Demo.ComplexMap.StudentWCD.Record).%OnDelete($$$oidForm({ID})) If $$$ISERR(%ok) Quit
}

Index StudentIDIdx On StudentID;

Parameter RECORDMAPGENERATED = 1;

Storage Default
{
<Data name="RecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClassID</Value>
</Value>
<Value name="3">
<Value>%Source</Value>
</Value>
<Value name="4">
<Value>Grade</Value>
</Value>
<Value name="5">
<Value>LastName</Value>
</Value>
<Value name="6">
<Value>FirstName</Value>
</Value>
<Value name="7">
<Value>MiddleName</Value>
</Value>
<Value name="8">
<Value>Email</Value>
</Value>
<Value name="9">
<Value>Phone</Value>
</Value>
<Value name="10">
<Value>Phone1</Value>
</Value>
<Value name="11">
<Value>StudentID</Value>
</Value>
</Data>
<DataLocation>^Demo.ComplexMap.Stu5694.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.ComplexMap.Stu5694.RecordD</IdLocation>
<IndexLocation>^Demo.ComplexMap.Stu5694.RecordI</IndexLocation>
<StreamLocation>^Demo.ComplexMap.Stu5694.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
