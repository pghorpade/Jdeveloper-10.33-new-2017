<?xml version='1.0' encoding='UTF-8'?>

<!DOCTYPE xsl:stylesheet [
<!ENTITY ojd 'oracle.jdeveloper.deploy.'>
<!ENTITY newns 'http://xmlns.oracle.com/jdeveloper/902rc/deploy/'>
]>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:data="urn:data">
  <xsl:output indent="yes"/>

  <upgrade xmlns="urn:data">
    <urimap class="&ojd;jar.ArchiveProfile"   newuri="&newns;jar"/>
    <urimap class="&ojd;jar.LoadjavaProfile"  newuri="&newns;loadjava"/>
    <urimap class="&ojd;sp.StoredProcProfile" newuri="&newns;stored-proc"/>
    <urimap class="&ojd;ear.EarProfile"       newuri="&newns;j2ee-ear"/>
    <urimap class="&ojd;ejb.EjbProfile"       newuri="&newns;j2ee-ejb-jar"/>
    <urimap class="&ojd;war.WarProfile"       newuri="&newns;j2ee-war"/>
    <urimap class="&ojd;jar.Taglib11Profile"  newuri="&newns;j2ee-taglib"/>
    <urimap class="&ojd;jar.ClientProfile"    newuri="&newns;j2ee-client-jar"/>
  </upgrade>

  <xsl:variable name="list" select="document('')/xsl:stylesheet/data:upgrade"/>
  <xsl:variable name="class" select="/*/@class"/>
  <xsl:variable name="newuri" select="$list/data:urimap[@class=$class]/@newuri"/>

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
  <xsl:template match="/*">
    <xsl:variable name="name" select="name()"/>
    <xsl:element name="{$name}" namespace="{$newuri}">
      <xsl:attribute name="nselem"><xsl:value-of select="$name"/></xsl:attribute>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
