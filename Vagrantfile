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

# start desktop
echo "autologin-user=vagrant" | sudo tee -a /etc/lightdm/lightdm.conf
sudo service lightdm restart

# install Eclipse Kepler 4.3.1 Java EE 
echo Downloading Eclipse...

if [ ! -f /vagrant/resources/eclipse-jee-kepler-SR1-linux-gtk-x86_64.tar.gz ]
then
  mkdir /vagrant/resources
  cd /vagrant/resources
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
sudo apt-get install -y libsvn-java svn
svn info 2>/dev/null # just to create .subversion directory with config
sed -i 's/# password-stores = gnome-keyring,kwallet/password-stores = kwallet/g' /home/vagrant/.subversion/config
echo "-Djava.library.path=/usr/lib/x86_64-linux-gnu/jni" | sudo tee -a /opt/eclipse/eclipse.ini
/opt/eclipse/eclipse -nosplash -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/releases/kepler/ -repository http://subclipse.tigris.org/update_1.6.x -installIU com.collabnet.subversion.merge,org.tigris.subversion.clientadapter,org.tigris.subversion.clientadapter.javahl,org.tigris.subversion.clientadapter.svnkit,org.tigris.subversion.subclipse.core,org.tigris.subversion.subclipse.doc,org.tigris.subversion.subclipse.graph,org.tigris.subversion.subclipse.mylyn,org.tigris.subversion.subclipse.tools.usage,org.tigris.subversion.subclipse.ui

# setup VBox Guest Additions
sudo /etc/init.d/vboxadd-x11 setup
DISPLAY=:0.0 gsettings set com.canonical.Unity.Launcher favorites "['nautilus-home.desktop', 'ubuntu-software-center.desktop', 'gnome-control-center.desktop', 'gnome-terminal.desktop', 'chromium-browser.desktop', 'eclipse.desktop', 'gvim.desktop']"
sudo service lightdm restart
SCRIPT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.hostname = "java-ide-precise64"

  config.vm.provision "shell", privileged: false, inline: $script

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
  end

end
