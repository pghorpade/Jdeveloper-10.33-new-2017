<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY oldns 'http://xmlns.oracle.com/jdeveloper/905/ide-preferences'>
<!ENTITY newns 'http://xmlns.oracle.com/jdeveloper/9051/ide-preferences'>
]>
<!--
 |  This XSLT file migrates an Oracle9i JDeveloper 9.0.5Preview settings file
 |  to the 9.0.5Production format.
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
   | Filters out the <Item> element with <Key> of "layout-options"
   +-->
  <xsl:template match='old:Item[old:Key = "layout-options"]' priority="10"/>

   <!--
   | Filters out the <Item> element with <Key> of "oracle.ide.keyboard.KeyStrokeOptions"
   +-->
  <xsl:template match='old:Item[old:Key = "oracle.ide.keyboard.KeyStrokeOptions"]' priority="10"/>

</xsl:stylesheet>


