# java-ide

Easy start developing with Eclipse Kepler 4.3.1 for Java JEE running on Ubuntu 12.04 VM.

# Installation
You will need [Vagrant](http://vagrantup.com) and [VirtualBox](http://virtualbox.org) to install the Ubuntu Box. It will then install the Java IDE inside and some other tools you may need to start developing.

## Preparing the Java IDE Ubuntu box
The Java IDE will be installed into an Ubuntu 12.04 box. Just clone this repo and call vagrant up with the following commands:

    git clone https://github.com/StefanScherer/java-ide.git
    cd java-ide
    vagrant up

# What's in the box

*   Ubuntu 12.04.3 LTS 64bit
*   Oracle JDK 7 64bit
*   subversion  command line
*   git command line
*   maven 3.0.4 command line
*   Chromium Browser
*   Eclipse Kepler 4.3.1  for Java JEE
*   JBoss Tools 4.1.1
*   Subclipse
*   Markdown Editor

# external files
## SSH Keys
Put external files like your ssh keys for GitHub into

    resources/.ssh/id_rsa
    resources/.ssh/id_rsa.pub

and they will be copied into the box while provisioning.

# extra environments
Put additional environments for bash into the optional file 

   resources/.extra

and it will be copied into vagrant's home directory.

# Maven settings
Put additional maven settings into

   resources/.m2/settings.xml
   resources/.m2/settings-security.xml

and they will be copied into vagrant's home directory.

# Licensing
Copyright (c) 2014 Stefan Scherer

MIT License, see LICENSE.txt for more details.
