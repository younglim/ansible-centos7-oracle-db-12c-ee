# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  host = RbConfig::CONFIG['host_os']
   # Give VM 1/4 system memory
  if host =~ /darwin/
    # sysctl returns Bytes and we need to convert to MB
    mem = `sysctl -n hw.memsize`.to_i / 1024
  elsif host =~ /linux/
    # meminfo shows KB and we need to convert to MB
    mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i
  elsif host =~ /mswin|mingw|cygwin/
    # Windows code via https://github.com/rdsubhas/vagrant-faster
    mem = 16777216
  end

  mem = mem / 1024 / 4

  is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)

  config.vm.box = "centos/7"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", mem]

    # vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
    vb.cpus = 1

  end

    config.vm.provision "shell" do |sh|
      sh.path = "windows.sh"
      sh.args = "provision.yml inventory /home/vagrant/sync project_dir=/tmp/oracle-download user_home=vagrant"
    end

  config.vm.network "forwarded_port", guest: 8081, host: 8081, auto_correct: true
  config.vm.network "forwarded_port", guest: 1521, host: 1521, auto_correct: true

end
