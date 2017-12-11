#!/bin/sh
#
# oc4j_jdev.sh - shell for invoking ADF Portal Dev Kit OC4J 
#
# Usage:    oc4j JAVA_HOME ORACLE_HOME EXT_DIR [Options]
#
#           Options:
#            -start                  : start OC4J
#            -shutdown -port <ORMI port> -password <password>
#                                    : stop OC4J
#            -version                : display the version
#            -help                   : display this message
#
# Copyright (c) 2006, Oracle. All rights reserved.  
#

#########################################################
## Dev-kit OC4J init
#########################################################

JAVA_HOME=$1
shift
ORACLE_HOME=$1
shift
EXT_DIR=$1
shift
SERVER_XML=$EXT_DIR/j2ee/home/config/server.xml

#########################################################
## Install wsrp if not exists
#########################################################

if [ ! -x $EXT_DIR/j2ee/home/shared-lib/oracle.wsrp/1.0 ] 
then
  echo wsrp not installed 
  echo installing wsrp......
  mkdir $EXT_DIR/javacache
  mkdir $EXT_DIR/javacache/admin
  cd $EXT_DIR/j2ee/home
  $JAVA_HOME/bin/java -jar $ORACLE_HOME/adfp/lib/portlet-server-install.jar
  cd $EXT_DIR/bin
fi

###########################################################
## Create default WebCliping repository path if not exists
###########################################################

if [ ! -x $ORACLE_HOME/portal/portletdata/tools/webClipping ] 
then
  echo Create WebClipping repository path 
  mkdir $ORACLE_HOME/portal
  mkdir $ORACLE_HOME/portal/portletdata
  mkdir $ORACLE_HOME/portal/portletdata/tools
  mkdir $ORACLE_HOME/portal/portletdata/tools/webClipping
fi

###########################################################
## Copy portal/conf/* to ORACLE_HOME
###########################################################

