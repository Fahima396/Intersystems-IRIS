Class dc.Sample.HL7Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="dc.Sample.HL7Production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="dc.HL7Servce" Category="" ClassName="dc.HL7Servce" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="HL7Process" Name="Validation"></Setting>
  </Item>
</Production>
}

}
