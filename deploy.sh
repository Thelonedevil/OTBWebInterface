#!/bin/bash
type=$1
password=$2
bundle exec rake assets:precompile
bundle exec warble war
echo "<settings><servers><server><id>snapshots</id><username>deployment</username><password>$password</password></server><server><id>release</id><username>deployment</username><password>$password</password></server></servers></settings>" > settings.xml
mvn deploy:deploy-file -Dfile=OTBWebInterface.war -DpomFile=pom.xml -DrepositoryId="$type" -Durl=http://ts.tldcode.uk:8081/nexus/content/repositories/"$type"/ --settings settings.xml
