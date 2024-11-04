Class custom2hl7.Patients2Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="custom2hl7.Patients2Production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="EnsLib.RecordMap.Service.FileService" Category="" ClassName="EnsLib.RecordMap.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="RecordMap">PatientMap2</Setting>
    <Setting Target="Adapter" Name="ArchivePath">C:\InterSystems\IRISHealth\mgr\Out\</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\InterSystems\IRISHealth\csv\in\</Setting>
    <Setting Target="Adapter" Name="FileSpec">patients4.csv</Setting>
  </Item>
</Production>
}

}
