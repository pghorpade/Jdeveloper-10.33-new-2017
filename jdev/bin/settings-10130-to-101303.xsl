<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY oldns
'http://xmlns.oracle.com/jdeveloper/10130/ide-preferences'>
<!ENTITY newns
'http://xmlns.oracle.com/jdeveloper/101303/ide-preferences'>
]>
<!--
 |  This XSLT file migrates an Oracle JDeveloper 10.1.3 preview settings file
 |  to the 10.1.3 production format.
 +-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:data="urn:data"
                xmlns="&newns;"
                xmlns:old="&oldns;">

  <xsl:output indent="yes"/>

  <!-- 
   |  Lookup list for old and new class names.
   +-->
  <upgrade xmlns="urn:data">
    <class old="oracle.ide.util.DynamicPropertySetImpl"                 new="oracle.javatools.util.DynamicPropertySetImpl"/>
    <class old="oracle.jdeveloper.ceditor.find.FindOptions"             new="oracle.ide.ceditor.find.FindOptions"/>
    <class old="oracle.jdeveloper.ceditor.options.CaretOptions"         new="oracle.ide.ceditor.options.CaretOptions"/>
    <class old="oracle.jdeveloper.ceditor.options.DisplayOptions"       new="oracle.ide.ceditor.options.DisplayOptions"/>
    <class old="oracle.jdeveloper.ceditor.options.EditorOptions"        new="oracle.ide.ceditor.options.EditorOptions"/>
    <class old="oracle.jdeveloper.ceditor.options.FontSettings"         new="oracle.ide.ceditor.options.FontSettings"/>
    <class old="oracle.jdeveloper.ceditor.options.FontSizeOptions"      new="oracle.ide.ceditor.options.FontSizeOptions"/>
    <class old="oracle.jdeveloper.ceditor.options.InsightOptions"       new="oracle.ide.ceditor.options.InsightOptions"/>
    <class old="oracle.jdeveloper.ceditor.options.PrintingHTMLOptions"  new="oracle.ide.ceditor.options.PrintingHTMLOptions"/>
    <class old="oracle.jdeveloper.ceditor.options.PrintingOptions"      new="oracle.ide.ceditor.options.PrintingOptions"/>
    <class old="oracle.jdeveloper.ceditor.options.S2Highlight"          new="oracle.ide.ceditor.options.S2Highlight"/>
    <class old="oracle.jdeveloper.ceditor.options.S2Style"              new="oracle.ide.ceditor.options.S2Style"/>
    <class old="oracle.jdeveloper.ceditor.options.SyntaxColorsOptions"  new="oracle.ide.ceditor.options.SyntaxColorsOptions"/>
    <class old="oracle.jdeveloper.ceditor.options.SyntaxHighlight"      new="oracle.ide.ceditor.options.SyntaxHighlight"/>
    <class old="oracle.jdeveloper.ceditor.options.SyntaxSchemes"        new="oracle.ide.ceditor.options.SyntaxSchemes"/>
    <class old="oracle.jdeveloper.ceditor.options.SyntaxStyle"          new="oracle.ide.ceditor.options.SyntaxStyle"/>
    <class old="oracle.jdeveloper.ceditor.options.UndoOptions"          new="oracle.ide.ceditor.options.UndoOptions"/>
    <class old="oracle.jdevimpl.uieditor.UIEditorOptions"               new="oracle.jdeveloper.uieditor.UIEditorOptions"/>
  </upgrade>
  <delete xmlns="urn:data">
    <class old="oracle.bm.xmi.config.XMIOptions"/>
    <class old="oracle.ide.addin.config.AddinManagerOptions"/>
    <class old="oracle.ideimpl.update.wizard.AuthInfo"/>
    <class old="oracle.jdevimpl.audit.preferences.MetricsPreferences"/>
    <class old="oracle.jdevimpl.java.cl.JavaSourceOptions"/>
  </delete>

  <xsl:variable name="this" select="document('')/xsl:stylesheet"/>
  <xsl:variable name="list" select="$this/data:upgrade"/>
  <xsl:variable name="deleteList" select="$this/data:delete/data:class/@old"/>

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
   |  Deletes any Item element whose class type is on the delete list.
   +-->
  <xsl:template match="old:Item">
    <xsl:choose>
      <xsl:when test="old:Value/@class=$deleteList"/>
      <xsl:otherwise>
        <xsl:element name="Item" namespace="&newns;">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
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
  <xsl:template match="old:Key">
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
