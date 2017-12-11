<?xml version='1.0' encoding='UTF-8'?>

<!DOCTYPE xsl:stylesheet [
<!ENTITY oldns 'http://xmlns.oracle.com/jdeveloper/905/deploy/'>
<!ENTITY newns 'http://xmlns.oracle.com/jdeveloper/9051/deploy/'>
]>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ora="http://www.oracle.com/XSL/Transform/java"
                xmlns:data="urn:data"
                xmlns:oldjar="&oldns;jar"
                xmlns:oldsp="&oldns;stored-proc"
                xmlns:oldear="&oldns;j2ee-ear"
                xmlns:oldejb="&oldns;j2ee-ejb-jar"
                xmlns:oldwar="&oldns;j2ee-war"
                xmlns:oldcar="&oldns;j2ee-client-jar"
                xmlns:oldtld="&oldns;j2ee-taglib"
                exclude-result-prefixes="data oldjar oldsp oldear oldejb oldwar oldcar oldtld ora">
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
  <xsl:template match="*" name="copy">
    <xsl:element name="{name()}" namespace="{$newuri}">
      <xsl:apply-templates select="node()|@*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="emit-fileGroups">
    <fileGroups>
      <groups>
        <Item class="oracle.jdeveloper.deploy.common.ProjectFileGroup" internalName="legacy">
          <contributors>
            <xsl:apply-templates select="../*[local-name()='selectedProjectFiles']/*"/>
          </contributors>
          <displayName/>
          <filters>
            <xsl:apply-templates select="../*[local-name()='cdaSettings']/*"/>
          </filters>
          <targetWithinJar/>
        </Item>
        <Item class="oracle.jdeveloper.deploy.common.PackagingFileGroup" internalName="legacy-project-deps">
          <contributors>
            <Item type="7"/>
          </contributors>
          <displayName/>
          <filters>
            <rules>
              <Item type="1" pattern="connections.xml"/>
              <Item type="1" pattern="**/CVS/"/>
              <Item type="1" pattern="**.cdi"/>
              <Item type="1" pattern="**.contrib"/>
              <Item type="1" pattern="**.keep"/>
              <Item type="1" pattern="**.rvi"/>
              <Item type="1" pattern=".jsps/"/>
              <Item type="0" pattern="**"/>
            </rules>
          </filters>
          <targetWithinJar/>
        </Item>
      </groups>
    </fileGroups>
  </xsl:template>

  <!--
   |  Migrate simple archive deployment profile.
   +-->
  <xsl:template match="oldjar:cdaSettings">
    <xsl:call-template name="emit-fileGroups"/>
  </xsl:template>
  <xsl:template match="oldjar:selectedProjectFiles"/>

  <!--
   |  Migrate tag library deployment profile.
   +-->
  <xsl:template match="oldtld:cdaSettings">
    <xsl:call-template name="emit-fileGroups"/>
  </xsl:template>
  <xsl:template match="oldtld:selectedProjectFiles"/>

  <!--
   |  Migrate Client JAR deployment profile.
   +-->
  <xsl:template match="oldcar:enterpriseAppName">
    <xsl:call-template name="copy"/>
    <xsl:call-template name="emit-fileGroups"/>
  </xsl:template>
  <xsl:template match="oldcar:cdaSettings"/>
  <xsl:template match="oldcar:selectedProjectFiles"/>

  <!--
   |  Migrate EJB JAR deployment profile.
   +-->
  <xsl:template match="oldejb:enterpriseAppName">
    <xsl:call-template name="copy"/>
    <xsl:call-template name="emit-fileGroups"/>
  </xsl:template>
  <xsl:template match="oldejb:cdaSettings"/>
  <xsl:template match="oldejb:selectedProjectFiles"/>

  <!--
   |  Migrate Loadjava and Java Stored Procedures deployment profile.
   +-->
  <xsl:template match="oldsp:defaultConnection">
    <xsl:call-template name="copy"/>
    <xsl:call-template name="emit-fileGroups"/>
  </xsl:template>
  <xsl:template match="oldsp:cdaSettings"/>
  <xsl:template match="oldsp:selectedProjectFiles"/>

  <!--
   |  Migrate EAR deployment profile.
   +-->
  <xsl:template match="oldear:enterpriseAppName">
    <xsl:call-template name="copy"/>
    <fileGroups>
      <groups/>
    </fileGroups>
  </xsl:template>
  <xsl:template match="oldear:cdaSettings"/>
  <xsl:template match="oldear:selectedProjectFiles"/>

  <!--
   |  Migrate WAR deployment profile.
   +-->
  <xsl:key name="uniqueJarPath" match="/oldwar:web-app-deployment/oldwar:cdaSettings/oldwar:selectedArchives/oldwar:archives/oldwar:Item" use="@path"/>
  <xsl:template match="oldwar:enterpriseAppName">
    <xsl:call-template name="copy"/>
    <fileGroups>
      <groups>
        <Item class="oracle.jdeveloper.deploy.common.PackagingFileGroup" internalName="web-files">
          <contributors>
            <Item type="5"/>
          </contributors>
          <displayName>HTML</displayName>
          <filters>
            <rules>
              <xsl:variable name="old-rules" select="../oldwar:webSelectionRules/oldwar:rules/oldwar:Item"/>
              <xsl:choose>
                <xsl:when test="$old-rules">
                  <xsl:for-each select="$old-rules">
                    <Item type="{oldwar:type}" pattern="{oldwar:pattern}"/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <Item type="1" pattern="**/CVS/"/>
                  <Item type="1" pattern="**.cdi"/>
                  <Item type="1" pattern="**.contrib"/>
                  <Item type="1" pattern="**.keep"/>
                  <Item type="1" pattern="**.rvi"/>
                  <Item type="1" pattern=".jsps/"/>
                  <Item type="0" pattern="**"/>
                </xsl:otherwise>
              </xsl:choose>
            </rules>
          </filters>
          <targetWithinJar/>
        </Item>
        <Item class="oracle.jdeveloper.deploy.common.ProjectFileGroup" internalName="legacy">
          <contributors>
            <xsl:apply-templates select="../oldwar:javaFiles/*"/>
          </contributors>
          <displayName>WEB-INF/classes</displayName>
          <filters>
            <additionalArchives/>
            <afterFilters/>
            <beforeFilters/>
            <duringFilters/>
            <selectedArchives>
              <archives/>
              <selectionMode>0</selectionMode>
            </selectedArchives>
          </filters>
          <targetWithinJar>WEB-INF/classes</targetWithinJar>
        </Item>
        <Item class="oracle.jdeveloper.deploy.common.PackagingFileGroup" internalName="legacy-project-deps">
          <contributors>
            <Item type="7"/>
          </contributors>
          <displayName/>
          <filters>
            <rules>
              <Item type="1" pattern="connections.xml"/>
              <Item type="1" pattern="**/CVS/"/>
              <Item type="1" pattern="**.cdi"/>
              <Item type="1" pattern="**.contrib"/>
              <Item type="1" pattern="**.keep"/>
              <Item type="1" pattern="**.rvi"/>
              <Item type="1" pattern=".jsps/"/>
              <Item type="0" pattern="**"/>
            </rules>
          </filters>
          <targetWithinJar>WEB-INF/classes</targetWithinJar>
        </Item>
        <Item class="oracle.jdeveloper.deploy.common.LibraryFileGroup" internalName="libraries">
          <displayName>WEB-INF/lib</displayName>
          <xsl:variable name="jars" select="../oldwar:cdaSettings/oldwar:selectedArchives/oldwar:archives/oldwar:Item[generate-id(.)=generate-id(key('uniqueJarPath',@path))]"/>
          <xsl:call-template name="emitFiltersAndSelectedLibraries">
            <xsl:with-param name="jars" select="$jars"/>
          </xsl:call-template>
          <selectionMode>0</selectionMode>
          <targetWithinJar>WEB-INF/lib</targetWithinJar>
        </Item>
      </groups>
    </fileGroups>
    <jarURL>
      <xsl:copy-of select="../oldwar:warURL/@*"/>
    </jarURL>
  </xsl:template>
  <xsl:template match="/oldwar:web-app-deployment/oldwar:cdaSettings/oldwar:selectedArchives/oldwar:selectionMode">
    <selectionMode>1</selectionMode>
  </xsl:template>
  <xsl:template match="oldwar:cdaSettings"/>
  <xsl:template match="oldwar:javaFiles"/>
  <xsl:template match="oldwar:warURL"/>
  <xsl:template match="oldwar:webSelectionRules"/>
  <xsl:template name="getFileName">
    <xsl:param name="path"/>
    <xsl:choose>
      <xsl:when test="contains($path,'/')">
        <xsl:call-template name="getFileName">
          <xsl:with-param name="path" select="substring-after($path,'/')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$path"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="endsWithSlashOrEmpty">
    <xsl:param name="path"/>
    <xsl:choose>
      <xsl:when test="not(boolean($path))">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="contains($path,'/')">
        <xsl:call-template name="endsWithSlashOrEmpty">
          <xsl:with-param name="path" select="substring-after($path,'/')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Given a list of the jars that are in the profile, map them
       to a list of library names. -->
  <xsl:template name="emitFiltersAndSelectedLibraries">
    <xsl:param name="jars"/>
    <!-- First match the paths in the profile with the endings in the table -->
    <xsl:variable name="rtf-jarmatches-with-dups">
      <xsl:for-each select="$jars">
        <xsl:variable name="jarpath" select="@path"/>
        <!-- In XPath 2.0, this can be replaced with a single call to the ends-with($jarpath,@path) function. -->
        <xsl:for-each select="$jar2lib[contains($jarpath,@path) and not(substring-after($jarpath,@path))]">
          <xsl:variable name="isEnding">
            <xsl:call-template name="endsWithSlashOrEmpty">
              <xsl:with-param name="path" select="substring-before($jarpath,@path)"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$isEnding">
            <xsl:variable name="matchingpath">
              <xsl:choose>
                <xsl:when test="@newpath"><xsl:value-of select="@newpath"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="@path"/></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="curlib" select="@lib"/>
            <jarmatch path="{$jarpath}" matchingpath="{$matchingpath}" lib="{$curlib}"/>
            <xsl:for-each select="data:plus">
              <!-- auto-select additional jars that were introduced because
                   an older jar was split into multiple jars -->
              <jarmatch path="{$jarpath}" matchingpath="{@path}" lib="{$curlib}"/>
            </xsl:for-each>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="jarmatches-with-dups" select="ora:node-set($rtf-jarmatches-with-dups)"/>
    <xsl:variable name="rtf-jarmatches">
      <xsl:for-each select="$jarmatches-with-dups/jarmatch">
        <xsl:if test="not(preceding-sibling::*[@lib=current()/@lib and @matchingpath=current()/@matchingpath])">
          <xsl:copy-of select="."/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="jarmatches" select="ora:node-set($rtf-jarmatches)"/>

    <!-- For each jar matched, find the single library that is the most
         likely selection. -->
    <xsl:variable name="rtf-libs">
      <xsl:for-each select="$jarmatches/jarmatch">
        <xsl:variable name="libmatches" select="$jarmatches/jarmatch[@path=current()/@path]"/>
        <xsl:choose>
          <xsl:when test="count($libmatches) = 0"/>
          <xsl:when test="count($libmatches) = 1">
            <!-- Easy case: the jar only maps to one lib. -->
            <lib lib="{$libmatches/@lib}"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Tougher case: The jar maps to multiple libs.  To resolve
                 the ambiguity, select the lib that is 'most selected'
                 among all the possibilities.  That is, choose the lib that
                 has the highest percentage of its jars selected in the
                 deployment profile.  If there is a tie, the <jar2lib> table
                 is used to break the tie (libs are ordered there according
                 to likelihood of selection).  There is a special case if the
                 tie occurs for libraries that all have 100% selection; in
                 this case, no contender is singled out, and all the 100%
                 libs are selected in the migrated profile. -->
            <xsl:variable name="rtf-percentages">
              <xsl:for-each select="$libmatches">
                <xsl:variable name="curlib" select="current()/@lib"/>
                <xsl:variable name="numjarmatches" select="$jarmatches/jarmatch[@lib=$curlib]"/>
                <xsl:variable name="totaljars" select="$jar2lib[@lib=$curlib and contains(@ver,'9051')]"/>
                <xsl:variable name="percentage" select="count($numjarmatches) div count($totaljars)"/>
                <xsl:variable name="libs"><xsl:for-each select="$numjarmatches"><xsl:value-of select="@path"/></xsl:for-each></xsl:variable>
                <libmatch lib="{@lib}" percentage="{count($numjarmatches) div count($totaljars)}" libs="{$libs}"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="percentages" select="ora:node-set($rtf-percentages)"/>
            <xsl:variable name="maxpercentage">
              <xsl:for-each select="$percentages/libmatch/@percentage">
                <xsl:sort data-type="number" order="descending"/>
                <xsl:if test="position() = 1">
                  <xsl:value-of select="number(current())"/>
                </xsl:if>
              </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="libWithMaxPercentage" select="$percentages/libmatch[@percentage=$maxpercentage]"/>
            <xsl:choose>
              <!-- If multiple libraries had 100% selection, select them all. -->
              <xsl:when test="$maxpercentage >= 1">
                <xsl:for-each select="$libWithMaxPercentage">
                  <lib lib="{@lib}" percentage="{$maxpercentage}" libs="{@libs}"/>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="$libWithMaxPercentage">
                  <lib lib="{$libWithMaxPercentage[1]/@lib}" percentage="{$maxpercentage}" libs="{$libWithMaxPercentage[1]/@libs}"/>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="libs" select="ora:node-set($rtf-libs)"/>

    <!-- emit filters -->
    <filters>
      <rules>
        <xsl:variable name="rtf-filenames">
          <xsl:for-each select="$libs/lib">
            <!-- for each library, emit an exclude rule for jars that were
                 not selected in the old profile -->
            <xsl:if test="not(preceding-sibling::*[@lib=current()/@lib])">
              <xsl:variable name="curlib" select="."/>
              <xsl:for-each select="$jar2lib[@lib=$curlib/@lib]">
                <!-- add exclude filter for each 9050 library entry that isn't
                     selected, after adjusting for jar names or locations that
                     have changed through the versions -->
                <xsl:variable name="selectionsWithMatchingPath" select="$jarmatches/jarmatch[@matchingpath=current()/@path]"/>
                <xsl:choose>
                  <xsl:when test="contains(@ver,'9051')">
                    <xsl:if test="not($selectionsWithMatchingPath)">
                      <xsl:variable name="filename">
                        <xsl:choose>
                          <xsl:when test="@newfile">
                            <xsl:value-of select="@newfile"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:call-template name="getFileName">
                              <xsl:with-param name="path" select="@path"/>
                            </xsl:call-template>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>
                      <file name="{$filename}"/>
                    </xsl:if>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
            </xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="filenames" select="ora:node-set($rtf-filenames)"/>
        <xsl:for-each select="$filenames/file">
          <xsl:sort select="@name" order="ascending"/>
          <xsl:if test="not(preceding-sibling::*[@name=current()/@name])">
            <Item type="1" pattern="{@name}"/>
          </xsl:if>
        </xsl:for-each>
        <Item type="0" pattern="**"/>
      </rules>
    </filters>

    <!-- emit selected libraries -->
    <selectedLibraries>
      <!-- Strip out duplicates and emit result tree fragment. -->
      <xsl:for-each select="$libs/lib">
        <xsl:if test="not(preceding-sibling::*[@lib=current()/@lib])">
          <!--<Item percentage="{@percentage}" libs="{@libs}"><xsl:value-of select="@lib"/></Item>-->
          <Item><xsl:value-of select="@lib"/></Item>
        </xsl:if>
      </xsl:for-each>
    </selectedLibraries>

  </xsl:template>

  <!--
   |  Table lookup to map JAR paths to library names in 9051.
   +-->
  <xsl:variable name="jar2lib" select="document('')/xsl:stylesheet/data:jar2lib/data:jarmap"/>
  <jar2lib xmlns="urn:data">
    <jarmap path="BC4J/jlib/adfmejb.jar" lib="ADF EJB Runtime" ver="9050,9051"/>
    <jarmap path="BC4J/jlib/adfmtl.jar" lib="ADF Model Generic Runtime" ver="9050,9051"/>
    <!-- adfmtl.jar is not in any pre-9051 libraries.xml -->
    <!--<jarmap path="BC4J/jlib/adfmtl.jar" lib="ADF Toplink Runtime" ver="9051"/>-->
    <jarmap path="BC4J/jlib/bc4jctvb.jar" lib="BC4J VB Client" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/jlib/bc4jctvb.jar" lib="BC4J VB Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/jlib/bc4jdatum.jar" lib="BC4J Oracle Domains" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/jlib/bc4jdomgnrc.jar" lib="BC4J Generic Domains" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/jlib/bc4jimjui.jar" lib="Oracle Intermedia JClient" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/jlib/bc4jmtvb.jar" lib="BC4J VB Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/jlib/bc4jstruts.jar" lib="BC4J Struts Runtime" ver="903,904,9050,9051"/>
    <jarmap path="BC4J/jlib/bc4jtester.jar" lib="BC4J Tester" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/jlib/bc4jui.jar" lib="JClient Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/jlib/bc4juixtags.jar" lib="BC4J HTML" ver="9050,9051"/>
    <jarmap path="BC4J/jlib/dacf.zip" lib="InfoBus DAC" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/jlib/datatags.jar" lib="BC4J HTML" ver="9051"/>
    <jarmap path="BC4J/jlib/graphtags.jar" lib="BC4J HTML" ver="9050,9051"/>
    <jarmap path="BC4J/lib/adfm.jar" lib="ADF Model Generic Runtime" ver="9050,9051"/>
    <jarmap path="BC4J/lib/adfm.jar" lib="ADF Model Runtime" ver="9050,9051"/>
    <jarmap path="BC4J/lib/adfm.jar" lib="JClient Runtime" ver="9050,9051"/>
    <!-- bc4j_jclient_common.jar is not in the 9051 libraries.xml -->
    <!--<jarmap path="BC4J/lib/bc4j_jclient_common.jar" lib="BC4J HTML" ver="903,904,9050"/>-->
    <!--<jarmap path="BC4J/lib/bc4j_jclient_common.jar" lib="JClient Runtime" ver="9050"/>-->
    <jarmap path="BC4J/lib/bc4jct.jar" lib="BC4J Client" ver="9050,9051"/>
    <jarmap path="BC4J/lib/bc4jct.jar" lib="BC4J EJB Client" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/bc4jct.jar" lib="BC4J Oracle9iAS Client" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/bc4jct.jar" lib="BC4J Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/bc4jct.jar" lib="BC4J VB Client" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/bc4jct.jar" lib="BC4J VB Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/bc4jctejb.jar" lib="BC4J EJB Client" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/bc4jctejb.jar" lib="BC4J Oracle9iAS Client" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/bc4jdomorcl.jar" lib="BC4J Oracle Domains" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/bc4jhtml.jar" lib="BC4J HTML" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/bc4jimdomains.jar" lib="Oracle Intermedia JClient" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/bc4jimdomains.jar" lib="Oracle Intermedia" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/bc4jmt.jar" lib="BC4J Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/bc4jmtejb.jar" lib="BC4J EJB Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/bc4juixtags.jar" newpath="BC4J/jlib/bc4juixtags.jar" lib="BC4J HTML" ver="902,903,904"/>
    <jarmap path="BC4J/lib/collections.jar" lib="ADF Model Generic Runtime" ver="9050,9051"/>
    <jarmap path="BC4J/lib/collections.jar" lib="ADF Model Runtime" ver="9050,9051"/>
    <jarmap path="BC4J/lib/collections.jar" lib="BC4J Client" ver="9050,9051"/>
    <jarmap path="BC4J/lib/collections.jar" lib="BC4J EJB Client" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/collections.jar" lib="BC4J Oracle9iAS Client" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/collections.jar" lib="BC4J Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/collections.jar" lib="BC4J VB Client" ver="902,903,904,9050,9051"/>
    <jarmap path="BC4J/lib/datatags.jar" newpath="BC4J/jlib/datatags.jar" lib="BC4J HTML" ver="902,903,904,9050"/>
    <jarmap path="BC4J/lib/uixtags.jar" newpath="BC4J/jlib/bc4juixtags.jar" lib="BC4J HTML" ver="902"/>
    <!-- The OnlineOrdersModule9iAS[Client] libraries are not in the 9051 libraries.xml -->
    <!--<jarmap path="BC4J/samples/OnlineOrdersForClients/OnlineOrdersBeanManagedCl/classes/" lib="OnlineOrdersModule9iASClient" ver="902"/>-->
    <!--<jarmap path="BC4J/samples/OnlineOrdersForClients/classes/OnlineOrdersEjbCommon.jar" lib="OnlineOrdersModule9iAS" ver="902"/>-->
    <jarmap path="adfc/lib/adf-controller.jar" lib="ADF Controller Runtime" ver="9050,9051"/>
    <jarmap path="ds/uddi/lib/uddiclient.jar" newpath="uddi/lib/uddiclient.jar" lib="Oracle UDDI" ver="903,9050"/>
    <!-- f90all.jar is not in the 9051 libraries.xml -->
    <!--<jarmap path="forms90/java/f90all.jar" lib="Oracle Forms" ver="902,903,9050"/>-->
    <jarmap path="ide/lib/ide.jar" lib="JDeveloper Extension SDK" ver="9050,9051"/>
    <jarmap path="ide/lib/ide.jar" lib="JDeveloper VCS Extension SDK" oldlib="JDeveloper SCM API" ver="9051"/>
    <jarmap path="ide/lib/javatools.jar" lib="JDeveloper Extension SDK" ver="9050,9051"/>
    <jarmap path="ide/lib/javatools.jar" lib="JDeveloper VCS Extension SDK" oldlib="JDeveloper SCM API" ver="9051"/>
    <jarmap path="infobus/lib/infobus.jar" lib="InfoBus DAC" ver="902,903,904,9050,9051"/>
    <jarmap path="j2ee/home/ejb.jar" newpath="j2ee/home/lib/ejb.jar" lib="BC4J EJB Client" ver="902"/>
    <jarmap path="j2ee/home/ejb.jar" newpath="j2ee/home/lib/ejb.jar" lib="BC4J EJB Runtime" ver="902"/>
    <jarmap path="j2ee/home/ejb.jar" newpath="j2ee/home/lib/ejb.jar" lib="BC4J Oracle9iAS Client" ver="902"/>
    <jarmap path="j2ee/home/ejb.jar" newpath="j2ee/home/lib/ejb.jar" lib="J2EE" ver="902"/>
    <jarmap path="j2ee/home/jaas.jar" newpath="j2ee/home/lib/jaas.jar" lib="BC4J Oracle9iAS Client" ver="902"/>
    <jarmap path="j2ee/home/jaas.jar" newpath="j2ee/home/lib/jaas.jar" lib="J2EE" ver="902"/>
    <jarmap path="j2ee/home/jaxp.jar" newpath="j2ee/home/lib/jaxp.jar" lib="J2EE" ver="902"/>
    <jarmap path="j2ee/home/jazn.jar" lib="BC4J Security" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/jazncore.jar" lib="BC4J Security" ver="9050,9051"/>
    <jarmap path="j2ee/home/jdbc.jar" newpath="j2ee/home/lib/jdbc.jar" lib="J2EE" ver="902"/>
    <jarmap path="j2ee/home/jsp/lib/taglib/ojsputil.jar" lib="JSP Runtime" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/jsse.jar" newpath="j2ee/home/lib/jsse.jar" lib="J2EE" ver="902"/>
    <jarmap path="j2ee/home/lib/activation.jar" lib="J2EE" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/activation.jar" lib="Oracle SOAP" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/aqapi.jar" newpath="rdbms/jlib/aqapi.jar" lib="AQJMS" ver="903"/>
    <jarmap path="j2ee/home/lib/aqapi.jar" newpath="rdbms/jlib/aqapi.jar" lib="EBI Messaging Adapters" ver="903"/>
    <jarmap path="j2ee/home/lib/ejb.jar" lib="BC4J EJB Client" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/ejb.jar" lib="BC4J EJB Runtime" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/ejb.jar" lib="BC4J Oracle9iAS Client" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/ejb.jar" lib="J2EE" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/http_client.jar" lib="Oracle SOAP" ver="902,903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jaas.jar" lib="BC4J Oracle9iAS Client" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jaas.jar" lib="J2EE" ver="903,904,9050,9051"/>
    <!-- javax77.jar is not in the 9051 libraries.xml -->
    <!--<jarmap path="j2ee/home/lib/javax77.jar" lib="BC4J Oracle9iAS Client" ver="904"/>-->
    <jarmap path="j2ee/home/lib/jaxp.jar" lib="J2EE" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jcert.jar" lib="J2EE" ver="904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jdbc.jar" lib="J2EE" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jms.jar" lib="AQJMS" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jms.jar" lib="BC4J Oracle9iAS Client" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jms.jar" lib="EBI Messaging Adapters" ver="903,904,9051"/>
    <jarmap path="j2ee/home/lib/jms.jar" lib="J2EE" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jndi.jar" lib="BC4J Client" ver="9050,9051"/>
    <jarmap path="j2ee/home/lib/jndi.jar" lib="BC4J EJB Client" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jndi.jar" lib="BC4J EJB Runtime" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jndi.jar" lib="BC4J Oracle9iAS Client" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jndi.jar" lib="BC4J Runtime" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jndi.jar" lib="BC4J VB Client" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jndi.jar" lib="J2EE" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jnet.jar" lib="J2EE" ver="904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jsse.jar" lib="J2EE" ver="904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jta.jar" lib="AQJMS" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jta.jar" lib="BC4J Oracle9iAS Client" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/jta.jar" lib="J2EE" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/mail.jar" lib="J2EE" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/mail.jar" lib="Oracle SOAP" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/ojsp.jar" lib="JSP Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/ojsputil.jar" newpath="j2ee/home/jsp/lib/taglib/ojsputil.jar" lib="JSP Runtime" ver="902"/>
    <jarmap path="j2ee/home/lib/servlet.jar" lib="J2EE" ver="904,9050,9051"/>
    <jarmap path="j2ee/home/lib/servlet.jar" lib="JSP Runtime" oldver="902" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/servlet.jar" lib="Servlet Runtime" oldver="902" ver="903,904,9050,9051"/>
    <jarmap path="j2ee/home/lib/translator.jar" newpath="sqlj/lib/translator.jar" lib="JServer" ver="9050"/>
    <jarmap path="j2ee/home/oc4j.jar" lib="JSP Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="j2ee/home/oc4j.jar" lib="Oracle9 iAS" ver="902,903,904,9050,9051"/>
    <jarmap path="j2ee/home/oc4j.jar" lib="Servlet Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="j2ee/home/oc4jclient.jar" lib="BC4J Oracle9iAS Client" ver="902,903,904,9050,9051"/>
    <jarmap path="jakarta-commons-el/commons-el.jar" lib="ADF Controller Runtime" ver="9050,9051"/>
    <jarmap path="jakarta-commons-el/commons-el.jar" lib="ADF UIX Runtime" ver="9050,9051"/>
    <jarmap path="jakarta-commons-el/jsp-el-api.jar" lib="ADF Controller Runtime" ver="9050,9051"/>
    <jarmap path="jakarta-commons-el/jsp-el-api.jar" lib="ADF UIX Runtime" ver="9050,9051"/>
    <jarmap path="jakarta-commons-el/oracle-el.jar" lib="ADF Controller Runtime" ver="9050,9051"/>
    <jarmap path="jakarta-commons-el/oracle-el.jar" lib="ADF UIX Runtime" ver="9050,9051"/>
    <jarmap path="jakarta-struts/lib/commons-beanutils.jar" lib="Struts Runtime" ver="904,9050,9051"/>
    <jarmap path="jakarta-struts/lib/commons-collections.jar" lib="Struts Runtime" ver="904,9050,9051"/>
    <jarmap path="jakarta-struts/lib/commons-digester.jar" lib="Struts Runtime" ver="904,9050,9051"/>
    <jarmap path="jakarta-struts/lib/commons-fileupload.jar" lib="Struts Runtime" ver="904,9050,9051"/>
    <jarmap path="jakarta-struts/lib/commons-lang.jar" lib="Struts Runtime" ver="904,9050,9051"/>
    <jarmap path="jakarta-struts/lib/commons-logging.jar" lib="Struts Runtime" ver="904,9050,9051"/>
    <jarmap path="jakarta-struts/lib/commons-validator.jar" lib="Struts Runtime" ver="904,9050,9051"/>
    <jarmap path="jakarta-struts/lib/jakarta-oro.jar" lib="Struts Runtime" ver="904,9050,9051"/>
    <jarmap path="jakarta-struts/lib/struts.jar" lib="Struts Runtime" ver="903,904,9050,9051"/>
    <jarmap path="jakarta-taglibs/jstl-1.0/lib/dom.jar" lib="JSTL" ver="9050,9051"/>
    <jarmap path="jakarta-taglibs/jstl-1.0/lib/jaxen-full.jar" lib="JSTL" ver="9050,9051"/>
    <jarmap path="jakarta-taglibs/jstl-1.0/lib/jaxp-api.jar" lib="JSTL" ver="9050,9051"/>
    <jarmap path="jakarta-taglibs/jstl-1.0/lib/jstl.jar" lib="JSTL" ver="9050,9051"/>
    <jarmap path="jakarta-taglibs/jstl-1.0/lib/sax.jar" lib="JSTL" ver="9050,9051"/>
    <jarmap path="jakarta-taglibs/jstl-1.0/lib/saxpath.jar" lib="JSTL" ver="9050,9051"/>
    <jarmap path="jakarta-taglibs/jstl-1.0/lib/standard.jar" lib="JSTL" ver="9050,9051"/>
    <jarmap path="jakarta-taglibs/jstl-1.0/lib/xalan.jar" lib="JSTL" ver="9050,9051"/>
    <jarmap path="jakarta-taglibs/jstl-1.0/lib/xercesImpl.jar" lib="JSTL" ver="9050,9051"/>
    <jarmap path="javavm/lib/aurora.zip" lib="JServer" ver="902,903,904,9050,9051"/>
    <jarmap path="jdbc/lib/classes12.jar" lib="Oracle JDBC" ver="902,903,904,9050,9051"/>
    <jarmap path="jdbc/lib/nls_charset12.jar" lib="Oracle JDBC" ver="902,903,904,9050,9051"/>
    <jarmap path="jdk/jre/lib/ext/activation.jar" newpath="j2ee/home/lib/activation.jar" lib="J2EE" ver="902"/>
    <jarmap path="jdk/jre/lib/ext/activation.jar" newpath="j2ee/home/lib/activation.jar" lib="Oracle SOAP" ver="902"/>
    <jarmap path="jdk/jre/lib/ext/jcert.jar" newpath="j2ee/home/lib/jcert.jar" lib="J2EE" ver="902,903"/>
    <jarmap path="jdk/jre/lib/ext/jndi.jar" newpath="j2ee/home/lib/jndi.jar" lib="BC4J EJB Client" ver="902"/>
    <jarmap path="jdk/jre/lib/ext/jndi.jar" newpath="j2ee/home/lib/jndi.jar" lib="BC4J EJB Runtime" ver="902"/>
    <jarmap path="jdk/jre/lib/ext/jndi.jar" newpath="j2ee/home/lib/jndi.jar" lib="BC4J Oracle9iAS Client" ver="902"/>
    <jarmap path="jdk/jre/lib/ext/jndi.jar" newpath="j2ee/home/lib/jndi.jar" lib="BC4J Runtime" ver="902"/>
    <jarmap path="jdk/jre/lib/ext/jndi.jar" newpath="j2ee/home/lib/jndi.jar" lib="BC4J VB Client" ver="902"/>
    <jarmap path="jdk/jre/lib/ext/jndi.jar" newpath="j2ee/home/lib/jndi.jar" lib="J2EE" ver="902"/>
    <jarmap path="jdk/jre/lib/ext/jnet.jar" newpath="j2ee/home/lib/jnet.jar" lib="J2EE" ver="902,903"/>
    <jarmap path="jdk/jre/lib/ext/jta.jar" newpath="j2ee/home/lib/jta.jar" lib="BC4J Oracle9iAS Client" ver="902"/>
    <jarmap path="jdk/jre/lib/ext/jta.jar" newpath="j2ee/home/lib/jta.jar" lib="J2EE" ver="902"/>
    <jarmap path="jdk/jre/lib/ext/mail.jar" newpath="j2ee/home/lib/mail.jar" lib="J2EE" ver="902"/>
    <jarmap path="jdk/jre/lib/ext/mail.jar" newpath="j2ee/home/lib/mail.jar" lib="Oracle SOAP" ver="902"/>
    <jarmap path="jdk/lib/tools.jar" lib="Sun Tools" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/LW_PfjBean.jar" lib="Chart" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/LW_PfjBean.jar" lib="JClient Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/bigraphbean-nls.zip" lib="Oracle BI Graph" ver="903,904,9050,9051"/>
    <jarmap path="jlib/bigraphbean.jar" lib="JClient Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/bigraphbean.jar" lib="Oracle BI Graph" ver="903,904,9050,9051"/>
    <!-- help4-nls.jar is not in the 9051 libraries.xml -->
    <!--<jarmap path="jlib/help4-nls.jar" lib="BC4J Tester" ver="902,903,9050"/>-->
    <!--<jarmap path="jlib/help4-nls.jar" lib="Oracle Help for Java" ver="903,9050"/>-->
    <!--<jarmap path="jlib/help4-nls.jar" lib="Oracle JEWT" ver="902,903,9050"/>-->
    <jarmap path="jlib/help4.jar" lib="BC4J Tester" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/help4.jar" lib="Oracle Help for Java" ver="903,904,9050,9051"/>
    <jarmap path="jlib/help4.jar" lib="Oracle JEWT" ver="902,903,904,9050,9051"/>
    <!-- inspect4-nls.jar is not in the 9051 libararies.xml -->
    <!--<jarmap path="jlib/inspect4-nls.jar" lib="JDeveloper Extension SDK" ver="9050"/>-->
    <!--<jarmap path="jlib/inspect4-nls.jar" lib="Oracle JEWT" ver="902,903,9050"/>-->
    <jarmap path="jlib/inspect4.jar" lib="JDeveloper Extension SDK" ver="904,9050,9051"/>
    <jarmap path="jlib/inspect4.jar" lib="Oracle JEWT" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/javax-ssl-1_2.jar" lib="Oracle SOAP" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/jdev-cm.jar" lib="BC4J Client" ver="9050,9051"/>
    <jarmap path="jlib/jdev-cm.jar" lib="BC4J EJB Client" ver="903,904,9050,9051"/>
    <jarmap path="jlib/jdev-cm.jar" lib="BC4J Oracle9iAS Client" ver="903,904,9050,9051"/>
    <jarmap path="jlib/jdev-cm.jar" lib="BC4J Runtime" ver="903,904,9050,9051"/>
    <jarmap path="jlib/jdev-cm.jar" lib="BC4J Tester" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/jdev-cm.jar" lib="Connection Manager" ver="902,903,904,9050,9051"/>
    <!-- jewt4-nls.jar is not in the 9051 libraries.xml -->
    <!--<jarmap path="jlib/jewt4-nls.jar" lib="BC4J Tester" ver="902,903,9050"/>-->
    <!--<jarmap path="jlib/jewt4-nls.jar" lib="Oracle Help for Java" ver="903,9050"/>-->
    <!--<jarmap path="jlib/jewt4-nls.jar" lib="Oracle JEWT" ver="902,903,9050"/>-->
    <jarmap path="jlib/jewt4.jar" lib="BC4J Tester" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/jewt4.jar" lib="JDeveloper Extension SDK" ver="903,904,9050,9051"/>
    <jarmap path="jlib/jewt4.jar" lib="Oracle Help for Java" ver="903,904,9050,9051"/>
    <jarmap path="jlib/jewt4.jar" lib="Oracle JEWT" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/jssl-1_2.jar" lib="Oracle SOAP" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/ojmisc.jar" lib="BC4J EJB Client" ver="904,9050,9051"/>
    <jarmap path="jlib/ojmisc.jar" lib="BC4J Oracle9iAS Client" ver="904,9050,9051"/>
    <jarmap path="jlib/ojmisc.jar" lib="BC4J Runtime" ver="904,9050,9051"/>
    <jarmap path="jlib/ojmisc.jar" lib="BC4J Tester" ver="904,9050,9051"/>
    <jarmap path="jlib/oracle_ice.jar" lib="BC4J Tester" ver="904,9050,9051"/>
    <jarmap path="jlib/oracle_ice.jar" lib="Ice" ver="904,9050,9051"/>
    <jarmap path="jlib/oracle_ice.jar" lib="Oracle Help for Java" ver="904,9050,9051"/>
    <jarmap path="jlib/oracle_ice5.jar" newpath="jlib/oracle_ice.jar" lib="BC4J Tester" ver="902,903"/>
    <jarmap path="jlib/oracle_ice5.jar" newpath="jlib/oracle_ice.jar" lib="Ice" ver="902,903"/>
    <jarmap path="jlib/oracle_ice5.jar" newpath="jlib/oracle_ice.jar" lib="Oracle Help for Java" ver="903"/>
    <jarmap path="jlib/regexp.jar" lib="ADF UIX Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/regexp.jar" lib="Apache Regexp 1.2" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/share.jar" lib="ADF UIX Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/share.jar" lib="BC4J Tester" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/share.jar" lib="Oracle Help for Java" ver="903,904,9050,9051"/>
    <jarmap path="jlib/share.jar" lib="Oracle JEWT" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/uix2.jar" lib="ADF UIX Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="jlib/uixadfrt.jar" lib="ADF UIX Runtime" ver="9050,9051"/>
    <jarmap path="lib/aurora_client.jar" lib="JServer" ver="902,903,904,9050,9051"/>
    <jarmap path="lib/dms.jar" lib="Oracle DMS" ver="903,904,9050,9051"/>
    <jarmap path="lib/jsse.jar" newpath="j2ee/home/lib/jsse.jar" lib="J2EE" ver="903"/>
    <jarmap path="lib/mts.jar" lib="JServer" ver="902,903,904,9050,9051"/>
    <jarmap path="lib/oraclexsql.jar" lib="XSQL Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="lib/servlet.jar" newpath="j2ee/home/lib/servlet.jar" lib="JSP Runtime" ver="902"/>
    <jarmap path="lib/servlet.jar" newpath="j2ee/home/lib/servlet.jar" lib="Servlet Runtime" ver="902"/>
    <jarmap path="lib/xmlcomp.jar" lib="Oracle XML Parser v2" ver="902,903,904,9050,9051"/>
    <jarmap path="lib/xmlparserv2.jar" lib="BC4J EJB Client" ver="903,904,9050,9051"/>
    <jarmap path="lib/xmlparserv2.jar" lib="BC4J Oracle9iAS Client" ver="903,904,9050,9051"/>
    <jarmap path="lib/xmlparserv2.jar" lib="BC4J Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="lib/xmlparserv2.jar" lib="BC4J Tester" ver="902,903,904,9050,9051"/>
    <jarmap path="lib/xmlparserv2.jar" lib="EBI Messaging Adapters" ver="902,903,904,9050,9051"/>
    <jarmap path="lib/xmlparserv2.jar" lib="Oracle SOAP" ver="902,903,904,9050,9051"/>
    <jarmap path="lib/xmlparserv2.jar" lib="Oracle XML Parser v2" ver="902,903,904,9050,9051"/>
    <jarmap path="lib/xmlparserv2.jar" lib="XSQL Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="lib/xsqlserializers.jar" lib="XSQL Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="mds/lib/mdsrt.jar" lib="MDS Runtime" ver="9050,9051"/>
    <jarmap path="opmn/lib/optic.jar" lib="Oracle9 iAS" ver="904,9051"/>
    <jarmap path="orant/lite/classes/olite40.jar" lib="Oracle8i Lite" ver="903,904,9050,9051"/>
    <jarmap path="ord/jlib/jmf.jar" lib="Java Media Framework" ver="902,903,904,9050,9051"/>
    <jarmap path="ord/jlib/jmf.jar" lib="Oracle Intermedia JClient" ver="902,903,904,9050,9051"/>
    <jarmap path="ord/jlib/ordhttp.jar" lib="Oracle Intermedia JClient" ver="902,903,904,9050,9051"/>
    <jarmap path="ord/jlib/ordhttp.jar" lib="Oracle Intermedia" ver="902,903,904,9050,9051"/>
    <jarmap path="ord/jlib/ordim.jar" lib="Oracle Intermedia JClient" ver="902,903,904,9050,9051"/>
    <jarmap path="ord/jlib/ordim.jar" lib="Oracle Intermedia" ver="902,903,904,9050,9051"/>
    <jarmap path="rdbms/jlib/aqapi.jar" lib="AQJMS" ver="902,904,9050,9051"/>
    <jarmap path="rdbms/jlib/aqapi.jar" lib="EBI Messaging Adapters" ver="902,904,9050,9051"/>
    <jarmap path="rdbms/jlib/jmscommon.jar" newpath="j2ee/home/lib/jms.jar" lib="AQJMS" ver="902"/>
    <jarmap path="rdbms/jlib/jmscommon.jar" newpath="j2ee/home/lib/jms.jar" lib="EBI Messaging Adapters" ver="902,9050"/>
    <jarmap path="rdbms/jlib/xsu12.jar" lib="Oracle XML SQL Utility" ver="902,903,904,9050,9051"/>
    <jarmap path="rdbms/jlib/xsu12.jar" lib="XSQL Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="soap/lib/soap.jar" lib="Oracle SOAP" ver="902,903,904,9050,9051"/>
    <jarmap path="soap/lib/wsdl.jar" newpath="webservices/lib/wsdl.jar" lib="Oracle JWSDL" ver="902"/>
    <jarmap path="sqlj/lib/runtime.jar" newpath="sqlj/lib/runtime12.jar" lib="JServer" ver="902,903"/>
    <jarmap path="sqlj/lib/runtime12.jar" lib="JServer" ver="9050,9051"/>
    <jarmap path="sqlj/lib/runtime12.jar" lib="SQLJ Runtime" ver="902,903,9050,9051"/>
    <jarmap path="sqlj/lib/runtime12ee.jar" newpath="sqlj/lib/runtime12.jar" lib="JServer" ver="904"/>
    <jarmap path="sqlj/lib/runtime12ee.jar" newpath="sqlj/lib/runtime12.jar" lib="SQLJ Runtime" ver="904"/>
    <jarmap path="sqlj/lib/translator.jar" lib="JServer" ver="902,903,904,9051"/>
    <jarmap path="toplink/jlib/toplink.jar" lib="TopLink" ver="9050,9051"/>
    <jarmap path="uddi/lib/uddiclient.jar" lib="Oracle UDDI" ver="904,9051"/>
    <jarmap path="vbroker4/lib/vbdev.jar" lib="JServer" ver="902,903,904,9050,9051"/>
    <jarmap path="vbroker4/lib/vbdev.jar" lib="VisiBroker4" ver="902,903,904,9050,9051"/>
    <jarmap path="vbroker4/lib/vbjdev.jar" lib="JServer" ver="902,903,904,9050,9051"/>
    <jarmap path="vbroker4/lib/vbjdev.jar" lib="VisiBroker4" ver="902,903,904,9050,9051"/>
    <jarmap path="vbroker4/lib/vbjorb.jar" lib="BC4J VB Client" ver="902,903,904,9050,9051"/>
    <jarmap path="vbroker4/lib/vbjorb.jar" lib="BC4J VB Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="vbroker4/lib/vbjorb.jar" lib="JServer" ver="902,903,904,9050,9051"/>
    <jarmap path="vbroker4/lib/vbjorb.jar" lib="VisiBroker4" ver="902,903,904,9050,9051"/>
    <jarmap path="webservices/lib/wsdl.jar" lib="Oracle JWSDL" ver="903,904,9050,9051"/>
    <jarmap path="ant.jar" lib="Apache Ant" ver="903,904,9050,9051"/>
    <!-- The batik jars are new in the 9051 libraries.xml -->
    <!--<jarmap path="batik-awt-util.jar" lib="Apache Batik" ver="9051"/>-->
    <!--<jarmap path="batik-bridge.jar" lib="Apache Batik" ver="9051"/>-->
    <!--<jarmap path="batik-css.jar" lib="Apache Batik" ver="9051"/>-->
    <!--<jarmap path="batik-dom.jar" lib="Apache Batik" ver="9051"/>-->
    <!--<jarmap path="batik-ext.jar" lib="Apache Batik" ver="9051"/>-->
    <!--<jarmap path="batik-gui-util.jar" lib="Apache Batik" ver="9051"/>-->
    <!--<jarmap path="batik-gvt.jar" lib="Apache Batik" ver="9051"/>-->
    <!--<jarmap path="batik-parser.jar" lib="Apache Batik" ver="9051"/>-->
    <!--<jarmap path="batik-script.jar" lib="Apache Batik" ver="9051"/>-->
    <!--<jarmap path="batik-svg-dom.jar" lib="Apache Batik" ver="9051"/>-->
    <!--<jarmap path="batik-svggen.jar" lib="Apache Batik" ver="9051"/>-->
    <!--<jarmap path="batik-transcoder.jar" lib="Apache Batik" ver="9051"/>-->
    <!--<jarmap path="batik-util.jar" lib="Apache Batik" ver="9051"/>-->
    <!--<jarmap path="batik-xml.jar" lib="Apache Batik" ver="9051"/>-->
    <!-- The bc4jdt.jar is not in any pre-9051 libraries.xml -->
    <!--<jarmap path="bc4jdt.jar" lib="ADF Designtime API" ver="9051"/>-->
    <jarmap path="dmsstub.jar" lib="DMS ProfilerAPI stub" ver="903,904,9050,9051"/>
    <jarmap path="ebiadapters.jar" lib="EBI Messaging Adapters" ver="902,903,904,9050,9051"/>
    <jarmap path="javax_ejb.jar" newpath="j2ee/home/lib/ejb.jar" lib="J2EE" ver="902"/>
    <jarmap path="jdebi.jar" lib="EBI Runtime Support" ver="902,903,904,9050,9051"/>
    <jarmap path="jdev-rt.jar" lib="JDeveloper Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="jdev-rt.jar" lib="Oracle SOAP" ver="903,904,9050,9051"/>
    <jarmap path="jdev.jar" lib="JDeveloper Extension SDK" ver="902,903,904,9050,9051">
      <plus path="ide/lib/ide.jar"/>
      <plus path="ide/lib/javatools.jar"/>
    </jarmap>
    <jarmap path="jdev.jar" lib="JDeveloper VCS Extension SDK" oldlib="JDeveloper SCM API" ver="902,903,904,9050,9051"/>
    <jarmap path="jdscm.jar" lib="JDeveloper VCS Extension SDK" oldlib="JDeveloper SCM API" ver="902,903,904,9050,9051"/>
    <jarmap path="jdukshare.jar" lib="JDeveloper VCS Extension SDK" oldlib="JDeveloper SCM API" ver="903,904,9050,9051"/>
    <jarmap path="jgl3.1.0.jar" lib="JGL 3.1.0" ver="902,903,904,9050,9051"/>
    <jarmap path="jr_cmd.jar" lib="Oracle9i SCM" ver="9050,9051"/>
    <jarmap path="jr_cws.jar" lib="Oracle9i SCM" ver="9050,9051"/>
    <jarmap path="jr_diff.jar" lib="Oracle9i SCM" ver="9050,9051"/>
    <jarmap path="jr_file.jar" lib="Oracle9i SCM" ver="9050,9051"/>
    <jarmap path="jr_jol.jar" lib="Oracle9i SCM" ver="9050,9051"/>
    <jarmap path="jr_vhv.jar" lib="Oracle9i SCM" ver="9050,9051"/>
    <jarmap path="ojc.jar" lib="JSP Runtime" ver="902,903,904,9050,9051"/>
    <jarmap path="ojc.jar" lib="Oracle Java Compiler" ver="902,903,904,9050,9051"/>
    <jarmap path="optional.jar" lib="Apache Ant" ver="903,904,9050,9051"/>
    <jarmap path="xmladdin.jar" lib="JDeveloper Extension SDK" ver="903,904,9050,9051"/>
    <jarmap path="xmleditor.jar" lib="JDeveloper Extension SDK" ver="903,904,9050,9051"/>
  </jar2lib>

</xsl:stylesheet>
