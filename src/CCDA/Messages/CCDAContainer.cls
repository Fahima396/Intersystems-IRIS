Class CCDA.Messages.CCDAContainer Extends (%Persistent, %XML.Adaptor, Ens.Request)
{

Property SourceFolder As %String;

Property FilePath As %String(MAXLEN = 500);

Property Stream As %Stream.GlobalCharacter;

/// Used for meta. source ('gs://')
Property GCSBucketArchivePath As %String(MAXLEN = 500);

/// Used for meta.tag (EPP)
Property BinaryFhirID As %String(MAXLEN = 500);

/// Used for DocumentReference masterIdentifier (CDA)
Property DocRefMasterID As %String(MAXLEN = 500);

Property DocRefMasterIdentifier As %String(MAXLEN = 500);

/// Store any patient identifiers located outside of the CCDA (e.g. Notification JSON Wraper)
Property PatientIdentifiers As array Of %String(MAXLEN = 500);

/// Store original Request ID to pass to other components
Property requestId As %String(MAXLEN = 500);

/// Store original generatedDocId to pass to other components
Property generatedDocId As %String(MAXLEN = 500);

// CQ sends Patient Information in JSON Wrapper

Property sourceSystemName As %String(MAXLEN = 500);

Property sourceSystemPatientId As %String(MAXLEN = 500);

Property PatientBirthDate As %String(MAXLEN = 500);

Property PatientAddress As %String(MAXLEN = 500);

Property PatientAddressLine1 As %String(MAXLEN = 500);

Property PatientAddressLine2 As %String(MAXLEN = 500);

Property PatientCity As %String(MAXLEN = 500);

Property PatientState As %String(MAXLEN = 500);

Property PatientZip As %String(MAXLEN = 500);

Property PatientGender As %String(MAXLEN = 500);

Property PatientGivenName As %String(MAXLEN = 500);

Property PatientLastName As %String(MAXLEN = 500);

Property TransactionTimeStamp As %String(MAXLEN = 200);

Property Custodian As %String(MAXLEN = 1000);

Storage Default
{
<Data name="CCDAContainerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SourceFolder</Value>
</Value>
<Value name="3">
<Value>FilePath</Value>
</Value>
<Value name="4">
<Value>Stream</Value>
</Value>
<Value name="5">
<Value>GCSBucketArchivePath</Value>
</Value>
<Value name="6">
<Value>BinaryFhirID</Value>
</Value>
<Value name="7">
<Value>DocRefMasterID</Value>
</Value>
<Value name="8">
<Value>DocRefMasterIdentifier</Value>
</Value>
<Value name="9">
<Value>requestId</Value>
</Value>
<Value name="10">
<Value>generatedDocId</Value>
</Value>
<Value name="11">
<Value>sourceSystemName</Value>
</Value>
<Value name="12">
<Value>sourceSystemPatientId</Value>
</Value>
<Value name="13">
<Value>PatientBirthDate</Value>
</Value>
<Value name="14">
<Value>PatientAddress</Value>
</Value>
<Value name="15">
<Value>PatientAddressLine1</Value>
</Value>
<Value name="16">
<Value>PatientAddressLine2</Value>
</Value>
<Value name="17">
<Value>PatientCity</Value>
</Value>
<Value name="18">
<Value>PatientState</Value>
</Value>
<Value name="19">
<Value>PatientZip</Value>
</Value>
<Value name="20">
<Value>PatientGender</Value>
</Value>
<Value name="21">
<Value>PatientGivenName</Value>
</Value>
<Value name="22">
<Value>PatientLastName</Value>
</Value>
<Value name="23">
<Value>TransactionTimeStamp</Value>
</Value>
<Value name="24">
<Value>Custodian</Value>
</Value>
</Data>
<Data name="PatientIdentifiers">
<Attribute>PatientIdentifiers</Attribute>
<Structure>subnode</Structure>
<Subscript>"PatientIdentifiers"</Subscript>
</Data>
<DataLocation>^CCDA.Messages.CCDAContainerD</DataLocation>
<DefaultData>CCDAContainerDefaultData</DefaultData>
<IdLocation>^CCDA.Messages.CCDAContainerD</IdLocation>
<IndexLocation>^CCDA.Messages.CCDAContainerI</IndexLocation>
<StreamLocation>^CCDA.Messages.CCDAContainerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
