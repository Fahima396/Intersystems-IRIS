Class custom2hl7.PatientDTL2 Extends Ens.DataTransformDTL [ DependsOn = (custom2hl7.PatientMapper.Record, EnsLib.HL7.Message) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='custom2hl7.PatientMapper.Record' targetClass='EnsLib.HL7.Message' targetDocType='2.3.1:ADT_A01' create='new' language='objectscript' >
<assign value='"|"' property='target.{MSH:FieldSeparator}' action='set' />
<assign value='"UTF-8"' property='target.{MSH:EncodingCharacters}' action='set' />
<assign value='"ADT"' property='target.{MSH:MessageType.messagetype}' action='set' />
<assign value='"A01"' property='target.{MSH:MessageType.triggerevent}' action='set' />
<assign value='"ADT_A01"' property='target.{MSH:MessageType.messagestructure}' action='set' />
<assign value='source.Id' property='target.{MSH:MessageControlID}' action='set' />
<assign value='source.Id' property='target.{MSH:ProcessingID}' action='set' />
<assign value='"1.0"' property='target.{MSH:VersionID}' action='set' />
<assign value='"A01"' property='target.{EVN:EventTypeCode}' action='set' />
<assign value='..CurrentDateTime()' property='target.{EVN:RecordedDateTime}' action='set' />
<assign value='source.Id' property='target.{PID:PatientIdentifierList().ID}' action='set' />
<assign value='source.LAST' property='target.{PID:PatientName().familylastname.familyname}' action='set' />
<assign value='source.FIRST' property='target.{PID:PatientName().givenname}' action='set' />
<assign value='source.PREFIX' property='target.{PID:PatientName().prefix}' action='set' />
<assign value='source.SUFFIX' property='target.{PID:PatientName().suffix}' action='set' />
<assign value='source.MAIDEN' property='target.{PID:PatientName().middleinitialorname}' action='set' />
<assign value='source.MARITAL' property='target.{PID:MaritalStatus.text}' action='set' />
<assign value='source.RACE' property='target.{PID:Race().text}' action='set' />
<assign value='source.SSN' property='target.{PID:SSNNumberPatient}' action='set' />
<assign value='source.DRIVERS' property='target.{PID:DriversLicenseNumberPatient.DriversLicenseNumber}' action='set' />
<assign value='source.BIRTHDATE' property='target.{PID:DateTimeOfBirth}' action='set' />
<assign value='source.GENDER' property='target.{PID:Sex}' action='set' />
<assign value='source.ETHNICITY' property='target.{PID:EthnicGroup().text}' action='set' />
<assign value='source.BIRTHPLACE' property='target.{PID:BirthPlace}' action='set' />
<assign value='source.COUNTY' property='target.{PID:CountyCode}' action='set' />
<assign value='source.DEATHDATE' property='target.{PID:PatientDeathDateandTime}' action='set' />
<assign value='source.CITY' property='target.{PID:PatientAddress().city}' action='set' />
<assign value='source.ZIP' property='target.{PID:PatientAddress().ziporpostalcode}' action='set' />
<assign value='source.STATE' property='target.{PID:PatientAddress().stateorprovince}' action='set' />
<assign value='source.ADDRESS' property='target.{PID:PatientAddress().streetaddress}' action='set' />
<assign value='"LAT/LONG."_source.LAT_"/"_source.LON' property='target.{PID:PatientAddress().othergeographicdesignation}' action='set' />
<assign value='"|"' property='target.{PV1:PatientClass}' action='set' />
</transform>
}

}
