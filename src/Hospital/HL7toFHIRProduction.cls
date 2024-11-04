Class Hospital.HL7toFHIRProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Hospital.HL7toFHIRProduction" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="EnsLib.HL7.Service.FileService" Category="" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\InterSystems\IRISHealth\mgr\data\In\</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.txt</Setting>
    <Setting Target="Host" Name="TargetConfigNames">Hospital.Audit.HL7InboundBP</Setting>
  </Item>
  <Item Name="HS.FHIRServer.Interop.Operation" Category="" ClassName="HS.FHIRServer.Interop.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="SDAtoFHIRProcess" Category="" ClassName="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="FHIREndpoint">/csp/healthshare/fahima/fhir/r4</Setting>
    <Setting Target="Host" Name="FHIRMetadataSet">HL7v40 / FHIR R4 Core Specification</Setting>
    <Setting Target="Host" Name="TargetConfigName">HS.FHIRServer.Interop.Operation</Setting>
  </Item>
  <Item Name="Hospital.HL7toSDA3Process" Category="" ClassName="Hospital.HL7toSDA3Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Hospital.Audit.HL7InboundBP" Category="" ClassName="Hospital.Audit.HL7InboundBP" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Hospital.Inbound.CCDA" Category="" ClassName="EnsLib.XML.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="ArchivePath">C:\InterSystems\IRISHealth\mgr\Out\</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\InterSystems\IRISHealth\mgr\data\In\</Setting>
    <Setting Target="Host" Name="TargetConfigNames">Hospital.Audit.HL7InboundBP</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.xml</Setting>
  </Item>
  <Item Name="Hospital.PRCS.CCDAtoSDA" Category="" ClassName="Hospital.CCDATransformPrcs" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">SDAtoFHIRProcess</Setting>
  </Item>
  <Item Name="FHIRDEMO.PRCS.CCDAtoSDA" Category="" ClassName="FHIRSERVERPKG.CCDATransformProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
