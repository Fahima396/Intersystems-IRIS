/// REST backend for Scramble word game<br/>
/// Business logic class defined by OpenAPI in WordGame.spec<br/>
/// Updated Jan 22, 2024 10:54:41
Class WordGame.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// Return the score for the provided word<br/>
/// The method arguments hold values for:<br/>
///     word<br/>
ClassMethod Score(word As %String) As %DynamicObject
{
	Quit {"score": ($length(word))}
}

/// Add a word to the dictionary<br/>
/// The method arguments hold values for:<br/>
///     body<br/>
ClassMethod AddWord(body As %Stream.Object) As %Stream.Object
{
	// unimplemented
	Quit ""
}

}
