<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY oldns
'http://xmlns.oracle.com/jdeveloper/9051/ide-preferences'>
<!ENTITY newns
'http://xmlns.oracle.com/jdeveloper/10120/ide-preferences'>
]>
<!--
 |  This XSLT file migrates an Oracle9i JDeveloper 9.0.5.1 settings file
 |  to the 10.1.2 format.
 +-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:data="urn:data"
                xmlns="&newns;"
                xmlns:old="&oldns;">

  <xsl:output indent="yes"/>
 
  <!--
   |  Identity transformation.
   +-->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <!--
   |  Translates old namespace to new.
   +-->
  <xsl:template match="old:*">
    <xsl:call-template name="copy_element"/>
  </xsl:template>

  <xsl:template name="copy_element">
    <xsl:element name="{name()}" namespace="&newns;">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
  </xsl:template>

  <!--
  |  Rename the UIEditorOptions class
   +-->
  <xsl:template match="old:Value[@class='oracle.jdevimpl.uieditor.UIEditorOptions']">
    <Value class="oracle.jdeveloper.uieditor.UIEditorOptions">
      <xsl:apply-templates />
    </Value>
  </xsl:template>

</xsl:stylesheet>

