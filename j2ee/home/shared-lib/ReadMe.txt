This directory contains the code-sources (JAR/ZIP files) that comprise a shared
library installed in OC4J.

To install a shared library, add its code-sources as follows:

- Create a directory with the name of the shared library; for example "acme".
- Create a subdirectory named for the version number of the shared library; for
  example "2.5".
- Copy each JAR or ZIP file containing the classes that comprise the shared
  library into this subdirectory.

For example:

/shared-lib (this directory)
  /acme
    /2.5
      acme-apis.jar
      acmeImpl.jar

An additional version of the shared library can be installed by creating another
subdirectory containing its archive files within this directory structure, as
shown below:

/shared-lib
  /acme
    /2.5
      acme-apis.jar
      acmeImpl.jar
    /3.0
      acme-apis.jar
      acmeImpl.jar

When finished, declare the shared libraries in the <OC4J_HOME>/j2ee/home/config/server.xml file:

<shared-library name=acme version=2.5>
  <code-source path=acme-apis.jar/>
  <code-source path=acmeImpl.jar/>
</shared-library>

<shared-library name=acme version=3.0>
  <code-source path=acme-apis.jar/>
  <code-source path=acmeImpl.jar/>
</shared-library>

Note that the path specified in a code-source element be absolute or relative to
the subdirectory containing the archive files.

For more information, see Chapter 4: Using the OC4J Class Loading Framework in
the OC4J Developer's Guide.


