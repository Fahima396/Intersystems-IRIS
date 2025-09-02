/// Patient update.<br/>
/// Business logic class defined by OpenAPI in Demo.spec<br/>
/// Updated Aug 27, 2025 17:50:32
Class Demo.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// This operation allows you to check if you have acces to Ensemble. <br> - <b>Operate it only in develeopment!</b><br> - It can be operated from a browser as well. <br> - It should show you the IP you are connected from
/// WARNING: This method's signature has changed.
ClassMethod HelloTest() As %Stream.Object
{
	Do ..%SetStatusCode(200)
    Quit "Welcome!"
}

/// This method updates the patient data - extracted from HL7 messages<br/>
/// The method arguments hold values for:<br/>
///     body<br/>
ClassMethod PatientUpdateData(body As %DynamicObject) As %DynamicObject
{
    set res={"Success":true,
        	"ErrorMessage":""}
    Do ..%SetStatusCode(200)
    Quit (res) ; response may be a string, stream or dynamic object
}

}
