@echo off
set "type=%1"
set "password=%2"
call bundle exec rake assets:precompile
call bundle exec warble war
echo ^<settings^>^<servers^>^<server^>^<id^>snapshots^</id^>^<username^>deployment^</username^>^<password^>%password%^</password^>^</server^>^<server^>^<id^>release^</id^>^<username^>deployment^</username^>^<password^>%password%^</password^>^</server^>^</servers^>^</settings^> > settings.xml
call mvn deploy:deploy-file -Dfile=OTBWebInterface.war -DpomFile=pom.xml -DrepositoryId=%type% -Durl=http://ts.tldcode.uk:8081/nexus/content/repositories/%type%/ --settings settings.xml
pause