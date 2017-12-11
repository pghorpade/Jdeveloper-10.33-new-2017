<?xml version="1.0" encoding="UTF-8"?>

<!--
 |  This XSLT file migrates an Oracle10g JDeveloper 10.1.2 project file
 |  to the 10.1.3 format.
 +-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ora="http://www.oracle.com/XSL/Transform/java"
                xmlns:old="http://xmlns.oracle.com/jdeveloper/10120/jproject"
                xmlns:jpr="http://xmlns.oracle.com/ide/project"
                exclude-result-prefixes="ora old">

  <xsl:output indent="yes"/>

  <xsl:template match="old:project">
    <xsl:variable name="project-rtf">
      <xsl:apply-templates mode="resolve-idref" select="."/>
    </xsl:variable>
    <xsl:variable name="project" select="ora:node-set($project-rtf)/old:project"/>
    <jpr:project>
      <hash n="component-versions">
        <xsl:choose>
          <xsl:when test="@migration-origin">
            <value n="oracle.ide.model.Project" v="{@migration-origin}"/>
          </xsl:when>
          <xsl:otherwise>
            <value n="oracle.ide.model.Project" v="10.1.2.0.0"/>
          </xsl:otherwise>
        </xsl:choose>
      </hash>
      <list n="contentSets">
        <string v="oracle.jdeveloper.model.PathsConfiguration/javaContentSet"/>
        <string v="oracle.ide.model.ResourcePaths/resourcesContentSet"/>
        <string v="oracle.jdeveloper.model.J2eeSettings/webContentSet"/>
        <string v="oracle.jdeveloper.offlinedb.OfflineDBProjectSettings/offlineDBContentSet"/>
        <string v="oracle.bm.commonIde.data.project.ModelerProjectSettings/modelersContentSet"/>
      </list>
      <xsl:if test="$project/old:defaultPackage">
        <value n="defaultPackage" v="{$project/old:defaultPackage}"/>
      </xsl:if>
      <xsl:apply-templates mode="ejbModuleContainer" select="$project/old:projectSettings/old:commonData/old:Item[old:Key='ejbModuleContainer']/old:Value"/>
      <xsl:apply-templates mode="listOfChildren" select="$project/old:listOfChildren"/>
      <xsl:apply-templates mode="oc4j.cmd.line.template" select="$project/old:properties/old:Item[old:Key='oc4j.cmd.line.template']"/>
      <xsl:apply-templates mode="DBData" select="$project/old:projectSettings/old:commonData/old:Item[old:Key='oracle.adf.mds.dt.ui.util.DBData']/old:Value"/>
      <xsl:apply-templates mode="JRADOAData" select="$project/old:projectSettings/old:commonData/old:Item[old:Key='oracle.jrad.design.ui.jide.oa.project.JRADOAData']/old:Value"/>
      <xsl:apply-templates mode="JRADRunOptions" select="$project/old:projectSettings/old:commonData/old:Item[old:Key='oracle.jrad.design.ui.jide.oa.project.JRADRunOptions']/old:Value"/>
      <xsl:apply-templates mode="JRADRuntimeData" select="$project/old:projectSettings/old:commonData/old:Item[old:Key='oracle.jrad.design.ui.jide.oa.project.JRADRuntimeData']/old:Value"/>
      <xsl:apply-templates mode="XMLPathData" select="$project/old:projectSettings/old:commonData/old:Item[old:Key='oracle.adf.mds.dt.ui.ide.common.XMLPathData']/old:Value"/>
      <xsl:apply-templates mode="ModelerProjectSettings" select="$project/old:projectSettings/old:commonData/old:Item[old:Key='oracle.bm.commonIde.data.project.ModelerProjectSettings']/old:Value"/>
      <xsl:apply-templates mode="dependencyList" select="$project/old:dependencyList"/>
      <xsl:apply-templates mode="technologyScope" select="$project/old:properties/old:Item[old:Key='technologyScope']/old:Value/old:technologyKeys"/>
      <xsl:apply-templates mode="AntConfiguration" select="$project/old:projectSettings/old:commonData/old:Item[old:Key='oracle.jdeveloper.compiler.ant.AntConfiguration']/old:Value"/>
      <xsl:apply-templates mode="OjcConfiguration" select="$project/old:projectSettings/old:configurations/old:Item[1]/old:Value/old:configData/old:Item[old:Key='oracle.jdeveloper.compiler.OjcConfiguration']/old:Value"/>
      <xsl:apply-templates mode="JProjectJavadoc" select="$project/old:projectSettings/old:configurations/old:Item[1]/old:Value/old:configData/old:Item[old:Key='oracle.jdeveloper.javadoc.JProjectJavadoc']/old:Value"/>
      <hash n="oracle.ide.model.ResourcePaths">
        <hash n="resourcesContentSet"/>
      </hash>
      <hash n="oracle.jdeveloper.model.J2eeSettings">
        <xsl:if test="$project/old:j2eeWebAppName">
          <value n="j2eeWebAppName" v="{$project/old:j2eeWebAppName}"/>
        </xsl:if>
        <xsl:if test="$project/old:j2eeWebContextRoot">
          <value n="j2eeWebContextRoot" v="{$project/old:j2eeWebContextRoot}"/>
        </xsl:if>
        <hash n="webContentSet">
          <list n="url-path">
            <url><xsl:copy-of select="$project/old:htmlRootDirectory/@*"/></url>
          </list>
        </hash>
      </hash>
      <hash n="oracle.jdeveloper.model.PathsConfiguration">
        <hash n="javaContentSet">
          <list n="url-path">
            <xsl:for-each select="$project/old:projectSourcePath/old:entries/old:Item">
              <url><xsl:copy-of select="@*"/></url>
            </xsl:for-each>
          </list>
        </hash>
      </hash>
      <xsl:apply-templates mode="OfflineDBProjectSettings" select="$project/old:projectSettings/old:commonData/old:Item[old:Key='oracle.jdeveloper.offlinedb.OfflineDBProjectSettings']/old:Value"/>
      <xsl:apply-templates mode="RunConfiguration" select="$project/old:projectSettings/old:configurations/old:Item[1]/old:Value/old:configData/old:Item[old:Key='oracle.jdeveloper.runner.RunConfiguration']/old:Value"/>
      <xsl:apply-templates mode="JProjectLibraries" select="$project/old:projectSettings/old:configurations/old:Item[1]/old:Value/old:configData/old:Item[old:Key='oracle.jdevimpl.config.JProjectLibraries']/old:Value"/>
      <xsl:apply-templates mode="JProjectPaths" select="$project/old:projectSettings/old:configurations/old:Item[1]/old:Value/old:configData/old:Item[old:Key='oracle.jdevimpl.config.JProjectPaths']/old:Value"/>
      <xsl:apply-templates mode="XSLTConfiguration" select="$project/old:projectSettings/old:configurations/old:Item[1]/old:Value/old:configData/old:Item[old:Key='oracle.jdevimpl.runner.xslt.XSLTConfiguration']/old:Value"/>
      <xsl:apply-templates mode="SqljConfiguration" select="$project/old:projectSettings/old:configurations/old:Item[1]/old:Value/old:configData/old:Item[old:Key='oracle.jdevimpl.sqlj.config.SqljConfiguration']/old:Value"/>
      <xsl:apply-templates mode="ownerMap" select="$project/old:ownerMap"/>
      <value n="project-migration-in-progress" v="true"/>
      <value n="project-migration-was-dynamic-project" v="{$project/old:properties/old:Item[old:Key='useDynamicPaths']/old:Value/text()}"/>
      <xsl:if test="$project/old:defaultPackages/old:Item">
        <list n="recentlyUsedPackages">
          <xsl:for-each select="$project/old:defaultPackages/old:Item">
            <string v="{.}"/>
          </xsl:for-each>
        </list>
      </xsl:if>
      <xsl:apply-templates mode="WebappJspCompilerOptions" select="$project/old:projectSettings/old:configurations/old:Item[1]/old:Value/old:configData/old:Item[old:Key='WebappJspCompilerOptions']/old:Value"/>
      <xsl:apply-templates mode="tpo-properties" select="$project/old:properties/old:Item[not(old:Key='oc4j.cmd.line.template') and not(old:Key='technologyScope')]"/>
      <xsl:apply-templates mode="pcbpel-properties" select="$project/old:projectSettings/old:commonData/old:Item[old:Key='Namespace' or old:Key='ProcessName' or old:Key='Template']"/>
    </jpr:project>
  </xsl:template>

  <xsl:template mode="ejbModuleContainer" match="old:Value">
    <hash n="ejbModuleContainer">
      <value n="cmpProvider" v="{old:cmpProvider}"/>
      <hash n="ejbIdToEjbNameMap">
        <!-- 9.0.5 and later -->
        <xsl:for-each select="old:ejbIdToEjbNameMap/old:Item">
          <value n="{old:Key}" v="{old:Value}"/>
        </xsl:for-each>
        <!-- 9.0.4 and earlier -->
        <xsl:for-each select="old:ejbIdToEjbContainerMap/old:Item">
          <xsl:variable name="ejbName" select="old:Value/old:URL/@ref"/>
          <xsl:choose>
            <xsl:when test="starts-with($ejbName, 'Entity.')">
              <value n="{old:Key}" v="{substring($ejbName, 8)}"/>
            </xsl:when>
            <xsl:when test="starts-with($ejbName, 'Session.')">
              <value n="{old:Key}" v="{substring($ejbName, 9)}"/>
            </xsl:when>
            <xsl:when test="starts-with($ejbName, 'MessageDriven.')">
              <value n="{old:Key}" v="{substring($ejbName, 15)}"/>
            </xsl:when>
            <xsl:otherwise>
              <value n="{old:Key}" v="{old:Value/old:URL/@ref}"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </hash>
      <url n="ejbJarNodeURL"><xsl:copy-of select="old:ejbJarNodeURL/@*"/></url>
      <hash n="entityNameToCmpProviderNameMap">
        <xsl:for-each select="old:entityNameToCmpProviderNameMap/old:Item">
          <value n="{old:Key}" v="{old:Value}"/>
        </xsl:for-each>
      </hash>
      <url n="orionEjbJarNodeURL"><xsl:copy-of select="old:orionEjbJarNodeURL/@*"/></url>
    </hash>
  </xsl:template>

  <xsl:template mode="listOfChildren" match="old:listOfChildren">
    <list n="listOfChildren">
      <xsl:for-each select="old:Item">
        <hash>
          <xsl:variable name="nodeClass" select="old:nodeClass"/>
          <xsl:if test="$nodeClass">
            <xsl:choose>
              <xsl:when test="$nodeClass='oracle.jdeveloper.compiler.ant.AntNode'">
                <value n="nodeClass" v="oracle.jdeveloper.ant.AntNode"/>
              </xsl:when>
              <xsl:when test="$nodeClass='oracle.adfimpl.struts.navigator.StrutsConfigNode'">
                <value n="nodeClass" v="oracle.adfdt.controller.struts.navigator.StrutsConfigNode"/>
              </xsl:when>
              <xsl:otherwise>
                <value n="nodeClass" v="{$nodeClass}"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <xsl:choose>
            <!-- 4017537 -->
            <xsl:when test="$nodeClass='oracle.toplink.addin.node.SessionsNode' and
                            substring(old:URL/@path,string-length(old:URL/@path))='/'">
              <url n="URL">
                <xsl:copy-of select="old:URL/@*"/>
                <xsl:attribute name="path">
                  <xsl:value-of select="substring(old:URL/@path,0,string-length(old:URL/@path))"/>
                </xsl:attribute>
              </url>
            </xsl:when>
            <xsl:otherwise>
              <url n="URL"><xsl:copy-of select="old:URL/@*"/></url>
            </xsl:otherwise>
          </xsl:choose>
        </hash>
      </xsl:for-each>
    </list>
  </xsl:template>

  <xsl:template mode="oc4j.cmd.line.template" match="old:Item">
    <value n="oc4j.cmd.line.template" v="{old:Value}"/>
  </xsl:template>

  <xsl:template mode="DBData" match="old:Value">
    <hash n="oracle.adf.mds.dt.ui.util.DBData">
      <value n="reposConnectionName" v="{old:reposConnectionName}"/>
      <value n="useRepository" v="{old:useRepository}"/>
    </hash>
  </xsl:template>
  
  <xsl:template mode="JRADOAData" match="old:Value">
    <hash n="oracle.jrad.design.ui.jide.oa.project.JRADOAData">
      <list n="MDSXMLPath">
        <xsl:for-each select="old:MDSXMLPath/old:entries/old:Item">
          <url><xsl:copy-of select="@*"/></url>
        </xsl:for-each>
      </list>
    </hash>
  </xsl:template>
  
  <xsl:template mode="JRADRunOptions" match="old:Value">
    <hash n="oracle.jrad.design.ui.jide.oa.project.JRADRunOptions">
      <value n="selectedRunOptions" v="{old:selectedRunOptions}"/>
    </hash>
  </xsl:template>

  <xsl:template mode="JRADRuntimeData" match="old:Value">
    <hash n="oracle.jrad.design.ui.jide.oa.project.JRADRuntimeData">
      <value n="DBCFileName" v="{old:DBCFileName}"/>
      <value n="URLParameters" v="{old:URLParameters}"/>
      <value n="fndTop" v="{old:fndTop}"/>
      <value n="password" v="{old:password}"/>
      <value n="respAppShortName" v="{old:respAppShortName}"/>
      <value n="responsibility" v="{old:responsibilityKey}"/>
      <value n="userName" v="{old:userName}"/>
    </hash>
  </xsl:template>

  <xsl:template mode="XMLPathData" match="old:Value">
    <hash n="oracle.adf.mds.dt.ui.ide.common.XMLPathData">
      <list n="XMLPath">
        <xsl:for-each select="old:XMLPath/old:entries/old:Item">
          <url><xsl:copy-of select="@*"/></url>
        </xsl:for-each>
      </list>
    </hash>
  </xsl:template>

  <xsl:template mode="ModelerProjectSettings" match="old:Value">
    <hash n="oracle.bm.commonIde.data.project.ModelerProjectSettings">
      <hash n="modelersContentSet">
        <list n="url-path">
          <xsl:for-each select="old:modelersPath/old:entries/old:Item">
            <url><xsl:copy-of select="@*"/></url>
          </xsl:for-each>
        </list>
      </hash>
      <xsl:if test="old:modelersVersion">
        <value n="modelersVersion" v="{old:modelersVersion}"/>
      </xsl:if>
    </hash>
  </xsl:template>

  <xsl:template mode="dependencyList" match="old:dependencyList">
    <xsl:variable name="hash-rtf">  <!-- 3958125 -->
      <hash n="oracle.ide.model.DependencyConfiguration">
        <xsl:if test="old:Item">
          <list n="dependencyList">
            <xsl:for-each select="old:Item">
              <hash>
                <value n="class" v="{@class}"/>
                <url n="sourceOwnerURL"><xsl:copy-of select="old:sourceOwnerURL/@*"/></url>
                <url n="sourceURL"><xsl:copy-of select="old:sourceURL/@*"/></url>
              </hash>
            </xsl:for-each>
          </list>
        </xsl:if>
      </hash>
    </xsl:variable>
    <xsl:if test="ora:node-set($hash-rtf)/hash/*">
      <xsl:copy-of select="$hash-rtf"/>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="technologyScope" match="old:technologyKeys">
    <hash n="oracle.ide.model.TechnologyScopeConfiguration">
      <list n="technologyScope">
        <xsl:for-each select="old:Item">
          <string v="{.}"/>
        </xsl:for-each>
      </list>
    </hash>
  </xsl:template>

  <xsl:template mode="AntConfiguration" match="old:Value">
    <xsl:variable name="hash-rtf">  <!-- 3958125 -->
      <hash n="oracle.jdeveloper.compiler.ant.AntConfiguration">
        <xsl:if test="string(old:arguments)">  <!-- default is null -->
          <value n="arguments" v="{old:arguments}"/>
        </xsl:if>
        <xsl:if test="string(old:makeTarget)"> <!-- default is null -->
          <value n="makeTarget" v="{old:makeTarget}"/>
        </xsl:if>
        <xsl:if test="old:projectBuildfile/@*"> <!-- default is null -->
          <url n="projectBuildfile"><xsl:copy-of select="old:projectBuildfile/@*"/></url>
        </xsl:if>
        <xsl:if test="string(old:rebuildTarget)"> <!-- default is null -->
          <value n="rebuildTarget" v="{old:rebuildTarget}"/>
        </xsl:if>
        <xsl:if test="old:showOutput and string(old:showOutput) != 'true'"> <!-- default is true -->
          <value n="showOutput" v="{old:showOutput}"/>
        </xsl:if>
      </hash>
    </xsl:variable>
    <xsl:if test="ora:node-set($hash-rtf)/hash/*">
      <xsl:copy-of select="$hash-rtf"/>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="OjcConfiguration" match="old:Value">
    <hash n="oracle.jdeveloper.compiler.OjcConfiguration">
      <!--<xsl:if test="old:assertionsEnabled">-->  <!-- no longer used in 10.1.3 -->
      <!--  <value n="assertionsEnabled" v="{old:assertionsEnabled}"/>-->
      <!--</xsl:if>-->
      <xsl:choose>
        <!-- 9.0.2. beta had no copyRes -->
        <xsl:when test="old:project/@migration-origin='9.0.2.0'"/>
        <!-- 9.0.2rc, 9.0.2prod, 9.0.3.x (all versions), and 9.0.4.x (all versions) had 6 items in copyRes by default. -->
        <xsl:when test="(old:project/@migration-origin='9.0.2.1' or old:project/@migration-origin='9.0.2.2' or old:project/@migration-origin='9.0.3.0' or old:project/@migration-origin='9.0.3.1' or old:project/@migration-origin='9.0.4') and count(old:copyRes/old:Item) = 6 and old:copyRes/old:Item='.gif' and old:copyRes/old:Item='.properties' and old:copyRes/old:Item='.jpg' and old:copyRes/old:Item='.jpeg' and old:copyRes/old:Item='.xml' and old:copyRes/old:Item='-apf.xml'"/>
        <!-- 9.0.5 preview had 11 items in copyRes by default. -->
        <xsl:when test="old:project/@migration-origin='9.0.5.0' and count(old:copyRes/old:Item) = 11 and old:copyRes/old:Item='.gif' and old:copyRes/old:Item='.properties' and old:copyRes/old:Item='.jpg' and old:copyRes/old:Item='.jpeg' and old:copyRes/old:Item='.xml' and old:copyRes/old:Item='-apf.xml' and old:copyRes/old:Item='.xcfg' and old:copyRes/old:Item='.cpx' and old:copyRes/old:Item='.css' and old:copyRes/old:Item='.js' and old:copyRes/old:Item='.png'"/>
        <!-- 9.0.5 production and 10.1.2 production had 12 items in copyRes by default. -->
        <xsl:when test="(old:project/@migration-origin='9.0.5.1' or not(old:project/@migration-origin)) and count(old:copyRes/old:Item) = 12 and old:copyRes/old:Item='.gif' and old:copyRes/old:Item='.properties' and old:copyRes/old:Item='.jpg' and old:copyRes/old:Item='.jpeg' and old:copyRes/old:Item='.xml' and old:copyRes/old:Item='-apf.xml' and old:copyRes/old:Item='.xcfg' and old:copyRes/old:Item='.cpx' and old:copyRes/old:Item='.css' and old:copyRes/old:Item='.js' and old:copyRes/old:Item='.png' and old:copyRes/old:Item='.tld'"/>
        <xsl:otherwise>
          <list n="copyRes">
            <xsl:for-each select="old:copyRes/old:Item">
              <string v="{.}"/>
            </xsl:for-each>
          </list>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="old:debugInformation and string(old:debugInformation) != 'true'">  <!-- default is true -->
        <value n="debugInformation" v="{old:debugInformation}"/>
      </xsl:if>
      <xsl:if test="old:excludedClasses/old:Item">
        <list n="excludedClasses">
          <xsl:for-each select="old:excludedClasses/old:Item">
            <string v="{.}"/>
          </xsl:for-each>
        </list>
      </xsl:if>
      <xsl:if test="old:internalEncoding and string(old:internalEncoding) != 'Default'"> <!-- default is "Default" -->
        <value n="internalEncoding" v="{old:internalEncoding}"/>
      </xsl:if>
      <!--<xsl:if test="old:obfuscate">-->  <!-- no longer used in 10.1.3 -->
      <!--  <value n="obfuscate" v="{old:obfuscate}"/>-->
      <!--</xsl:if>-->
      <xsl:if test="old:reverseCopyRes and string(old:reverseCopyRes) != 'false'">  <!-- default is false -->
        <value n="reverseCopyRes" v="{old:reverseCopyRes}"/>
      </xsl:if>
      <xsl:if test="old:showDeprecations and string(old:showDeprecations) != 'true'">   <!-- default is true -->
        <value n="showDeprecations" v="{old:showDeprecations}"/>
      </xsl:if>
      <xsl:if test="old:showObjectDotStaticWarnings and string(old:showObjectDotStaticWarnings) != 'false'">  <!-- default is false -->
        <value n="showObjectDotStaticWarnings" v="{old:showObjectDotStaticWarnings}"/>
      </xsl:if>
      <xsl:if test="old:showPartialImportWarnings and string(old:showPartialImportWarnings) != 'false'">  <!-- default is false -->
        <value n="showPartialImportWarnings" v="{old:showPartialImportWarnings}"/>
      </xsl:if>
      <xsl:if test="old:showSelfDeprecations and string(old:showSelfDeprecations) != 'true'">   <!-- default is true -->
        <value n="showSelfDeprecations" v="{old:showSelfDeprecations}"/>
      </xsl:if>
      <xsl:if test="old:showUnusedImportWarnings and string(old:showUnusedImportWarnings) != 'false'">  <!-- default is false -->
        <value n="showUnusedImportWarnings" v="{old:showUnusedImportWarnings}"/>
      </xsl:if>
      <xsl:if test="old:showWarnings and string(old:showWarnings) != 'true'">   <!-- default is true -->
        <value n="showWarnings" v="{old:showWarnings}"/>
      </xsl:if>
      <!--<value n="source" v="Default"/>-->  <!-- default property value omitted during migration -->
      <xsl:if test="old:target and string(old:target) != 'Default'">  <!-- default is "Default" -->
        <value n="target" v="{old:target}"/>
      </xsl:if>
      <!--<xsl:if test="old:updateImports">-->  <!-- no longer used in 10.1.3 -->
      <!--  <value n="updateImports" v="{old:updateImports}"/>-->
      <!--</xsl:if>-->
      <!--<xsl:if test="old:updateZipJarImports">-->  <!-- no longer used in 10.1.3 -->
      <!--  <value n="updateZipJarImports" v="{old:updateZipJarImports}"/>-->
      <!--</xsl:if>-->
      <!--<value n="useJavac" v="false"/>-->  <!-- default property value omitted during migration -->
    </hash>
  </xsl:template>

  <xsl:template mode="JProjectJavadoc" match="old:Value">
    <xsl:variable name="hash-rtf">  <!-- 3958125 -->
      <hash n="oracle.jdeveloper.javadoc.JProjectJavadoc">
        <xsl:if test="old:embedDiagram and string(old:embedDiagram) != '5'"> <!-- default is 5 (meaning EMBED_DIAGRAM_INLINE; oracle.bm.javadoc.UmlJavadocOptions) -->
          <value n="embedDiagram" v="{old:embedDiagram}"/>
        </xsl:if>
        <xsl:if test="old:genDiagramDoc and string(old:genDiagramDoc) != 'true'"> <!-- default is true (oracle.bm.javadoc.UmlJavadocOptions)-->
          <value n="genDiagramDoc" v="{old:genDiagramDoc}"/>
        </xsl:if>
        <xsl:if test="old:generateAuthor and string(old:generateAuthor) != 'false'">  <!-- default is false -->
          <value n="generateAuthor" v="{old:generateAuthor}"/>
        </xsl:if>
        <xsl:if test="old:generateDeprecated and string(old:generateDeprecated) != 'true'"> <!-- default is true -->
          <value n="generateDeprecated" v="{old:generateDeprecated}"/>
        </xsl:if>
        <xsl:if test="old:generateIndex and string(old:generateIndex) != 'true'">  <!-- default is true -->
          <value n="generateIndex" v="{old:generateIndex}"/>
        </xsl:if>
        <xsl:if test="old:generateNavbar and string(old:generateNavbar) != 'true'">  <!-- default is true -->
          <value n="generateNavbar" v="{old:generateNavbar}"/>
        </xsl:if>
        <xsl:if test="old:generateSince and string(old:generateSince) != 'true'"> <!-- default is true -->
          <value n="generateSince" v="{old:generateSince}"/>
        </xsl:if>
        <xsl:if test="old:generateTree and string(old:generateTree) != 'true'">  <!-- default is true -->
          <value n="generateTree" v="{old:generateTree}"/>
        </xsl:if>
        <xsl:if test="old:generateVersion and string(old:generateVersion) != 'false'"> <!-- default is false -->
          <value n="generateVersion" v="{old:generateVersion}"/>
        </xsl:if>
        <!--<xsl:if test="old:heapSize">--> <!-- no longer used -->
        <!--  <value n="heapSize" v="{old:heapSize}"/>-->
        <!--</xsl:if>-->
        <xsl:if test="old:imageFormat and string(old:imageFormat) != '1'"> <!-- default is 1 (meaning IMAGE_FORMAT_PNG; see oracle.bm.javadoc.UmlJavadocOptions) -->
          <value n="imageFormat" v="{old:imageFormat}"/>
        </xsl:if>
        <xsl:if test="string(old:miscOptions)"> <!-- default is "" -->
          <value n="miscOptions" v="{old:miscOptions}"/>
        </xsl:if>
        <xsl:if test="old:outputDirectory and (count(old:outputDirectory/@*) != 1 or old:outputDirectory/@path != 'javadoc/')"> <!-- default is "javadoc/" -->
          <url n="outputDirectory"><xsl:copy-of select="old:outputDirectory/@*"/></url>
        </xsl:if>
        <xsl:if test="old:scope and string(old:scope) != '-protected'"> <!-- default is "-protected" -->
          <value n="scope" v="{old:scope}"/>
        </xsl:if>
      </hash>
    </xsl:variable>
    <xsl:if test="ora:node-set($hash-rtf)/hash/*">
      <xsl:copy-of select="$hash-rtf"/>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="OfflineDBProjectSettings" match="old:Value">
    <hash n="oracle.jdeveloper.offlinedb.OfflineDBProjectSettings">
      <hash n="offlineDBContentSet">
        <list n="url-path">
          <xsl:for-each select="old:databasePath/old:entries/old:Item">
            <url><xsl:copy-of select="@*"/></url>
          </xsl:for-each>
        </list>
      </hash>
    </hash>
  </xsl:template>

  <xsl:template mode="RunConfiguration" match="old:Value">
    <xsl:variable name="hash-rtf">  <!-- 3958125 -->
      <hash n="oracle.jdeveloper.runner.RunConfiguration">
        <xsl:if test="old:allowInput and string(old:allowInput) != 'false'"> <!-- default is false -->
          <value n="allowInput" v="{old:allowInput}"/>
        </xsl:if>
        <xsl:if test="old:clearLogBeforeRun and string(old:clearLogBeforeRun) != 'true'"> <!-- default is true -->
          <value n="clearLogBeforeRun" v="{old:clearLogBeforeRun}"/>
        </xsl:if>
        <xsl:if test="old:compileBeforeRun and string(old:compileBeforeRun) != 'true'"> <!-- default is true -->
          <value n="compileBeforeRun" v="{old:compileBeforeRun}"/>
        </xsl:if>
        <xsl:if test="string(old:connectionName)"> <!-- default is null -->
          <value n="connectionName" v="{old:connectionName}"/>
        </xsl:if>
        <xsl:if test="string(old:javaOptions)"> <!-- default is "" -->
          <value n="javaOptions" v="{old:javaOptions}"/>
        </xsl:if>
        <xsl:if test="old:logCommand and string(old:logCommand) != 'true'"> <!-- default is true -->
          <value n="logCommand" v="{old:logCommand}"/>
        </xsl:if>
        <xsl:if test="old:logError and string(old:logError) != 'true'"> <!-- default is true -->
          <value n="logError" v="{old:logError}"/>
        </xsl:if>
        <xsl:if test="old:logExit and string(old:logExit) != 'true'"> <!-- default is true -->
          <value n="logExit" v="{old:logExit}"/>
        </xsl:if>
        <xsl:if test="old:logOutput and string(old:logOutput) != 'true'"> <!-- default is true -->
          <value n="logOutput" v="{old:logOutput}"/>
        </xsl:if>
        <xsl:if test="string(old:programArguments)"> <!-- default is "" -->
          <value n="programArguments" v="{old:programArguments}"/>
        </xsl:if>
        <xsl:if test="old:runActiveFile and string(old:runActiveFile) != 'true'"> <!-- default is true -->
          <value n="runActiveFile" v="{old:runActiveFile}"/>
        </xsl:if>
        <xsl:if test="old:runDirectoryURL/@*"> <!-- default is null -->
          <url n="runDirectoryURL"><xsl:copy-of select="old:runDirectoryURL/@*"/></url>
        </xsl:if>
        <xsl:if test="old:targetURL/@*"> <!-- default is null -->
          <url n="targetURL"><xsl:copy-of select="old:targetURL/@*"/></url>
        </xsl:if>
        <xsl:if test="old:VMName and string(old:VMName) != 'ojvm'"> <!-- default is "ojvm" -->
          <value n="VMName" v="{old:VMName}"/>
        </xsl:if>
        <xsl:if test="old:useProxy and string(old:useProxy) != 'true'"> <!-- default is true -->
          <value n="useProxy" v="{old:useProxy}"/>
        </xsl:if>
      </hash>
    </xsl:variable>
    <xsl:if test="ora:node-set($hash-rtf)/hash/*">
      <xsl:copy-of select="$hash-rtf"/>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="JProjectLibraries" match="old:Value">
    <hash n="oracle.jdevimpl.config.JProjectLibraries">
      <xsl:variable name="additionalClassPathItems" select="../../old:Item[old:Key='oracle.jdevimpl.config.JProjectPaths']/old:Value/old:additionalClassPath/old:entries/old:Item"/>
      <list n="exportedReferences">
        <xsl:if test="$additionalClassPathItems">
          <hash>
            <value n="id" v="Additional Classpath"/>
            <value n="isJDK" v="false"/>
          </hash>
        </xsl:if>
      </list>
      <hash n="internalDefinitions">
        <list n="jdkDefinitions">
          <xsl:for-each select="../../../../../../../old:projectLibraryList/old:jdkList/old:Item">
            <hash>
              <list n="classPath">
                <xsl:for-each select="old:classPath/old:entries/old:Item">
                  <url><xsl:copy-of select="@*"/></url>
                </xsl:for-each>
              </list>
              <value n="description" v="{old:name}"/>
              <list n="docPath">
                <xsl:for-each select="old:docPath/old:entries/old:Item">
                  <url><xsl:copy-of select="@*"/></url>
                </xsl:for-each>
              </list>
              <value n="id" v="{old:name}"/>
              <url n="javaExecutable"><xsl:copy-of select="old:javaExecutable/@*"/></url>
              <url n="sdkBinDir"><xsl:copy-of select="old:SDKBinDir/@*"/></url>
              <list n="sourcePath">
                <xsl:for-each select="old:sourcePath/old:entries/old:Item">
                  <url><xsl:copy-of select="@*"/></url>
                </xsl:for-each>
              </list>
              <value n="version" v="{old:javaVersion}"/>
            </hash>
          </xsl:for-each>
        </list>
        <list n="libraryDefinitions">
          <xsl:for-each select="../../../../../../../old:projectLibraryList/old:libraryList/old:Item">
            <hash>
              <list n="classPath">
                <xsl:for-each select="old:defaultLibraryDefinition/old:classPath/old:entries/old:Item">
                  <url><xsl:copy-of select="@*"/></url>
                </xsl:for-each>
              </list>
              <value n="deployedByDefault" v="{@deployedByDefault}"/>
              <value n="description" v="{old:name}"/>
              <list n="docPath">
                <xsl:for-each select="old:defaultLibraryDefinition/old:docPath/old:entries/old:Item">
                  <url><xsl:copy-of select="@*"/></url>
                </xsl:for-each>
              </list>
              <value n="id" v="{old:name}"/>
              <list n="sourcePath">
                <xsl:for-each select="old:defaultLibraryDefinition/old:sourcePath/old:entries/old:Item">
                  <url><xsl:copy-of select="@*"/></url>
                </xsl:for-each>
              </list>
            </hash>
          </xsl:for-each>
          <xsl:if test="$additionalClassPathItems">
            <hash>
              <list n="classPath">
                <xsl:for-each select="$additionalClassPathItems">
                  <url><xsl:copy-of select="@*"/></url>
                </xsl:for-each>
              </list>
              <value n="deployedByDefault" v="true"/>
              <value n="description" v="Additional Classpath"/>
              <value n="id" v="Additional Classpath"/>
            </hash>
          </xsl:if>
        </list>
      </hash>
      <xsl:if test="old:jdkName">
        <xsl:if test="old:jdkVersionNumber">
          <hash n="jdkReference">
            <value n="id" v="{old:jdkName}"/>
            <value n="isJDK" v="true"/>
            <value n="jdkVersion" v="{old:jdkVersionNumber}"/>
          </hash>
        </xsl:if>
      </xsl:if>
      <list n="libraryReferences">
        <xsl:if test="$additionalClassPathItems">
          <hash>
            <value n="id" v="Additional Classpath"/>
            <value n="isJDK" v="false"/>
          </hash>
        </xsl:if>
        <xsl:call-template name="convert-library-list">
          <xsl:with-param name="str"><xsl:value-of select="old:libraries"/></xsl:with-param>
        </xsl:call-template>
      </list>
    </hash>
  </xsl:template>

  <xsl:template mode="JProjectPaths" match="old:Value">
    <hash n="oracle.jdevimpl.config.JProjectPaths">
      <url n="outputDirectory"><xsl:copy-of select="old:outputDirectory/@*"/></url>
    </hash>
  </xsl:template>

  <xsl:template mode="XSLTConfiguration" match="old:Value">
    <xsl:variable name="hash-rtf">  <!-- 3958125 -->
      <hash n="oracle.jdevimpl.runner.xslt.XSLTConfiguration">
        <xsl:if test="old:inputFileURL/@*">
          <url n="inputFileURL"><xsl:copy-of select="old:inputFileURL/@*"/></url>
        </xsl:if>
        <xsl:if test="old:outputFileURL/@*">
          <url n="outputFileURL"><xsl:copy-of select="old:outputFileURL/@*"/></url>
        </xsl:if>
        <xsl:if test="old:showInputFile and string(old:showInputFile) != 'true'"> <!-- default is true -->
          <value n="showInputFile" v="{old:showInputFile}"/>
        </xsl:if>
        <xsl:if test="old:showOutputFile and string(old:showOutputFile) != 'true'"> <!-- default is true -->
          <value n="showOutputFile" v="{old:showOutputFile}"/>
        </xsl:if>
        <xsl:if test="old:sourcePath/old:entries/old:Item">
          <list n="sourcePath">
            <xsl:for-each select="old:sourcePath/old:entries/old:Item">
              <url><xsl:copy-of select="@*"/></url>
            </xsl:for-each>
          </list>
        </xsl:if>
      </hash>
    </xsl:variable>
    <xsl:if test="ora:node-set($hash-rtf)/hash/*">
      <xsl:copy-of select="$hash-rtf"/>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="SqljConfiguration" match="old:Value">
    <xsl:variable name="hash-rtf">  <!-- 3958125 -->
      <hash n="oracle.jdevimpl.sqlj.config.SqljConfiguration">
        <!--<value n="additionalParameters" v="{old:additionalParameters}"/> <!- not used when invoking SQLJ translator -->
        <xsl:if test="old:checkSemantics and string(old:checkSemantics) != 'false'"> <!-- default is false -->
          <value n="checkSemantics" v="{old:checkSemantics}"/>
        </xsl:if>
        <xsl:if test="old:codegen and string(old:codegen) != 'oracle'"> <!-- default is "oracle" -->
          <value n="codegen" v="{old:codegen}"/>
        </xsl:if>
        <xsl:if test="old:contextConnectionMap/old:Item"> <!-- default is empty -->
          <hash n="contextConnectionMap">
            <xsl:for-each select="old:contextConnectionMap/old:Item">
              <value n="{old:Key}" v="{old:Value}"/>
            </xsl:for-each>
          </hash>
        </xsl:if>
        <xsl:if test="old:contextName and string(old:contextName) != '&lt;none>' and string(old:contextName) != '&lt;&#x306A;&#x3057;>'"> <!-- default is "<none>", the Japanese transation of "<none>" ("<\u306A\u3057>") or null -->
          <value n="contextName" v="{old:contextName}"/>
        </xsl:if>
        <xsl:if test="old:useCache and string(old:useCache) != 'false'"> <!-- default is false -->
          <value n="useCache" v="{old:useCache}"/>
        </xsl:if>
        <xsl:if test="old:warnAll and string(old:warnAll) != 'false'"> <!-- default is false -->
          <value n="warnAll" v="{old:warnAll}"/>
        </xsl:if>
        <xsl:if test="old:warnNull and string(old:warnNull) != 'false'"> <!-- default is false -->
          <value n="warnNull" v="{old:warnNull}"/>
        </xsl:if>
        <xsl:if test="old:warnPortable and string(old:warnPortable) != 'false'"> <!-- default is false -->
          <value n="warnPortable" v="{old:warnPortable}"/>
        </xsl:if>
        <xsl:if test="old:warnPrecision and string(old:warnPrecision) != 'false'"> <!-- default is false -->
          <value n="warnPrecision" v="{old:warnPrecision}"/>
        </xsl:if>
        <xsl:if test="old:warnStrict and string(old:warnStrict) != 'false'"> <!-- default is false -->
          <value n="warnStrict" v="{old:warnStrict}"/>
        </xsl:if>
        <xsl:if test="old:warnVerbose and string(old:warnVerbose) != 'false'"> <!-- default is false -->
          <value n="warnVerbose" v="{old:warnVerbose}"/>
        </xsl:if>
      </hash>
    </xsl:variable>
    <xsl:if test="ora:node-set($hash-rtf)/hash/*">
      <xsl:copy-of select="$hash-rtf"/>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="ownerMap" match="old:ownerMap">
    <list n="ownerMap">
      <xsl:for-each select="old:Item">
        <hash>
          <xsl:choose>
            <xsl:when test="old:Key/@class='oracle.ide.model.Reference'">
              <value n="nodeClass" v="{old:Key/old:nodeClass}"/>
              <url n="nodeURL"><xsl:copy-of select="old:Key/old:URL/@*"/></url>
            </xsl:when>
            <xsl:otherwise>
              <!-- legacy case where Key was an URL instead of Reference. -->
              <url n="nodeURL"><xsl:copy-of select="old:Key/@*[not(name()='class')]"/></url>
            </xsl:otherwise>
          </xsl:choose>
          <value n="ownerClass" v="{old:Value/old:nodeClass}"/>
          <url n="ownerURL"><xsl:copy-of select="old:Value/old:URL/@*"/></url>
        </hash>
      </xsl:for-each>
    </list>
  </xsl:template>

  <xsl:template mode="WebappJspCompilerOptions" match="old:Value">
    <xsl:variable name="hash-rtf">  <!-- 3958125 -->
      <hash n="WebappJspCompilerOptions">
        <xsl:if test="old:forgiveDuplicateDirectiveAttributes and string(old:forgiveDuplicateDirectiveAttributes) != 'false'"> <!-- default is false -->
          <value n="forgiveDuplicateDirectiveAttributes" v="{old:forgiveDuplicateDirectiveAttributes}"/>
        </xsl:if>
        <xsl:if test="old:requestTimeIntrospection and string(old:requestTimeIntrospection) != 'false'"> <!-- default is false -->
          <value n="requestTimeIntrospection" v="{old:requestTimeIntrospection}"/>
        </xsl:if>
        <!--<xsl:if test="old:validate">-->  <!-- no longer used in 10.1.3 -->
        <!--  <value n="validate" v="{old:validate}"/>-->
        <!--</xsl:if>-->
        <!--<xsl:if test="old:validateTLD">-->  <!-- no longer used in 10.1.3 -->
        <!--  <value n="validateTLD" v="{old:validateTLD}"/>-->
        <!--</xsl:if>-->
      </hash>
    </xsl:variable>
    <xsl:if test="ora:node-set($hash-rtf)/hash/*">
      <xsl:copy-of select="$hash-rtf"/>
    </xsl:if>
  </xsl:template>

  <!-- Other properties are assumed to be String key and String value. -->
  <xsl:template mode="tpo-properties" match="old:Item">
    <value n="{old:Key}" v="{old:Value}"/>
  </xsl:template>
  <!-- 4016206 -->
  <xsl:template mode="tpo-properties" match="old:Item[old:Key='WEB_SERVICE_JAVA_PROXY_MAPPINGS']">
    <hash n="{old:Key}">
      <xsl:for-each select="old:Value/old:Item">
        <list n="{translate(string(old:Key),'/','\')}">
          <xsl:for-each select="old:Value/old:Item">
            <xsl:choose>
              <xsl:when test="@class='java.net.URL'">
                <url><xsl:copy-of select="@*"/></url>
              </xsl:when>
              <xsl:when test="@class='java.lang.String'">
                <string v="{string(.)}"/>
              </xsl:when>
              <xsl:when test="@class='java.lang.Integer'">
                <int v="{string(.)}"/>
              </xsl:when>
              <xsl:when test="@class='java.lang.Boolean'">
                <boolean v="{string(.)}"/>
              </xsl:when>
              <xsl:when test="not(@class)">
                <null/>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </list>
      </xsl:for-each>
    </hash>
  </xsl:template>

  <!-- PCBPEL properties -->
  <xsl:template mode="pcbpel-properties" match="old:Item">
    <value n="{old:Key}" v="{old:Value}"/>
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
      <xsl:apply-templates mode="resolve-idref" select="@*|node()[not(local-name(.)='project')]"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="convert-library-list">
    <xsl:param name="str"/>
    <xsl:if test="string($str)">
      <xsl:variable name="car" select="substring-before($str,';')"/>
      <xsl:variable name="cdr" select="substring-after($str,';')"/>
      <xsl:if test="not($car) and not($cdr)">
        <hash>
          <value n="id" v="{$str}"/>
          <value n="isJDK" v="false"/>
        </hash>
      </xsl:if>
      <xsl:if test="$car">
        <hash>
          <value n="id" v="{$car}"/>
          <value n="isJDK" v="false"/>
        </hash>
      </xsl:if>
      <xsl:if test="$cdr">
        <xsl:call-template name="convert-library-list">
          <xsl:with-param name="str"><xsl:value-of select="$cdr"/></xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
