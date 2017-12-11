<?xml version="1.0" encoding="UTF-8"?>

<!--
 |  This XSLT file migrates an Oracle10g JDeveloper 9.0.5.1 workspace file
 |  to the 10.1.3 format.
 +-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ora="http://www.oracle.com/XSL/Transform/java"
                xmlns:jws="http://xmlns.oracle.com/jdeveloper/10130/workspace"
                exclude-result-prefixes="ora">

  <xsl:output indent="yes"/>

  <xsl:template match="*[local-name()='workspace']">
    <xsl:variable name="workspace-rtf">
      <xsl:apply-templates mode="resolve-idref" select="."/>
    </xsl:variable>
    <xsl:variable name="workspace" select="ora:node-set($workspace-rtf)/*[local-name()='workspace']"/>
    <jws:workspace>
      <xsl:apply-templates mode="listOfChildren" select="$workspace/*[local-name()='listOfChildren']"/>
      <xsl:apply-templates mode="tpo-properties" select="$workspace/*[local-name()='properties']/*[local-name()='Item']"/>
    </jws:workspace>
  </xsl:template>

  <xsl:template mode="listOfChildren" match="*[local-name()='listOfChildren']">
    <list n="listOfChildren">
      <xsl:for-each select="*[local-name()='Item']">
        <xsl:variable name="nodeClassName" select="string(*[local-name()='nodeClass'])"/>
        <hash>
          <xsl:choose>
            <xsl:when test="$nodeClassName='oracle.jdeveloper.model.JProject'">
              <value n="nodeClass" v="oracle.ide.model.Project"/>  <!-- 4438590 -->
            </xsl:when>
            <xsl:otherwise>
              <value n="nodeClass" v="{$nodeClassName}"/>
            </xsl:otherwise>
          </xsl:choose>
          <url n="URL"><xsl:copy-of select="*[local-name()='URL']/@*"/></url>
        </hash>
      </xsl:for-each>
    </list>
  </xsl:template>

  <!-- Other properties are assumed to be String key and String value. -->
  <xsl:template mode="tpo-properties" match="*[local-name()='Item']">
    <value n="{*[local-name()='Key']}" v="{*[local-name()='Value']}"/>
  </xsl:template>

  <!-- Templates in mode "resolve-idref" resolve the id/idref attributes. -->
  <xsl:template mode="resolve-idref" match="@id"/>
  <xsl:template mode="resolve-idref" match="*[@idref]">
    <xsl:call-template name="resolve-and-copy">
      <xsl:with-param name="node" select="."/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="resolve-and-copy">
    <xsl:param name="node"/>
    <xsl:variable name="nodeID" select="generate-id($node)"/>
    <xsl:choose>
      <xsl:when test="../*[generate-id(.)=$nodeID]">  <!--  i.e. the node is an element -->
        <xsl:choose>
          <xsl:when test="$node/@idref">
            <xsl:call-template name="copy-impl">
              <xsl:with-param name="curNode" select="$node"/>
              <xsl:with-param name="origNode" select="//*[@id=($node/@idref)]"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="copy-impl">
              <xsl:with-param name="curNode" select="$node"/>
              <xsl:with-param name="origNode" select="$node"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>  <!--  not an element, just copy it -->
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="copy-impl">
    <xsl:param name="curNode"/>
    <xsl:param name="origNode"/>
    <xsl:element name="{name($curNode)}" namespace="{namespace-uri($curNode)}">
      <xsl:copy-of select="$origNode/@*[not(name()='id')]"/>
      <xsl:for-each select="$origNode/node()">
        <xsl:call-template name="resolve-and-copy">
          <xsl:with-param name="node" select="."/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  <xsl:template mode="resolve-idref" match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates mode="resolve-idref" select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
