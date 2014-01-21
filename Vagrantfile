# vi: set ft=ruby :

$script = <<SCRIPT
# switch to German keyboard layout
sudo sed -i 's/"us"/"de"/g' /etc/default/keyboard
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y console-common
sudo install-keymap de

# switch Ubuntu download mirror to German server
sudo sed -i 's,http://us.archive.ubuntu.com/ubuntu/,http://ftp.fau.de/ubuntu/,' /etc/apt/sources.list
sudo sed -i 's,http://security.ubuntu.com/ubuntu,http://ftp.fau.de/ubuntu,' /etc/apt/sources.list
sudo apt-get update -y

# set timezone to German timezone
echo "Europe/Berlin" | sudo tee /etc/timezone
sudo dpkg-reconfigure -f noninteractive tzdata

# install Ubuntu desktop
sudo apt-get install -y --no-install-recommends ubuntu-desktop
sudo apt-get install -y gnome-panel
sudo apt-get install -y unity-lens-applications
gconftool -s /apps/gnome-terminal/profiles/Default/use_system_font -t bool false

# install Chromium  browser
sudo apt-get install -y chromium-browser

# install development tools
sudo apt-get install -y git vim vim-gnome

if [ ! -d /vagrant/resources ]
then
  mkdir /vagrant/resources
fi

# install Oracle JDK 7
sudo apt-get purge openjdk*
sudo apt-get install -y python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update -y
if [ -f /vagrant/resources/jdk-7u51-linux-x64.tar.gz ]
then
  sudo mkdir -p /var/cache/oracle-jdk7-installer/
  sudo cp /vagrant/resources/jdk-7u51-linux-x64.tar.gz /var/cache/oracle-jdk7-installer/jdk-7u51-linux-x64.tar.gz
fi
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo /usr/bin/debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java7-installer
sudo apt-get install -y oracle-java7-set-default
if [ ! -f /vagrant/resources/jdk-7u51-linux-x64.tar.gz ]
then
  cp /var/cache/oracle-jdk7-installer/jdk-7u51-linux-x64.tar.gz /vagrant/resources/jdk-7u51-linux-x64.tar.gz
fi

sudo apt-get install maven

# install Eclipse Kepler 4.3.1 Java EE 
if [ ! -f /vagrant/resources/eclipse-jee-kepler-SR1-linux-gtk-x86_64.tar.gz ]
then
  cd /vagrant/resources
  echo Downloading Eclipse...
  wget -q http://mirror.netcologne.de/eclipse//technology/epp/downloads/release/kepler/SR1/eclipse-jee-kepler-SR1-linux-gtk-x86_64.tar.gz
  cd /home/vagrant
fi
sudo tar xzf /vagrant/resources/eclipse-jee-kepler-SR1-linux-gtk-x86_64.tar.gz -C /opt --owner=root
cat <<DESKTOP | sudo tee /usr/share/applications/eclipse.desktop
[Desktop Entry]
Version=4.3.1
Name=Eclipse for Java EE Developers
Comment=IDE for all seasons
Exec=env UBUNTU_MENUPROXY=0 /opt/eclipse/eclipse
Icon=/opt/eclipse/icon.xpm
Terminal=false
Type=Application
Categories=Utility;Application;Development;IDE
DESKTOP

mkdir /home/vagrant/workspace
mkdir -p /home/vagrant/.eclipse/org.eclipse.platform_4.3.0_1473617060_linux_gtk_x86_64/configuration/.settings/
cat <<PREFS | tee /home/vagrant/.eclipse/org.eclipse.platform_4.3.0_1473617060_linux_gtk_x86_64/configuration/.settings/org.eclipse.ui.ide.prefs 
MAX_RECENT_WORKSPACES=5
RECENT_WORKSPACES=/home/vagrant/workspace
RECENT_WORKSPACES_PROTOCOL=3
SHOW_WORKSPACE_SELECTION_DIALOG=false
eclipse.preferences.version=1
PREFS

# install Eclipse Subclipse 1.6.x, because only JavaHL 1.6 is in Ubuntu precise repo
sudo apt-get install -y libsvn-java subversion
svn info 2>/dev/null # just to create .subversion directory with config
sed -i 's/# password-stores = gnome-keyring,kwallet/password-stores = /g' /home/vagrant/.subversion/config
echo "-Djava.library.path=/usr/lib/x86_64-linux-gnu/jni" | sudo tee -a /opt/eclipse/eclipse.ini
#/opt/eclipse/eclipse -nosplash -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/releases/kepler/ -repository http://subclipse.tigris.org/update_1.6.x -installIU com.collabnet.subversion.merge,org.tigris.subversion.clientadapter,org.tigris.subversion.clientadapter.javahl,org.tigris.subversion.clientadapter.svnkit,org.tigris.subversion.subclipse.core,org.tigris.subversion.subclipse.doc,org.tigris.subversion.subclipse.graph,org.tigris.subversion.subclipse.mylyn,org.tigris.subversion.subclipse.tools.usage,org.tigris.subversion.subclipse.ui

# start desktop
echo "autologin-user=vagrant" | sudo tee -a /etc/lightdm/lightdm.conf
sudo service lightdm restart

# install JBoss Tools + subclipse
if [ ! -f /vagrant/resources/jbosstools-Update-4.1.1.Final_2013-12-08_01-06-33-B605.zip ]
then
  cd /vagrant/resources
  wget -q http://download.jboss.org/jbosstools/updates/scripted-install/install.xml
  wget -q http://download.jboss.org/jbosstools/updates/scripted-install/director.xml
  echo Downloading JBoss Tools 4.1.1 ...
  wget -q http://downloads.sourceforge.net/project/jboss/JBossTools/JBossTools4.1.x/jbosstools-Update-4.1.1.Final_2013-12-08_01-06-33-B605.zip
  cd /home/vagrant
fi
sudo /opt/eclipse/eclipse -consolelog -nosplash -data /tmp -application org.eclipse.ant.core.antRunner -f \
  /vagrant/resources/install.xml \
  -DsourceZip=/vagrant/resources/jbosstools-Update-4.1.1.Final_2013-12-08_01-06-33-B605.zip \
  -DotherRepos=http://download.jboss.org/jbosstools/updates/stable/kepler/central/core/ \
  -DtargetDir=/opt/eclipse/ \
  -Dinstall="org.jboss.tools.community.central.feature.feature.group,\
org.tigris.subversion.subclipse.feature.group,\
org.tigris.subversion.clientadapter.svnkit.feature.feature.group,\
com.collabnet.subversion.merge.feature.feature.group,\
net.java.dev.jna.feature.group,\
org.tigris.subversion.clientadapter.feature.feature.group,\
org.tigris.subversion.subclipse.graph.feature.feature.group,\
org.tmatesoft.svnkit.feature.group"

# setup VBox Guest Additions
sudo /etc/init.d/vboxadd-x11 setup
DISPLAY=:0.0 gsettings set com.canonical.Unity.Launcher favorites "['nautilus-home.desktop', 'ubuntu-software-center.desktop', 'gnome-control-center.desktop', 'gnome-terminal.desktop', 'chromium-browser.desktop', 'eclipse.desktop', 'gvim.desktop']"
sudo service lightdm restart
SCRIPT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "opscode_ubunto-12.04_chef-provisionerless"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box"
#  config.vm.box = "precise64"
#  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.hostname = "java-ide-precise64"

  config.vm.provision "shell", privileged: false, inline: $script

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "1"]
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
  end

end
