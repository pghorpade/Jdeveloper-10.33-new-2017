<?xml version='1.0' encoding='UTF-8'?>

<!DOCTYPE xsl:stylesheet [

<!ENTITY oldns 'http://xmlns.oracle.com/jdeveloper/903/ide-preferences'>
<!ENTITY newns 'http://xmlns.oracle.com/jdeveloper/904/ide-preferences'>

]>

<!--
 |  This XSLT file migrates an Oracle9i JDeveloper 9.0.3 settings file
 |  to the 9.0.4 format.
 +-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:data="urn:data"
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
   |  Transforms the old encoding property into the internalEncoding property
   +-->  
  <xsl:template match='old:Value[@class="oracle.ide.config.EnvironOptions"]/old:encoding'>
    <xsl:element name="internalEncoding">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>


