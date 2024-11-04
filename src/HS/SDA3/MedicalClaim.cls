/// MedicalClaim is neither parsed from HL7, nor is it stored to the Viewer Cache.
Class HS.SDA3.MedicalClaim Extends (HS.SDA3.SuperClass, HS.SDA3.AbstractClaim)
{

Property Extension As HS.Local.SDA3.MedicalClaimExtension;

/// Unique identifier within the payer's system that applies to the entire claim.<br>
/// 837apP:	loop2300().CLM:ClaimSubmittersIdentifier<br>
Property MedicalClaimNumber As %String(MAXLEN = 450);

/// The APCD filing-type identifier that defines the data contained within the file.<br>
Property RecordType As %String(MAXLEN = 50);

/// Incrementing counter for a claim line that is reprocessed for any reason over the course of time.<br>
/// Highest value should indicate latest reprocessing of line by the carrier/submitter.<br>
Property Version As HS.SDA3.Numeric;

/// A standardized code that reports the admission source of the Patient into an inpatient setting/facility <br>
/// and indicates how the Patient was referred into the inpatient setting.<br>
Property AdmissionSource As HS.SDA3.CodeTableDetail.AdmissionSource;

/// A standardized, numeric code that reports the type of admission into an inpatient setting.<br>
Property AdmissionType As HS.SDA3.CodeTableDetail.AdmissionType;

/// The date that the Patient was admitted into an inpatient setting at the facility.<br>
Property AdmissionDate As HS.SDA3.TimeStamp;

/// Numeric indicator that reports if a claim line was processed / paid under a global payment arrangement.<br>
/// 837apP:	loop2300().CN1:ContractTypeCode<br>
Property GlobalPaymentFlag As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// Numeric indicator that reports if a claim line is covered under a capitation arrangement.<br>
Property CapitatedEncounterFlag As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// Numeric indicator that reports if the claim line was paid by the carrier or its designee, and the COB order of the payment.<br>
Property ClaimStatus As HS.SDA3.CodeTableDetail.ClaimStatus;

Property DelegatedBenefitAdminOrgID As %String(MAXLEN = 50);

/// A standardized, numeric code that reports the discharge status of the Patient.<br>
Property DischargeStatus As HS.SDA3.CodeTableDetail.DischargeStatus;

/// Deprecated <br/>
/// CMS methodology when available. When the CMS methodology for DRGs is not available, but the All Payer DRG system <br/>
/// is used, the insurer shall format the DRG and the complexity level within the same field with an "A" prefix, and <br/>
/// with a hyphen separating the DRG and the complexity level (e.g. AXXX-XX). <br/>
/// This property is deprecated and has been replaced by the DiagnosisRelatedGroup property that is a coded representation of the data. <br/> 
Property DRG As %String(MAXLEN = 50) [ Deprecated ];

/// Deprecated <br/>
/// Severity adjustment level when applicable. <br/>
/// This property is deprecated and has been replaced by the DiagnosisRelatedGroup property that is a coded <br/>
/// representation of the data. <br/>
Property DRGLevel As %String(MAXLEN = 50) [ Deprecated ];

/// Deprecated <br/>
/// Version identifier of the DRG Grouper used. <br/>
/// This property is deprecated and has been replaced by the DiagnosisRelatedGroup property that is a coded representation of the data. <br/>
Property DRGVersion As %String(MAXLEN = 50) [ Deprecated ];

/// Deprecated <br/>
/// Diagnostic code assigned by the provider to support admission into an inpatient setting at the <br/>
/// facility reported in Plan Rendering Provider ID and Provider Location. <br/>
/// This property is deprecated and has been replaced by the Diagnoses property where "admitting" may be <br/>
/// specified as a value in the DiagnosisType property in the HS.SDA3.Diagnosis class. <br/>
Property AdmissionDiagnosis As HS.SDA3.CodeTableDetail.Diagnosis [ Deprecated ];

/// Deprecated <br/>
/// The ICD9 diagnosis code assigned to the Patient upon discharge. <br/>
/// This property is deprecated and has been replaced by the Diagnoses property where "discharge" may be specified as <br/>
/// a value in the DiagnosisType property in the HS.SDA3.Diagnosis class. <br/> 
Property DischargeDiagnosis As HS.SDA3.CodeTableDetail.Diagnosis [ Deprecated ];

/// Deprecated <br/>
/// Primary ICD9 Diagnosis Code. <br/>
/// 837apP: loop2300().HI():HealthCareCodeInformation2 <br/>
/// This property is deprecated and has been replaced by the Diagnoses property where "principal" <br/>
/// may be specified as a value in the DiagnosisType property in the HS.SDA3.Diagnosis class. <br/>
Property PrincipalDiagnosis As HS.SDA3.CodeTableDetail.Diagnosis [ Deprecated ];

/// Deprecated <br/>
/// Other ICD9 Diagnosis Codes. <br/>
/// 837apP: loop2300().HI():HealthCareCodeInformation2 <br/>
/// This property is deprecated and has been replaced by the Diagnoses property where a greater granularity of diagnosis type may be specified as a <br/>
/// value in the DiagnosisType property in the HS.SDA3.Diagnosis class. <br/>
Property OtherDiagnoses As list Of HS.SDA3.CodeTableDetail.Diagnosis [ Deprecated ];

/// Numeric indicator that reports if the claim line has any Medicare payments applied towards it as a Prior Payer on the claim.<br>
Property MedicareIndicator As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// Numeric indicator that reports if the claim line procedure was performed due to an accident (not employment based).<br>
Property AccidentIndicator As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

Property PatientAccount As %String(MAXLEN = 50);

Property SiteNumber As %String(MAXLEN = 50);

Property AttendingProvider As HS.SDA3.CodeTableDetail.CareProvider;

/// Report CHIA defined, unique
/// Submitter ID here. TR002 must
/// match the Submitter ID reported
/// here. This ID is linked to other
/// elements in the file for quality control
/// 837apP:	loop1000A.NM1:IdentificationCode<br>
Property Submitter As %String(MAXLEN = 50);

/// Deprecated <br/>
/// For Institutional Claims: a standardized code that reports the type of facility where the claim line service occurred. <br/>
/// This property is deprecated and has been replaced by the TypeOfBillInstitutionalCoded property that is a coded representation of the data. <br/>
Property TypeOfBillInstitutional As %String(MAXLEN = 50) [ Deprecated ];

/// Numeric indicator that reports if the claim line procedure was performed due to an employment related accident.<br>
/// 837apP:	loop2300().CLM:RelatedCausesInformation.RelatedCausesCode<br>
Property EmploymentRelatedIndicator As %String(DISPLAYLIST = ",Yes,No,Unknown,Other,NotApplicable", VALUELIST = ",1,2,3,4,5");

/// Subscriber
/// 837apP:	loop2000A().loop2000B()<br>
Property Subscriber As HS.SDA3.Guarantor;

/// Deprecated <br/>
/// The Payer Claim Control Number previously assigned to this claim line in a prior reporting period. <br/>
/// This property is deprecated and has been replaced by the RelatedClaim property that provides for greater variety and specificity of how claims are related.<br/>
Property FormerClaimNumber As %String(MAXLEN = 50) [ Deprecated ];

Property MedicalClaimLines As list Of HS.SDA3.MedicalClaimLine;

/// Information about diagnoses relevant to the claim items. ICD-10 or ICD-9.
Property Diagnoses As list Of HS.SDA3.Diagnosis;

/// Claim diagnosis related group (DRG). 
/// This is a coded representation of the data and should be used in place of DRG, 
/// DRGLevel, and DRGVersion which are retained for compatibility with previous versions of HealthShare.
Property DiagnosisRelatedGroup As HS.SDA3.CodeTableDetail.DiagnosisRelatedGroup;

/// End date of the inpatient stay
Property DischargeDate As HS.SDA3.TimeStamp;

/// Indicates that the Performing Provider has a contract with the Plan (regardless of the network)
/// as of the effective date of service.
Property PerformingNetworkContractingStatus As HS.SDA3.CodeTableDetail.PayerProviderContractingStatus;

/// The name of the facility where the service occurred. Examples include hospitals, 
/// nursing homes, laboratories or homeless shelters.
Property ServiceFacility As HS.SDA3.CodeTableDetail.Organization;

/// Type of bill code provides specific information for payer purposes. 
/// The first digit of the three-digit number denotes the type of institution, 
/// the second digit classifies the type of care being billed, 
/// and the third digit identifies the frequency of the bill for a specific course of treatment 
/// or inpatient confinement.This is a coded representation of the data and should be used in place of 
/// TypeOfBillInstitutional which is retained for compatibility with previous versions of HealthShare.
Property TypeOfBillInstitutionalCoded As HS.SDA3.CodeTableDetail.TypeOfBill;

/// Identifies the place of service related to the location at which
/// a health care service was rendered.
/// X12 source: 837 loop2300().CLM:HealthCareServiceLocationInf.FacilityCodeValue
Property PlaceOfService As HS.SDA3.CodeTableDetail.PlaceOfService;

Storage Default
{
<Data name="SuperClassState">
<Subscript>"SuperClass"</Subscript>
<Value name="1">
<Value>ActionCode</Value>
</Value>
<Value name="2">
<Value>ActionScope</Value>
</Value>
<Value name="3">
<Value>EnteredBy</Value>
</Value>
<Value name="4">
<Value>EnteredAt</Value>
</Value>
<Value name="5">
<Value>EnteredOn</Value>
</Value>
<Value name="6">
<Value>ExternalId</Value>
</Value>
<Value name="7">
<Value>EncounterNumber</Value>
</Value>
<Value name="8">
<Value>FromTime</Value>
</Value>
<Value name="9">
<Value>ToTime</Value>
</Value>
<Value name="10">
<Value>Deleted</Value>
</Value>
<Value name="11">
<Value>UpdatedOn</Value>
</Value>
<Value name="12">
<Value>CustomPairs</Value>
</Value>
<Value name="13">
<Value>MedicalClaimNumber</Value>
</Value>
<Value name="14">
<Value>RecordType</Value>
</Value>
<Value name="15">
<Value>SubmissionDate</Value>
</Value>
<Value name="16">
<Value>Version</Value>
</Value>
<Value name="17">
<Value>AdmissionSource</Value>
</Value>
<Value name="18">
<Value>AdmissionType</Value>
</Value>
<Value name="19">
<Value>AdmissionDate</Value>
</Value>
<Value name="20">
<Value>GlobalPaymentFlag</Value>
</Value>
<Value name="21">
<Value>CapitatedEncounterFlag</Value>
</Value>
<Value name="22">
<Value>ClaimProcessedDate</Value>
</Value>
<Value name="23">
<Value>ClaimStatus</Value>
</Value>
<Value name="24">
<Value>DelegatedBenefitAdminOrgID</Value>
</Value>
<Value name="25">
<Value>DischargeStatus</Value>
</Value>
<Value name="26">
<Value>DRG</Value>
</Value>
<Value name="27">
<Value>DRGLevel</Value>
</Value>
<Value name="28">
<Value>DRGVersion</Value>
</Value>
<Value name="29">
<Value>AdmissionDiagnosis</Value>
</Value>
<Value name="30">
<Value>DischargeDiagnosis</Value>
</Value>
<Value name="31">
<Value>PrincipalDiagnosis</Value>
</Value>
<Value name="32">
<Value>OtherDiagnoses</Value>
</Value>
<Value name="33">
<Value>MedicareIndicator</Value>
</Value>
<Value name="34">
<Value>FormerClaimNumber</Value>
</Value>
<Value name="35">
<Value>AccidentIndicator</Value>
</Value>
<Value name="36">
<Value>PatientAccount</Value>
</Value>
<Value name="37">
<Value>SiteNumber</Value>
</Value>
<Value name="38">
<Value>AttendingProvider</Value>
</Value>
<Value name="39">
<Value>ReceivedDate</Value>
</Value>
<Value name="40">
<Value>Submitter</Value>
</Value>
<Value name="41">
<Value>TypeOfBillInstitutional</Value>
</Value>
<Value name="42">
<Value>EmploymentRelatedIndicator</Value>
</Value>
<Value name="43">
<Value>Subscriber</Value>
</Value>
<Value name="44">
<Value>MedicalClaimLines</Value>
</Value>
<Value name="45">
<Value>Extension</Value>
</Value>
<Value name="46">
<Value>DeniedReasonCodes</Value>
</Value>
<Value name="47">
<Value>OtherCoverage</Value>
</Value>
<Value name="48">
<Value>PayeeOther</Value>
</Value>
<Value name="49">
<Value>PayeeProvider</Value>
</Value>
<Value name="50">
<Value>PayeeProviderOrganization</Value>
</Value>
<Value name="51">
<Value>PayeeSubscriber</Value>
</Value>
<Value name="52">
<Value>Payer</Value>
</Value>
<Value name="53">
<Value>PaymentAmount</Value>
</Value>
<Value name="54">
<Value>PaymentCurrency</Value>
</Value>
<Value name="55">
<Value>PrimaryProcedure</Value>
</Value>
<Value name="56">
<Value>Priority</Value>
</Value>
<Value name="57">
<Value>RelatedClaims</Value>
</Value>
<Value name="58">
<Value>Status</Value>
</Value>
<Value name="59">
<Value>TotalAdjudicationDetails</Value>
</Value>
<Value name="60">
<Value>Use</Value>
</Value>
<Value name="61">
<Value>AdjudicatedCoverage</Value>
</Value>
<Value name="62">
<Value>AdjudicationStatus</Value>
</Value>
<Value name="63">
<Value>BillingProvider</Value>
</Value>
<Value name="64">
<Value>ClaimType</Value>
</Value>
<Value name="65">
<Value>AdjudicationDetails</Value>
</Value>
<Value name="66">
<Value>AdditionalSupportingInfo</Value>
</Value>
<Value name="67">
<Value>PayeeBeneficiary</Value>
</Value>
<Value name="68">
<Value>BillingNetworkContractingStatus</Value>
</Value>
<Value name="69">
<Value>OtherProcedures</Value>
</Value>
<Value name="70">
<Value>PaymentStatus</Value>
</Value>
<Value name="71">
<Value>PaymentDate</Value>
</Value>
<Value name="72">
<Value>CareTeamMembers</Value>
</Value>
<Value name="73">
<Value>ProcessNotes</Value>
</Value>
<Value name="74">
<Value>ClaimSubType</Value>
</Value>
<Value name="75">
<Value>Diagnoses</Value>
</Value>
<Value name="76">
<Value>DiagnosisRelatedGroup</Value>
</Value>
<Value name="77">
<Value>DischargeDate</Value>
</Value>
<Value name="78">
<Value>PerformingNetworkContractingStatus</Value>
</Value>
<Value name="79">
<Value>ServiceFacility</Value>
</Value>
<Value name="80">
<Value>TypeOfBillInstitutionalCoded</Value>
</Value>
<Value name="81">
<Value>OtherIdentifiers</Value>
</Value>
<Value name="82">
<Value>BillingProviderIndividual</Value>
</Value>
<Value name="83">
<Value>PlaceOfService</Value>
</Value>
<Value name="84">
<Value>SourceFormat</Value>
</Value>
<Value name="85">
<Value>ProvenanceIds</Value>
</Value>
</Data>
<Type>%Storage.Serial</Type>
}

}
