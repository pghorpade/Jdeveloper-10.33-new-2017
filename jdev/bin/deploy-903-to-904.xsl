<?xml version='1.0' encoding='UTF-8'?>

<!DOCTYPE xsl:stylesheet [
<!ENTITY oldns 'http://xmlns.oracle.com/jdeveloper/903/deploy/'>
<!ENTITY newns 'http://xmlns.oracle.com/jdeveloper/904/deploy/'>
]>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:data="urn:data">
  <xsl:output indent="yes"/>

  <upgrade xmlns="urn:data">
    <urimap old="&oldns;jar"             new="&newns;jar"/>
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

</xsl:stylesheet>
