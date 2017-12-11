JDeveloper 10.1.3 uses JSR-198 manifests to load extensions, see documentation 
and xml schemas in jdev/doc/extensions. JDeveloper 10.1.2 manifests are 
supported only for backward compatibility.


This directory is the location for 3rd party extensions which 
support auto-registration.

To auto-register addins place the extension (addin) into a jar file 
with a xml manifest file. The manifest file must be named jdev-ext.xml 
and placed in the root directory meta-inf of the jar file. 

A xml schema (extensionmanifest1013.xsd) describing the structure can be found in 
the same directory as this file. 

The manifest file can be complicated as it informs JDeveloper to load extensions,
create gallery and palette items, defines library definitions, insert help files.

But your extension does not have to have all these features, it could be a 
single extension for JDeveloper. The following will help you define your extension
manifest.


Manifest Defintions
-------------------

The element "extensions" is the root xml element used to hold the xml namespace
attibute. 

The "feature" element describes to JDeveloper what features are to be created. It has
the attribute "set" more on this latter, the attribute is not required for regular
extensions

The "extension" element names the extension that JDeveloper is to load.

The following example will inform JDeveloper to load the extension 
"mycompany.editor.codeformater"


<?xml version = '1.0' encoding = 'windows-1252'?>
<extensions xmlns="http://xmlns.oracle.com/jdeveloper/1013/extensions">
  <esdk-version>10.1.3</esdk-version>
  <feature>
    <extenion>
      <addin>mycompany.editor.codeformater</addin>
    </extension>
  </feature>
</extensions>

The "esdk-version" element informs JDeveloper what version of the Extension
Software Development Kit (ESDK) your extension was built against, this needs 
to match the version JDeveloper is using.

Extension with dependencies
===========================

If your extension has a dependency (run time) then you need to inform JDeveloper
of this dependency. So that your extension is initialized in the correct order
and your extension is not initialized if the dependency is unloaded. 

The "dependency_addin" element names the dependency, if "mycompany.editor.codeformater" 
had a dependency on the JDeveloper code editor then this should be listed 
for example


<?xml version = '1.0' encoding = 'windows-1252'?>
<extensions xmlns="http://xmlns.oracle.com/jdeveloper/1013/extensions">
  <feature>
    <extenion>
      <addin>mycompany.editor.codeformater</addin>
      <dependency_addin>oracle.jdeveloper.ceditor.CodeEditorAddin</dependency_addin>
    </extension>
  </feature>
</extensions>


Dependent jars
==============

If your extension requires a supporting jar file to run, specifiy the jar file
location in the manifest using the "classpath" element . The jar file 
path is relative to the extension jar file.


<?xml version = '1.0' encoding = 'windows-1252'?>
<extensions xmlns="http://xmlns.oracle.com/jdeveloper/1013/extensions">
  <feature>
    <extenion>
      <addin>mycompany.editor.codeformater</addin>
      <classpath>../lib/mycompay/format.jar</classpath>
      <dependency_addin>oracle.jdeveloper.ceditor.CodeEditorAddin</dependency_addin>
    </extension>
  </feature>
</extensions>


The "classpath" element can be repeated if there are many jar files. The "classpath"
element can appear outside the "extension" element if there are many extensions
defined within the manifest and they all require the jar file.


<extensions xmlns="http://xmlns.oracle.com/jdeveloper/1013/extensions">
  <classpath>../lib/mycompay/format.jar</classpath>
  <feature>
    <extenion>
      <addin>mycompany.editor.codeformater</addin>
      <dependency_addin>oracle.jdeveloper.ceditor.CodeEditorAddin</dependency_addin>
    </extension>
    <extenion>
      <addin>mycompany.editor.javacodeformater</addin>
      <dependency_addin>mycompany.editor.codeformater</dependency_addin>
    </extension>
    <extenion>
      <addin>mycompany.editor.sqlcodeformater</addin>
      <dependency_addin>mycompany.editor.codeformater</dependency_addin>
    </extension>
  </feature>
</extensions>


Unloading Extensions - Groups
=============================

