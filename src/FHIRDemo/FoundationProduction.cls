Class FHIRDemo.FoundationProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="FHIRDemo.FoundationProduction" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="FHIRDemo.Inbound.HL7" Category="" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">FHIRDemo.PRCS.HL7toSDA,FHIRDemo.Audit.InboundAuditBP</Setting>
    <Setting Target="Adapter" Name="ArchivePath">C:\InterSystems\IRISHealth\mgr\Out\hl7Out\</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\InterSystems\IRISHealth\mgr\data\In\HL7\In\</Setting>
  </Item>
  <Item Name="FHIRDemo.Audit.InboundAuditBP" Category="" ClassName="Hospital.Audit.HL7InboundBP" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.FHIRServer.Interop.Operation" Category="" ClassName="HS.FHIRServer.Interop.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="FHIRDemo.Inbound.CCDA" Category="" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.3.1</Setting>
    <Setting Target="Host" Name="TargetConfigNames">FHIRDemo.PRCS.CCDAtoSDA,FHIRDemo.Audit.InboundAuditBP</Setting>
    <Setting Target="Adapter" Name="ArchivePath">C:\InterSystems\IRISHealth\mgr\Out\ccdaOut\</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\InterSystems\IRISHealth\mgr\data\In\CCDA\In\</Setting>
  </Item>
  <Item Name="FHIRDemo.PRCS.HL7toSDA" Category="" ClassName="FHIRDemo.HL7toSDA3Process" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="FHIRDemo.PRCS.SDAtoFHIR" Category="" ClassName="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="FHIREndpoint">/csp/healthshare/fahima/fhir/r4</Setting>
    <Setting Target="Host" Name="FHIRMetadataSet">HL7v40 / FHIR R4 Core Specification</Setting>
    <Setting Target="Host" Name="TargetConfigName">HS.FHIRServer.Interop.Operation</Setting>
  </Item>
  <Item Name="FHIRDemo.PRCS.CCDAtoSDA" Category="" ClassName="Hospital.CCDATransformPrcs" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">FHIRDemo.PRCS.SDAtoFHIR</Setting>
  </Item>
</Production>
}

}
