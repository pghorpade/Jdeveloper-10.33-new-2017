<?xml version='1.0' encoding='UTF-8'?>

<!DOCTYPE xsl:stylesheet [
<!ENTITY oldns 'http://xmlns.oracle.com/jdeveloper/902rc/deploy/'>
<!ENTITY newns 'http://xmlns.oracle.com/jdeveloper/902/deploy/'>
]>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:data="urn:data"
                xmlns:oldjar="&oldns;jar"
                xmlns:oldtld="&oldns;j2ee-taglib"
                xmlns:oldear="&oldns;j2ee-ear"
                xmlns:oldwar="&oldns;j2ee-war">
  <xsl:output indent="yes"/>

  <upgrade xmlns="urn:data">
    <urimap old="&oldns;jar"             new="&newns;jar"/>
    <urimap old="&oldns;loadjava"        new="&newns;loadjava"/>
    <urimap old="&oldns;stored-proc"     new="&newns;stored-proc"/>
    <urimap old="&oldns;j2ee-ear"        new="&newns;j2ee-ear"/>
    <urimap old="&oldns;j2ee-ejb-jar"    new="&newns;j2ee-ejb-jar"/>
    <urimap old="&oldns;j2ee-war"        new="&newns;j2ee-war"/>
    <urimap old="&oldns;j2ee-client-jar" new="&newns;j2ee-client-jar"/>
    <urimap old="&oldns;j2ee-taglib"     new="&newns;j2ee-taglib"/>
  </upgrade>

  <xsl:variable name="list" select="document('')/xsl:stylesheet/data:upgrade"/>
  <xsl:variable name="olduri" select="namespace-uri(/*)"/>
  <xsl:variable name="newuri" select="$list/data:urimap[@old=$olduri]/@new"/>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <!--
   |  Map old namespace URI to new namespace URI.
   +-->
  <xsl:template match="*">
    <xsl:element name="{name()}" namespace="{$newuri}">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
  </xsl:template>

  <!--
   |  Migrate simple archive deployment profile.
   +-->
  <xsl:template match="oldjar:simple-archive-deployment/oldjar:mostRecentTarget">
    <xsl:element name="jarURL" namespace="&newns;jar">
      <xsl:copy-of select="oldjar:fileURL/@*"/>
    </xsl:element>
    <xsl:element name="profileDeps" namespace="&newns;jar"/>
  </xsl:template>

  <!--
   |  Migrate tag library deployment profile.
   +-->
  <xsl:template match="oldtld:taglib-deployment">
    <xsl:element name="taglib-deployment" namespace="&newns;j2ee-taglib">
      <xsl:attribute name="nselem">taglib-deployment</xsl:attribute>
      <xsl:attribute name="class">oracle.jdeveloper.deploy.jar.TaglibProfile</xsl:attribute>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="oldtld:taglib-deployment/oldtld:mostRecentTarget">
    <xsl:element name="jarURL" namespace="&newns;j2ee-taglib">
      <xsl:copy-of select="oldtld:fileURL/@*"/>
    </xsl:element>
    <xsl:element name="profileDeps" namespace="&newns;j2ee-taglib"/>
  </xsl:template>

  <!--
   |  Migrate EAR deployment profile.
   +-->
  <xsl:template match="oldear:ear-deployment/oldear:earDeps">
    <xsl:element name="profileDeps" namespace="&newns;j2ee-ear">
      <xsl:copy-of select="./@*"/>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="oldear:ear-deployment/oldear:appName">
    <xsl:element name="enterpriseAppName" namespace="&newns;j2ee-ear">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
  </xsl:template>

  <!--
   |  Migrate WAR deployment profile.
   +-->
  <xsl:template match="oldwar:web-app-deployment/oldwar:ejbDeps">
    <xsl:element name="profileDeps" namespace="&newns;j2ee-war">
      <xsl:copy-of select="./@*"/>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="oldwar:web-app-deployment/*[self::oldwar:appletFiles or self::oldwar:javaFiles]/oldwar:selectionFilters/oldwar:Item['oracle.jdeveloper.deploy.common.dt.JavaSelectionFilter' and not(@idref)]">
    <xsl:element name="Item" namespace="&newns;j2ee-war">
      <xsl:copy-of select="./@*"/>
      <xsl:text>oracle.jdevimpl.deploy.common.JavaSelectionFilter</xsl:text>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
