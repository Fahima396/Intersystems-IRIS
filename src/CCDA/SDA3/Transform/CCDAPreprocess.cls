Include %occXSLT

Class CCDA.SDA3.Transform.CCDAPreprocess
{

Parameter BaseUrl As STRING = "http://CVS-IRIS/CCDAToFHIRPipeline";

ClassMethod XSLT(pStream As %Stream.Object, pTransforms As %String, Output pNewStream As %Stream.GlobalCharacter) As %Status
{

    #dim tSC   As %Status=$$$OK
    #dim eException  As %Exception.AbstractException

    Try {
        
        Do pStream.Rewind()
        Set pNewStream=##class(%Stream.GlobalCharacter).%New()
        Do pNewStream.CopyFrom(pStream)

        Set tXSLs = $LISTFROMSTRING(pTransforms)
        Set ptr=0
        While $LISTNEXT(tXSLs,ptr,value) {
            Set tDocumentTransform=##class(%Dictionary.XDataDefinition).%OpenId($CLASSNAME()_"||"_value,0).Data
            $$$THROWONERROR(tSC, ##class(%XML.XSLT.CompiledStyleSheet).CreateFromStream(tDocumentTransform, .tCompiledStyleSheet))
            $$$THROWONERROR(tSC, ##class(%XML.XSLT.Transformer).TransformStreamWithCompiledXSL(pNewStream, tCompiledStyleSheet, .pNewStream,,,))
        }
    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }

    Quit tSC
}

XData PreXMLValidation
{
<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output method="xml" omit-xml-declaration="yes" encoding="UTF-8" indent="yes" />

        <xsl:template match="@*[name() = 'xsi:schemaLocation']">
            <xsl:comment>PreProcess XSLT:Removed 'xsi:schemaLocation'</xsl:comment>
        </xsl:template>

        <xsl:template match="@*|node()">
            <xsl:copy>
                <xsl:apply-templates select="@*|node()" />
            </xsl:copy>
        </xsl:template>
</xsl:stylesheet>
}

XData Foundation
{
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns="urn:hl7-org:v3"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:isc="http://Extension-functions.intersystems.com"
    xmlns:hl7="urn:hl7-org:v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:exsl="http://exslt.org/common"
    exclude-result-prefixes="isc hl7 xsi exsl">

    <!-- Output settings -->
    <xsl:output method="xml" indent="yes" omit-xml-declaration="no" />

    <!-- Template to copy all attributes and nodes -->
    <xsl:template match="//@* | //node()">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Template to handle ClinicalDocument root -->
    <xsl:template match="/hl7:ClinicalDocument">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:comment>XSLT: Generic</xsl:comment>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- Template to enforce hl7 namespace -->
    <xsl:template match="ClinicalDocument | ClinicalDocument//*">
        <xsl:element name="{name()}" namespace="urn:hl7-org:v3">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
}

XData AddTemplateIds
{
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns="urn:hl7-org:v3"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:isc="http://extension-functions.intersystems.com"
    xmlns:hl7="urn:hl7-org:v3"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:exsl="http://exslt.org/common"
    exclude-result-prefixes="isc hl7 xsi exsl">

    <!-- Output settings -->
    <xsl:output method="xml" indent="yes" omit-xml-declaration="no" />

    <!-- Template to copy all attributes and nodes -->
    <xsl:template match="//@* | //node()">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Template to handle ClinicalDocument root -->
    <xsl:template match="/hl7:ClinicalDocument">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:comment>XSLT: AddTemplateIds</xsl:comment>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- Encounters -->
    <xsl:template match="/hl7:ClinicalDocument/hl7:structureBody/hl7:component/hl7:section/hl7:code[@code='46240-8]">
        <templateId root="2.16.840.1.113883.10.20.22.2.22"/>
        <xsl:copy-of select="."/>
    </xsl:template>

    <!-- Discharge Medications -->
    <xsl:template match="/hl7:ClinicalDocument/hl7:structureBody/hl7:component/hl7:section/hl7:code[@code='10183-2]">
        <templateId root="2.16.840.1.113883.10.20.22.2.11"/>
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="/hl7:ClinicalDocument/hl7:structureBody/hl7:component/hl7:section/hl7:code[@code='75311-1']">
        <templateId root="2.16.840.1.113883.10.20.22.2.11.1"/>
        <xsl:copy-of select="."/>
    </xsl:template>

    <!-- Medications -->
    <xsl:template match="/hl7:ClinicalDocument/hl7:structureBody/hl7:component/hl7:section/hl7:code[@code='29549-3]">
        <templateId root="2.16.840.1.113883.10.20.22.2.38"/>
        <xsl:copy-of select="."/>
    </xsl:template>

    <!-- Medications -->
    <xsl:template match="/hl7:ClinicalDocument/hl7:structureBody/hl7:component/hl7:section/hl7:code[@code='10160-0]">
        <templateId root="2.16.840.1.113883.10.20.22.2.1.1"/>
        <xsl:copy-of select="."/>
    </xsl:template>

    <!-- Procedures -->
    <xsl:template match="/hl7:ClinicalDocument/hl7:structureBody/hl7:component/hl7:section/hl7:code[@code='47519-4]">
        <templateId root="2.16.840.1.113883.10.20.22.2.7"/>
        <xsl:copy-of select="."/>
    </xsl:template>

    <!-- Social History -->
    <xsl:template match="/hl7:ClinicalDocument/hl7:structureBody/hl7:component/hl7:section/hl7:code[@code='29762-2]">
        <templateId root="2.16.840.1.113883.10.20.22.2.17"/>
        <xsl:copy-of select="."/>
    </xsl:template>

</xsl:stylesheet>
}

}
