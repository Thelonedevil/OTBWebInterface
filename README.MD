# OTBWebInterface

## Build
### Requirements
  - Jruby 1.7+
  - Bundler 1.9.9
  - JDK 8
  - maven (deployment only)
  
### To build a local file
#### Windows
    run "build.bat"
#### Linux
    run "make build"
### To deploy to the maven repository (team members only)
#### Windows
    run "deploy.bat <repo> <password>"
    <repo> will be either "snapshots" or "releases"
    <password> will be the deployment password
#### Linux
    run "make deploy repo=<repo> password=<password>"
    <repo> will be either "snapshots" or "releases"
    <password> will be the deployment password
    
### To set up requirements
#### JDK 8
##### Windows
There are a few things we need to do.
Firstly, go <a href="http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html" target="_blank">here</a>, accept the license, and download the JDK version suitable for your system. x86 is for a 32bit machine and x64 for a 64 bit machine. Use JDK 8! Once you have downloaded the installer, you need to install the JDK. Write down where you install the JDK, because we need this location later.
After you have successfully installed the JDK, there are just 2 more things needed: Adding it to your PATH, and setting JAVA_HOME.

###### Setting JAVA_HOME
1. Open System (on windows 8.1, right click the start button and choose system, on windows 7 right click "My Computer" and choose properties)
2. On the left hand side click "Advanced System Settings"
3. Near the bottom of that window, click "Environment Variables..."
4. Click "New..." under User variables
5. Set the variable name as "JAVA_HOME"
6. Set the variable value as the path to the JDK install folder
7. Click Ok

###### Adding to PATH
If you already have a "Path" variable under User variables, then edit it, and append "%JAVA_HOME%\bin;" making sure that there is a ";" at the end of the current PATH. 
If there is no "Path" variable under User variables, Click "New...", set the name to "Path" and the value to "%JAVA_HOME%\bin;" 

###### Finishing up and verification
To verify that the JDK is installed and set-up correctly
1. Open a Command Prompt window (windows 8.1 right click the start button and click Command Prompt, windows 7 open start menu and type cmd, press enter)
2. Enter "javac -version" if you get the Java version back, everything is great, if you get "'javac' is not recognized as an internal or external command,
operable program or batch file." then go back and check that you did everything correctly

##### Ubuntu/Linux Mint
Follow the instructions <a href="http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html" target="_blank">here</a>

##### Debian
Follow the instructions <a href="http://www.webupd8.org/2014/03/install-oracle-java-8-in-debian.html" target="_blank">here</a>

##### Fedora/Redhat/CentOS
Firstly, go <a href="http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html" target="_blank">here</a>, accept the license, and download the JDK version suitable for your system. x86 is for a 32bit machine and x64 for a 64 bit machine. You want the linux rpm versions.

1. In a terminal navigate to where the rpm file was downloaded to
2. Run "rpm -ivh jdk-8u40-linux-x64.rpm" (replace the file name with the one downloaded)
3. Check the Java version installed with "java -version"

###### Setting the Global Variables
1. Using a text editor of your choice create a file at "/etc/profile.d/java.sh"
2. Add the following lines replacing jdk1.8.0_25 with the version of the JDK you installed

    ```bash
    #!/bin/bash
    JAVA_HOME=/usr/java/jdk1.8.0_25/
    PATH=$JAVA_HOME/bin:$PATH
    export PATH JAVA_HOME
    export CLASSPATH=.
    ```

3. Save and close the file
4. Make the file executable with "chmod +x /etc/profile.d/java.sh"
5. Then run "source /etc/profile.d/java.sh" to make the variables permanent
6. From a new terminal run "javac -version" to check that everything is working correctly

##### OSX
Firstly go  <a href="http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html" target="_blank">here</a> and download the Mac OSX package after accepting the license.

1. Double click the .dmg file you just downloaded, a Finder window should appear containing an icon of an open box and the name of the .pkg file
2. Double click the package icon
3. Click continue
4. Click install
5. Enter the Administrator login details
6. From a terminal run "javac -version" to check that everything is working correctly

#### Maven
##### Windows
1. Download the maven binary zip file from <a href="https://maven.apache.org/download.cgi" target="_blank">here</a>. 
2. Extract it to a folder (I normally call it maven)
3. Move that folder to the root of your C drive (or any other hard drive)
4. Add the path to the bin folder to your Path variable, It will be something like "C:\maven\bin;"
5. Run "mvn --version" in a new Command Prompt to verify that it is all installed

##### Ubuntu/Debian
1. Run "sudo apt-get install maven2" from a terminal

##### Linux/OSX
1. Download the maven binary tar.gz file from <a href="https://maven.apache.org/download.cgi" target="_blank">here</a>. 
2. Extract it to "/usr/local/apache-maven"
3. In a terminal run "export PATH=$PATH:/usr/local/apache-maven/apache-maven-3.3.1/bin"
5. Run "mvn --version" to verify that it is all installed

#### Jruby 1.7+
##### Windows
Grab the windows executable from [here](http://jruby.org/download) and run it.
##### Linux
1. install RVM with ```\curl -sSL https://get.rvm.io | bash -s stable ```
2. run ```rvm install jruby ```
3. run ```rvm use jruby ```

#### Bundler 1.9.9
  jruby -S gem install bundler -v 1.9.9
