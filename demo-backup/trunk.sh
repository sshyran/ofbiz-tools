#!/bin/sh

cd /home/ofbizDemo/trunk
svn up
rm /home/ofbizDemo/trunk/framework/base/config/*.jks
rm /home/ofbizDemo/trunk/framework/base/config/jesse.properties
./gradlew --no-daemon pullAllPluginsSource
./gradlew --no-daemon terminateOfbiz
./gradlew --no-daemon cleanAll
./gradlew --no-daemon loadAll
./gradlew --no-daemon svnInfoFooter
./gradlew --no-daemon ofbizBackground
