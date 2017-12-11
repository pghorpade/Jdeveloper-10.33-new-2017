<?xml version='1.0' encoding='UTF-8'?>

<!DOCTYPE xsl:stylesheet [

<!ENTITY ojd 'oracle.jdeveloper.deploy.'>
<!ENTITY ojx 'oracle.jdeveloper.xml.'>
<!ENTITY oldns 'http://xmlns.oracle.com/jdeveloper/904/jproject'>
<!ENTITY newns 'http://xmlns.oracle.com/jdeveloper/905/jproject'>

]>

<!--
 |  This XSLT file migrates an Oracle9i JDeveloper 9.0.4 project file
 |  to the 9.0.5 format.
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
    <class old="&ojd;jar.dd.ApplicationClientNode"        new="&ojx;j2ee.car.ApplicationClientNode"/>
    <class old="&ojd;jar.oc4j.Oc4jApplicationClientNode"  new="&ojx;oc4j.car.OrionApplicationClientNode"/>
    <class old="&ojd;ejb.dd.EjbJarNode"                   new="&ojx;j2ee.ejb.EjbJarNode"/>
    <class old="&ojd;ejb.oc4j.Oc4jEjbJarNode"             new="&ojx;oc4j.ejb.OrionEjbJarNode"/>
    <class old="&ojd;ejb.wl.WlEjbJarNode"                 new="&ojx;wl.ejb.WeblogicEjbJarNode"/>
    <class old="&ojd;ejb.jboss.JbossNode"                 new="&ojx;jboss.ejb.JbossNode"/>
    <class old="&ojd;oc4j.ds.Oc4jDataSourcesNode"         new="&ojx;oc4j.ds.DataSourcesNode"/>
    <class old="&ojd;ear.dd.ApplicationNode"              new="&ojx;j2ee.ear.ApplicationNode"/>
    <class old="&ojd;ear.oc4j.Oc4jApplicationNode"        new="&ojx;oc4j.ear.OrionApplicationNode"/>
    <class old="&ojd;war.dd.WebAppNode"                   new="&ojx;j2ee.war.WebAppNode"/>
    <class old="&ojd;war.oc4j.Oc4jWebAppNode"             new="&ojx;oc4j.war.OrionWebAppNode"/>
    <class old="&ojd;war.wl.WlWebAppNode"                 new="&ojx;wl.war.WeblogicWebAppNode"/>
    <class old="oracle.jdevimpl.web.struts.StrutsConfigNode" new="oracle.adfimpl.struts.navigator.StrutsConfigNode"/>
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
    <xsl:call-template name="copy_element"/>
  </xsl:template>

  <xsl:template name="copy_element">
    <xsl:element name="{name()}" namespace="&newns;">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="/old:project">
    <xsl:element name="project" namespace="&newns;">
      <xsl:if test="not(@migration-origin)"><xsl:attribute name="migration-origin">9.0.4</xsl:attribute></xsl:if>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
  </xsl:template>

  <!--
   |  Migrates class name changes to project/listOfChildren/Item
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

  <!--
   |  Migrates <nodeClass> elements.
   +-->
  <xsl:template match="/old:project/old:listOfChildren/old:Item/old:nodeClass">
    <xsl:variable name="val" select="."/>
    <xsl:choose>
      <xsl:when test="$list/data:class[@old=$val]">
        <xsl:element name="nodeClass" namespace="&newns;">
          <xsl:value-of select="$list/data:class[@old=$val]/@new"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="copy_element"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
