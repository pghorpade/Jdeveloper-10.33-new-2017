<?xml version='1.0' encoding='UTF-8'?>

<!DOCTYPE xsl:stylesheet [

<!ENTITY oj 'oracle.jdeveloper.'>
<!ENTITY impl 'oracle.jdevimpl.'>
<!ENTITY newns 'http://xmlns.oracle.com/jdeveloper/902rc/jproject'>

]>

<!--
 |  This XSLT file migrates an Oracle9i JDeveloper Beta project file
 |  to the Oracle9i JDeveloper Release Candidate format.
 +-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:data="urn:data">

  <xsl:output indent="yes"/>

  <!-- 
   |  Lookup list for old and new class names.
   +-->
  <upgrade xmlns="urn:data">
    <class old="&oj;config.JProjectLibraries"            new="&impl;config.JProjectLibraries"/>
    <class old="&oj;config.JProjectPaths"                new="&impl;config.JProjectPaths"/>
    <class old="&oj;idl.config.IdlConfiguration"         new="&impl;idl.config.IdlConfiguration"/>
    <class old="&oj;runner.codecoach.CCConfiguration"    new="&impl;runner.codecoach.CCConfiguration"/>
    <class old="&oj;runner.debug.DebugConfiguration"     new="&impl;runner.debug.DebugConfiguration"/>
    <class old="&oj;runner.profile.ProfileConfiguration" new="&impl;runner.profile.ProfileConfiguration"/>
    <class old="&oj;sqlj.config.SqljConfiguration"       new="&impl;sqlj.config.SqljConfiguration"/>
    <class old="&oj;webapp.html.HtmlSourceNode"          new="&impl;webapp.html.HtmlSourceNode"/>
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
   |  Adds 902rc attributes to <project> element.
   +-->
  <xsl:template match="project[@class='&oj;model.JProject']">
    <xsl:element name="project" namespace="&newns;">
      <xsl:attribute name="nselem">project</xsl:attribute>
      <xsl:attribute name="class">&oj;model.JProject</xsl:attribute>
      <xsl:if test="not(@migration-origin)"><xsl:attribute name="migration-origin">9.0.2.0</xsl:attribute></xsl:if>
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

  <!--
   |  Matches any element named 'Key' and updates the PCDATA text as
   |  necessary.
   +-->
  <xsl:template match="Key">
    <xsl:variable name="val" select="."/>
    <xsl:element name="Key" namespace="&newns;">
      <xsl:choose>
        <xsl:when test="$list/data:class[@old=$val]">
          <xsl:value-of select="$list/data:class[@old=$val]/@new"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
