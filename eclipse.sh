#!/bin/bash
sudo apt-get install -y libsvn-java
echo "-Djava.library.path=/usr/lib/x86_64-linux-gnu/jni" | sudo tee -a /opt/eclipse/eclipse.ini
mkdir /home/vagrant/workspace
mkdir -p /home/vagrant/.eclipse/org.eclipse.platform_4.3.0_1473617060_linux_gtk_x86_64/configuration/.settings/
cat <<PREFS | tee /home/vagrant/.eclipse/org.eclipse.platform_4.3.0_1473617060_linux_gtk_x86_64/configuration/.settings/org.eclipse.ui.ide.prefs
MAX_RECENT_WORKSPACES=5
RECENT_WORKSPACES=/home/vagrant/workspace
RECENT_WORKSPACES_PROTOCOL=3
SHOW_WORKSPACE_SELECTION_DIALOG=false
eclipse.preferences.version=1
PREFS

# additional eclipse plugins
#/opt/eclipse/eclipse -nosplash -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/releases/kepler/ -repository http://subclipse.tigris.org/update_1.6.x -installIU org.tigris.subversion.clientadapter,org.tigris.subversion.clientadapter.javahl,org.tigris.subversion.subclipse.core

/opt/eclipse/eclipse -nosplash -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/releases/kepler/ -repository http://subclipse.tigris.org/update_1.6.x -installIU com.collabnet.subversion.merge,org.tigris.subversion.clientadapter,org.tigris.subversion.clientadapter.javahl,org.tigris.subversion.clientadapter.svnkit,org.tigris.subversion.subclipse.core,org.tigris.subversion.subclipse.doc,org.tigris.subversion.subclipse.graph,org.tigris.subversion.subclipse.mylyn,org.tigris.subversion.subclipse.tools.usage,org.tigris.subversion.subclipse.ui