If your extension is to be unloadable by the extension manager, this is encouraged
so that people can configure JDeveloper. Extensions can be unloaded via the Extension 
Manger Preferences - see Tools->Preferences->Extension Manager.

To organise the unloading of extensions they need to be organsied using the 
"group" element. The "group" element has several important attributes these
are "name" and "nlsclass". The name attribute is used to identify the group,
the nlsclass is a fully qualify class which implements the 
oracle.ide.model.Displayable interface. The extension manager uses the nlsclass
value to display the groups name and description to the user. The methods 
getShortLabel and getLongLabel from the Displayable interface are used for
the name and description respectly. 


<extensions xmlns="http://xmlns.oracle.com/jdeveloper/1013/extensions">
  <feature>
    <group name="formater" nlsclass="mycompany.editor.groupdetails">
      <extenion>
        <addin>mycompany.editor.codeformater</addin>
        <classpath>../lib/mycompay/format.jar</classpath>
        <dependency_addin>oracle.jdeveloper.ceditor.CodeEditorAddin</dependency_addin>
      </extension>
    </group>
  </feature>
</extensions>


New Gallery
===========

Gallery items can be specified in the manifest using the "gallery" element. The
gallery can belong to an extension if defined within the "extension" element. If 
defined within the "extension" element the gallery item is not created if the 
extension is not initialized, the user has used the Extension Manager to customize
JDeveloper so that your extension is not initialized.


<extensions xmlns="http://xmlns.oracle.com/jdeveloper/1013/extensions">
  <feature>
    <group name="formater" nlsclass="mycompany.editor.groupdetails">
      <extenion>
        <addin>mycompany.editor.codeformater</addin>
        <classpath>../lib/mycompay/format.jar</classpath>
        <dependency_addin>oracle.jdeveloper.ceditor.CodeEditorAddin</dependency_addin>
	<gallery>
          <name>mycompany.editor.codeformater.FormaterWizard</name>
          <category>General</category>
          <folder>Projects</folder>
          <technologyKey>J2EE</technologyKey>
        <gallery>
      </extension>
    </group>
  </feature>
</extensions>


The following specifies a gallery item which will always be created
  	

<extensions xmlns="http://xmlns.oracle.com/jdeveloper/1013/extensions">
  <feature>
    <gallery>
      <name>mycompany.editor.codeformater.FormaterWizard</name>
      <category>General</category>
      <folder>Projects</folder>
     <gallery>
  </feature>
</extensions>


The "gallery" element has three elements which need to be specifed these
are "name", "category" and "folder".
  "name" is the full qualified name of the gallary wizard, that you are defining
  "category" is the categories name see File->New->New Gallery
  "folder" is the name under the category item.

Defining these three elements determines where your new gallary item appears.

The "technology" element further refines when your gallery item appears, if the 
"technology" element is not defined then your gallery will appear in the 
"All Technologies" definition.

The gallery element can be repeated if many new gallery items are required.

Palette Entries
===============

The "Palette" element enables you as an extension writer to defined palette
pages and items that the extension manager will add. The "palette"
element has a child element "page" which can be repeated if many palette pages are 
required. Like the "gallery" element the "palette" element can be placed within
or outside the "extension" element


<extensions xmlns="http://xmlns.oracle.com/jdeveloper/1013/extensions">
  <feature>
    <palette>
      <page>
        <name>Code Formaters</name>
        <showForTypes>java</showForTypes>
        <technologyScope>Java;JavaBeans;Swing/AWT</technologyScope>
        <type>java</type>
        <canRemove>false</canRemove>
        <canShow>true</canShow>
        <draggable>true</draggable>
        <view>
        <item>
          <icon>/mycompany/editor/codeeditor/format.gif</icon>
          <info>jfc\lib\swingall.jar,javax.swing.JMenuBar</info>
          <isPersistent>true</isPersistent>
          <longLabel>javax.swing.JMenuBar</longLabel>
          <shortLabel>JMenuBar</shortLabel>
          <type>JavaBean</type>
        </item>
     </page>
   </palette>
  </feature>
