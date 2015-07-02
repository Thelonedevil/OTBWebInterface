build:
	jruby -S bundle install
	jruby -S bundle exec rake assets:precompile
	jruby -S bundle exec warble war
	
deploy: build
	echo "<settings><servers><server><id>snapshots</id><username>deployment</username><password>$(password)</password></server><server><id>release</id><username>deployment</username><password>$(password)</password></server></servers></settings>" > settings.xml
	mvn deploy:deploy-file -Dfile=OTBWebInterface.war -DpomFile=pom.xml -DrepositoryId="$(repo)" -Durl=http://ts.tldcode.uk:8081/nexus/content/repositories/"$(repo)"/ --settings settings.xml

clean:
	rm OTBWebInterface.war
