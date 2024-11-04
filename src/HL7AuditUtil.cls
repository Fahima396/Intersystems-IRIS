Class Hospital.Audit.HL7AuditUtil Extends %RegisteredObject
{

/// Insert Audit Record
ClassMethod AddAuditEntry(HL7FileName As %String, MessageType As %String, TriggerEvent As %String, Sender As %String, Receiver As %String, ReceivedDate As %String, ReceivedTime As %String, ReceivedPatientID As %String) As %Status
{
        Set sc = $$$OK
            set tHL7Audit=##class(Hospital.Audit.HL7Audit).%New()
            set tHL7Audit.HL7FileName=HL7FileName
            set tHL7Audit.MessageType=MessageType
            set tHL7Audit.TriggerEvent=TriggerEvent
            set tHL7Audit.Sender=Sender
            set tHL7Audit.Receiver=Receiver
            set tHL7Audit.ReceivedDate=ReceivedDate
            set tHL7Audit.ReceivedTime=ReceivedTime
            set tHL7Audit.ReceivedPatientID=ReceivedPatientID
            set sc = tHL7Audit.%Save()
        Return sc
}

ClassMethod AddAuditFromHL7Req(pRequest As EnsLib.HL7.Message) As %Status
{
    set sc=$$$OK
        set tHL7Audit=##class(Hospital.Audit.HL7Audit).%New()
        set tHL7Audit.HL7FileName=pRequest.Source
        set tHL7Audit.HL7Version=pRequest.MessageTypeCategory
        set tHL7Audit.MessageType=pRequest.GetValueAt("MSH:9")
        set tHL7Audit.TriggerEvent=pRequest.GetValueAt("MSH:9.2")
        set tHL7Audit.Sender=pRequest.GetValueAt("MSH:SendingApplication.namespaceID")
        set tHL7Audit.Receiver=pRequest.GetValueAt("MSH:ReceivingApplication.namespaceID")
        set RcvdDate=pRequest.GetValueAt("MSH:7.1")
        set tHL7Audit.ReceivedDate = $E(RcvdDate,1,8)
        set RecvedTime = pRequest.GetValueAt("MSH:7")
        set tHL7Audit.ReceivedTime = $E(RecvedTime, 9,12)
        set tHL7Audit.ReceivedPatientID=pRequest.GetValueAt("PID:2.1")
        set sc = tHL7Audit.%Save()
    return sc
}

/// Description
ClassMethod AddAuditFromCCDA(pRequest As Ens.StreamContainer) As %Status
{
    Set sc = $$$OK
    // do something
    Return sc
}

}
