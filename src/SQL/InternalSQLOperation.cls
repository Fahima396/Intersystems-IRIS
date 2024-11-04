Class SQL.InternalSQLOperation Extends Ens.BusinessOperation
{

Method GetDataTable(pRequest As EnsLib.SQL.Snapshot, html As %String) As %Status
{
    Set sc=$$$OK
    Try{
    //first html obj can be if the styling needs passed
    If $ISOBJECT(html){Set html=""}
    //loop get column titles 
    Set ColumnIteration=1
    Set ColumnCount=pRequest.%ResultColumnCountGet()
    
    Set html=html_" <table class=""tg"">"
    Set html= html_ " " _"<tr>"
    Set meta=pRequest.%GetMetadata() //this is like raw text of the result using it to get the column titles out
    If ColumnCount>0{
        While ColumnIteration<=ColumnCount{
        
        Set html= html_ " <th>"_  meta.columns.GetAt(ColumnIteration).colName _" </th>"
        Set ColumnIteration=ColumnIteration+1
        }

    }
    Set html= html_ " " _"</tr>"
    //not get the data from each row. In html need a <tr> and a td. 
    Set coldataiteration=1
    While pRequest.%Next() {
        Set html= html_ " <tr>"
        While coldataiteration <=ColumnCount{
        Set html= html_ " <td> "_pRequest.%GetData(coldataiteration) _" </td>"
        Set coldataiteration=coldataiteration+1
        }
        
        Set html= html_ " </tr>"
        Set coldataiteration=1
    }
    Set html= html_ " " _"</table>"
    $$$TRACE(html)
    #; Quit sc
    }
    Catch err {
    #; Quit err.AsStatus()
    }
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="EnsLib.SQL.Snapshot">
        <Method>GetDataTable</Method>
    </MapItem>
    </MapItems>
}

}
