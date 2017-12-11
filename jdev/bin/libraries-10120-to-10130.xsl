<?xml version='1.0' encoding='UTF-8'?>

<!DOCTYPE xsl:stylesheet [

<!ENTITY newns 'http://xmlns.oracle.com/jdeveloper/10130/jlibrary-list'>

]>

<!--
 |  This XSLT file migrates a pre 10.1.3 libraries.xml file
 |  to the Oracle10G JDeveloper Release 10.1.3 format.
 +-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:data="urn:data">

  <xsl:output indent="yes"/>

  <!-- 
   |  Lookup list for old and new class names.
   +-->
  <upgrade xmlns="urn:data">
    <class old="oracle.jdeveloper.library.JLibraryList"            new="oracle.jdeveloper.library.LegacyLibraryList"/>
    <class old="oracle.jdeveloper.library.JLibrary"                new="oracle.jdeveloper.library.LegacyLibrary"/>
    <class old="oracle.jdeveloper.library.JDK"                    new="oracle.jdeveloper.library.LegacyJDK"/>
  </upgrade>

  <xsl:variable name="list" select="document('')/xsl:stylesheet/data:upgrade"/>

  <!--
   |  Identity transformation.
   +-->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*">
    <xsl:element name="{name()}" namespace="&newns;">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <!--
   |  Adds 10130 attributes to <JLibraryList> element.
   +-->
  <xsl:template match="JLibraryList[@class='oracle.jdeveloper.library.JLibraryList']">
    <xsl:element name="JLibraryList" namespace="&newns;">
      <xsl:attribute name="nselem">JLibraryList</xsl:attribute>
      <xsl:attribute name="class">oracle.jdeveloper.library.LegacyLibraryList</xsl:attribute>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <!--
   |  Matches any 'class' attribute and updates the attribute value as
   |  necessary.
   +-->
  <xsl:template match="@class">
    <xsl:variable name="val" select="."/>
    <xsl:choose>
      <xsl:when test="$list/data:class[@old=$val]">
        <xsl:attribute name="class">
          <xsl:value-of select="$list/data:class[@old=$val]/@new"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy/>
      </xsl:otherwise>
    </xsl:choose>  
  </xsl:template>

</xsl:stylesheet>
