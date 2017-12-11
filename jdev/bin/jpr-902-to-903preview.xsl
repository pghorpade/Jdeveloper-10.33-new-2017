<?xml version='1.0' encoding='UTF-8'?>

<!DOCTYPE xsl:stylesheet [

<!ENTITY ojd 'oracle.jdeveloper.deploy.'>
<!ENTITY oje 'oracle.jdeveloper.ejb.'>
<!ENTITY jbodt 'oracle.jbo.dt.'>
<!ENTITY oldns 'http://xmlns.oracle.com/jdeveloper/902/jproject'>
<!ENTITY newns 'http://xmlns.oracle.com/jdeveloper/903preview/jproject'>

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
    <class old="&ojd;ejb.dd11.EjbJar11Node"           new="&ojd;ejb.dd.EjbJarNode"/>
    <class old="&ojd;ejb.oc4j1022.Oc4jEjbJarNode"     new="&ojd;ejb.oc4j.Oc4jEjbJarNode"/>
    <class old="&ojd;ejb.wl600.WlEjbJarNode"          new="&ojd;ejb.wl.WlEjbJarNode"/>
    <class old="&ojd;jar.dd12.ApplicationClient12Node"  new="&ojd;jar.dd.ApplicationClientNode"/>
    <class old="&ojd;jar.tld11.Taglib11Node"          new="oracle.jdevimpl.jsp.wizards.taglib.TaglibNode"/>
    <class old="&ojd;war.dd22.WebApp22Node"           new="&ojd;war.dd.WebAppNode"/>
    <class old="&ojd;war.wl600.WlWebAppNode"          new="&ojd;war.wl.WlWebAppNode"/>
    <class old="&oje;EJBModule"                       new="&oje;EjbModuleContainer"/>
    <class old="&oje;EjbModule"                       new="&oje;EjbModuleContainer"/>
    <class old="&jbodt;ui.wizards.dac.datadef.AppDefNode"   new="&jbodt;jclient.datadef.AppDefNode"/>
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
      <xsl:if test="not(@migration-origin)"><xsl:attribute name="migration-origin">9.0.2.2</xsl:attribute></xsl:if>
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
   |  Migrates class name changes to project/projectSettings/commonData/Item/Value
   +-->
  <xsl:template match="/old:project/old:projectSettings/old:commonData/old:Item/old:Value/@class">
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
