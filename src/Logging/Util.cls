Class Logging.Util
{

/// Util Method to log to the STD Log out
ClassMethod LogStdout(pArr As %String) As %Status
{
    Set sc = $$$OK
    Set tMetricStr = ""

    Set tAttribute = ""
    Set tAttribute=$O(pArr(tAttribute))
    while tAttribute'= ""
    {
        If "" = tMetricStr {
            Set tMetricStr=tAttribute_"="_pArr(tAttribute)
        } else {
            Set tMetricStr=tMetricStr_","_tAttribute_"="_pArr(tAttribute)
        }
        Set tAttribute = $O(pArr(tAttribute))
    }
    If ""=tMetricStr {
        q $$$OK
    } 

    Do $ZF(-1, "echo "_tMetricStr_" >> C:\IrisLogs\log.txt")
    
    Return sc
}

}
