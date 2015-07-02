@echo off
set "repo=%1"
set "password=%2"
call jruby -S bundle install
call jruby -S bundle exec rake assets:precompile
call jruby -S bundle exec warble war
echo ^<settings^>^<servers^>^<server^>^<id^>snapshots^</id^>^<username^>deployment^</username^>^<password^>%password%^</password^>^</server^>^<server^>^<id^>release^</id^>^<username^>deployment^</username^>^<password^>%password%^</password^>^</server^>^</servers^>^</settings^> > settings.xml
call mvn deploy:deploy-file -Dfile=OTBWebInterface.war -DpomFile=pom.xml -DrepositoryId=%repo% -Durl=http://ts.tldcode.uk:8081/nexus/content/repositories/%repo%/ --settings settings.xml
pause