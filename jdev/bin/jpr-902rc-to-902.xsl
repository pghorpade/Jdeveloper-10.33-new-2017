<?xml version='1.0' encoding='UTF-8'?>

<!DOCTYPE xsl:stylesheet [

<!ENTITY ojd 'oracle.jdeveloper.deploy.'>
<!ENTITY oldns 'http://xmlns.oracle.com/jdeveloper/902rc/jproject'>
<!ENTITY newns 'http://xmlns.oracle.com/jdeveloper/902/jproject'>

]>

<!--
 |  This XSLT file migrates an Oracle9i JDeveloper release candidate
 |  project file to the Oracle9i JDeveloper production format.
 +-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:data="urn:data"
                xmlns:old="&oldns;">

  <xsl:output indent="yes"/>

  <!-- 
   |  Lookup list for old and new class names.
   +-->
  <upgrade xmlns="urn:data">
    <class old="&ojd;jar.dt.ApplicationClient12Node"  new="&ojd;jar.dd12.ApplicationClient12Node"/>
    <class old="&ojd;jar.dt.Taglib11Node"             new="&ojd;jar.tld11.Taglib11Node"/>
    <class old="&ojd;ejb.dt.EjbJar11Node"             new="&ojd;ejb.dd11.EjbJar11Node"/>
    <class old="&ojd;war.dt.WebApp22Node"             new="&ojd;war.dd22.WebApp22Node"/>
  </upgrade>

  <xsl:variable name="list" select="document('')/xsl:stylesheet/data:upgrade"/>

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
      <xsl:if test="not(@migration-origin)"><xsl:attribute name="migration-origin">9.0.2.1</xsl:attribute></xsl:if>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
  </xsl:template>

  <!--
   |  Migrates class name changes.
   +-->
  <xsl:template match="/old:project/old:listOfChildren/old:Item/@class">
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
