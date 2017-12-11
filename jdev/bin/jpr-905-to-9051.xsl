<?xml version='1.0' encoding='UTF-8'?>

<!DOCTYPE xsl:stylesheet [

<!ENTITY oldns 'http://xmlns.oracle.com/jdeveloper/905/jproject'>
<!ENTITY newns 'http://xmlns.oracle.com/jdeveloper/9051/jproject'>

]>

<!--
 |  This XSLT file migrates an Oracle10g JDeveloper 9.0.5
 |  project file to the 9.0.5.1 format.
 +-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
    <xsl:element name="{name()}" namespace="&newns;">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="/old:project">
    <xsl:element name="project" namespace="&newns;">
      <xsl:if test="not(@migration-origin)"><xsl:attribute name="migration-origin">9.0.5.0</xsl:attribute></xsl:if>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
  </xsl:template>

  <!--
   |  Transforms the old encoding property into the internalEncoding property
   +-->  
  <xsl:template match='old:Value[@class="oracle.jdeveloper.compiler.OjcConfiguration"]/old:currentEncoding'>
    <xsl:element name="internalEncoding" namespace="&newns;">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