</extensions>


See the xml manifest for a full description of the palette items.

Librarys
========

The manifest can specifiy JDeveloper libraries which enable other java developers
to use your java framework / api. 

The "library" element has a attribute called "name" this is required and is used to 
identify the library. The "library" element has three child elements classpath,
docpath and srcpath. The classpath is required the other two are optional. The paths
are relative to the extension jar file.

<extensions xmlns="http://xmlns.oracle.com/jdeveloper/1013/extensions">
  <feature>
    <library name="FormatFramework">
      <classpath>../../frameworks/lib/format.jar</classpath> 
      <docpath>../../frameworks/doc/format.jar</docpath> 
      <srcpath>../../frameworks/src/format.jar</srcpath> 
    </library>
  </feature>
</extensions>


Feature Element
===============

The "feature" element as previous mentioned has a attribute called set, if assigned
a value the extension manager defers loading of the feature contents until it is 
instructed to load the feature. This could be done by an extension when it is 
initialized or when a condition is met.

In this example the audit "feature" is loaded by the extension manager after being 
instructed by the "oracle.jdevimpl.audit.core.AuditExtension" extension

<extensions xmlns="http://xmlns.oracle.com/jdeveloper/1013/extensions">
  <feature>
      <extension>
         <addin>oracle.jdevimpl.audit.core.AuditExtension</addin>
      </extension>
   </feature>
   <feature set="Audit">
      <extension>
         <addin>oracle.jdevimpl.audit.core.AuditMetricsAddin</addin>
      </extension>
      <group name="General">
         <group name="DocCommenter" nlsclass="oracle.jdevimpl.javadoc.audit.DocCommenterExtGroupInfo">
            <extension>
               <addin>oracle.jdevimpl.javadoc.audit.DocCommenter</addin>
               <dependency_addin>oracle.jdevimpl.audit.core.AuditMetricsAddin</dependency_addin>
            </extension>
         </group>
      </group>
      <group name="General">
         <group name="Audit" nlsclass="oracle.jdevimpl.audit.core.AuditAddinDescription">
            <profile_name>Java_Development</profile_name>
            <extension>
               <addin>oracle.jdevimpl.audit.core.AuditAddin</addin>
               <dependency_addin>oracle.jdevimpl.audit.core.AuditMetricsAddin</dependency_addin>
            </extension>
         </group>
         <group name="Metrics" nlsclass="oracle.jdevimpl.audit.core.MetricsAddinDescription">
            <profile_name>Java_Development</profile_name>
            <extension>
               <addin>oracle.jdevimpl.audit.core.MetricsAddin</addin>
               <dependency_addin>oracle.jdevimpl.audit.core.AuditMetricsAddin</dependency_addin>
            </extension>
         </group>
      </group>
    </feature>
</feature>   


Detailed specification
======================

<?xml version = '1.0' encoding = 'windows-1252'?>
<extensions xmlns="http://xmlns.oracle.com/jdeveloper/905/extensions">
  <profile name="" nlsclass=""/>
  <classpath></classpth>
  <feature>
    <group name="****" nlsclass="" exclusive="" toplevel="" default="">
      <description></description>
      <extension>
        <addin>*****</addin>
        <classpath></classpath>
        <dependency_addin>
        </dependency_addin>
        <gallery>see below for definition</gallery>
        <palette>
          <page>
            <name>*****</name>
            <showForTypes></showForTypes>
	    <technologyScope></technologyScope>
            <type></type>
            <view></view>
            <canRemove></canRemove>
            <canShow></canShow>
            <draggable></draggable>
	    <paletteContext></<paletteContext>
            <item>
              <canRemove></canRemove>
              <editor></editor>
              <icon>*****</icon>
              <info>*****</info>
              <isPersistent></isPersistent>
              <library></library>
              <longLabel>*****</longLabel>
              <shortLabel>****</shortLabel>
              <type>*****</type>
	      <helpable>******</helpable>
            </item>        
          </page>
        </palette>
        <help>see below</help>
        <library>see below</library>
        <jsplibrary>see below</jsplibrary>        
      </extension>
    </group>  
    <gallery>
      <name>*****</name>
      <description></description>
      <help></help>
      <icon></icon>
      <unsorted></unsorted>
      <category></category>
      <folder>*****</folder>
      <parameter></parameter>
      <technologyKey></technologyKey>
    </gallery>
    <help>
      <helpURL>*****</helpURL>
      <relativeTo></relativeTo>
      <relativePosition></relativePosition>
    </help>
    <library name="*****">
      <classpath></classpath> 
      <docpath></docpath> 
      <srcpath></srcpath> 
    </library>
   <jsplibrary>
      <URI></URI>
      <classesURL></classesURL>
      <displayName>*****</displayName>
      <prefix>*****</prefix>
      <tldURL>*****</tldURL>
      <runInEditor></runInEditor>
      <libraries></libraries>
   </jsplibrary>                      
  </feature>
