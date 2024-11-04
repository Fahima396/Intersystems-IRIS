Class FHIRDemo.HL7toSDA3 Extends %Persistent
{

/// Convert HL7 v2 to SDA
ClassMethod GetSDAFromHL7(pRequest As EnsLib.HL7.Message) As %Stream.GlobalCharacter
{
        Set status = ##class(HS.Gateway.HL7.HL7ToSDA3).GetSDA(pRequest,.sdaStream)
        quit sdaStream
}

Storage Default
{
<Data name="HL7toSDA3DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^Hospital.HL7toSDA3D</DataLocation>
<DefaultData>HL7toSDA3DefaultData</DefaultData>
<IdLocation>^Hospital.HL7toSDA3D</IdLocation>
<IndexLocation>^Hospital.HL7toSDA3I</IndexLocation>
<StreamLocation>^Hospital.HL7toSDA3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
