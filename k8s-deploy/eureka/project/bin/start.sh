#!/bin/bash

INSTALL_DIR="/root/project"
JVM_OPTS=""

JMX_PORT="30012"
JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.port=$JMX_PORT"
JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.authenticate=false"
JAVA_OPTS="$JAVA_OPTS -Duser.timezone=Asia/Shanghai"

JAVA_OPTS="$JAVA_OPTS $JVM_OPTS"

CLASSPATH="$INSTALL_DIR/lib/*:$INSTALL_DIR/conf"

MAIN_CLASS="org.springframework.boot.loader.JarLauncher"

echo "CLASSPATH": $CLASSPATH
echo "JAVA_OPTS": $JAVA_OPTS

java $JAVA_OPTS -cp $CLASSPATH $MAIN_CLASS