</extensions>

Notes on the XML syntax
-----------------------
1. XML tags extensions, feature, group, addin must be present within the 
jdev-ext.xml file all others are optional.
2. ***** are mandatory values, others are optional.
3. XML tag <parameter> can be repeated, value must be a string
4. XML tags <group>, <extension>, <dependency_addin> can be repeated.
5. If the extension has gallery items then the gallery xml tag within the 
extension xml tag should be used. Use the gallery xml outside extension xml 
tag for gallery wizards only.
6. XML tags <page> within <palette> can be repeated. <item> tags within <page> 
can be repeated.
7. The <helpURL> within the xml tag <help> must be the name of the help jar file 
followed by the help set file eg file.jar!/helpsetfile.hs. If you wish to define
the location of your help file within the table of contents use the tags
<relativeTo> and <relativePosition> where relativeTo = location of a current 
help file eg "Tutorials" and relativePosition = "after" or "before".
8. The classpath, docpath & srcpath within library must be a semi-comma 
separated list of files. The file paths should be relative to the extension 
jar file. These tags can be repeated.
9. Gallery XML tags <description>, <help>, and <icon> are not required
if the gallery class implements the oracle.ide.model.Displayable
interface.
10. The oracle_home macro (@ORACLE_HOME@) can be used in the tags <classesURL>
and <tldURL> within the <jsplibrary> tag.
11. If the <group> attribute nlsclass is used, the class should implement
oracle.ide.model.Displayable. The extension manager will use the Displayable 
methods getShortLabel() and getLongLabel() to display the group name and
description respectively.
12. If a group is to contain a set of mutually exclusive sub-groups then
each sub-group needs to have the attribute "exclusive" assigned to true.
A sub group can be designated the default by assigning the attribute
"default" to true.
13. If a group is not to appear under the system extension group on the
extension manager preferences then assign the group attribute "toplevel" 
to true.
14. XML tag <technologyKey> can be repeated; specifying the
technologies for a gallery item allows filtering the gallery display.
The value is a string, and should match a technology key registered
with the oracle.ide.model.TechnologyRegistry.  The keys for
pre-registered JDeveloper technologies are exposed as constants in the
oracle.ide.model.IdeTechnologies and
oracle.jdeveloper.model.JDevTechnologies classes.
15. The <runInEditor> tag in the <jsplibrary> tag allows you to specify if
the tag library should be executed in the JSP visual editor.
16. The <libraries> tag in the <jsplibrary> tag allows you to specify a semicolon
delimited list of JDev libraries that should be added to your project when a
tag from your library is added to a JSP.  The libraries should contain the 
actual tag handler classes archive as well.
17. Use the profile tag to define a profile for multiple extension groups. This 
is used to "remember" a set of active extension groups. The attributes name and 
nlsclass must be defined if the profile tag is used. The nlsclass attribute 
class should implement oracle.ide.model.Displayable. The extension manager will
use the Displayable method getShortLabel() to display the profile name.
18. Use the profile_name tag to add a extension group to a named profile.
19. classpath under <extensions> should be used in preference to 
<extension><classpath> if class path entries are shared by many extensions.


