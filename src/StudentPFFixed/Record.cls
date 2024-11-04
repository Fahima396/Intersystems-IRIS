/// RECORDMAP: Generated from RecordMap 'Demo.ComplexMap.StudentPFFixed'
/// on 2018-05-04 at 13:19:17.874 [2018-05-04 18:19:17.874 UTC]
/// by user UnknownUser
Class Demo.ComplexMap.StudentPFFixed.Record Extends (EnsLib.RecordMap.ComplexChild, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property StudentID As %Integer(MAXVAL = 9999999999) [ Required ];

Property ClassID As %String(MAXLEN = 10) [ Required ];

Property Grade As %Integer(MAXVAL = 9999999999) [ Required ];

Property Pass As %Boolean;

Property FirstName As %String(MAXLEN = 20) [ Required ];

Property MiddleName As %String(MAXLEN = 20);

Property LastName As %String(MAXLEN = 20) [ Required ];

Trigger OnDelete [ Event = DELETE ]
{
	Set %ok = ##class(Demo.ComplexMap.StudentPFFixed.Record).%OnDelete($$$oidForm({ID})) If $$$ISERR(%ok) Quit
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
<Value>StudentID</Value>
</Value>
<Value name="3">
<Value>%Source</Value>
</Value>
<Value name="4">
<Value>Grade</Value>
</Value>
<Value name="5">
<Value>Pass</Value>
</Value>
<Value name="6">
<Value>FirstName</Value>
</Value>
<Value name="7">
<Value>MiddleName</Value>
</Value>
<Value name="8">
<Value>LastName</Value>
</Value>
<Value name="9">
<Value>ClassID</Value>
</Value>
</Data>
<DataLocation>^Demo.ComplexMap.Stu4B74.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.ComplexMap.Stu4B74.RecordD</IdLocation>
<IndexLocation>^Demo.ComplexMap.Stu4B74.RecordI</IndexLocation>
<StreamLocation>^Demo.ComplexMap.Stu4B74.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