if [ ! -e $ORACLE_HOME/portal/conf/ca-bundle.crt ] 
then
  echo Create portal conf
  mkdir $ORACLE_HOME/portal
  mkdir $ORACLE_HOME/portal/conf
  cp $EXT_DIR/portal/conf/* $ORACLE_HOME/portal/conf
fi

#########################################################
########## START CONFIGURATION SECTION ##################
#########################################################

J2EE_HOME=$ORACLE_HOME/j2ee/home

#Any persistent arguments to specify at the JVM level can be set here 
#By default this will be read from the operating system environment
if [ "$OC4J_JVM_ARGS" ]
then 
  JVMARGS=$OC4J_JVM_ARGS
else
  JVMARGS="-XX:MaxPermSize=128m -Xmx512m"
fi
CMDARGS=

if [ "$VERBOSE" ]
then 
  VERBOSE=$VERBOSE
else
  VERBOSE=on
fi

ORMI_URL=ormi://127.0.0.1
ORMI_USER=oc4jadmin

OC4J_JAR=$J2EE_HOME/oc4j.jar
ADMIN_JAR=$J2EE_HOME/admin.jar

#########################################################
##########  END CONFIGURATION SECTION  ##################
#########################################################

check_oc4j()
{
  EXIT=0
  if [ "$JAVA_HOME" = "" ]
  then
    echo "Error# JAVA_HOME environment variable is not defined."
    check_msg="correct JAVA_HOME environment variable."
    EXIT=2
  elif [ ! -x $JAVA_HOME/bin/java ] 
  then
    echo "Error# Can not find java executable in $JAVA_HOME/bin."
    check_msg="correct java executable."
    EXIT=2
  elif [ "$ORACLE_HOME" = "" ] 
  then
    echo "Error: The ORACLE_HOME environment variable must be set before executing this script. Set this to the directory into which you unzipped oc4j_extended.zip."
    check_msg="correct ORACLE_HOME environment variable."
    EXIT=2
  elif [ ! -r "$OC4J_JAR" ]
  then
    check_msg="readable $OC4J_JAR."
    EXIT=2
  elif [ ! -w "$SERVER_XML" ]
  then
    check_msg="writable $SERVER_XML."
    EXIT=2
  elif [ ! -r "$ADMIN_JAR" ]
  then
    check_msg="readable $ADMIN_JAR."
     EXIT=2
  fi
}

echo_check_msg()
{
  echo "Error: The command can not be run without $1"
}

start_oc4j()
{
    echo "Starting OC4J from $J2EE_HOME ..."

    CMDARGS="-config $SERVER_XML"

    while [ $# -ge 1 ]
    do
    
      case $1 in
        *)
          echo ""
          echo "Error: The optoin \"$1\" was not recognized."
          EXIT=1
          return
          ;;
      esac
    done 

    if [ "$VERBOSE" = "on" ]
    then 
      echo "Executing: $JAVA_HOME/bin/java $JVMARGS -jar $OC4J_JAR $CMDARGS"
    fi

    $JAVA_HOME/bin/java $JVMARGS -jar $OC4J_JAR $CMDARGS

}

shutdown_oc4j()
{
    while [ $# -ge 1 ]
    do 

      case $1 in
        -port)
           shift
           if [ "$1" = "" ]
           then
             echo ""
             echo "Error: You must specify the ORMI port value."
             EXIT=1
             return
           else
             ORMI_PORT=$1
             shift
           fi
           ;;
        -password)
           shift
           if [ "$1" = "" ]
           then
             echo ""
             echo "Error: You must specify the password value."
             EXIT=1
             return
           else
             ORMI_PASSWORD=$1
             shift
           fi
           ;;
        *)
           echo ""
           echo "Error: The option \"$1\" was not recognized."
           EXIT=1
           return
           ;;
      esac
    done

    if [ "$ORMI_PORT" = "" ]
    then
      echo ""
      echo "Error: You must specify the ORMI port using the -port switch."
      echo "       The port value can be found in $J2EE_HOME/config/rmi.xml."
      EXIT=1
      return
    fi

    if [ "$ORMI_PASSWORD" = "" ]
    then
      echo ""
      echo "Error: You must specify the ORMI password using the -password switch."
      EXIT=1
      return
    fi

    echo "Shutdown OC4J instance..."

    CMDARGS="$ORMI_URL:$ORMI_PORT $ORMI_USER $ORMI_PASSWORD -shutdown"

    if [ "$VERBOSE" = "on" ]
    then 
      echo "Executing: $JAVA_HOME/bin/java -jar $ADMIN_JAR $CMDARGS"
    fi

    $JAVA_HOME/bin/java -jar $ADMIN_JAR $CMDARGS
}

version()
{
    echo "Getting the version of OC4J instance..."
    CMDARGS="-version"
    if [ "$VERBOSE" = "on" ]
    then 
      echo "Executing: $JAVA_HOME/bin/java $JVMARGS -jar $OC4J_JAR $CMDARGS"
    fi
    $JAVA_HOME/bin/java $JVMARGS -jar $OC4J_JAR $CMDARGS
}

help()
{
cat <<EOF

  Usage: oc4j [Options]
  Options:
  
   -start                     : start OC4J 
   -shutdown -port <ORMI port> -password <password>
                              : stop OC4J
   -version                   : display the version
   -help                      : display this message

EOF
}

########################################
### Start main function section      ###
########################################
check_oc4j
if [ ! "$EXIT" -eq 0 ]
then
  echo_check_msg "$check_msg"
else
  if [ $# -eq 0 ] 
  then
    help
  else
    # the first argument
    CMDARG="$1"

    # decrement number of arguments
    shift
    
    # get the rest of the command line
    
    case $CMDARG in
      -start)
        start_oc4j "$@"
        ;;
      -shutdown)
        shutdown_oc4j "$@"
        ;;
      -version)
        if [ $# -gt 0 ] ; then
          echo ""
          echo "Error: The option \"$CMDARG\" does not take any argument."
          EXIT=1
        else
          version
        fi
        ;;
      -help)
        help
        EXIT=0
        ;;
      *)
        echo ""
        echo "Error: The option \"$CMDARG\" was not recognized."
        EXIT=1
        ;;
    esac
    
    if [ $EXIT -eq 1 ]
    then 
      help
    fi

  fi
fi

echo Stop OC4J command finished.
