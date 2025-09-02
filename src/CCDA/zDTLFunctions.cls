Class CCDA.zDTLFunctions
{

/// Description
ClassMethod zSetUrnPrefix(pArg1 As %String) As %String
{
    Quit $select(
        ##class(HS.HC.Util).IsOID(pArg1,1):pArg1 ,
        ##class(HS.HC.Util).IsOID(pArg1,0):"urn:oid:"_pArg1 ,
        ##class(HS.HC.Util).IsUUID(pArg1,1):pArg1 ,
        ##class(HS.HC.Util).IsUUID(pArg1,0):"urn:uuid:"_pArg1,
        1:pArg1
    )
}

}
