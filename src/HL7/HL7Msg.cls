Class HL7.HL7Msg Extends (%Persistent, %Populate, %JSON.Adaptor)
{

/// Description
Property Sender As %String;

/// Description
Property ArtifactType As %String;

/// Description
Property ArtifactVersion As %String;

/// Description
Property RawContent As %Stream.GlobalCharacter;

/// Description
Property DecodedHL7Msg As %Stream.GlobalCharacter;

/// Description
ClassMethod AddTestData(version As %Integer) As %Status
{
    Set sc = $$$OK
    d ..Populate(version)
    Return sc
}

Storage Default
{
<Data name="HL7MsgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Sender</Value>
</Value>
<Value name="3">
<Value>ArtifactType</Value>
</Value>
<Value name="4">
<Value>ArtifactVersion</Value>
</Value>
<Value name="5">
<Value>RawContent</Value>
</Value>
<Value name="6">
<Value>DecodedHL7Msg</Value>
</Value>
</Data>
<DataLocation>^HL7.HL7MsgD</DataLocation>
<DefaultData>HL7MsgDefaultData</DefaultData>
<IdLocation>^HL7.HL7MsgD</IdLocation>
<IndexLocation>^HL7.HL7MsgI</IndexLocation>
<StreamLocation>^HL7.HL7MsgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
